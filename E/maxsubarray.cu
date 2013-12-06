#include <cstdio>
#include <climits>
#include <algorithm>

#define SERIAL_SCALE 3

#define SERIAL_PART (1<<SERIAL_SCALE)

extern "C" {
    __global__
    void kernelMain(int* input, int* output, int N)
    {
        //int thid = (blockIdx.x * blockDim.x) + threadIdx.x; // Globalny ID wątku (mało przydatne)
        __shared__ int mem[SERIAL_PART * 1024];
        for (int i = 0; i < SERIAL_PART; ++i) {
            mem[blockDim.x * i + threadIdx.x] = input[N * blockIdx.y + blockDim.x * i + threadIdx.x];
        }
        __syncthreads();
        for (int shift = 1; shift < N; shift *= 2) {
            int v[SERIAL_PART];
            for (int i = 0; i < SERIAL_PART; ++i) {
                v[i] = mem[blockDim.x * i + threadIdx.x];
                if (shift <= blockDim.x * i + threadIdx.x)
                    v[i] += mem[blockDim.x * i + threadIdx.x - shift];
            }
            __syncthreads();
            for (int i = 0; i < SERIAL_PART; ++i) {
                mem[blockDim.x * i + threadIdx.x] = v[i];
            }
        }

        for (int i = 0; i < SERIAL_PART; ++i) {
            output[(N + 1)*blockIdx.y + blockDim.x * i + threadIdx.x + 1] = mem[blockDim.x * i + threadIdx.x];
        }

        if (threadIdx.x == 0)
            output[(N + 1)*blockIdx.y] = 0;
    }

    __global__
    void findMax(int* prefixSumMatrix, int* output, int N)
    {
        int x = (blockIdx.x * blockDim.x) + threadIdx.x;
        int y = (blockIdx.y * blockDim.y) + threadIdx.y + 1;
        __shared__ int mem[1024];
        int flatId = blockDim.x * threadIdx.y + threadIdx.x;
        if (x >= y) {
            mem[flatId] = 0;
        } else {
            int result = 0;
            int current = 0;
            for (int i = 0; i < N; ++i) {
                current = current + prefixSumMatrix[(N + 1) * i + y] - prefixSumMatrix[(N + 1) * i + x];
                if (current < 0)
                    current = 0;
                if (current > result)
                    result = current;
            }
            mem[flatId] = result;
        }
        __syncthreads();
        for (int shift = 1; shift < 1024; shift *= 2) {
            int v = mem[flatId];
            if (flatId >= shift)
                if (v < mem[flatId - shift])
                    v = mem[flatId - shift];
            __syncthreads();
            mem[flatId] = v;
        }
        if (flatId == 1023) {
            output[gridDim.x * blockIdx.y + blockIdx.x] = mem[flatId];
        }
    }
}

