#include<cstdio>

extern "C" {
    __global__
    void kernelMain(int *input, int *output, const unsigned int *arg) {
        //int thid = (blockIdx.x * blockDim.x) + threadIdx.x;

        __shared__ int cache[32][32];

        const unsigned int width=arg[0],height=arg[1];

        const unsigned int x=threadIdx.x;


        for(unsigned int y=0; y<32; ++y)
        {
            const unsigned int row=blockIdx.y*32+y;
            const unsigned int column=blockIdx.x*32+x;

            cache[x][y]=input[width*row+column];
        }
        __syncthreads();
        for(unsigned int y=0; y<32; ++y)
        {
            const unsigned int newRow=32*blockIdx.x+x;
            const unsigned int newColumn=32*blockIdx.y+y;


            output[newRow*height+newColumn]=cache[x][y];
        }
    }

}

