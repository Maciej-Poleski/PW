#include<cstdio>

extern "C" {
__global__
void kernelMain(int *input, int *output, const unsigned int *arg){
    //int thid = (blockIdx.x * blockDim.x) + threadIdx.x;
    const unsigned int width=arg[0],height=arg[1];
    const unsigned int column=blockIdx.x*32+threadIdx.x;
    const unsigned int row=blockIdx.y*32+threadIdx.y;

    const unsigned int newRow=(32*blockIdx.x+threadIdx.y);
    const unsigned int newColumn=32*blockIdx.y+threadIdx.x;

    __shared__ int cache[32][35];

    cache[threadIdx.x][threadIdx.y]=input[width*row+column];
    __syncthreads();
    output[newRow*height+newColumn]=cache[threadIdx.y][threadIdx.x];
//     output[height*column+row]=cache[threadIdx.y][threadIdx.x];
//     output[height*column+row]=input[width*row+column];
}

}

