#include "cuMin.h"
#include <cstdio>
#include <climits>

using namespace std;
int main(){
    int *c;
    int n = (1<<17)+52;
    c = new int [n];
    for(int i = 0; i < n; ++i ) {
        c[i] = n-i+5;
    }
    int d = cuMin(c , n);
    printf ("%d\n",d);
    delete[]c;
    return 0;
}
