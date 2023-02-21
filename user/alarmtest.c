//
// test program for the alarm lab.
// you can modify this file for testing,
// but please make sure your kernel
// modifications pass the original
// versions of these tests.
//

#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/riscv.h"
#include "user/user.h"

void test0();
void test1();
void test2();
void test3();
void periodic();
void slow_handler();
void dummy_handler();

int
main(int argc, char *argv[])
{
  test0();
  test1();
  test2();
  test3();
  exit(0);
}

volatile static int count;

void
periodic()
{
    //为什么不写sigreturn();也可以正常返回到test0中？
    //因为在XV6中函数调用发生时，不会自动将ra压入栈中，而是需要在被调用函数开头将ra和fp压入栈，例如本函数：
            // 0:	1141                	addi	sp,sp,-16
            // 2:	e406                	sd	ra,8(sp)
            // 4:	e022                	sd	s0,0(sp)
            // 6:	0800                	addi	s0,sp,16
    //因此在traps返回时，我们把epc指向了periodic()，
    //随后periodic()函数将ra压入栈中，ra就是test0函数中写入的，情况可能不确定，但是总规是在test0中
    //因此即使不写sigreturn() 也可以可以返回到test0中，可能会有bug。
    //验证的方法很好做，就是在traps中改写epc寄存器的同时，将p->trapframe->ra = 0x0;
    //这样，traps返回时，ra=0x0，即periodic()函数，这样程序会一直在periodic()中循环！
  count = count + 1;
  printf("alarm!\n");
  sigreturn();
}

// tests whether the kernel calls
// the alarm handler even a single time.
void
test0()
{
  int i;
  printf("test0 start\n");
  count = 0;
  sigalarm(2, periodic);
  for(i = 0; i < 1000*500000; i++){
    if((i % 1000000) == 0)
      write(2, ".", 1);
    if(count > 0)
      break;
  }
  sigalarm(0, 0);
  if(count > 0){
    printf("test0 passed\n");
  } else {
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
  }
}

void __attribute__ ((noinline)) foo(int i, int *j) {
  if((i % 2500000) == 0) {
    write(2, ".", 1);
  }
  *j += 1;
}

//
// tests that the kernel calls the handler multiple times.
//
// tests that, when the handler returns, it returns to
// the point in the program where the timer interrupt
// occurred, with all registers holding the same values they
// held when the interrupt occurred.
//
void
test1()
{
  int i;
  int j;

  printf("test1 start\n");
  count = 0;
  j = 0;
  sigalarm(2, periodic);
  for(i = 0; i < 500000000; i++){
    if(count >= 10)
      break;
    foo(i, &j);
  }
  if(count < 10){
    printf("\ntest1 failed: too few calls to the handler\n");
  } else if(i != j){
    // the loop should have called foo() i times, and foo() should
    // have incremented j once per call, so j should equal i.
    // once possible source of errors is that the handler may
    // return somewhere other than where the timer interrupt
    // occurred; another is that that registers may not be
    // restored correctly, causing i or j or the address ofj
    // to get an incorrect value.
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
  } else {
    printf("test1 passed\n");
  }
}

//
// tests that kernel does not allow reentrant alarm calls.
void
test2()
{
  int i;
  int pid;
  int status;

  printf("test2 start\n");
  if ((pid = fork()) < 0) {
    printf("test2: fork failed\n");
  }
  if (pid == 0) {
    count = 0;
    sigalarm(2, slow_handler);
    for(i = 0; i < 1000*500000; i++){
      if((i % 1000000) == 0)
        write(2, ".", 1);
      if(count > 0)
        break;
    }
    if (count == 0) {
      printf("\ntest2 failed: alarm not called\n");
      exit(1);
    }
    exit(0);
  }
  wait(&status);
  if (status == 0) {
    printf("test2 passed\n");
  }
}

void
slow_handler()
{
  count++;
  printf("alarm!\n");
  if (count > 1) {
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  }
  sigalarm(0, 0);
  sigreturn();
}

//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void
dummy_handler()
{
  sigalarm(0, 0);
  sigreturn();
}

//
// tests that the return from sys_sigreturn() does not
// modify the a0 register
void
test3()
{
  uint64 a0;

  sigalarm(1, dummy_handler);
  printf("test3 start\n");

  asm volatile("lui a5, 0");
  asm volatile("addi a0, a5, 0xac" : : : "a0");
  for(int i = 0; i < 500000000; i++)
    ;
  asm volatile("mv %0, a0" : "=r" (a0) );

  if(a0 != 0xac)
    printf("test3 failed: register a0 changed\n");
  else
    printf("test3 passed\n");
}
