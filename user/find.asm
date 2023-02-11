
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getFileName>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void getFileName(char * path, char * fileName){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
   e:	892e                	mv	s2,a1
    int index = 0;
    char *p = path + strlen(path) - 1;
  10:	00000097          	auipc	ra,0x0
  14:	344080e7          	jalr	836(ra) # 354 <strlen>
  18:	1502                	slli	a0,a0,0x20
  1a:	9101                	srli	a0,a0,0x20
  1c:	157d                	addi	a0,a0,-1
  1e:	9526                	add	a0,a0,s1
    while(*p != '/') p--;
  20:	00054703          	lbu	a4,0(a0)
  24:	02f00793          	li	a5,47
  28:	00f70963          	beq	a4,a5,3a <getFileName+0x3a>
  2c:	02f00713          	li	a4,47
  30:	157d                	addi	a0,a0,-1
  32:	00054783          	lbu	a5,0(a0)
  36:	fee79de3          	bne	a5,a4,30 <getFileName+0x30>
    //todo if len > max
    p++;
  3a:	00150713          	addi	a4,a0,1
    while(*p){
  3e:	00154783          	lbu	a5,1(a0)
  42:	cb89                	beqz	a5,54 <getFileName+0x54>
  44:	85ca                	mv	a1,s2
        fileName[index++] = *p;
  46:	00f58023          	sb	a5,0(a1)
        p++;
  4a:	0705                	addi	a4,a4,1
    while(*p){
  4c:	00074783          	lbu	a5,0(a4)
  50:	0585                	addi	a1,a1,1
  52:	fbf5                	bnez	a5,46 <getFileName+0x46>
    }
}
  54:	60e2                	ld	ra,24(sp)
  56:	6442                	ld	s0,16(sp)
  58:	64a2                	ld	s1,8(sp)
  5a:	6902                	ld	s2,0(sp)
  5c:	6105                	addi	sp,sp,32
  5e:	8082                	ret

0000000000000060 <find>:

void find(char * path, char * name){
  60:	d7010113          	addi	sp,sp,-656
  64:	28113423          	sd	ra,648(sp)
  68:	28813023          	sd	s0,640(sp)
  6c:	26913c23          	sd	s1,632(sp)
  70:	27213823          	sd	s2,624(sp)
  74:	27313423          	sd	s3,616(sp)
  78:	27413023          	sd	s4,608(sp)
  7c:	25513c23          	sd	s5,600(sp)
  80:	25613823          	sd	s6,592(sp)
  84:	25713423          	sd	s7,584(sp)
  88:	0d00                	addi	s0,sp,656
  8a:	892a                	mv	s2,a0
  8c:	89ae                	mv	s3,a1
    char buf[512] = {0};
  8e:	da043823          	sd	zero,-592(s0)
  92:	1f800613          	li	a2,504
  96:	4581                	li	a1,0
  98:	db840513          	addi	a0,s0,-584
  9c:	00000097          	auipc	ra,0x0
  a0:	2e2080e7          	jalr	738(ra) # 37e <memset>
    int fd;
    struct stat st;
    struct dirent de;
    if((fd = open(path, 0)) < 0){
  a4:	4581                	li	a1,0
  a6:	854a                	mv	a0,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	51a080e7          	jalr	1306(ra) # 5c2 <open>
  b0:	08054863          	bltz	a0,140 <find+0xe0>
  b4:	84aa                	mv	s1,a0
        fprintf(2, "cannot open %s\n", path);
        return;
    }
    if(fstat(fd, &st) < 0){
  b6:	d9840593          	addi	a1,s0,-616
  ba:	00000097          	auipc	ra,0x0
  be:	520080e7          	jalr	1312(ra) # 5da <fstat>
  c2:	08054a63          	bltz	a0,156 <find+0xf6>
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }
    switch(st.type){
  c6:	da041783          	lh	a5,-608(s0)
  ca:	0007869b          	sext.w	a3,a5
  ce:	4705                	li	a4,1
  d0:	0ae68363          	beq	a3,a4,176 <find+0x116>
  d4:	2781                	sext.w	a5,a5
  d6:	4709                	li	a4,2
  d8:	02e79a63          	bne	a5,a4,10c <find+0xac>
        case T_FILE:{
            char fileName[DIRSIZ];
            memset(fileName, 0, sizeof(fileName));
  dc:	4639                	li	a2,14
  de:	4581                	li	a1,0
  e0:	d7840513          	addi	a0,s0,-648
  e4:	00000097          	auipc	ra,0x0
  e8:	29a080e7          	jalr	666(ra) # 37e <memset>
            getFileName(path, fileName);
  ec:	d7840593          	addi	a1,s0,-648
  f0:	854a                	mv	a0,s2
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <getFileName>
            // printf("---%s\n", path);
            // printf("+++%s\n", fileName);
            if(strcmp(fileName, name) == 0){
  fa:	85ce                	mv	a1,s3
  fc:	d7840513          	addi	a0,s0,-648
 100:	00000097          	auipc	ra,0x0
 104:	228080e7          	jalr	552(ra) # 328 <strcmp>
 108:	14050563          	beqz	a0,252 <find+0x1f2>
                }
                //printf("+++%s\n", de.name);
                find(buf, name);
            }
    }
    close(fd);
 10c:	8526                	mv	a0,s1
 10e:	00000097          	auipc	ra,0x0
 112:	49c080e7          	jalr	1180(ra) # 5aa <close>
    return;
}
 116:	28813083          	ld	ra,648(sp)
 11a:	28013403          	ld	s0,640(sp)
 11e:	27813483          	ld	s1,632(sp)
 122:	27013903          	ld	s2,624(sp)
 126:	26813983          	ld	s3,616(sp)
 12a:	26013a03          	ld	s4,608(sp)
 12e:	25813a83          	ld	s5,600(sp)
 132:	25013b03          	ld	s6,592(sp)
 136:	24813b83          	ld	s7,584(sp)
 13a:	29010113          	addi	sp,sp,656
 13e:	8082                	ret
        fprintf(2, "cannot open %s\n", path);
 140:	864a                	mv	a2,s2
 142:	00001597          	auipc	a1,0x1
 146:	95e58593          	addi	a1,a1,-1698 # aa0 <malloc+0xe8>
 14a:	4509                	li	a0,2
 14c:	00000097          	auipc	ra,0x0
 150:	780080e7          	jalr	1920(ra) # 8cc <fprintf>
        return;
 154:	b7c9                	j	116 <find+0xb6>
        fprintf(2, "ls: cannot stat %s\n", path);
 156:	864a                	mv	a2,s2
 158:	00001597          	auipc	a1,0x1
 15c:	95858593          	addi	a1,a1,-1704 # ab0 <malloc+0xf8>
 160:	4509                	li	a0,2
 162:	00000097          	auipc	ra,0x0
 166:	76a080e7          	jalr	1898(ra) # 8cc <fprintf>
        close(fd);
 16a:	8526                	mv	a0,s1
 16c:	00000097          	auipc	ra,0x0
 170:	43e080e7          	jalr	1086(ra) # 5aa <close>
        return;
 174:	b74d                	j	116 <find+0xb6>
                memset(buf, 0, sizeof(buf));
 176:	db040b13          	addi	s6,s0,-592
                if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
 17a:	00001a97          	auipc	s5,0x1
 17e:	94ea8a93          	addi	s5,s5,-1714 # ac8 <malloc+0x110>
 182:	00001b97          	auipc	s7,0x1
 186:	94eb8b93          	addi	s7,s7,-1714 # ad0 <malloc+0x118>
                memset(buf, 0, sizeof(buf));
 18a:	8a5a                	mv	s4,s6
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
 18c:	4641                	li	a2,16
 18e:	d8840593          	addi	a1,s0,-632
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	406080e7          	jalr	1030(ra) # 59a <read>
 19c:	47c1                	li	a5,16
 19e:	f6f517e3          	bne	a0,a5,10c <find+0xac>
                memset(buf, 0, sizeof(buf));
 1a2:	20000613          	li	a2,512
 1a6:	4581                	li	a1,0
 1a8:	8552                	mv	a0,s4
 1aa:	00000097          	auipc	ra,0x0
 1ae:	1d4080e7          	jalr	468(ra) # 37e <memset>
                if(de.inum == 0)
 1b2:	d8845783          	lhu	a5,-632(s0)
 1b6:	dbf9                	beqz	a5,18c <find+0x12c>
                if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
 1b8:	85d6                	mv	a1,s5
 1ba:	d8a40513          	addi	a0,s0,-630
 1be:	00000097          	auipc	ra,0x0
 1c2:	16a080e7          	jalr	362(ra) # 328 <strcmp>
 1c6:	d179                	beqz	a0,18c <find+0x12c>
 1c8:	85de                	mv	a1,s7
 1ca:	d8a40513          	addi	a0,s0,-630
 1ce:	00000097          	auipc	ra,0x0
 1d2:	15a080e7          	jalr	346(ra) # 328 <strcmp>
 1d6:	d95d                	beqz	a0,18c <find+0x12c>
                if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d8:	854a                	mv	a0,s2
 1da:	00000097          	auipc	ra,0x0
 1de:	17a080e7          	jalr	378(ra) # 354 <strlen>
 1e2:	2541                	addiw	a0,a0,16
 1e4:	20000793          	li	a5,512
 1e8:	06a7ef63          	bltu	a5,a0,266 <find+0x206>
                }if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1ec:	854a                	mv	a0,s2
 1ee:	00000097          	auipc	ra,0x0
 1f2:	166080e7          	jalr	358(ra) # 354 <strlen>
 1f6:	2541                	addiw	a0,a0,16
 1f8:	20000793          	li	a5,512
 1fc:	06a7ee63          	bltu	a5,a0,278 <find+0x218>
                strcpy(buf, path);
 200:	85ca                	mv	a1,s2
 202:	855a                	mv	a0,s6
 204:	00000097          	auipc	ra,0x0
 208:	108080e7          	jalr	264(ra) # 30c <strcpy>
                char *p = buf + strlen(buf);
 20c:	855a                	mv	a0,s6
 20e:	00000097          	auipc	ra,0x0
 212:	146080e7          	jalr	326(ra) # 354 <strlen>
 216:	02051793          	slli	a5,a0,0x20
 21a:	9381                	srli	a5,a5,0x20
 21c:	db040713          	addi	a4,s0,-592
 220:	97ba                	add	a5,a5,a4
                *p = '/';
 222:	02f00713          	li	a4,47
 226:	00e78023          	sb	a4,0(a5)
                p++;
 22a:	0785                	addi	a5,a5,1
                while(de.name[index]){
 22c:	d8a44703          	lbu	a4,-630(s0)
 230:	cb11                	beqz	a4,244 <find+0x1e4>
 232:	d8b40693          	addi	a3,s0,-629
                    *p = de.name[index];
 236:	00e78023          	sb	a4,0(a5)
                    p++;
 23a:	0785                	addi	a5,a5,1
                while(de.name[index]){
 23c:	0685                	addi	a3,a3,1
 23e:	fff6c703          	lbu	a4,-1(a3)
 242:	fb75                	bnez	a4,236 <find+0x1d6>
                find(buf, name);
 244:	85ce                	mv	a1,s3
 246:	855a                	mv	a0,s6
 248:	00000097          	auipc	ra,0x0
 24c:	e18080e7          	jalr	-488(ra) # 60 <find>
 250:	bf35                	j	18c <find+0x12c>
                printf("%s\n", path);
 252:	85ca                	mv	a1,s2
 254:	00001517          	auipc	a0,0x1
 258:	86c50513          	addi	a0,a0,-1940 # ac0 <malloc+0x108>
 25c:	00000097          	auipc	ra,0x0
 260:	69e080e7          	jalr	1694(ra) # 8fa <printf>
            break;
 264:	b565                	j	10c <find+0xac>
                    printf("ls: path too long\n");
 266:	00001517          	auipc	a0,0x1
 26a:	87250513          	addi	a0,a0,-1934 # ad8 <malloc+0x120>
 26e:	00000097          	auipc	ra,0x0
 272:	68c080e7          	jalr	1676(ra) # 8fa <printf>
                    break;
 276:	bd59                	j	10c <find+0xac>
                    printf("ls: path too long\n");
 278:	00001517          	auipc	a0,0x1
 27c:	86050513          	addi	a0,a0,-1952 # ad8 <malloc+0x120>
 280:	00000097          	auipc	ra,0x0
 284:	67a080e7          	jalr	1658(ra) # 8fa <printf>
                    break;
 288:	b551                	j	10c <find+0xac>

000000000000028a <main>:

int main(int argc, char *argv[]){
 28a:	7179                	addi	sp,sp,-48
 28c:	f406                	sd	ra,40(sp)
 28e:	f022                	sd	s0,32(sp)
 290:	ec26                	sd	s1,24(sp)
 292:	e84a                	sd	s2,16(sp)
 294:	e44e                	sd	s3,8(sp)
 296:	1800                	addi	s0,sp,48

    if(argc < 3){
 298:	4789                	li	a5,2
 29a:	02a7df63          	bge	a5,a0,2d8 <main+0x4e>
        printf("too less arg, eg.(find . b)");
        exit(0);
    }
    for(int i = 1; i < argc - 1; i++){
        find(argv[i], argv[argc - 1]);
 29e:	00351993          	slli	s3,a0,0x3
 2a2:	19e1                	addi	s3,s3,-8
 2a4:	99ae                	add	s3,s3,a1
 2a6:	00858493          	addi	s1,a1,8
 2aa:	ffd5091b          	addiw	s2,a0,-3
 2ae:	1902                	slli	s2,s2,0x20
 2b0:	02095913          	srli	s2,s2,0x20
 2b4:	090e                	slli	s2,s2,0x3
 2b6:	05c1                	addi	a1,a1,16
 2b8:	992e                	add	s2,s2,a1
 2ba:	0009b583          	ld	a1,0(s3)
 2be:	6088                	ld	a0,0(s1)
 2c0:	00000097          	auipc	ra,0x0
 2c4:	da0080e7          	jalr	-608(ra) # 60 <find>
    for(int i = 1; i < argc - 1; i++){
 2c8:	04a1                	addi	s1,s1,8
 2ca:	ff2498e3          	bne	s1,s2,2ba <main+0x30>
    }
    
    exit(0);
 2ce:	4501                	li	a0,0
 2d0:	00000097          	auipc	ra,0x0
 2d4:	2b2080e7          	jalr	690(ra) # 582 <exit>
        printf("too less arg, eg.(find . b)");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	81850513          	addi	a0,a0,-2024 # af0 <malloc+0x138>
 2e0:	00000097          	auipc	ra,0x0
 2e4:	61a080e7          	jalr	1562(ra) # 8fa <printf>
        exit(0);
 2e8:	4501                	li	a0,0
 2ea:	00000097          	auipc	ra,0x0
 2ee:	298080e7          	jalr	664(ra) # 582 <exit>

00000000000002f2 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2fa:	00000097          	auipc	ra,0x0
 2fe:	f90080e7          	jalr	-112(ra) # 28a <main>
  exit(0);
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	27e080e7          	jalr	638(ra) # 582 <exit>

000000000000030c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 312:	87aa                	mv	a5,a0
 314:	0585                	addi	a1,a1,1
 316:	0785                	addi	a5,a5,1
 318:	fff5c703          	lbu	a4,-1(a1)
 31c:	fee78fa3          	sb	a4,-1(a5)
 320:	fb75                	bnez	a4,314 <strcpy+0x8>
    ;
  return os;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret

0000000000000328 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cb91                	beqz	a5,346 <strcmp+0x1e>
 334:	0005c703          	lbu	a4,0(a1)
 338:	00f71763          	bne	a4,a5,346 <strcmp+0x1e>
    p++, q++;
 33c:	0505                	addi	a0,a0,1
 33e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 340:	00054783          	lbu	a5,0(a0)
 344:	fbe5                	bnez	a5,334 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 346:	0005c503          	lbu	a0,0(a1)
}
 34a:	40a7853b          	subw	a0,a5,a0
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <strlen>:

uint
strlen(const char *s)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	cf91                	beqz	a5,37a <strlen+0x26>
 360:	0505                	addi	a0,a0,1
 362:	87aa                	mv	a5,a0
 364:	4685                	li	a3,1
 366:	9e89                	subw	a3,a3,a0
 368:	00f6853b          	addw	a0,a3,a5
 36c:	0785                	addi	a5,a5,1
 36e:	fff7c703          	lbu	a4,-1(a5)
 372:	fb7d                	bnez	a4,368 <strlen+0x14>
    ;
  return n;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
  for(n = 0; s[n]; n++)
 37a:	4501                	li	a0,0
 37c:	bfe5                	j	374 <strlen+0x20>

000000000000037e <memset>:

void*
memset(void *dst, int c, uint n)
{
 37e:	1141                	addi	sp,sp,-16
 380:	e422                	sd	s0,8(sp)
 382:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 384:	ce09                	beqz	a2,39e <memset+0x20>
 386:	87aa                	mv	a5,a0
 388:	fff6071b          	addiw	a4,a2,-1
 38c:	1702                	slli	a4,a4,0x20
 38e:	9301                	srli	a4,a4,0x20
 390:	0705                	addi	a4,a4,1
 392:	972a                	add	a4,a4,a0
    cdst[i] = c;
 394:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 398:	0785                	addi	a5,a5,1
 39a:	fee79de3          	bne	a5,a4,394 <memset+0x16>
  }
  return dst;
}
 39e:	6422                	ld	s0,8(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret

00000000000003a4 <strchr>:

char*
strchr(const char *s, char c)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3aa:	00054783          	lbu	a5,0(a0)
 3ae:	cb99                	beqz	a5,3c4 <strchr+0x20>
    if(*s == c)
 3b0:	00f58763          	beq	a1,a5,3be <strchr+0x1a>
  for(; *s; s++)
 3b4:	0505                	addi	a0,a0,1
 3b6:	00054783          	lbu	a5,0(a0)
 3ba:	fbfd                	bnez	a5,3b0 <strchr+0xc>
      return (char*)s;
  return 0;
 3bc:	4501                	li	a0,0
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfe5                	j	3be <strchr+0x1a>

00000000000003c8 <gets>:

char*
gets(char *buf, int max)
{
 3c8:	711d                	addi	sp,sp,-96
 3ca:	ec86                	sd	ra,88(sp)
 3cc:	e8a2                	sd	s0,80(sp)
 3ce:	e4a6                	sd	s1,72(sp)
 3d0:	e0ca                	sd	s2,64(sp)
 3d2:	fc4e                	sd	s3,56(sp)
 3d4:	f852                	sd	s4,48(sp)
 3d6:	f456                	sd	s5,40(sp)
 3d8:	f05a                	sd	s6,32(sp)
 3da:	ec5e                	sd	s7,24(sp)
 3dc:	1080                	addi	s0,sp,96
 3de:	8baa                	mv	s7,a0
 3e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e2:	892a                	mv	s2,a0
 3e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e6:	4aa9                	li	s5,10
 3e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ea:	89a6                	mv	s3,s1
 3ec:	2485                	addiw	s1,s1,1
 3ee:	0344d863          	bge	s1,s4,41e <gets+0x56>
    cc = read(0, &c, 1);
 3f2:	4605                	li	a2,1
 3f4:	faf40593          	addi	a1,s0,-81
 3f8:	4501                	li	a0,0
 3fa:	00000097          	auipc	ra,0x0
 3fe:	1a0080e7          	jalr	416(ra) # 59a <read>
    if(cc < 1)
 402:	00a05e63          	blez	a0,41e <gets+0x56>
    buf[i++] = c;
 406:	faf44783          	lbu	a5,-81(s0)
 40a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40e:	01578763          	beq	a5,s5,41c <gets+0x54>
 412:	0905                	addi	s2,s2,1
 414:	fd679be3          	bne	a5,s6,3ea <gets+0x22>
  for(i=0; i+1 < max; ){
 418:	89a6                	mv	s3,s1
 41a:	a011                	j	41e <gets+0x56>
 41c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41e:	99de                	add	s3,s3,s7
 420:	00098023          	sb	zero,0(s3)
  return buf;
}
 424:	855e                	mv	a0,s7
 426:	60e6                	ld	ra,88(sp)
 428:	6446                	ld	s0,80(sp)
 42a:	64a6                	ld	s1,72(sp)
 42c:	6906                	ld	s2,64(sp)
 42e:	79e2                	ld	s3,56(sp)
 430:	7a42                	ld	s4,48(sp)
 432:	7aa2                	ld	s5,40(sp)
 434:	7b02                	ld	s6,32(sp)
 436:	6be2                	ld	s7,24(sp)
 438:	6125                	addi	sp,sp,96
 43a:	8082                	ret

000000000000043c <stat>:

int
stat(const char *n, struct stat *st)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	e426                	sd	s1,8(sp)
 444:	e04a                	sd	s2,0(sp)
 446:	1000                	addi	s0,sp,32
 448:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 44a:	4581                	li	a1,0
 44c:	00000097          	auipc	ra,0x0
 450:	176080e7          	jalr	374(ra) # 5c2 <open>
  if(fd < 0)
 454:	02054563          	bltz	a0,47e <stat+0x42>
 458:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 45a:	85ca                	mv	a1,s2
 45c:	00000097          	auipc	ra,0x0
 460:	17e080e7          	jalr	382(ra) # 5da <fstat>
 464:	892a                	mv	s2,a0
  close(fd);
 466:	8526                	mv	a0,s1
 468:	00000097          	auipc	ra,0x0
 46c:	142080e7          	jalr	322(ra) # 5aa <close>
  return r;
}
 470:	854a                	mv	a0,s2
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	64a2                	ld	s1,8(sp)
 478:	6902                	ld	s2,0(sp)
 47a:	6105                	addi	sp,sp,32
 47c:	8082                	ret
    return -1;
 47e:	597d                	li	s2,-1
 480:	bfc5                	j	470 <stat+0x34>

0000000000000482 <atoi>:

int
atoi(const char *s)
{
 482:	1141                	addi	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 488:	00054603          	lbu	a2,0(a0)
 48c:	fd06079b          	addiw	a5,a2,-48
 490:	0ff7f793          	andi	a5,a5,255
 494:	4725                	li	a4,9
 496:	02f76963          	bltu	a4,a5,4c8 <atoi+0x46>
 49a:	86aa                	mv	a3,a0
  n = 0;
 49c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 49e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4a0:	0685                	addi	a3,a3,1
 4a2:	0025179b          	slliw	a5,a0,0x2
 4a6:	9fa9                	addw	a5,a5,a0
 4a8:	0017979b          	slliw	a5,a5,0x1
 4ac:	9fb1                	addw	a5,a5,a2
 4ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4b2:	0006c603          	lbu	a2,0(a3)
 4b6:	fd06071b          	addiw	a4,a2,-48
 4ba:	0ff77713          	andi	a4,a4,255
 4be:	fee5f1e3          	bgeu	a1,a4,4a0 <atoi+0x1e>
  return n;
}
 4c2:	6422                	ld	s0,8(sp)
 4c4:	0141                	addi	sp,sp,16
 4c6:	8082                	ret
  n = 0;
 4c8:	4501                	li	a0,0
 4ca:	bfe5                	j	4c2 <atoi+0x40>

00000000000004cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4cc:	1141                	addi	sp,sp,-16
 4ce:	e422                	sd	s0,8(sp)
 4d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4d2:	02b57663          	bgeu	a0,a1,4fe <memmove+0x32>
    while(n-- > 0)
 4d6:	02c05163          	blez	a2,4f8 <memmove+0x2c>
 4da:	fff6079b          	addiw	a5,a2,-1
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	0785                	addi	a5,a5,1
 4e4:	97aa                	add	a5,a5,a0
  dst = vdst;
 4e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e8:	0585                	addi	a1,a1,1
 4ea:	0705                	addi	a4,a4,1
 4ec:	fff5c683          	lbu	a3,-1(a1)
 4f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4f4:	fee79ae3          	bne	a5,a4,4e8 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret
    dst += n;
 4fe:	00c50733          	add	a4,a0,a2
    src += n;
 502:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 504:	fec05ae3          	blez	a2,4f8 <memmove+0x2c>
 508:	fff6079b          	addiw	a5,a2,-1
 50c:	1782                	slli	a5,a5,0x20
 50e:	9381                	srli	a5,a5,0x20
 510:	fff7c793          	not	a5,a5
 514:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 516:	15fd                	addi	a1,a1,-1
 518:	177d                	addi	a4,a4,-1
 51a:	0005c683          	lbu	a3,0(a1)
 51e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 522:	fee79ae3          	bne	a5,a4,516 <memmove+0x4a>
 526:	bfc9                	j	4f8 <memmove+0x2c>

0000000000000528 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 528:	1141                	addi	sp,sp,-16
 52a:	e422                	sd	s0,8(sp)
 52c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 52e:	ca05                	beqz	a2,55e <memcmp+0x36>
 530:	fff6069b          	addiw	a3,a2,-1
 534:	1682                	slli	a3,a3,0x20
 536:	9281                	srli	a3,a3,0x20
 538:	0685                	addi	a3,a3,1
 53a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 53c:	00054783          	lbu	a5,0(a0)
 540:	0005c703          	lbu	a4,0(a1)
 544:	00e79863          	bne	a5,a4,554 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 548:	0505                	addi	a0,a0,1
    p2++;
 54a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 54c:	fed518e3          	bne	a0,a3,53c <memcmp+0x14>
  }
  return 0;
 550:	4501                	li	a0,0
 552:	a019                	j	558 <memcmp+0x30>
      return *p1 - *p2;
 554:	40e7853b          	subw	a0,a5,a4
}
 558:	6422                	ld	s0,8(sp)
 55a:	0141                	addi	sp,sp,16
 55c:	8082                	ret
  return 0;
 55e:	4501                	li	a0,0
 560:	bfe5                	j	558 <memcmp+0x30>

0000000000000562 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 562:	1141                	addi	sp,sp,-16
 564:	e406                	sd	ra,8(sp)
 566:	e022                	sd	s0,0(sp)
 568:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 56a:	00000097          	auipc	ra,0x0
 56e:	f62080e7          	jalr	-158(ra) # 4cc <memmove>
}
 572:	60a2                	ld	ra,8(sp)
 574:	6402                	ld	s0,0(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret

000000000000057a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 57a:	4885                	li	a7,1
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <exit>:
.global exit
exit:
 li a7, SYS_exit
 582:	4889                	li	a7,2
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <wait>:
.global wait
wait:
 li a7, SYS_wait
 58a:	488d                	li	a7,3
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 592:	4891                	li	a7,4
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <read>:
.global read
read:
 li a7, SYS_read
 59a:	4895                	li	a7,5
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <write>:
.global write
write:
 li a7, SYS_write
 5a2:	48c1                	li	a7,16
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <close>:
.global close
close:
 li a7, SYS_close
 5aa:	48d5                	li	a7,21
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b2:	4899                	li	a7,6
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ba:	489d                	li	a7,7
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <open>:
.global open
open:
 li a7, SYS_open
 5c2:	48bd                	li	a7,15
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ca:	48c5                	li	a7,17
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d2:	48c9                	li	a7,18
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5da:	48a1                	li	a7,8
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <link>:
.global link
link:
 li a7, SYS_link
 5e2:	48cd                	li	a7,19
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ea:	48d1                	li	a7,20
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f2:	48a5                	li	a7,9
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 5fa:	48a9                	li	a7,10
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 602:	48ad                	li	a7,11
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 60a:	48b1                	li	a7,12
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 612:	48b5                	li	a7,13
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 61a:	48b9                	li	a7,14
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 622:	1101                	addi	sp,sp,-32
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	addi	s0,sp,32
 62a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 62e:	4605                	li	a2,1
 630:	fef40593          	addi	a1,s0,-17
 634:	00000097          	auipc	ra,0x0
 638:	f6e080e7          	jalr	-146(ra) # 5a2 <write>
}
 63c:	60e2                	ld	ra,24(sp)
 63e:	6442                	ld	s0,16(sp)
 640:	6105                	addi	sp,sp,32
 642:	8082                	ret

