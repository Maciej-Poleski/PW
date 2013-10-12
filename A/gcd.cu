#include<cstdio>

extern "C" {
__global__
void kernelMain(int *iTab, int*jTab){
    //int thid = (blockIdx.x * blockDim.x) + threadIdx.x;
    const int i=blockIdx.x,j=blockIdx.y;
    const int rowSize=gridDim.y;

    int a=i+1,b=j+1;
    int x=0,lastX=1;
    int y=1,lastY=0;
    while(b!=0)
    {
        int q=a/b;
        int c=a%b;
        a=b;
        b=c;
        c=x;
        x=lastX-q*x;
        lastX=c;
        c=y;
        y=lastY-q*y;
        lastY=c;
    }

    iTab[rowSize*i+j]=lastX;
    jTab[rowSize*i+j]=lastY;
}

}
