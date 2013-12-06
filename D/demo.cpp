#include"radixsort.h"
#include<cstdio>
#include<sys/mman.h>

using namespace std;

int main()
{
    int* d;

    int n = 2048 * 10000 ;
    int* c = (int*) mmap(NULL, sizeof(int) * n, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    for (int j = 0; j < n; ++j) {
        c[j] = n - j;
    }
    d = radixsort(c, n);
    for (int j = 0; j < n; ++j) {
        printf("%d\n", d[j]);
    }
    munmap(c, sizeof(int)*n);
    munmap(d, sizeof(int)*n);
    return 0;
}
