#include "cuda.h"
#include <cstdio>
#include <cassert>
#include <climits>
#include <algorithm>
#include <limits>

const char* moduleName = "cuMin.ptx";
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

#include "cuMin.h"

#define SERIAL_SCALE 2
#define SERIAL_PART (1<<SERIAL_SCALE)

static int smallMin(CUfunction, int*, int);
static int bigMin(CUfunction, CUmodule , int* , int);

static int universalMin(CUfunction kernel, CUdeviceptr input, CUdeviceptr output,
                        unsigned int inputSize, unsigned int outputSize,
                        unsigned int inputInitialized, unsigned int outputInitialized)
__attribute__((optimize(3)));

static unsigned int filledMemSize(unsigned int size) __attribute__((optimize(3)));
static unsigned int filledMemSize(unsigned int size)
{
    if ((size & ((1 << (10+SERIAL_SCALE)) - 1)) == 0)
        return size;
    return (size & (~((1 << (10+SERIAL_SCALE)) - 1))) + (1 << (10+SERIAL_SCALE));
}

int cuMin(int* T, int n)
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

    /********* TUTAJ JEST ROZWIĄZANIE **********/

#ifdef DEBUG
    assert(filledMemSize(1024) == SERIAL_PART*1024);
    assert(filledMemSize(1) == SERIAL_PART*1024);
    assert(filledMemSize(2) == SERIAL_PART*1024);
    assert(filledMemSize(1023) == SERIAL_PART*1024);
#endif

    checkResult(cuMemHostRegister(T, n * sizeof(int), 0));

    CUdeviceptr inputD, outputD;
    const unsigned int maxStepSize = 200000000;
    int r = std::numeric_limits<int>::max();
    for (unsigned int i = 0; i < n; i += maxStepSize) {
        const unsigned int currentStepSize = std::min(n - i, maxStepSize);
        const unsigned int inputSize = filledMemSize(currentStepSize),
                           outputSize = filledMemSize(inputSize / (SERIAL_PART*1024));
        checkResult(cuMemAlloc(&inputD, inputSize * sizeof(int)));
        checkResult(cuMemAlloc(&outputD, outputSize * sizeof(int)));

        checkResult(cuMemcpyHtoD(inputD, T+i, currentStepSize * sizeof(int)));

        r = std::min(r, universalMin(helloWorld, inputD, outputD, inputSize, outputSize, currentStepSize, inputSize / (SERIAL_PART*1024)));

        checkResult(cuMemFree(inputD));
        checkResult(cuMemFree(outputD));
    }

    cuCtxDestroy(cuContext);


    return r;
}


static int universalMin(CUfunction kernel, CUdeviceptr input, CUdeviceptr output,
                        unsigned int inputSize, unsigned int outputSize,
                        unsigned int inputInitialized, unsigned int outputInitialized)
{
    if (inputInitialized < inputSize || outputInitialized < outputSize) {
        unsigned int fillSize = std::max(static_cast<int>(inputSize) - inputInitialized,
                                         static_cast<int>(outputSize) - outputInitialized);
        int* fill;
        checkResult(cuMemAllocHost(reinterpret_cast<void**>(&fill), fillSize * sizeof(int)));
        for (int* i = fill; i < fill + fillSize; ++i) // najwyżej 1023 obroty
            *i = INT_MAX;

        if (inputInitialized < inputSize) {
            checkResult(cuMemcpyHtoD(input + inputInitialized * sizeof(int), fill, sizeof(int) * (inputSize - inputInitialized)));
        }
        if (outputInitialized < outputSize) {
            checkResult(cuMemcpyHtoD(output + outputInitialized * sizeof(int), fill, sizeof(int) * (outputSize - outputInitialized)));
        }
        checkResult(cuMemFreeHost(fill));
    }
    const unsigned int maxGridSize=1U<<14;
    for (unsigned int inputBegin = 0, outputBegin = 0; inputBegin < inputSize; inputBegin += (maxGridSize << (10+SERIAL_SCALE)), outputBegin += maxGridSize) {
        CUdeviceptr inputForKernel = input + inputBegin * sizeof(int);
        CUdeviceptr outputForKernel = output + outputBegin * sizeof(int);
        void* args[] = {&inputForKernel, &outputForKernel};
        assert(inputSize % (SERIAL_PART*1024) == 0);
        assert(inputBegin % (SERIAL_PART*1024) == 0);
        const unsigned int gridSize = std::min((inputSize - inputBegin) / (SERIAL_PART*1024), maxGridSize);
        // Jeżeli wybrano mniej niż 1<<16 to jest to ostatni obieg pętli

        checkResult(cuLaunchKernel(kernel, gridSize, 1, 1,
                                   1024, 1, 1,
                                   0, 0,
                                   args, 0));
        //checkResult(cuCtxSynchronize());
    }
    if (inputSize == (SERIAL_PART*1024)) {
        int result;
        checkResult(cuMemcpyDtoH(&result, output, sizeof(int)));
        return result;
    } else {
        return universalMin(kernel, output, input, outputSize, filledMemSize(outputSize / (SERIAL_PART*1024)), outputSize, inputSize);
    }
}


