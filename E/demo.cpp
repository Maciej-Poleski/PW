#include <cuda.h>
#include <cstdio>
#include <climits>

int maxsubarray(CUdeviceptr array, int N);

int main()
{

    cuInit(0);
    CUdevice device;
    CUcontext context;
    CUmodule module;

    if (cuDeviceGet(&device, 0) != CUDA_SUCCESS) {
        printf("cuDeviceGet\n");
        exit(-1);
    }
    if (cuCtxCreate(&context, CU_CTX_SCHED_SPIN | CU_CTX_MAP_HOST, device) != CUDA_SUCCESS) {
        printf("cuCtxCreate\n");
        exit(-1);
    }

    int goodRes;
    scanf("%d", &goodRes);

    int N;
    scanf("%d", &N);
    int SIZE = N * N;

    int* arrayHost;
    CUdeviceptr array;

    if (cuMemAllocHost((void**)&arrayHost, SIZE * sizeof(int)) != CUDA_SUCCESS) {
        printf("cuMemAllocHost\n");
        exit(-1);
    }
    if (cuMemAlloc(&array, SIZE * sizeof(int)) != CUDA_SUCCESS) {
        printf("cuMemAlloc\n");
        exit(-1);
    }

    for (int i = 0; i < SIZE; ++i) {
        scanf("%d", &arrayHost[i]);
    }

    if (cuMemcpyHtoD(array, arrayHost, SIZE * sizeof(int)) != CUDA_SUCCESS) {
        printf("cuMemcpyHtoD\n");
        exit(-1);
    }
    cuCtxSynchronize();

    int res = maxsubarray(array, N);

    if (goodRes != res) {
        printf("WRONG ANSWER, should be: %d is: %d\n", goodRes, res);
    } else {
        printf("OK %d\n",res);
    }

    cuMemFreeHost(arrayHost);
    cuMemFree(array);
    cuCtxDestroy(context);

    return 0;
}
