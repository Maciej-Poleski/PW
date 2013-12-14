#include "cuda.h"
#include <cstdio>
#include <cassert>
#include <climits>
#include <algorithm>
#include <limits>

const char* moduleName = "components.ptx";

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

void components(CUdeviceptr bitmap, int N, CUdeviceptr out_cc)
{
    //Tworzy modul z pliku binarnego "gcd.ptx"
    CUmodule cuModule = (CUmodule)0;
    checkResult(cuModuleLoad(&cuModule, moduleName));

    /********* TUTAJ JEST ROZWIĄZANIE **********/

    //Pobiera handler kernela z modulu
    CUfunction initialize;
    checkResult(cuModuleGetFunction(&initialize, cuModule, "initialize"));
    CUfunction transpose;
    checkResult(cuModuleGetFunction(&transpose, cuModule, "transpose"));
    CUfunction propagateMin;
    checkResult(cuModuleGetFunction(&propagateMin, cuModule, "propagateMin"));

    int size=N*N;

    void *argsInit[]={&out_cc,&size};

    checkResult(cuLaunchKernel(initialize,size/1024+!!(size%1024),1,1,1024,1,1,0,0,argsInit,0));

    CUdeviceptr aux;
    checkResult(cuMemAlloc(&aux,size*sizeof(int)));

    CUdeviceptr bitmapTransposed;
    checkResult(cuMemAlloc(&bitmapTransposed,size*sizeof(int)));
    void *argsBitmapTranspose[]={&bitmap,&bitmapTransposed,&N};
    checkResult(cuLaunchKernel(transpose,N/32,N/32,1,32,32,1,0,0,argsBitmapTranspose,0));

    void *argsTranspose[]={&out_cc, &aux,&N};
    void *argsTransposeTransposed[]={&aux,&out_cc,&N};

    int *modified;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&modified),sizeof(int)));

    void *argsPropagateMin[]={&bitmap, &out_cc,&modified,&N};
    void *argsPropagateMinTransposed[]={&bitmapTransposed, &aux,&modified,&N};
    for(;;)
    {
        *modified=0;
        checkResult(cuLaunchKernel(propagateMin,N/32,1,1,32,1,1,0,0,argsPropagateMin,0));

        checkResult(cuCtxSynchronize());
        bool m1=*modified;

        checkResult(cuLaunchKernel(transpose,N/32,N/32,1,32,32,1,0,0,argsTranspose,0));

        *modified=0;
        checkResult(cuLaunchKernel(propagateMin,N/32,1,1,32,1,1,0,0,argsPropagateMinTransposed,0));

        checkResult(cuCtxSynchronize());
        bool m2=*modified;

        checkResult(cuLaunchKernel(transpose,N/32,N/32,1,32,32,1,0,0,argsTransposeTransposed,0));

        if(!(m1 || m2))
            break;
    }

    checkResult(cuCtxSynchronize());

    checkResult(cuMemFreeHost(modified));
    checkResult(cuMemFree(bitmapTransposed));
    checkResult(cuMemFree(aux));
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