static int smallMinDevice(CUfunction, CUdeviceptr, int);

static int bigMin(CUfunction hw, CUmodule cuModule, int* T, int n)
{
    CUfunction helloWorld;
    checkResult(cuModuleGetFunction(&helloWorld, cuModule, "kernelPrepare"));

    const unsigned int count = n / (1 << 16) + !!(n % (1 << 16));
    const unsigned int threadPool = n / count + !!(n % count);
    const unsigned int gridSize = threadPool / 1024 + !!(threadPool % 1024);

    CUdeviceptr inputOnDevice, outputOnDevice, arg;
    checkResult(cuMemAlloc(&inputOnDevice, n * sizeof(int)));
    checkResult(cuMemAlloc(&outputOnDevice, gridSize * 1024 * sizeof(int)));
    checkResult(cuMemAlloc(&arg, 2 * sizeof(int)));

    int data[] = {count, n};

    checkResult(cuMemcpyHtoD(arg, data, sizeof(int) * 2));
    checkResult(cuMemcpyHtoD(inputOnDevice, T, sizeof(int)*n));

    void* args[] = {&inputOnDevice, &outputOnDevice, &arg};

    checkResult(cuLaunchKernel(helloWorld, gridSize, 1, 1, 1024, 1, 1, 0, 0, args, 0));
    checkResult(cuCtxSynchronize());

    checkResult(cuMemFree(inputOnDevice));
    checkResult(cuMemFree(arg));

    return smallMinDevice(hw, outputOnDevice, threadPool);
}

static int smallMinDevice(CUfunction helloWorld, CUdeviceptr inputOnDevice, int n)
{
    CUresult res;

    const unsigned int blockSize = 1024;
    const unsigned int gridSize = n / blockSize + !!(n % blockSize);

    CUdeviceptr outputOnDevice; // input musi być dopełniony do bloku, output też
    checkResult(cuMemAlloc(&outputOnDevice, std::max(gridSize, blockSize)*sizeof(int)));

    {
        // dopełnianie
        const int pad = gridSize * blockSize - n;
        const int gridPad = blockSize - gridSize;

        int* d;
        checkResult(cuMemAllocHost(reinterpret_cast<void**>(&d), std::max(pad, gridPad)*sizeof(int)));
        for (int* i = d; i < d + std::max(pad, gridPad); ++i)
            *i = INT_MAX;

        if (pad) {
            assert(pad > 0);
            checkResult(cuMemcpyHtoD(inputOnDevice + n * sizeof(int), d, pad * sizeof(int)));
        }
        if (gridPad > 0) {
            checkResult(cuMemcpyHtoD(outputOnDevice + gridSize * sizeof(int), d, gridPad * sizeof(int)));
        }
        checkResult(cuMemFreeHost(d));
    }

    void* args[] = {&inputOnDevice, &outputOnDevice};


    res = cuLaunchKernel(helloWorld, gridSize, 1, 1,
                         blockSize, 1, 1, 0, 0, args, 0);

    if (res != CUDA_SUCCESS) {
        printf("cannot run kernel\n");
        exit(1);
    }

    int* result;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&result), sizeof(int)));

    checkResult(cuCtxSynchronize());

    if (gridSize == 1) {
        checkResult(cuMemcpyDtoH(result, outputOnDevice, sizeof(int)));
    } else {
        void* args[] = {&outputOnDevice, &inputOnDevice};

        res = cuLaunchKernel(helloWorld, 1, 1, 1,
                             blockSize, 1, 1, 0, 0, args, 0); // Zmieści się w jednym bloku

        if (res != CUDA_SUCCESS) {
            printf("cannot run kernel\n");
            exit(1);
        }

        checkResult(cuCtxSynchronize());

        checkResult(cuMemcpyDtoH(result, inputOnDevice, sizeof(int)));
    }
    int r = result[0];

    cuMemFree(inputOnDevice);
    cuMemFree(outputOnDevice);
    cuMemFreeHost(result);

    return r;
}

