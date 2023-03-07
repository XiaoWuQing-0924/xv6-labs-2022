// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock[NCPU];
  struct run *freelist[NCPU];
} kmem;

void
kinit()
{
    push_off();
    int hart = cpuid();
    pop_off();
    //char name[10] = "";
    //uint64 n = ((uint64)PHYSTOP - (uint64)end) / NCPU;

    // snprintf(name, 10, "kmem%d", hart);
    // printf("CPU %d : %s\n", hart, name);
    initlock(&kmem.lock[hart], "kmem");
    //freerange((void *)((uint64)end + hart * n), (void *)((uint64)end + (hart + 1) * n));
    freerange(end , (void *)PHYSTOP);   
}

void
kinit1()
{
    push_off();
    int hart = cpuid();
    pop_off();
    initlock(&kmem.lock[hart], "kmem");   
}

void
splitFreeRange(){

}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;


  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  
  push_off();
  int hart = cpuid();
  pop_off();

  acquire(&kmem.lock[hart]);
  r->next = kmem.freelist[hart];
  kmem.freelist[hart] = r;
  release(&kmem.lock[hart]);


}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
// void *
// kalloc(void)
// {
//     struct run *r;

//     push_off();
//     int hart = cpuid();
    

//     acquire(&kmem.lock[hart]);
//     r = kmem.freelist[hart];
//     if(r){
//         kmem.freelist[hart] = r->next;
//         kmem.freeSum[hart]--;
//     }else{
//         uint64 maxFreeSum = 0;
//         int maxHartId = -1;
//         //找出最多的内存
//         for(int i = 0; i < NCPU; i++){
//             if(i == hart)
//                 continue;
//             acquire(&kmem.lock[i]);
//             if(kmem.freeSum[i] > maxFreeSum){
//                 maxFreeSum = kmem.freeSum[i];
//                 maxHartId = i;
//             }
//             release(&kmem.lock[i]);
//         }
//         if(maxHartId == -1){
//             release(&kmem.lock[hart]);
//             pop_off();
//             return 0;
//         }
//         //分一半内存给当前cpu
//         acquire(&kmem.lock[maxHartId]);
//         maxFreeSum = kmem.freeSum[maxHartId] / 2;
//         //printf("%d ", maxFreeSum);
//         if(maxFreeSum == 0){//kmem.freeSum[maxHartId] = 1
//             r = kmem.freelist[maxHartId];
//             kmem.freelist[maxHartId] = 0;
//             kmem.freeSum[maxHartId] = 0;
//             kmem.freeSum[hart] += 1;
//         }else{
//             struct run *tmp = kmem.freelist[maxHartId];
//             for(int i = 1; i < maxFreeSum; i++){
//                 tmp = tmp->next;
//             }
//             r = tmp->next;
//             tmp->next = 0;
//             kmem.freelist[hart] = r->next;
//             kmem.freeSum[hart] = (kmem.freeSum[maxHartId] - maxFreeSum - 1);
//             kmem.freeSum[maxHartId] = maxFreeSum;
//         }
        
//         release(&kmem.lock[maxHartId]);
//     }
        
//     release(&kmem.lock[hart]);
//     pop_off();
//     if(r)
//         memset((char*)r, 5, PGSIZE); // fill with junk
//     // else
//     //     panic("kalloc : r = 0\n");
//     return (void*)r;
//     }

void *
kalloc(void)
{
  struct run *r;

  push_off();

  int cpu = cpuid();

  acquire(&kmem.lock[cpu]);

  if(!kmem.freelist[cpu]) { // no page left for this cpu
    int steal_left = 64; // steal 64 pages from other cpu(s)
    for(int i=0;i<NCPU;i++) {
      if(i == cpu) continue; // no self-robbery
      acquire(&kmem.lock[i]);
      struct run *rr = kmem.freelist[i];
      while(rr && steal_left) {
        kmem.freelist[i] = rr->next;
        rr->next = kmem.freelist[cpu];
        kmem.freelist[cpu] = rr;
        rr = kmem.freelist[i];
        steal_left--;
      }
      release(&kmem.lock[i]);
      if(steal_left == 0) break; // done stealing
    }
  }

  r = kmem.freelist[cpu];
  if(r)
    kmem.freelist[cpu] = r->next;
  release(&kmem.lock[cpu]);

  pop_off();

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
