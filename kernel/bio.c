// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define HashSize 31
#define BUFMAP_HASH(dev, blockno) ((((dev)<<27)|(blockno))%HashSize)
struct buflist{
    struct buf *next;
};

struct {
  struct spinlock replaceLock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  //struct buf head;
  struct buflist bufmap[HashSize];
  struct spinlock buflocks[HashSize];
 
} bcache;

void
binit(void)
{
    struct buf *b;

    initlock(&bcache.replaceLock, "bcache_replace");
    for(int i = 0; i < HashSize; i++){
        bcache.bufmap[i].next = 0;
        initlock(&bcache.buflocks[i], "bcache_bufmap");
    }
    for(int i = 0; i < NBUF; i++){
        b = &bcache.buf[i];
        initsleeplock(&b->lock, "buffer");
        //把所有的buf放到bufmap[0]中
        b->next = bcache.bufmap[0].next;
        bcache.bufmap[0].next = b;
    }
//   // Create linked list of buffers
//   bcache.head.prev = &bcache.head;
//   bcache.head.next = &bcache.head;
//   for(b = bcache.buf; b < bcache.buf+NBUF; b++){
//     b->next = bcache.head.next;
//     b->prev = &bcache.head;
//     initsleeplock(&b->lock, "buffer");
//     bcache.head.next->prev = b;
//     bcache.head.next = b;
//   }
  
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    struct buf *b;
    uint key = BUFMAP_HASH(dev, blockno);

    acquire(&bcache.buflocks[key]);

    // Is the block already cached?
    for(b = bcache.bufmap[key].next; b; b = b->next){
        if(b->dev == dev && b->blockno == blockno){
            b->refcnt++;
            release(&bcache.buflocks[key]);
            acquiresleep(&b->lock);
            return b;
        }
    }
    //释放key锁，防止其他进程在寻找可替换的key时，发生死锁
    release(&bcache.buflocks[key]);
    //获取replaceLock，防止两个进程同时申请一个blockno
    acquire(&bcache.replaceLock);
    ////再次确认是否以及缓存了
    for(b = bcache.bufmap[key].next; b; b = b->next){
        if(b->dev == dev && b->blockno == blockno){
            acquire(&bcache.buflocks[key]);
            b->refcnt++;
            release(&bcache.buflocks[key]);
            release(&bcache.replaceLock);
            acquiresleep(&b->lock);
            return b;
        }
    }
    // Not cached.
    // Recycle the least recently used (LRU) unused buffer.
    b = 0;
    struct buf *cur;
    int lockIndex = 0;
    int preIndex = -1;
    for(int i = 0; i < HashSize; i++){
        int updateFlag = 0;
        //对于每个可能的最小lastuse且refcnt==0，我们都需要获取锁，防止在遍历时其他进程使得refcnt=1
        //每次更新我们都需要释放之前的锁
        acquire(&bcache.buflocks[i]);
        for(cur = bcache.bufmap[i].next; cur; cur = cur->next){
            if(cur->refcnt == 0 && (!b || b->lastuse > cur->lastuse)){
                b = cur;
                lockIndex = i;
                updateFlag = 1;
            } 
        }
        if(!updateFlag){
            release(&bcache.buflocks[i]);
        }else{
            if(preIndex >= 0){
                release(&bcache.buflocks[preIndex]);
            }
            preIndex = lockIndex;
        }
    }
    if(!b){
        panic("bget: no buffers");
    }
    b->dev = dev;
    b->blockno = blockno;
    b->valid = 0;
    b->refcnt = 1;
    //remove which be replaced 
    if(lockIndex != key){
        struct buf *pre = 0;
        for(cur = bcache.bufmap[lockIndex].next; cur; cur = cur->next){
            if(cur == b){
                if(pre){
                    pre->next = cur->next;
                }else{
                    bcache.bufmap[lockIndex].next = cur->next;
                }
            }
            pre = cur;
        }
        release(&bcache.buflocks[lockIndex]);
        //append to the new hashmap
        acquire(&bcache.buflocks[key]);
        b->next = bcache.bufmap[key].next;
        bcache.bufmap[key].next = b;
        release(&bcache.buflocks[key]);
    }else{
        release(&bcache.buflocks[lockIndex]);
    }
    release(&bcache.replaceLock);
    acquiresleep(&b->lock);
    return b;
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    if(!holdingsleep(&b->lock))
    panic("brelse");

    releasesleep(&b->lock);
    uint key = BUFMAP_HASH(b->dev, b->blockno);
    acquire(&bcache.buflocks[key]);
    b->refcnt--;
    if (b->refcnt == 0) {
        b->lastuse = ticks;
    }

    release(&bcache.buflocks[key]);
}

void
bpin(struct buf *b) {
  uint key = BUFMAP_HASH(b->dev, b->blockno);
  acquire(&bcache.buflocks[key]);
  b->refcnt++;
  release(&bcache.buflocks[key]);
}

void
bunpin(struct buf *b) {
  uint key = BUFMAP_HASH(b->dev, b->blockno);
  acquire(&bcache.buflocks[key]);
  b->refcnt--;
  release(&bcache.buflocks[key]);
}


