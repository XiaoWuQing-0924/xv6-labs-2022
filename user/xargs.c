#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char **argv){
    int index = 0;
    char c;
    if(argc < 2){
        fprintf(2, " too less arg (eg. echo a.txt | xargs grep name)");
    }
    char **str = (char **)malloc(sizeof(char *) * MAXARG);
    for(int i = 0 ; i < MAXARG; i++){
        str[i] = (char *)malloc(sizeof(char) * MAXPATH);
    }
    for(; index < argc - 1; index++){
        strcpy(str[index], argv[index + 1]);
    }
    //printf("%d",sizeof(str));
    int n = 0;
    while(read(0, &c, 1) > 0){
        //printf("%c", c);
        if(c == '\n'){
            n = 0;
            index++;
            continue;
        }
        if(n > MAXPATH)
            fprintf(2, "too long arg!");
        str[index][n++] = c;
    }
    for(int i = 0; i < index; i++){
        argv[i] = str[i];
    }
    argv[index] = 0;
    exec(argv[0], argv);
    fprintf(2, "exec %s failed\n", argv[0]);
    
    return 0;
}