0000000000000644 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 644:	7139                	addi	sp,sp,-64
 646:	fc06                	sd	ra,56(sp)
 648:	f822                	sd	s0,48(sp)
 64a:	f426                	sd	s1,40(sp)
 64c:	f04a                	sd	s2,32(sp)
 64e:	ec4e                	sd	s3,24(sp)
 650:	0080                	addi	s0,sp,64
 652:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 654:	c299                	beqz	a3,65a <printint+0x16>
 656:	0805c863          	bltz	a1,6e6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 65a:	2581                	sext.w	a1,a1
  neg = 0;
 65c:	4881                	li	a7,0
 65e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 662:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 664:	2601                	sext.w	a2,a2
 666:	00000517          	auipc	a0,0x0
 66a:	4b250513          	addi	a0,a0,1202 # b18 <digits>
 66e:	883a                	mv	a6,a4
 670:	2705                	addiw	a4,a4,1
 672:	02c5f7bb          	remuw	a5,a1,a2
 676:	1782                	slli	a5,a5,0x20
 678:	9381                	srli	a5,a5,0x20
 67a:	97aa                	add	a5,a5,a0
 67c:	0007c783          	lbu	a5,0(a5)
 680:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 684:	0005879b          	sext.w	a5,a1
 688:	02c5d5bb          	divuw	a1,a1,a2
 68c:	0685                	addi	a3,a3,1
 68e:	fec7f0e3          	bgeu	a5,a2,66e <printint+0x2a>
  if(neg)
 692:	00088b63          	beqz	a7,6a8 <printint+0x64>
    buf[i++] = '-';
 696:	fd040793          	addi	a5,s0,-48
 69a:	973e                	add	a4,a4,a5
 69c:	02d00793          	li	a5,45
 6a0:	fef70823          	sb	a5,-16(a4)
 6a4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6a8:	02e05863          	blez	a4,6d8 <printint+0x94>
 6ac:	fc040793          	addi	a5,s0,-64
 6b0:	00e78933          	add	s2,a5,a4
 6b4:	fff78993          	addi	s3,a5,-1
 6b8:	99ba                	add	s3,s3,a4
 6ba:	377d                	addiw	a4,a4,-1
 6bc:	1702                	slli	a4,a4,0x20
 6be:	9301                	srli	a4,a4,0x20
 6c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6c4:	fff94583          	lbu	a1,-1(s2)
 6c8:	8526                	mv	a0,s1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	f58080e7          	jalr	-168(ra) # 622 <putc>
  while(--i >= 0)
 6d2:	197d                	addi	s2,s2,-1
 6d4:	ff3918e3          	bne	s2,s3,6c4 <printint+0x80>
}
 6d8:	70e2                	ld	ra,56(sp)
 6da:	7442                	ld	s0,48(sp)
 6dc:	74a2                	ld	s1,40(sp)
 6de:	7902                	ld	s2,32(sp)
 6e0:	69e2                	ld	s3,24(sp)
 6e2:	6121                	addi	sp,sp,64
 6e4:	8082                	ret
    x = -xx;
 6e6:	40b005bb          	negw	a1,a1
    neg = 1;
 6ea:	4885                	li	a7,1
    x = -xx;
 6ec:	bf8d                	j	65e <printint+0x1a>

