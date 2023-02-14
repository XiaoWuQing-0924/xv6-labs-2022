#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void func1(){
    int i = 1;
    i++;
    fprintf(1, "func1 start!!\n");
    fprintf(1, "i = %d\n", i);
    return;
}

int main(int argc, char *argv[]){

    fprintf(1, "test start!!\n");
    func1();
    return 0;
}