#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[]){
    int fd;
    if((fd = open(argv[1], 0)) < 0){
        fprintf(2, "cannot open %s\n", argv[1]);
    }else{
        fprintf(1, "yes open %s\n", argv[1]);
    }
    close(fd);
    return 0;
}