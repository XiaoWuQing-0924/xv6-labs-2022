
sleep.o:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16

0000000000000002 <.LCFI0>:
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

0000000000000008 <.LCFI1>:
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	02f50063          	beq	a0,a5,2a <.L2>
      fprintf(1, "error input! plase use eg.'sleep 10' \n");
   e:	00000597          	auipc	a1,0x0
  12:	00058593          	mv	a1,a1

0000000000000016 <.LVL1>:
  16:	4505                	li	a0,1

0000000000000018 <.LVL2>:
  18:	00000097          	auipc	ra,0x0
  1c:	000080e7          	jalr	ra # 18 <.LVL2>

0000000000000020 <.LVL3>:
      exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	000080e7          	jalr	ra # 22 <.LVL3+0x2>

000000000000002a <.L2>:
  }
  sleep(atoi(argv[1]));
  2a:	6588                	ld	a0,8(a1)

000000000000002c <.LVL5>:
  2c:	00000097          	auipc	ra,0x0
  30:	000080e7          	jalr	ra # 2c <.LVL5>

0000000000000034 <.LVL6>:
  34:	00000097          	auipc	ra,0x0
  38:	000080e7          	jalr	ra # 34 <.LVL6>

000000000000003c <.LVL7>:
  exit(0);
  3c:	4501                	li	a0,0
  3e:	00000097          	auipc	ra,0x0
  42:	000080e7          	jalr	ra # 3e <.LVL7+0x2>
