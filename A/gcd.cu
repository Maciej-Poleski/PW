#include<cstdio>

extern "C" {
__global__
void kernelMain(int *iTab, int *jTab, const unsigned int *arg){
    //int thid = (blockIdx.x * blockDim.x) + threadIdx.x;
    const unsigned int n=arg[0],m=arg[1];
    const unsigned int i=blockIdx.x*blockDim.x+threadIdx.x;
    const unsigned int j=blockIdx.y*blockDim.y+threadIdx.y;
    const int rowSize=m;

    if(i>=n || j>=m)
        return;

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
