#include "cuda.h"
#include <cstdio>
#include <cassert>
#include <climits>
#include <algorithm>
#include <limits>

const char* moduleName = "radixsort.ptx";
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

#include "radixsort.h"

#define SERIAL_SCALE 1
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

int* radixsort(int* T, int n)
{
    //Inicjalizajca drivera - za nim uruchomimy jaka kolwiek funkcje z Driver API
    cuInit(0);

    //Pobranie handlera do devica
    //(moze byc kilka urzadzen. Tutaj zakladamy, ze jest conajmniej jedno)
    CUdevice cuDevice;
    CUresult res = cuDeviceGet(&cuDevice, 0);
    if (res != CUDA_SUCCESS) {
        printf("cannot acquire device 0\n");
        exit(1);
    }

    //Tworzy kontext
    CUcontext cuContext;
    res = cuCtxCreate(&cuContext, 0, cuDevice);
    if (res != CUDA_SUCCESS) {
        printf("cannot create context\n");
        exit(1);
    }

    //Tworzy modul z pliku binarnego "gcd.ptx"
    CUmodule cuModule = (CUmodule)0;
    res = cuModuleLoad(&cuModule, moduleName);
    if (res != CUDA_SUCCESS) {
        printf("cannot load module: %d\n", res);
        exit(1);
    }

    //Pobiera handler kernela z modulu
    CUfunction helloWorld;
    res = cuModuleGetFunction(&helloWorld, cuModule, kernelName);
    if (res != CUDA_SUCCESS) {
        printf("cannot acquire kernel handle\n");
        exit(1);
    }

    CUfunction shuffle;
    checkResult(cuModuleGetFunction(&shuffle, cuModule, "kernelShuffle"));


#ifdef DEBUG
    assert(filledMemSize(1024) == SERIAL_PART * 1024);
    assert(filledMemSize(1) == SERIAL_PART * 1024);
    assert(filledMemSize(2) == SERIAL_PART * 1024);
    assert(filledMemSize(1023) == SERIAL_PART * 1024);
#endif

    /********* TUTAJ JEST ROZWIĄZANIE **********/


    checkResult(cuMemHostRegister(T, n * sizeof(int), 0));

    CUdeviceptr inputD, outputD, sumLocalD;

    const unsigned int inputSize = filledMemSize(n);
    assert(inputSize % (SERIAL_PART * 1024) == 0);

    checkResult(cuMemAlloc(&inputD, inputSize * sizeof(int)));
    checkResult(cuMemAlloc(&outputD, inputSize * sizeof(int)));
    checkResult(cuMemAlloc(&sumLocalD, inputSize * sizeof(int)));

    unsigned int* sumGlobal;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&sumGlobal), (inputSize / 1024 + 1) * sizeof(int)));

    checkResult(cuMemcpyHtoD(inputD, T, n * sizeof(int)));

    if (n < inputSize) {
        unsigned int fillSize = inputSize - n;
        int* fill;
        checkResult(cuMemAllocHost(reinterpret_cast<void**>(&fill), fillSize * sizeof(int)));
        for (int* i = fill; i < fill + fillSize; ++i) // najwyżej 1023 obroty
            *i = INT_MAX;

        checkResult(cuMemcpyHtoD(inputD + n * sizeof(int), fill, sizeof(int) * (fillSize)));
        checkResult(cuMemFreeHost(fill));
    }

    int bitMask, sumLast;

    void* args1[] = {&inputD, &sumLocalD, &sumGlobal, &bitMask};
    void* args2[] = {&inputD, &outputD, &sumLocalD, &sumGlobal, &bitMask, &sumLast};

    const unsigned int gridSize = inputSize / (SERIAL_PART * 1024);

    for (int i = 0; i < 26; ++i) {
        bitMask = 1 << i;
        checkResult(cuLaunchKernel(helloWorld, gridSize, 1, 1,
                                   1024, 1, 1,
                                   0, 0,
                                   args1, 0));
        checkResult(cuCtxSynchronize());
        sumGlobal[0] = 0;
        for (int j = 0; j < SERIAL_PART * gridSize; ++j) {
            sumGlobal[j + 1] += sumGlobal[j];
        }
        sumLast = sumGlobal[SERIAL_PART * gridSize];
        checkResult(cuLaunchKernel(shuffle, gridSize, 1, 1, 1024, 1, 1, 0, 0, args2, 0));
        checkResult(cuCtxSynchronize());
        using std::swap;
        swap(inputD, outputD);
    }
    int* result = reinterpret_cast<int*>(mmap(NULL, sizeof(int) * inputSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0));
    checkResult(cuMemHostRegister(result, inputSize * sizeof(int), 0));
    checkResult(cuMemcpyDtoH(result, inputD, inputSize * sizeof(int)));
    checkResult(cuMemFreeHost(sumGlobal));
    checkResult(cuMemFree(sumLocalD));
    checkResult(cuMemFree(outputD));
    checkResult(cuMemFree(inputD));

    cuCtxDestroy(cuContext);


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