00000000000006ee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ee:	7119                	addi	sp,sp,-128
 6f0:	fc86                	sd	ra,120(sp)
 6f2:	f8a2                	sd	s0,112(sp)
 6f4:	f4a6                	sd	s1,104(sp)
 6f6:	f0ca                	sd	s2,96(sp)
 6f8:	ecce                	sd	s3,88(sp)
 6fa:	e8d2                	sd	s4,80(sp)
 6fc:	e4d6                	sd	s5,72(sp)
 6fe:	e0da                	sd	s6,64(sp)
 700:	fc5e                	sd	s7,56(sp)
 702:	f862                	sd	s8,48(sp)
 704:	f466                	sd	s9,40(sp)
 706:	f06a                	sd	s10,32(sp)
 708:	ec6e                	sd	s11,24(sp)
 70a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 70c:	0005c903          	lbu	s2,0(a1)
 710:	18090f63          	beqz	s2,8ae <vprintf+0x1c0>
 714:	8aaa                	mv	s5,a0
 716:	8b32                	mv	s6,a2
 718:	00158493          	addi	s1,a1,1
  state = 0;
 71c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71e:	02500a13          	li	s4,37
      if(c == 'd'){
 722:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 726:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 72a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 72e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 732:	00000b97          	auipc	s7,0x0
 736:	3e6b8b93          	addi	s7,s7,998 # b18 <digits>
 73a:	a839                	j	758 <vprintf+0x6a>
        putc(fd, c);
 73c:	85ca                	mv	a1,s2
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	ee2080e7          	jalr	-286(ra) # 622 <putc>
 748:	a019                	j	74e <vprintf+0x60>
    } else if(state == '%'){
 74a:	01498f63          	beq	s3,s4,768 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 74e:	0485                	addi	s1,s1,1
 750:	fff4c903          	lbu	s2,-1(s1)
 754:	14090d63          	beqz	s2,8ae <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 758:	0009079b          	sext.w	a5,s2
    if(state == 0){
 75c:	fe0997e3          	bnez	s3,74a <vprintf+0x5c>
      if(c == '%'){
 760:	fd479ee3          	bne	a5,s4,73c <vprintf+0x4e>
        state = '%';
 764:	89be                	mv	s3,a5
 766:	b7e5                	j	74e <vprintf+0x60>
      if(c == 'd'){
 768:	05878063          	beq	a5,s8,7a8 <vprintf+0xba>
      } else if(c == 'l') {
 76c:	05978c63          	beq	a5,s9,7c4 <vprintf+0xd6>
      } else if(c == 'x') {
 770:	07a78863          	beq	a5,s10,7e0 <vprintf+0xf2>
      } else if(c == 'p') {
 774:	09b78463          	beq	a5,s11,7fc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 778:	07300713          	li	a4,115
 77c:	0ce78663          	beq	a5,a4,848 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 780:	06300713          	li	a4,99
 784:	0ee78e63          	beq	a5,a4,880 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 788:	11478863          	beq	a5,s4,898 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78c:	85d2                	mv	a1,s4
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	e92080e7          	jalr	-366(ra) # 622 <putc>
        putc(fd, c);
 798:	85ca                	mv	a1,s2
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e86080e7          	jalr	-378(ra) # 622 <putc>
      }
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b765                	j	74e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7a8:	008b0913          	addi	s2,s6,8
 7ac:	4685                	li	a3,1
 7ae:	4629                	li	a2,10
 7b0:	000b2583          	lw	a1,0(s6)
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e8e080e7          	jalr	-370(ra) # 644 <printint>
 7be:	8b4a                	mv	s6,s2
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b771                	j	74e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	008b0913          	addi	s2,s6,8
 7c8:	4681                	li	a3,0
 7ca:	4629                	li	a2,10
 7cc:	000b2583          	lw	a1,0(s6)
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e72080e7          	jalr	-398(ra) # 644 <printint>
 7da:	8b4a                	mv	s6,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bf85                	j	74e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7e0:	008b0913          	addi	s2,s6,8
 7e4:	4681                	li	a3,0
 7e6:	4641                	li	a2,16
 7e8:	000b2583          	lw	a1,0(s6)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e56080e7          	jalr	-426(ra) # 644 <printint>
 7f6:	8b4a                	mv	s6,s2
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bf91                	j	74e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7fc:	008b0793          	addi	a5,s6,8
 800:	f8f43423          	sd	a5,-120(s0)
 804:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 808:	03000593          	li	a1,48
 80c:	8556                	mv	a0,s5
 80e:	00000097          	auipc	ra,0x0
 812:	e14080e7          	jalr	-492(ra) # 622 <putc>
  putc(fd, 'x');
 816:	85ea                	mv	a1,s10
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e08080e7          	jalr	-504(ra) # 622 <putc>
 822:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 824:	03c9d793          	srli	a5,s3,0x3c
 828:	97de                	add	a5,a5,s7
 82a:	0007c583          	lbu	a1,0(a5)
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	df2080e7          	jalr	-526(ra) # 622 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 838:	0992                	slli	s3,s3,0x4
 83a:	397d                	addiw	s2,s2,-1
 83c:	fe0914e3          	bnez	s2,824 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 840:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 844:	4981                	li	s3,0
 846:	b721                	j	74e <vprintf+0x60>
        s = va_arg(ap, char*);
 848:	008b0993          	addi	s3,s6,8
 84c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 850:	02090163          	beqz	s2,872 <vprintf+0x184>
        while(*s != 0){
 854:	00094583          	lbu	a1,0(s2)
 858:	c9a1                	beqz	a1,8a8 <vprintf+0x1ba>
          putc(fd, *s);
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	dc6080e7          	jalr	-570(ra) # 622 <putc>
          s++;
 864:	0905                	addi	s2,s2,1
        while(*s != 0){
 866:	00094583          	lbu	a1,0(s2)
 86a:	f9e5                	bnez	a1,85a <vprintf+0x16c>
        s = va_arg(ap, char*);
 86c:	8b4e                	mv	s6,s3
      state = 0;
 86e:	4981                	li	s3,0
 870:	bdf9                	j	74e <vprintf+0x60>
          s = "(null)";
 872:	00000917          	auipc	s2,0x0
 876:	29e90913          	addi	s2,s2,670 # b10 <malloc+0x158>
        while(*s != 0){
 87a:	02800593          	li	a1,40
 87e:	bff1                	j	85a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 880:	008b0913          	addi	s2,s6,8
 884:	000b4583          	lbu	a1,0(s6)
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	d98080e7          	jalr	-616(ra) # 622 <putc>
 892:	8b4a                	mv	s6,s2
      state = 0;
 894:	4981                	li	s3,0
 896:	bd65                	j	74e <vprintf+0x60>
        putc(fd, c);
 898:	85d2                	mv	a1,s4
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	d86080e7          	jalr	-634(ra) # 622 <putc>
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b565                	j	74e <vprintf+0x60>
        s = va_arg(ap, char*);
 8a8:	8b4e                	mv	s6,s3
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	b54d                	j	74e <vprintf+0x60>
    }
  }
}
 8ae:	70e6                	ld	ra,120(sp)
 8b0:	7446                	ld	s0,112(sp)
 8b2:	74a6                	ld	s1,104(sp)
 8b4:	7906                	ld	s2,96(sp)
 8b6:	69e6                	ld	s3,88(sp)
 8b8:	6a46                	ld	s4,80(sp)
 8ba:	6aa6                	ld	s5,72(sp)
 8bc:	6b06                	ld	s6,64(sp)
 8be:	7be2                	ld	s7,56(sp)
 8c0:	7c42                	ld	s8,48(sp)
 8c2:	7ca2                	ld	s9,40(sp)
 8c4:	7d02                	ld	s10,32(sp)
 8c6:	6de2                	ld	s11,24(sp)
 8c8:	6109                	addi	sp,sp,128
 8ca:	8082                	ret

00000000000008cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8cc:	715d                	addi	sp,sp,-80
 8ce:	ec06                	sd	ra,24(sp)
 8d0:	e822                	sd	s0,16(sp)
 8d2:	1000                	addi	s0,sp,32
 8d4:	e010                	sd	a2,0(s0)
 8d6:	e414                	sd	a3,8(s0)
 8d8:	e818                	sd	a4,16(s0)
 8da:	ec1c                	sd	a5,24(s0)
 8dc:	03043023          	sd	a6,32(s0)
 8e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8e8:	8622                	mv	a2,s0
 8ea:	00000097          	auipc	ra,0x0
 8ee:	e04080e7          	jalr	-508(ra) # 6ee <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6161                	addi	sp,sp,80
 8f8:	8082                	ret

00000000000008fa <printf>:

void
printf(const char *fmt, ...)
{
 8fa:	711d                	addi	sp,sp,-96
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e40c                	sd	a1,8(s0)
 904:	e810                	sd	a2,16(s0)
 906:	ec14                	sd	a3,24(s0)
 908:	f018                	sd	a4,32(s0)
 90a:	f41c                	sd	a5,40(s0)
 90c:	03043823          	sd	a6,48(s0)
 910:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 914:	00840613          	addi	a2,s0,8
 918:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 91c:	85aa                	mv	a1,a0
 91e:	4505                	li	a0,1
 920:	00000097          	auipc	ra,0x0
 924:	dce080e7          	jalr	-562(ra) # 6ee <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6125                	addi	sp,sp,96
 92e:	8082                	ret

0000000000000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	1141                	addi	sp,sp,-16
 932:	e422                	sd	s0,8(sp)
 934:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 936:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93a:	00000797          	auipc	a5,0x0
 93e:	6c67b783          	ld	a5,1734(a5) # 1000 <freep>
 942:	a805                	j	972 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 944:	4618                	lw	a4,8(a2)
 946:	9db9                	addw	a1,a1,a4
 948:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	6318                	ld	a4,0(a4)
 950:	fee53823          	sd	a4,-16(a0)
 954:	a091                	j	998 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 956:	ff852703          	lw	a4,-8(a0)
 95a:	9e39                	addw	a2,a2,a4
 95c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 95e:	ff053703          	ld	a4,-16(a0)
 962:	e398                	sd	a4,0(a5)
 964:	a099                	j	9aa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 966:	6398                	ld	a4,0(a5)
 968:	00e7e463          	bltu	a5,a4,970 <free+0x40>
 96c:	00e6ea63          	bltu	a3,a4,980 <free+0x50>
{
 970:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	fed7fae3          	bgeu	a5,a3,966 <free+0x36>
 976:	6398                	ld	a4,0(a5)
 978:	00e6e463          	bltu	a3,a4,980 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	fee7eae3          	bltu	a5,a4,970 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 980:	ff852583          	lw	a1,-8(a0)
 984:	6390                	ld	a2,0(a5)
 986:	02059713          	slli	a4,a1,0x20
 98a:	9301                	srli	a4,a4,0x20
 98c:	0712                	slli	a4,a4,0x4
 98e:	9736                	add	a4,a4,a3
 990:	fae60ae3          	beq	a2,a4,944 <free+0x14>
    bp->s.ptr = p->s.ptr;
 994:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 998:	4790                	lw	a2,8(a5)
 99a:	02061713          	slli	a4,a2,0x20
 99e:	9301                	srli	a4,a4,0x20
 9a0:	0712                	slli	a4,a4,0x4
 9a2:	973e                	add	a4,a4,a5
 9a4:	fae689e3          	beq	a3,a4,956 <free+0x26>
  } else
    p->s.ptr = bp;
 9a8:	e394                	sd	a3,0(a5)
  freep = p;
 9aa:	00000717          	auipc	a4,0x0
 9ae:	64f73b23          	sd	a5,1622(a4) # 1000 <freep>
}
 9b2:	6422                	ld	s0,8(sp)
 9b4:	0141                	addi	sp,sp,16
 9b6:	8082                	ret

00000000000009b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b8:	7139                	addi	sp,sp,-64
 9ba:	fc06                	sd	ra,56(sp)
 9bc:	f822                	sd	s0,48(sp)
 9be:	f426                	sd	s1,40(sp)
 9c0:	f04a                	sd	s2,32(sp)
 9c2:	ec4e                	sd	s3,24(sp)
 9c4:	e852                	sd	s4,16(sp)
 9c6:	e456                	sd	s5,8(sp)
 9c8:	e05a                	sd	s6,0(sp)
 9ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9cc:	02051493          	slli	s1,a0,0x20
 9d0:	9081                	srli	s1,s1,0x20
 9d2:	04bd                	addi	s1,s1,15
 9d4:	8091                	srli	s1,s1,0x4
 9d6:	0014899b          	addiw	s3,s1,1
 9da:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9dc:	00000517          	auipc	a0,0x0
 9e0:	62453503          	ld	a0,1572(a0) # 1000 <freep>
 9e4:	c515                	beqz	a0,a10 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e8:	4798                	lw	a4,8(a5)
 9ea:	02977f63          	bgeu	a4,s1,a28 <malloc+0x70>
 9ee:	8a4e                	mv	s4,s3
 9f0:	0009871b          	sext.w	a4,s3
 9f4:	6685                	lui	a3,0x1
 9f6:	00d77363          	bgeu	a4,a3,9fc <malloc+0x44>
 9fa:	6a05                	lui	s4,0x1
 9fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a00:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a04:	00000917          	auipc	s2,0x0
 a08:	5fc90913          	addi	s2,s2,1532 # 1000 <freep>
  if(p == (char*)-1)
 a0c:	5afd                	li	s5,-1
 a0e:	a88d                	j	a80 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a10:	00000797          	auipc	a5,0x0
 a14:	60078793          	addi	a5,a5,1536 # 1010 <base>
 a18:	00000717          	auipc	a4,0x0
 a1c:	5ef73423          	sd	a5,1512(a4) # 1000 <freep>
 a20:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a22:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a26:	b7e1                	j	9ee <malloc+0x36>
      if(p->s.size == nunits)
 a28:	02e48b63          	beq	s1,a4,a5e <malloc+0xa6>
        p->s.size -= nunits;
 a2c:	4137073b          	subw	a4,a4,s3
 a30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a32:	1702                	slli	a4,a4,0x20
 a34:	9301                	srli	a4,a4,0x20
 a36:	0712                	slli	a4,a4,0x4
 a38:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a3a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a3e:	00000717          	auipc	a4,0x0
 a42:	5ca73123          	sd	a0,1474(a4) # 1000 <freep>
      return (void*)(p + 1);
 a46:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a4a:	70e2                	ld	ra,56(sp)
 a4c:	7442                	ld	s0,48(sp)
 a4e:	74a2                	ld	s1,40(sp)
 a50:	7902                	ld	s2,32(sp)
 a52:	69e2                	ld	s3,24(sp)
 a54:	6a42                	ld	s4,16(sp)
 a56:	6aa2                	ld	s5,8(sp)
 a58:	6b02                	ld	s6,0(sp)
 a5a:	6121                	addi	sp,sp,64
 a5c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a5e:	6398                	ld	a4,0(a5)
 a60:	e118                	sd	a4,0(a0)
 a62:	bff1                	j	a3e <malloc+0x86>
  hp->s.size = nu;
 a64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a68:	0541                	addi	a0,a0,16
 a6a:	00000097          	auipc	ra,0x0
 a6e:	ec6080e7          	jalr	-314(ra) # 930 <free>
  return freep;
 a72:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a76:	d971                	beqz	a0,a4a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a7a:	4798                	lw	a4,8(a5)
 a7c:	fa9776e3          	bgeu	a4,s1,a28 <malloc+0x70>
    if(p == freep)
 a80:	00093703          	ld	a4,0(s2)
 a84:	853e                	mv	a0,a5
 a86:	fef719e3          	bne	a4,a5,a78 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a8a:	8552                	mv	a0,s4
 a8c:	00000097          	auipc	ra,0x0
 a90:	b7e080e7          	jalr	-1154(ra) # 60a <sbrk>
  if(p == (char*)-1)
 a94:	fd5518e3          	bne	a0,s5,a64 <malloc+0xac>
        return 0;
 a98:	4501                	li	a0,0
 a9a:	bf45                	j	a4a <malloc+0x92>
