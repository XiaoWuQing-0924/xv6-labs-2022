#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void getFileName(char * path, char * fileName){
    int index = 0;
    char *p = path + strlen(path) - 1;
    while(*p != '/') p--;
    //todo if len > max
    p++;
    while(*p){
        fileName[index++] = *p;
        p++;
    }
}

void find(char * path, char * name){
    char buf[512] = {0};
    int fd;
    struct stat st;
    struct dirent de;
    if((fd = open(path, 0)) < 0){
        fprintf(2, "cannot open %s\n", path);
        return;
    }
    if(fstat(fd, &st) < 0){
        fprintf(2, "ls: cannot stat %s\n", path);
        close(fd);
        return;
    }
    switch(st.type){
        case T_FILE:{
            char fileName[DIRSIZ];
            memset(fileName, 0, sizeof(fileName));
            getFileName(path, fileName);
            // printf("---%s\n", path);
            // printf("+++%s\n", fileName);
            if(strcmp(fileName, name) == 0){
                printf("%s\n", path);
            }
            break;
        }
            
        case T_DIR:
            while(read(fd, &de, sizeof(de)) == sizeof(de)){
                memset(buf, 0, sizeof(buf));
                if(de.inum == 0)
                    continue;
                if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0){
                    continue;
                } 
                if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
                    printf("ls: path too long\n");
                    break;
                }if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
                    printf("ls: path too long\n");
                    break;
                }
                strcpy(buf, path);
                
                char *p = buf + strlen(buf);
                *p = '/';
                p++;
                int index = 0;
                while(de.name[index]){
                    *p = de.name[index];
                    p++;
                    index++;
                }
                //printf("+++%s\n", de.name);
                find(buf, name);
            }
    }
    close(fd);
    return;
}

int main(int argc, char *argv[]){

    if(argc < 3){
        printf("too less arg, eg.(find . b)");
        exit(0);
    }
    for(int i = 1; i < argc - 1; i++){
        find(argv[i], argv[argc - 1]);
    }
    
    exit(0);
}
