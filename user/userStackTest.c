#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

struct g
{
    int cnt[900];
};
void foo(struct g *x){
    for(int i = 0; i < 900; i++){
        printf("%d\n", x->cnt[i]);
    }
    return;
}

int main(){
    struct g x;
    for(int i = 0; i < 900; i++){
        x.cnt[i] = i + 100;
    }
    foo(&x);
    exit(0);
}