static int smallMin(CUfunction helloWorld, int* T, int n)
{
    CUresult res;
    //FIXME: narazie zakładam rozmiar co najwyżej 2^16

    const unsigned int blockSize = 1024;
    const unsigned int gridSize = n / blockSize + !!(n % blockSize);

    CUdeviceptr inputOnDevice, outputOnDevice; // input musi być dopełniony do bloku, output też
    checkResult(cuMemAlloc(&inputOnDevice, gridSize * blockSize * sizeof(int)));
    checkResult(cuMemAlloc(&outputOnDevice, std::max(gridSize, blockSize)*sizeof(int)));

    {
        // dopełnianie
        const int pad = gridSize * blockSize - n;
        const int gridPad = blockSize - gridSize;

        int* d;
        checkResult(cuMemAllocHost(reinterpret_cast<void**>(&d), std::max(pad, gridPad)*sizeof(int)));
        for (int* i = d; i < d + std::max(pad, gridPad); ++i)
            *i = INT_MAX;

        if (pad) {
            assert(pad > 0);
            checkResult(cuMemcpyHtoD(inputOnDevice + n * sizeof(int), d, pad * sizeof(int)));
        }
        if (gridPad > 0) {
            checkResult(cuMemcpyHtoD(outputOnDevice + gridSize * sizeof(int), d, gridPad * sizeof(int)));
        }
        checkResult(cuMemFreeHost(d));
    }

    checkResult(cuMemcpyHtoD(inputOnDevice, T, n * sizeof(int)));
    checkResult(cuMemHostUnregister(T));

    void* args[] = {&inputOnDevice, &outputOnDevice};


    res = cuLaunchKernel(helloWorld, gridSize, 1, 1,
                         blockSize, 1, 1, 0, 0, args, 0);

    if (res != CUDA_SUCCESS) {
        printf("cannot run kernel\n");
        exit(1);
    }

    int* result;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&result), sizeof(int)));

    checkResult(cuCtxSynchronize());

    if (gridSize == 1) {
        checkResult(cuMemcpyDtoH(result, outputOnDevice, sizeof(int)));
    } else {
        void* args[] = {&outputOnDevice, &inputOnDevice};

        res = cuLaunchKernel(helloWorld, 1, 1, 1,
                             blockSize, 1, 1, 0, 0, args, 0); // Zmieści się w jednym bloku

        if (res != CUDA_SUCCESS) {
            printf("cannot run kernel\n");
            exit(1);
        }

        checkResult(cuCtxSynchronize());

        checkResult(cuMemcpyDtoH(result, inputOnDevice, sizeof(int)));
    }
    int r = result[0];

    cuMemFree(inputOnDevice);
    cuMemFree(outputOnDevice);
    cuMemFreeHost(result);

    return r;
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


