#include "cuMin.h"
#include <cstdio>
#include <climits>

using namespace std;
int main(){
    int *c;
//     int n=(1<<16);
    int n = 292788770;
    c = new int [n];
    for(int i = 0; i < n; ++i ) {
        c[i] = n-i+6;
    }
    int d = cuMin(c , n);
    printf ("%d\n",d);
    delete[]c;
    return 0;
}
