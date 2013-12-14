#include <cuda.h>
#include <cstdio>
#include <climits>
#include <set>

void components(CUdeviceptr bitmap, int N, CUdeviceptr out_cc);

int maxsubarray(CUdeviceptr array, int N);

int main() {

    cuInit(0);

    CUdevice device;
    CUcontext context;
    CUmodule module;

    if (cuDeviceGet(&device, 0) != CUDA_SUCCESS) { printf("cuDeviceGet\n"); exit(-1); }
    if (cuCtxCreate(&context, CU_CTX_SCHED_SPIN | CU_CTX_MAP_HOST, device) != CUDA_SUCCESS) { printf("cuCtxCreate\n"); exit(-1); }

    int hint;
    scanf("%d", &hint);

    int N;
    scanf("%d", &N);
    int SIZE = N * N;

    int * bitmapHost;
    int * ccHost;
    CUdeviceptr bitmap;
    CUdeviceptr cc;
    std::set<int> ids;

    if (cuMemAllocHost((void**)&bitmapHost, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemAllocHost(bitmap)\n"); exit(-1); }
    if (cuMemAllocHost((void**)&ccHost, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemAllocHost(cc)\n"); exit(-1); }
    if (cuMemAlloc(&bitmap, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemAlloc(bitmap)\n"); exit(-1); }
    if (cuMemAlloc(&cc, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemAlloc(cc)\n"); exit(-1); }

    for (int i = 0; i < SIZE; ++i) {
        scanf("%d", &bitmapHost[i]);
    }

    if (cuMemcpyHtoD(bitmap, bitmapHost, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemcpyHtoD\n"); exit(-1); }

    cuCtxSynchronize();

    components(bitmap, N, cc);

    if (cuMemcpyDtoH(ccHost, cc, SIZE * sizeof(int)) != CUDA_SUCCESS) { printf("cuMemcpyDtoH\n"); exit(-1); }

    cuCtxSynchronize();
    for (int i = 0; i < N-1; ++i) {
        for (int j = 0; j < N-1; ++j) {

            int index = j + i * N;
            int indexR = j + 1 + i * N;
            int indexB = j + (i + 1) * N;

            int color = bitmapHost[index];
            int colorR = bitmapHost[indexR];
            int colorB = bitmapHost[indexB];

            int ccc = ccHost[index];
            int cccR = ccHost[indexR];
            int cccB = ccHost[indexB];

            if ((color == colorR) != (ccc == cccR)) {
                printf("WRONG R: (%d,%d) - %d %d\n", j, i, ccc, cccR); goto ERR;
            }
            if ((color == colorB) != (ccc == cccB)) {
                printf("WRONG B: (%d,%d) - %d %d\n", j, i, ccc, cccB); goto ERR;
            }
        }
    }

    for (int i = 0; i < SIZE; ++i) {
        ids.insert(ccHost[i]);
    }

    if (hint != ids.size()) {
        printf("WRONG number of CCs: %d %d\n", hint, (int)ids.size()); goto ERR;
    }

    printf("OK\n");

    ERR:

//     for(int i=0;i<N;++i)
//     {
//         for(int j=0;j<N;++j)
//         {
//             printf("%4d",ccHost[i*N+j]);
//         }
//         printf("\n");
//     }

    cuMemFreeHost(ccHost);
    cuMemFreeHost(bitmapHost);
    cuMemFree(cc);
    cuMemFree(bitmap);
    cuCtxDestroy(context);

    return 0;
}