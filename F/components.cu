#include <cstdio>
#include <climits>
#include <algorithm>

#define SERIAL_SCALE 3

#define SERIAL_PART (1<<SERIAL_SCALE)

extern "C" {
    __global__
    void initialize(int* output, int size)
    {
        int flatId=(blockIdx.x * blockDim.x) + threadIdx.x;
        if(flatId<size)
            output[flatId]=flatId;
    }

    __global__
    void transpose(int *input, int *output, int N){
        const unsigned int column=blockIdx.x*32+threadIdx.x;
        const unsigned int row=blockIdx.y*32+threadIdx.y;

        const unsigned int newRow=(32*blockIdx.x+threadIdx.y);
        const unsigned int newColumn=32*blockIdx.y+threadIdx.x;

        __shared__ int cache[32][35];

        cache[threadIdx.x][threadIdx.y]=input[N*row+column];
        __syncthreads();
        output[newRow*N+newColumn]=cache[threadIdx.y][threadIdx.x];
    }

    __global__
    void propagateMin(int *G,int *result,int *modified,int N)
    {
        int column=(blockIdx.x * blockDim.x) + threadIdx.x;
        bool m=false;
#define GET(array,row) array[N*(row)+column]
#define propagate(i)                                                           \
        int currG=GET(G,i);                                                    \
        if(prevG==currG)                                                       \
        {                                                                      \
            int currR=GET(result,i);                                           \
            if(currR>prevR)                                                    \
            {                                                                  \
                GET(result,i)=prevR;                                           \
                m=true;                                                        \
            }                                                                  \
            else                                                               \
            {                                                                  \
                prevR=currR;                                                   \
            }                                                                  \
        }                                                                      \
        else                                                                   \
        {                                                                      \
            prevR=GET(result,i);                                               \
        }                                                                      \
        prevG=currG;

        int prevG=GET(G,0);
        int prevR=GET(result,0);
        for(int i=1;i<N;++i)
        {
            propagate(i)
        }

        prevG=GET(G,N-1);
        prevR=GET(result,N-1);
        for(int i=N-2;i>=0;--i)
        {
            propagate(i)
        }

        if(m)
            *modified=-1;

#undef propagate
#undef GET
    }
}

