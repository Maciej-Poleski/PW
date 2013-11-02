#include <cstdio>
#include <climits>

extern "C" {
__global__
void kernelMain(int *input, int *output){
    int thid = (blockIdx.x * blockDim.x) + threadIdx.x;
    __shared__ int mem[1024];
    mem[threadIdx.x]=input[thid];
    __syncthreads();

    for(unsigned int shift=1;shift<1024;shift*=2)
    {
        int val=mem[threadIdx.x];
        if(threadIdx.x>=shift)
        {
            if(val>mem[threadIdx.x-shift])
                val=mem[threadIdx.x-shift];
        }
        __syncthreads();
        mem[threadIdx.x]=val;
    }
    if(threadIdx.x==1023)
        output[blockIdx.x]=mem[1023];
}

__global__ void kernelPrepare(int *input, int *output, int* args)
{
    const unsigned int count=args[0];
    const unsigned int n=args[1];
    int thid = (blockIdx.x * blockDim.x) + threadIdx.x;
    if(thid*count>=n)
        return;
    int m=input[thid*count];
    for(unsigned int i=1;i<count && thid*count+i<n;++i)
    {
        if(m>input[thid*count+i])
            m=input[thid*count+i];
    }
    output[thid]=m;
}

}

