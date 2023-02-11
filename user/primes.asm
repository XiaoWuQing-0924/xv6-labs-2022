
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <isPrimes>:
#include "kernel/types.h"
#include "user/user.h"
int isPrimes(int n){
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    for(int i = 2; i < n; i++){
   6:	4789                	li	a5,2
   8:	02a7d563          	bge	a5,a0,32 <isPrimes+0x32>
   c:	86aa                	mv	a3,a0
        if(n % i == 0){
   e:	00157793          	andi	a5,a0,1
  12:	c395                	beqz	a5,36 <isPrimes+0x36>
    for(int i = 2; i < n; i++){
  14:	4709                	li	a4,2
  16:	0017079b          	addiw	a5,a4,1
  1a:	0007871b          	sext.w	a4,a5
  1e:	00e68663          	beq	a3,a4,2a <isPrimes+0x2a>
        if(n % i == 0){
  22:	02f6e53b          	remw	a0,a3,a5
  26:	f965                	bnez	a0,16 <isPrimes+0x16>
  28:	a011                	j	2c <isPrimes+0x2c>
            return 0;
        }
    }
    return 1;
  2a:	4505                	li	a0,1
}
  2c:	6422                	ld	s0,8(sp)
  2e:	0141                	addi	sp,sp,16
  30:	8082                	ret
    return 1;
  32:	4505                	li	a0,1
  34:	bfe5                	j	2c <isPrimes+0x2c>
            return 0;
  36:	4501                	li	a0,0
  38:	bfd5                	j	2c <isPrimes+0x2c>

000000000000003a <main>:
int main(){
  3a:	715d                	addi	sp,sp,-80
  3c:	e486                	sd	ra,72(sp)
  3e:	e0a2                	sd	s0,64(sp)
  40:	fc26                	sd	s1,56(sp)
  42:	f84a                	sd	s2,48(sp)
  44:	f44e                	sd	s3,40(sp)
  46:	f052                	sd	s4,32(sp)
  48:	0880                	addi	s0,sp,80
    int fd[2];
    pipe(fd);
  4a:	fc840513          	addi	a0,s0,-56
  4e:	00000097          	auipc	ra,0x0
  52:	3f8080e7          	jalr	1016(ra) # 446 <pipe>
    int statu;
    if(fork() == 0){
  56:	00000097          	auipc	ra,0x0
  5a:	3d8080e7          	jalr	984(ra) # 42e <fork>
  5e:	c13d                	beqz	a0,c4 <main+0x8a>
        }
        close(fd[0]);
        //close(fd_child[1]);
        exit(0);
    }else{
        close(fd[0]);
  60:	fc842503          	lw	a0,-56(s0)
  64:	00000097          	auipc	ra,0x0
  68:	3fa080e7          	jalr	1018(ra) # 45e <close>
        for(int i = 2; i <= 35; i++){
  6c:	4789                	li	a5,2
  6e:	fcf42023          	sw	a5,-64(s0)
  72:	02300493          	li	s1,35
            write(fd[1], (char *)&i, 1);
  76:	4605                	li	a2,1
  78:	fc040593          	addi	a1,s0,-64
  7c:	fcc42503          	lw	a0,-52(s0)
  80:	00000097          	auipc	ra,0x0
  84:	3d6080e7          	jalr	982(ra) # 456 <write>
        for(int i = 2; i <= 35; i++){
  88:	fc042783          	lw	a5,-64(s0)
  8c:	2785                	addiw	a5,a5,1
  8e:	0007871b          	sext.w	a4,a5
  92:	fcf42023          	sw	a5,-64(s0)
  96:	fee4d0e3          	bge	s1,a4,76 <main+0x3c>
        }
        close(fd[1]);
  9a:	fcc42503          	lw	a0,-52(s0)
  9e:	00000097          	auipc	ra,0x0
  a2:	3c0080e7          	jalr	960(ra) # 45e <close>
        wait(&statu);
  a6:	fc440513          	addi	a0,s0,-60
  aa:	00000097          	auipc	ra,0x0
  ae:	394080e7          	jalr	916(ra) # 43e <wait>
    }
    return 0;
    
  b2:	4501                	li	a0,0
  b4:	60a6                	ld	ra,72(sp)
  b6:	6406                	ld	s0,64(sp)
  b8:	74e2                	ld	s1,56(sp)
  ba:	7942                	ld	s2,48(sp)
  bc:	79a2                	ld	s3,40(sp)
  be:	7a02                	ld	s4,32(sp)
  c0:	6161                	addi	sp,sp,80
  c2:	8082                	ret
        close(fd[1]);
  c4:	fcc42503          	lw	a0,-52(s0)
  c8:	00000097          	auipc	ra,0x0
  cc:	396080e7          	jalr	918(ra) # 45e <close>
                    tmp[i++] = cur%10 +'0';
  d0:	4929                	li	s2,10
  d2:	4a01                	li	s4,0
                str[j++] = '\n';
  d4:	49a9                	li	s3,10
        while(read(fd[0], &n, 1) > 0){
  d6:	4605                	li	a2,1
  d8:	fb740593          	addi	a1,s0,-73
  dc:	fc842503          	lw	a0,-56(s0)
  e0:	00000097          	auipc	ra,0x0
  e4:	36e080e7          	jalr	878(ra) # 44e <read>
  e8:	0aa05463          	blez	a0,190 <main+0x156>
            int cur = (int) n;
  ec:	fb744483          	lbu	s1,-73(s0)
            if(isPrimes(cur)){
  f0:	8526                	mv	a0,s1
  f2:	00000097          	auipc	ra,0x0
  f6:	f0e080e7          	jalr	-242(ra) # 0 <isPrimes>
  fa:	dd71                	beqz	a0,d6 <main+0x9c>
  fc:	4781                	li	a5,0
  fe:	a831                	j	11a <main+0xe0>
                    tmp[i++] = cur%10 +'0';
 100:	fb840713          	addi	a4,s0,-72
 104:	00f706b3          	add	a3,a4,a5
 108:	0324e73b          	remw	a4,s1,s2
 10c:	0307071b          	addiw	a4,a4,48
 110:	00e68023          	sb	a4,0(a3)
                    cur /= 10;
 114:	0324c4bb          	divw	s1,s1,s2
 118:	0785                	addi	a5,a5,1
 11a:	0007871b          	sext.w	a4,a5
                while(cur){
 11e:	f0ed                	bnez	s1,100 <main+0xc6>
                while(i >= 0){
 120:	fff7079b          	addiw	a5,a4,-1
 124:	fc040693          	addi	a3,s0,-64
 128:	a811                	j	13c <main+0x102>
                    str[j] = tmp[i];
 12a:	fb840613          	addi	a2,s0,-72
 12e:	963e                	add	a2,a2,a5
 130:	00064603          	lbu	a2,0(a2)
 134:	00c68023          	sb	a2,0(a3)
                    j++;
 138:	17fd                	addi	a5,a5,-1
 13a:	0685                	addi	a3,a3,1
                while(i >= 0){
 13c:	02079613          	slli	a2,a5,0x20
 140:	fe0655e3          	bgez	a2,12a <main+0xf0>
 144:	87ba                	mv	a5,a4
 146:	04074363          	bltz	a4,18c <main+0x152>
 14a:	0007871b          	sext.w	a4,a5
                str[j++] = '\n';
 14e:	0017849b          	addiw	s1,a5,1
 152:	fd040793          	addi	a5,s0,-48
 156:	97ba                	add	a5,a5,a4
 158:	ff378823          	sb	s3,-16(a5)
                str[j] = 0;
 15c:	fd040793          	addi	a5,s0,-48
 160:	97a6                	add	a5,a5,s1
 162:	fe078823          	sb	zero,-16(a5)
                fprintf(1, "prime ", 7);
 166:	461d                	li	a2,7
 168:	00000597          	auipc	a1,0x0
 16c:	7e858593          	addi	a1,a1,2024 # 950 <malloc+0xe4>
 170:	4505                	li	a0,1
 172:	00000097          	auipc	ra,0x0
 176:	60e080e7          	jalr	1550(ra) # 780 <fprintf>
                fprintf(1, str, j);
 17a:	8626                	mv	a2,s1
 17c:	fc040593          	addi	a1,s0,-64
 180:	4505                	li	a0,1
 182:	00000097          	auipc	ra,0x0
 186:	5fe080e7          	jalr	1534(ra) # 780 <fprintf>
 18a:	b7b1                	j	d6 <main+0x9c>
 18c:	87d2                	mv	a5,s4
 18e:	bf75                	j	14a <main+0x110>
        close(fd[0]);
 190:	fc842503          	lw	a0,-56(s0)
 194:	00000097          	auipc	ra,0x0
 198:	2ca080e7          	jalr	714(ra) # 45e <close>
        exit(0);
 19c:	4501                	li	a0,0
 19e:	00000097          	auipc	ra,0x0
 1a2:	298080e7          	jalr	664(ra) # 436 <exit>

00000000000001a6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1ae:	00000097          	auipc	ra,0x0
 1b2:	e8c080e7          	jalr	-372(ra) # 3a <main>
  exit(0);
 1b6:	4501                	li	a0,0
 1b8:	00000097          	auipc	ra,0x0
 1bc:	27e080e7          	jalr	638(ra) # 436 <exit>

00000000000001c0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c6:	87aa                	mv	a5,a0
 1c8:	0585                	addi	a1,a1,1
 1ca:	0785                	addi	a5,a5,1
 1cc:	fff5c703          	lbu	a4,-1(a1)
 1d0:	fee78fa3          	sb	a4,-1(a5)
 1d4:	fb75                	bnez	a4,1c8 <strcpy+0x8>
    ;
  return os;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret

00000000000001dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cb91                	beqz	a5,1fa <strcmp+0x1e>
 1e8:	0005c703          	lbu	a4,0(a1)
 1ec:	00f71763          	bne	a4,a5,1fa <strcmp+0x1e>
    p++, q++;
 1f0:	0505                	addi	a0,a0,1
 1f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	fbe5                	bnez	a5,1e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1fa:	0005c503          	lbu	a0,0(a1)
}
 1fe:	40a7853b          	subw	a0,a5,a0
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <strlen>:

uint
strlen(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20e:	00054783          	lbu	a5,0(a0)
 212:	cf91                	beqz	a5,22e <strlen+0x26>
 214:	0505                	addi	a0,a0,1
 216:	87aa                	mv	a5,a0
 218:	4685                	li	a3,1
 21a:	9e89                	subw	a3,a3,a0
 21c:	00f6853b          	addw	a0,a3,a5
 220:	0785                	addi	a5,a5,1
 222:	fff7c703          	lbu	a4,-1(a5)
 226:	fb7d                	bnez	a4,21c <strlen+0x14>
    ;
  return n;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  for(n = 0; s[n]; n++)
 22e:	4501                	li	a0,0
 230:	bfe5                	j	228 <strlen+0x20>

0000000000000232 <memset>:

void*
memset(void *dst, int c, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 238:	ce09                	beqz	a2,252 <memset+0x20>
 23a:	87aa                	mv	a5,a0
 23c:	fff6071b          	addiw	a4,a2,-1
 240:	1702                	slli	a4,a4,0x20
 242:	9301                	srli	a4,a4,0x20
 244:	0705                	addi	a4,a4,1
 246:	972a                	add	a4,a4,a0
    cdst[i] = c;
 248:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 24c:	0785                	addi	a5,a5,1
 24e:	fee79de3          	bne	a5,a4,248 <memset+0x16>
  }
  return dst;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <strchr>:

char*
strchr(const char *s, char c)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e422                	sd	s0,8(sp)
 25c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 25e:	00054783          	lbu	a5,0(a0)
 262:	cb99                	beqz	a5,278 <strchr+0x20>
    if(*s == c)
 264:	00f58763          	beq	a1,a5,272 <strchr+0x1a>
  for(; *s; s++)
 268:	0505                	addi	a0,a0,1
 26a:	00054783          	lbu	a5,0(a0)
 26e:	fbfd                	bnez	a5,264 <strchr+0xc>
      return (char*)s;
  return 0;
 270:	4501                	li	a0,0
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
  return 0;
 278:	4501                	li	a0,0
 27a:	bfe5                	j	272 <strchr+0x1a>

000000000000027c <gets>:

char*
gets(char *buf, int max)
{
 27c:	711d                	addi	sp,sp,-96
 27e:	ec86                	sd	ra,88(sp)
 280:	e8a2                	sd	s0,80(sp)
 282:	e4a6                	sd	s1,72(sp)
 284:	e0ca                	sd	s2,64(sp)
 286:	fc4e                	sd	s3,56(sp)
 288:	f852                	sd	s4,48(sp)
 28a:	f456                	sd	s5,40(sp)
 28c:	f05a                	sd	s6,32(sp)
 28e:	ec5e                	sd	s7,24(sp)
 290:	1080                	addi	s0,sp,96
 292:	8baa                	mv	s7,a0
 294:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 296:	892a                	mv	s2,a0
 298:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 29a:	4aa9                	li	s5,10
 29c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 29e:	89a6                	mv	s3,s1
 2a0:	2485                	addiw	s1,s1,1
 2a2:	0344d863          	bge	s1,s4,2d2 <gets+0x56>
    cc = read(0, &c, 1);
 2a6:	4605                	li	a2,1
 2a8:	faf40593          	addi	a1,s0,-81
 2ac:	4501                	li	a0,0
 2ae:	00000097          	auipc	ra,0x0
 2b2:	1a0080e7          	jalr	416(ra) # 44e <read>
    if(cc < 1)
 2b6:	00a05e63          	blez	a0,2d2 <gets+0x56>
    buf[i++] = c;
 2ba:	faf44783          	lbu	a5,-81(s0)
 2be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c2:	01578763          	beq	a5,s5,2d0 <gets+0x54>
 2c6:	0905                	addi	s2,s2,1
 2c8:	fd679be3          	bne	a5,s6,29e <gets+0x22>
  for(i=0; i+1 < max; ){
 2cc:	89a6                	mv	s3,s1
 2ce:	a011                	j	2d2 <gets+0x56>
 2d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d2:	99de                	add	s3,s3,s7
 2d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d8:	855e                	mv	a0,s7
 2da:	60e6                	ld	ra,88(sp)
 2dc:	6446                	ld	s0,80(sp)
 2de:	64a6                	ld	s1,72(sp)
 2e0:	6906                	ld	s2,64(sp)
 2e2:	79e2                	ld	s3,56(sp)
 2e4:	7a42                	ld	s4,48(sp)
 2e6:	7aa2                	ld	s5,40(sp)
 2e8:	7b02                	ld	s6,32(sp)
 2ea:	6be2                	ld	s7,24(sp)
 2ec:	6125                	addi	sp,sp,96
 2ee:	8082                	ret

00000000000002f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2f0:	1101                	addi	sp,sp,-32
 2f2:	ec06                	sd	ra,24(sp)
 2f4:	e822                	sd	s0,16(sp)
 2f6:	e426                	sd	s1,8(sp)
 2f8:	e04a                	sd	s2,0(sp)
 2fa:	1000                	addi	s0,sp,32
 2fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fe:	4581                	li	a1,0
 300:	00000097          	auipc	ra,0x0
 304:	176080e7          	jalr	374(ra) # 476 <open>
  if(fd < 0)
 308:	02054563          	bltz	a0,332 <stat+0x42>
 30c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30e:	85ca                	mv	a1,s2
 310:	00000097          	auipc	ra,0x0
 314:	17e080e7          	jalr	382(ra) # 48e <fstat>
 318:	892a                	mv	s2,a0
  close(fd);
 31a:	8526                	mv	a0,s1
 31c:	00000097          	auipc	ra,0x0
 320:	142080e7          	jalr	322(ra) # 45e <close>
  return r;
}
 324:	854a                	mv	a0,s2
 326:	60e2                	ld	ra,24(sp)
 328:	6442                	ld	s0,16(sp)
 32a:	64a2                	ld	s1,8(sp)
 32c:	6902                	ld	s2,0(sp)
 32e:	6105                	addi	sp,sp,32
 330:	8082                	ret
    return -1;
 332:	597d                	li	s2,-1
 334:	bfc5                	j	324 <stat+0x34>

0000000000000336 <atoi>:

int
atoi(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33c:	00054603          	lbu	a2,0(a0)
 340:	fd06079b          	addiw	a5,a2,-48
 344:	0ff7f793          	andi	a5,a5,255
 348:	4725                	li	a4,9
 34a:	02f76963          	bltu	a4,a5,37c <atoi+0x46>
 34e:	86aa                	mv	a3,a0
  n = 0;
 350:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 352:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 354:	0685                	addi	a3,a3,1
 356:	0025179b          	slliw	a5,a0,0x2
 35a:	9fa9                	addw	a5,a5,a0
 35c:	0017979b          	slliw	a5,a5,0x1
 360:	9fb1                	addw	a5,a5,a2
 362:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 366:	0006c603          	lbu	a2,0(a3)
 36a:	fd06071b          	addiw	a4,a2,-48
 36e:	0ff77713          	andi	a4,a4,255
 372:	fee5f1e3          	bgeu	a1,a4,354 <atoi+0x1e>
  return n;
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  n = 0;
 37c:	4501                	li	a0,0
 37e:	bfe5                	j	376 <atoi+0x40>

0000000000000380 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 386:	02b57663          	bgeu	a0,a1,3b2 <memmove+0x32>
    while(n-- > 0)
 38a:	02c05163          	blez	a2,3ac <memmove+0x2c>
 38e:	fff6079b          	addiw	a5,a2,-1
 392:	1782                	slli	a5,a5,0x20
 394:	9381                	srli	a5,a5,0x20
 396:	0785                	addi	a5,a5,1
 398:	97aa                	add	a5,a5,a0
  dst = vdst;
 39a:	872a                	mv	a4,a0
      *dst++ = *src++;
 39c:	0585                	addi	a1,a1,1
 39e:	0705                	addi	a4,a4,1
 3a0:	fff5c683          	lbu	a3,-1(a1)
 3a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a8:	fee79ae3          	bne	a5,a4,39c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
    dst += n;
 3b2:	00c50733          	add	a4,a0,a2
    src += n;
 3b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b8:	fec05ae3          	blez	a2,3ac <memmove+0x2c>
 3bc:	fff6079b          	addiw	a5,a2,-1
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	fff7c793          	not	a5,a5
 3c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ca:	15fd                	addi	a1,a1,-1
 3cc:	177d                	addi	a4,a4,-1
 3ce:	0005c683          	lbu	a3,0(a1)
 3d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d6:	fee79ae3          	bne	a5,a4,3ca <memmove+0x4a>
 3da:	bfc9                	j	3ac <memmove+0x2c>

00000000000003dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e2:	ca05                	beqz	a2,412 <memcmp+0x36>
 3e4:	fff6069b          	addiw	a3,a2,-1
 3e8:	1682                	slli	a3,a3,0x20
 3ea:	9281                	srli	a3,a3,0x20
 3ec:	0685                	addi	a3,a3,1
 3ee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f0:	00054783          	lbu	a5,0(a0)
 3f4:	0005c703          	lbu	a4,0(a1)
 3f8:	00e79863          	bne	a5,a4,408 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fc:	0505                	addi	a0,a0,1
    p2++;
 3fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 400:	fed518e3          	bne	a0,a3,3f0 <memcmp+0x14>
  }
  return 0;
 404:	4501                	li	a0,0
 406:	a019                	j	40c <memcmp+0x30>
      return *p1 - *p2;
 408:	40e7853b          	subw	a0,a5,a4
}
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret
  return 0;
 412:	4501                	li	a0,0
 414:	bfe5                	j	40c <memcmp+0x30>

0000000000000416 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 416:	1141                	addi	sp,sp,-16
 418:	e406                	sd	ra,8(sp)
 41a:	e022                	sd	s0,0(sp)
 41c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 41e:	00000097          	auipc	ra,0x0
 422:	f62080e7          	jalr	-158(ra) # 380 <memmove>
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 42e:	4885                	li	a7,1
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exit>:
.global exit
exit:
 li a7, SYS_exit
 436:	4889                	li	a7,2
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <wait>:
.global wait
wait:
 li a7, SYS_wait
 43e:	488d                	li	a7,3
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 446:	4891                	li	a7,4
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <read>:
.global read
read:
 li a7, SYS_read
 44e:	4895                	li	a7,5
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <write>:
.global write
write:
 li a7, SYS_write
 456:	48c1                	li	a7,16
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <close>:
.global close
close:
 li a7, SYS_close
 45e:	48d5                	li	a7,21
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <kill>:
.global kill
kill:
 li a7, SYS_kill
 466:	4899                	li	a7,6
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exec>:
.global exec
exec:
 li a7, SYS_exec
 46e:	489d                	li	a7,7
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <open>:
.global open
open:
 li a7, SYS_open
 476:	48bd                	li	a7,15
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 47e:	48c5                	li	a7,17
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 486:	48c9                	li	a7,18
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 48e:	48a1                	li	a7,8
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <link>:
.global link
link:
 li a7, SYS_link
 496:	48cd                	li	a7,19
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49e:	48d1                	li	a7,20
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a6:	48a5                	li	a7,9
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ae:	48a9                	li	a7,10
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b6:	48ad                	li	a7,11
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4be:	48b1                	li	a7,12
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c6:	48b5                	li	a7,13
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ce:	48b9                	li	a7,14
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d6:	1101                	addi	sp,sp,-32
 4d8:	ec06                	sd	ra,24(sp)
 4da:	e822                	sd	s0,16(sp)
 4dc:	1000                	addi	s0,sp,32
 4de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e2:	4605                	li	a2,1
 4e4:	fef40593          	addi	a1,s0,-17
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f6e080e7          	jalr	-146(ra) # 456 <write>
}
 4f0:	60e2                	ld	ra,24(sp)
 4f2:	6442                	ld	s0,16(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret

00000000000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	7139                	addi	sp,sp,-64
 4fa:	fc06                	sd	ra,56(sp)
 4fc:	f822                	sd	s0,48(sp)
 4fe:	f426                	sd	s1,40(sp)
 500:	f04a                	sd	s2,32(sp)
 502:	ec4e                	sd	s3,24(sp)
 504:	0080                	addi	s0,sp,64
 506:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 508:	c299                	beqz	a3,50e <printint+0x16>
 50a:	0805c863          	bltz	a1,59a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50e:	2581                	sext.w	a1,a1
  neg = 0;
 510:	4881                	li	a7,0
 512:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 516:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 518:	2601                	sext.w	a2,a2
 51a:	00000517          	auipc	a0,0x0
 51e:	44650513          	addi	a0,a0,1094 # 960 <digits>
 522:	883a                	mv	a6,a4
 524:	2705                	addiw	a4,a4,1
 526:	02c5f7bb          	remuw	a5,a1,a2
 52a:	1782                	slli	a5,a5,0x20
 52c:	9381                	srli	a5,a5,0x20
 52e:	97aa                	add	a5,a5,a0
 530:	0007c783          	lbu	a5,0(a5)
 534:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 538:	0005879b          	sext.w	a5,a1
 53c:	02c5d5bb          	divuw	a1,a1,a2
 540:	0685                	addi	a3,a3,1
 542:	fec7f0e3          	bgeu	a5,a2,522 <printint+0x2a>
  if(neg)
 546:	00088b63          	beqz	a7,55c <printint+0x64>
    buf[i++] = '-';
 54a:	fd040793          	addi	a5,s0,-48
 54e:	973e                	add	a4,a4,a5
 550:	02d00793          	li	a5,45
 554:	fef70823          	sb	a5,-16(a4)
 558:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55c:	02e05863          	blez	a4,58c <printint+0x94>
 560:	fc040793          	addi	a5,s0,-64
 564:	00e78933          	add	s2,a5,a4
 568:	fff78993          	addi	s3,a5,-1
 56c:	99ba                	add	s3,s3,a4
 56e:	377d                	addiw	a4,a4,-1
 570:	1702                	slli	a4,a4,0x20
 572:	9301                	srli	a4,a4,0x20
 574:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 578:	fff94583          	lbu	a1,-1(s2)
 57c:	8526                	mv	a0,s1
 57e:	00000097          	auipc	ra,0x0
 582:	f58080e7          	jalr	-168(ra) # 4d6 <putc>
  while(--i >= 0)
 586:	197d                	addi	s2,s2,-1
 588:	ff3918e3          	bne	s2,s3,578 <printint+0x80>
}
 58c:	70e2                	ld	ra,56(sp)
 58e:	7442                	ld	s0,48(sp)
 590:	74a2                	ld	s1,40(sp)
 592:	7902                	ld	s2,32(sp)
 594:	69e2                	ld	s3,24(sp)
 596:	6121                	addi	sp,sp,64
 598:	8082                	ret
    x = -xx;
 59a:	40b005bb          	negw	a1,a1
    neg = 1;
 59e:	4885                	li	a7,1
    x = -xx;
 5a0:	bf8d                	j	512 <printint+0x1a>

00000000000005a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a2:	7119                	addi	sp,sp,-128
 5a4:	fc86                	sd	ra,120(sp)
 5a6:	f8a2                	sd	s0,112(sp)
 5a8:	f4a6                	sd	s1,104(sp)
 5aa:	f0ca                	sd	s2,96(sp)
 5ac:	ecce                	sd	s3,88(sp)
 5ae:	e8d2                	sd	s4,80(sp)
 5b0:	e4d6                	sd	s5,72(sp)
 5b2:	e0da                	sd	s6,64(sp)
 5b4:	fc5e                	sd	s7,56(sp)
 5b6:	f862                	sd	s8,48(sp)
 5b8:	f466                	sd	s9,40(sp)
 5ba:	f06a                	sd	s10,32(sp)
 5bc:	ec6e                	sd	s11,24(sp)
 5be:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c903          	lbu	s2,0(a1)
 5c4:	18090f63          	beqz	s2,762 <vprintf+0x1c0>
 5c8:	8aaa                	mv	s5,a0
 5ca:	8b32                	mv	s6,a2
 5cc:	00158493          	addi	s1,a1,1
  state = 0;
 5d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d2:	02500a13          	li	s4,37
      if(c == 'd'){
 5d6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5da:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5de:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e6:	00000b97          	auipc	s7,0x0
 5ea:	37ab8b93          	addi	s7,s7,890 # 960 <digits>
 5ee:	a839                	j	60c <vprintf+0x6a>
        putc(fd, c);
 5f0:	85ca                	mv	a1,s2
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	ee2080e7          	jalr	-286(ra) # 4d6 <putc>
 5fc:	a019                	j	602 <vprintf+0x60>
    } else if(state == '%'){
 5fe:	01498f63          	beq	s3,s4,61c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 602:	0485                	addi	s1,s1,1
 604:	fff4c903          	lbu	s2,-1(s1)
 608:	14090d63          	beqz	s2,762 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 60c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 610:	fe0997e3          	bnez	s3,5fe <vprintf+0x5c>
      if(c == '%'){
 614:	fd479ee3          	bne	a5,s4,5f0 <vprintf+0x4e>
        state = '%';
 618:	89be                	mv	s3,a5
 61a:	b7e5                	j	602 <vprintf+0x60>
      if(c == 'd'){
 61c:	05878063          	beq	a5,s8,65c <vprintf+0xba>
      } else if(c == 'l') {
 620:	05978c63          	beq	a5,s9,678 <vprintf+0xd6>
      } else if(c == 'x') {
 624:	07a78863          	beq	a5,s10,694 <vprintf+0xf2>
      } else if(c == 'p') {
 628:	09b78463          	beq	a5,s11,6b0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 62c:	07300713          	li	a4,115
 630:	0ce78663          	beq	a5,a4,6fc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 634:	06300713          	li	a4,99
 638:	0ee78e63          	beq	a5,a4,734 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 63c:	11478863          	beq	a5,s4,74c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 640:	85d2                	mv	a1,s4
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e92080e7          	jalr	-366(ra) # 4d6 <putc>
        putc(fd, c);
 64c:	85ca                	mv	a1,s2
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e86080e7          	jalr	-378(ra) # 4d6 <putc>
      }
      state = 0;
 658:	4981                	li	s3,0
 65a:	b765                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	008b0913          	addi	s2,s6,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000b2583          	lw	a1,0(s6)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e8e080e7          	jalr	-370(ra) # 4f8 <printint>
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	b771                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b0913          	addi	s2,s6,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000b2583          	lw	a1,0(s6)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e72080e7          	jalr	-398(ra) # 4f8 <printint>
 68e:	8b4a                	mv	s6,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	bf85                	j	602 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 694:	008b0913          	addi	s2,s6,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000b2583          	lw	a1,0(s6)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e56080e7          	jalr	-426(ra) # 4f8 <printint>
 6aa:	8b4a                	mv	s6,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bf91                	j	602 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6b0:	008b0793          	addi	a5,s6,8
 6b4:	f8f43423          	sd	a5,-120(s0)
 6b8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6bc:	03000593          	li	a1,48
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e14080e7          	jalr	-492(ra) # 4d6 <putc>
  putc(fd, 'x');
 6ca:	85ea                	mv	a1,s10
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e08080e7          	jalr	-504(ra) # 4d6 <putc>
 6d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	03c9d793          	srli	a5,s3,0x3c
 6dc:	97de                	add	a5,a5,s7
 6de:	0007c583          	lbu	a1,0(a5)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	df2080e7          	jalr	-526(ra) # 4d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ec:	0992                	slli	s3,s3,0x4
 6ee:	397d                	addiw	s2,s2,-1
 6f0:	fe0914e3          	bnez	s2,6d8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b721                	j	602 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fc:	008b0993          	addi	s3,s6,8
 700:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 704:	02090163          	beqz	s2,726 <vprintf+0x184>
        while(*s != 0){
 708:	00094583          	lbu	a1,0(s2)
 70c:	c9a1                	beqz	a1,75c <vprintf+0x1ba>
          putc(fd, *s);
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	dc6080e7          	jalr	-570(ra) # 4d6 <putc>
          s++;
 718:	0905                	addi	s2,s2,1
        while(*s != 0){
 71a:	00094583          	lbu	a1,0(s2)
 71e:	f9e5                	bnez	a1,70e <vprintf+0x16c>
        s = va_arg(ap, char*);
 720:	8b4e                	mv	s6,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	bdf9                	j	602 <vprintf+0x60>
          s = "(null)";
 726:	00000917          	auipc	s2,0x0
 72a:	23290913          	addi	s2,s2,562 # 958 <malloc+0xec>
        while(*s != 0){
 72e:	02800593          	li	a1,40
 732:	bff1                	j	70e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 734:	008b0913          	addi	s2,s6,8
 738:	000b4583          	lbu	a1,0(s6)
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	d98080e7          	jalr	-616(ra) # 4d6 <putc>
 746:	8b4a                	mv	s6,s2
      state = 0;
 748:	4981                	li	s3,0
 74a:	bd65                	j	602 <vprintf+0x60>
        putc(fd, c);
 74c:	85d2                	mv	a1,s4
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	d86080e7          	jalr	-634(ra) # 4d6 <putc>
      state = 0;
 758:	4981                	li	s3,0
 75a:	b565                	j	602 <vprintf+0x60>
        s = va_arg(ap, char*);
 75c:	8b4e                	mv	s6,s3
      state = 0;
 75e:	4981                	li	s3,0
 760:	b54d                	j	602 <vprintf+0x60>
    }
  }
}
 762:	70e6                	ld	ra,120(sp)
 764:	7446                	ld	s0,112(sp)
 766:	74a6                	ld	s1,104(sp)
 768:	7906                	ld	s2,96(sp)
 76a:	69e6                	ld	s3,88(sp)
 76c:	6a46                	ld	s4,80(sp)
 76e:	6aa6                	ld	s5,72(sp)
 770:	6b06                	ld	s6,64(sp)
 772:	7be2                	ld	s7,56(sp)
 774:	7c42                	ld	s8,48(sp)
 776:	7ca2                	ld	s9,40(sp)
 778:	7d02                	ld	s10,32(sp)
 77a:	6de2                	ld	s11,24(sp)
 77c:	6109                	addi	sp,sp,128
 77e:	8082                	ret

0000000000000780 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 780:	715d                	addi	sp,sp,-80
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e010                	sd	a2,0(s0)
 78a:	e414                	sd	a3,8(s0)
 78c:	e818                	sd	a4,16(s0)
 78e:	ec1c                	sd	a5,24(s0)
 790:	03043023          	sd	a6,32(s0)
 794:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79c:	8622                	mv	a2,s0
 79e:	00000097          	auipc	ra,0x0
 7a2:	e04080e7          	jalr	-508(ra) # 5a2 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	00000097          	auipc	ra,0x0
 7d8:	dce080e7          	jalr	-562(ra) # 5a2 <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6125                	addi	sp,sp,96
 7e2:	8082                	ret

00000000000007e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e4:	1141                	addi	sp,sp,-16
 7e6:	e422                	sd	s0,8(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	8127b783          	ld	a5,-2030(a5) # 1000 <freep>
 7f6:	a805                	j	826 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f8:	4618                	lw	a4,8(a2)
 7fa:	9db9                	addw	a1,a1,a4
 7fc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	6318                	ld	a4,0(a4)
 804:	fee53823          	sd	a4,-16(a0)
 808:	a091                	j	84c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80a:	ff852703          	lw	a4,-8(a0)
 80e:	9e39                	addw	a2,a2,a4
 810:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 812:	ff053703          	ld	a4,-16(a0)
 816:	e398                	sd	a4,0(a5)
 818:	a099                	j	85e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x40>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x50>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x36>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059713          	slli	a4,a1,0x20
 83e:	9301                	srli	a4,a4,0x20
 840:	0712                	slli	a4,a4,0x4
 842:	9736                	add	a4,a4,a3
 844:	fae60ae3          	beq	a2,a4,7f8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061713          	slli	a4,a2,0x20
 852:	9301                	srli	a4,a4,0x20
 854:	0712                	slli	a4,a4,0x4
 856:	973e                	add	a4,a4,a5
 858:	fae689e3          	beq	a3,a4,80a <free+0x26>
  } else
    p->s.ptr = bp;
 85c:	e394                	sd	a3,0(a5)
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	6422                	ld	s0,8(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret

000000000000086c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	f04a                	sd	s2,32(sp)
 876:	ec4e                	sd	s3,24(sp)
 878:	e852                	sd	s4,16(sp)
 87a:	e456                	sd	s5,8(sp)
 87c:	e05a                	sd	s6,0(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 880:	02051493          	slli	s1,a0,0x20
 884:	9081                	srli	s1,s1,0x20
 886:	04bd                	addi	s1,s1,15
 888:	8091                	srli	s1,s1,0x4
 88a:	0014899b          	addiw	s3,s1,1
 88e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 890:	00000517          	auipc	a0,0x0
 894:	77053503          	ld	a0,1904(a0) # 1000 <freep>
 898:	c515                	beqz	a0,8c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	02977f63          	bgeu	a4,s1,8dc <malloc+0x70>
 8a2:	8a4e                	mv	s4,s3
 8a4:	0009871b          	sext.w	a4,s3
 8a8:	6685                	lui	a3,0x1
 8aa:	00d77363          	bgeu	a4,a3,8b0 <malloc+0x44>
 8ae:	6a05                	lui	s4,0x1
 8b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b8:	00000917          	auipc	s2,0x0
 8bc:	74890913          	addi	s2,s2,1864 # 1000 <freep>
  if(p == (char*)-1)
 8c0:	5afd                	li	s5,-1
 8c2:	a88d                	j	934 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c4:	00000797          	auipc	a5,0x0
 8c8:	74c78793          	addi	a5,a5,1868 # 1010 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7e1                	j	8a2 <malloc+0x36>
      if(p->s.size == nunits)
 8dc:	02e48b63          	beq	s1,a4,912 <malloc+0xa6>
        p->s.size -= nunits;
 8e0:	4137073b          	subw	a4,a4,s3
 8e4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e6:	1702                	slli	a4,a4,0x20
 8e8:	9301                	srli	a4,a4,0x20
 8ea:	0712                	slli	a4,a4,0x4
 8ec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70a73723          	sd	a0,1806(a4) # 1000 <freep>
      return (void*)(p + 1);
 8fa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fe:	70e2                	ld	ra,56(sp)
 900:	7442                	ld	s0,48(sp)
 902:	74a2                	ld	s1,40(sp)
 904:	7902                	ld	s2,32(sp)
 906:	69e2                	ld	s3,24(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	6121                	addi	sp,sp,64
 910:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	bff1                	j	8f2 <malloc+0x86>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91c:	0541                	addi	a0,a0,16
 91e:	00000097          	auipc	ra,0x0
 922:	ec6080e7          	jalr	-314(ra) # 7e4 <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	d971                	beqz	a0,8fe <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	fa9776e3          	bgeu	a4,s1,8dc <malloc+0x70>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	00000097          	auipc	ra,0x0
 944:	b7e080e7          	jalr	-1154(ra) # 4be <sbrk>
  if(p == (char*)-1)
 948:	fd5518e3          	bne	a0,s5,918 <malloc+0xac>
        return 0;
 94c:	4501                	li	a0,0
 94e:	bf45                	j	8fe <malloc+0x92>
