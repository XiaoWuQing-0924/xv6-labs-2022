#include "kernel/types.h"
#include "user/user.h"
int isPrimes(int n){
    for(int i = 2; i < n; i++){
        if(n % i == 0){
            return 0;
        }
    }
    return 1;
}
int main(){
    int fd[2];
    pipe(fd);
    int statu;
    if(fork() == 0){
        //child
        close(fd[1]);
        // int fd_child[2];
        // pipe(fd_child);
        // close(1);
        // dup(fd_child[0]);
        // close(fd_child[0]);
        char n;
        while(read(fd[0], &n, 1) > 0){

            int cur = (int) n;
            if(isPrimes(cur)){
                //fprintf(1, &n, 1);
                //to_string(n)
                char tmp[4],str[4];
                int i = 0, j = 0;
                while(cur){
                    tmp[i++] = cur%10 +'0';
                    cur /= 10;
                }
                i--;
                while(i >= 0){
                    str[j] = tmp[i];
                    i--;
                    j++;
                }
                str[j++] = '\n';
                str[j] = 0;
                fprintf(1, "prime ", 7);
                fprintf(1, str, j);
                // write(fd_child[1], "prime ", 7);
                // write(fd_child[1], str, j);
            }
        }
        close(fd[0]);
        //close(fd_child[1]);
        exit(0);
    }else{
        close(fd[0]);
        for(int i = 2; i <= 35; i++){
            write(fd[1], (char *)&i, 1);
        }
        close(fd[1]);
        wait(&statu);
    }
    return 0;
    
}