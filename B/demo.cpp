#include "transpose.h"
#include <cstdio>
using namespace std;

void dump(int *tab,int width,int height)
{
    for(int i=0;i<height;++i)
    {
        for(int j=0;j<width;++j)
        {
            printf("%d ",tab[width*i+j]);
        }
        printf("\n");
    }
}

int main(){
    int *c, *d;
    int n=2*32, m=2*32;
    c = new int[m*n];
    for (int j=0; j<n; ++j){
        for (int i=0; i<m; ++i){
            c[j*m + i] = i%5;
        }
    }
    dump(c,m,n);
    d = transpose(c, n, m);
    dump(d,n,m);
    delete [] c;
    delete [] d;
    return 0;
}
