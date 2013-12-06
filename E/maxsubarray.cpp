#include "cuda.h"
#include <cstdio>
#include <cassert>
#include <climits>
#include <algorithm>
#include <limits>

const char* moduleName = "maxsubarray.ptx";
const char* kernelName = "kernelMain";

const char* cuda_error_string(CUresult result);

#ifdef DEBUG
#define checkResult(x) checkResult_impl(x,__LINE__)
static void checkResult_impl(CUresult result, int line)
{
    if (result != CUDA_SUCCESS) {
        fprintf(stderr, "%d: %s\n", line, cuda_error_string(result));
    }
}
#else
#define NDEBUG
#define checkResult(x) x
#endif

#define SERIAL_SCALE 3
#define SERIAL_PART (1<<SERIAL_SCALE)

/**
 * @param size Ilość danych
 * @return Rozmiar tablicy zaokrąglony w górę do pełnego bloku (1024) * SERIAL_PART
 */
static unsigned int filledMemSize(unsigned int size) __attribute__((optimize(3)));
static unsigned int filledMemSize(unsigned int size)
{
    if ((size & ((1 << (10 + SERIAL_SCALE)) - 1)) == 0)
        return size;
    return (size & (~((1 << (10 + SERIAL_SCALE)) - 1))) + (1 << (10 + SERIAL_SCALE));
}

#include<sys/mman.h>

int maxsubarray(CUdeviceptr array, int N)
{
    //Tworzy modul z pliku binarnego "gcd.ptx"
    CUmodule cuModule = (CUmodule)0;
    checkResult(cuModuleLoad(&cuModule, moduleName));

    //Pobiera handler kernela z modulu
    CUfunction helloWorld;
    checkResult(cuModuleGetFunction(&helloWorld, cuModule, kernelName));

    CUfunction findMax;
    checkResult(cuModuleGetFunction(&findMax, cuModule, "findMax"));


#ifdef DEBUG
    assert(filledMemSize(1024) == SERIAL_PART * 1024);
    assert(filledMemSize(1) == SERIAL_PART * 1024);
    assert(filledMemSize(2) == SERIAL_PART * 1024);
    assert(filledMemSize(1023) == SERIAL_PART * 1024);
#endif

    /********* TUTAJ JEST ROZWIĄZANIE **********/

    CUdeviceptr prefixSum;
    checkResult(cuMemAlloc(&prefixSum, sizeof(int) * ((N + 1) * N)));

    void* args1[] = {&array, &prefixSum, &N};

    checkResult(cuLaunchKernel(helloWorld, 1, N, 1, N / SERIAL_PART, 1, 1, 0, 0, args1, 0));

// #ifdef DEBUG
//     int* outputH;
//     checkResult(cuMemAllocHost(reinterpret_cast<void**>(&outputH), sizeof(int)*N * (N + 1)));
//     checkResult(cuMemcpyDtoH(outputH,prefixSum,sizeof(int)*N*(N+1)));
//     for (int i = 0; i < N; ++i) {
//         for (int j = 0; j < N + 1; ++j)
//             printf("%d ", outputH[i * (N + 1) + j]);
//         printf("\n");
//     }
// #endif

    CUdeviceptr output;
    checkResult(cuMemAlloc(&output, sizeof(int) * (N / 32) * (N / 32)));
    checkResult(cuMemsetD32(output,0,(N/32)*(N/32)));

    void* args2[] = {&prefixSum, &output, &N};
    checkResult(cuLaunchKernel(findMax, N / 32, N / 32, 1, 32, 32, 1, 0, 0, args2, 0));

    int* almostResult;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&almostResult), sizeof(int) * (N / 32) * (N / 32)));

    checkResult(cuMemcpyDtoH(almostResult, output, sizeof(int) * (N / 32) * (N / 32)));
    checkResult(cuCtxSynchronize());
    int result = *std::max_element(almostResult, almostResult + (N / 32) * (N / 32));

    cuMemFreeHost(almostResult);
    cuMemFree(output);
    cuMemFree(prefixSum);

    return result;
}

const char* cuda_error_string(CUresult result)
{
    switch (result) {
    case CUDA_SUCCESS:
        return "No errors";
    case CUDA_ERROR_INVALID_VALUE:
        return "Invalid value";
    case CUDA_ERROR_OUT_OF_MEMORY:
        return "Out of memory";
    case CUDA_ERROR_NOT_INITIALIZED:
        return "Driver not initialized";
    case CUDA_ERROR_DEINITIALIZED:
        return "Driver deinitialized";

    case CUDA_ERROR_NO_DEVICE:
        return "No CUDA-capable device available";
    case CUDA_ERROR_INVALID_DEVICE:
        return "Invalid device";

    case CUDA_ERROR_INVALID_IMAGE:
        return "Invalid kernel image";
    case CUDA_ERROR_INVALID_CONTEXT:
        return "Invalid context";
    case CUDA_ERROR_CONTEXT_ALREADY_CURRENT:
        return "Context already current";
    case CUDA_ERROR_MAP_FAILED:
        return "Map failed";
    case CUDA_ERROR_UNMAP_FAILED:
        return "Unmap failed";
    case CUDA_ERROR_ARRAY_IS_MAPPED:
        return "Array is mapped";
    case CUDA_ERROR_ALREADY_MAPPED:
        return "Already mapped";
    case CUDA_ERROR_NO_BINARY_FOR_GPU:
        return "No binary for GPU";
    case CUDA_ERROR_ALREADY_ACQUIRED:
        return "Already acquired";
    case CUDA_ERROR_NOT_MAPPED:
        return "Not mapped";
    case CUDA_ERROR_NOT_MAPPED_AS_ARRAY:
        return "Mapped resource not available for access as an array";
    case CUDA_ERROR_NOT_MAPPED_AS_POINTER:
        return "Mapped resource not available for access as a pointer";
    case CUDA_ERROR_ECC_UNCORRECTABLE:
        return "Uncorrectable ECC error detected";
    case CUDA_ERROR_UNSUPPORTED_LIMIT:
        return "CUlimit not supported by device";

    case CUDA_ERROR_INVALID_SOURCE:
        return "Invalid source";
    case CUDA_ERROR_FILE_NOT_FOUND:
        return "File not found";
    case CUDA_ERROR_SHARED_OBJECT_SYMBOL_NOT_FOUND:
        return "Link to a shared object failed to resolve";
    case CUDA_ERROR_SHARED_OBJECT_INIT_FAILED:
        return "Shared object initialization failed";

    case CUDA_ERROR_INVALID_HANDLE:
        return "Invalid handle";

    case CUDA_ERROR_NOT_FOUND:
        return "Not found";

    case CUDA_ERROR_NOT_READY:
        return "CUDA not ready";

    case CUDA_ERROR_LAUNCH_FAILED:
        return "Launch failed";
    case CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES:
        return "Launch exceeded resources";
    case CUDA_ERROR_LAUNCH_TIMEOUT:
        return "Launch exceeded timeout";
    case CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING:
        return "Launch with incompatible texturing";

    case CUDA_ERROR_UNKNOWN:
        return "Unknown error";

    default:
        return "Unknown CUDA error value";
    }
}


