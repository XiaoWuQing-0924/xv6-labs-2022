#include "kernel/types.h"
#include "user/user.h"


int main(int argc, char *argv[]){
    int fd[2];
    pipe(fd);
    if(fork() == 0){
        //child
        char cnt[5];
        read(fd[0], cnt, sizeof(cnt));
        fprintf(1, "%d: received %s\n", getpid(), cnt);
        write(fd[1], "pong", 5);
        exit(0);
    }else{
        //parent
        char cnt[5];
        write(fd[1], "ping", 5);
        read(fd[0], cnt, sizeof(cnt));   
        fprintf(1, "%d: received %s\n", getpid(), cnt);
            
        exit(0);
    }
}