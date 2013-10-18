#include "cuda.h"
#include <cstdio>

const char * moduleName="gcd.ptx";
const char *kernelName="kernelMain";

const char *cuda_error_string(CUresult result);

#ifdef DEBUG

void checkResult(CUresult result)
{
    if(result!=CUDA_SUCCESS)
    {
        fprintf(stderr,"%s\n",cuda_error_string(result));
    }
}
#else
#define checkResult(x) x
#endif

int main(){
    //Inicjalizajca drivera - za nim uruchomimy jaka kolwiek funkcje z Driver API
    cuInit(0);
    
    //Pobranie handlera do devica
    //(moze byc kilka urzadzen. Tutaj zakladamy, ze jest conajmniej jedno)
    CUdevice cuDevice;
    CUresult res = cuDeviceGet(&cuDevice, 0);
    if (res != CUDA_SUCCESS){
        printf("cannot acquire device 0\n"); 
        exit(1);
    }

    //Tworzy kontext
    CUcontext cuContext;
    res = cuCtxCreate(&cuContext, 0, cuDevice);
    if (res != CUDA_SUCCESS){
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
    if (res != CUDA_SUCCESS){
        printf("cannot acquire kernel handle\n");
        exit(1);
    }

    unsigned int n,m;
    scanf("%u%u",&n,&m);

    CUdeviceptr xTab,yTab,arg;
    checkResult(cuMemAlloc(&xTab,n*m*sizeof(int)));
    checkResult(cuMemAlloc(&yTab,n*m*sizeof(int)));
    checkResult(cuMemAlloc(&arg,2*sizeof(int)));

    unsigned int data[]={n,m};

    cuMemcpyHtoD(arg,data,2*sizeof(int));

    void* args[] = {&xTab,&yTab,&arg};

    const unsigned int blockSize=32;

    const unsigned int gridWidth=n/blockSize+(n%blockSize!=0);
    const unsigned int gridHeight=m/blockSize+(m%blockSize!=0);

    res = cuLaunchKernel(helloWorld, gridWidth, gridHeight, 1,
                         blockSize, blockSize, 1, 0, 0, args, 0);

    if (res != CUDA_SUCCESS){
        printf("cannot run kernel\n");
        exit(1);
    }

//     int *xTabHost=reinterpret_cast<int*>(malloc(n*m*sizeof(int)));
//     int *yTabHost=reinterpret_cast<int*>(malloc(n*m*sizeof(int)));

    int *xTabHost,*yTabHost;
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&xTabHost),n*m*sizeof(int)));
    checkResult(cuMemAllocHost(reinterpret_cast<void**>(&yTabHost),n*m*sizeof(int)));

    cuCtxSynchronize();

    cuMemcpyDtoH(xTabHost,xTab,n*m*sizeof(int));
    cuMemcpyDtoH(yTabHost,yTab,n*m*sizeof(int));

    cuMemFree(xTab);
    cuMemFree(yTab);
    cuMemFree(arg);

    for(unsigned int i=0;i<n;++i)
    {
        for(unsigned int j=0;j<m;++j)
        {
            printf("%d %d %d %d %d\n",i+1,j+1,xTabHost[i*m+j],yTabHost[i*m+j],(i+1)*xTabHost[i*m+j]+(j+1)*yTabHost[i*m+j]);
        }
    }

//     free(xTabHost);
//     free(yTabHost);
    cuMemFreeHost(xTabHost);
    cuMemFreeHost(yTabHost);


    cuCtxDestroy(cuContext);

    return 0;
}

const char *cuda_error_string(CUresult result)
{
    switch(result) {
        case CUDA_SUCCESS: return "No errors";
        case CUDA_ERROR_INVALID_VALUE: return "Invalid value";
        case CUDA_ERROR_OUT_OF_MEMORY: return "Out of memory";
        case CUDA_ERROR_NOT_INITIALIZED: return "Driver not initialized";
        case CUDA_ERROR_DEINITIALIZED: return "Driver deinitialized";

        case CUDA_ERROR_NO_DEVICE: return "No CUDA-capable device available";
        case CUDA_ERROR_INVALID_DEVICE: return "Invalid device";

        case CUDA_ERROR_INVALID_IMAGE: return "Invalid kernel image";
        case CUDA_ERROR_INVALID_CONTEXT: return "Invalid context";
        case CUDA_ERROR_CONTEXT_ALREADY_CURRENT: return "Context already current";
        case CUDA_ERROR_MAP_FAILED: return "Map failed";
        case CUDA_ERROR_UNMAP_FAILED: return "Unmap failed";
        case CUDA_ERROR_ARRAY_IS_MAPPED: return "Array is mapped";
        case CUDA_ERROR_ALREADY_MAPPED: return "Already mapped";
        case CUDA_ERROR_NO_BINARY_FOR_GPU: return "No binary for GPU";
        case CUDA_ERROR_ALREADY_ACQUIRED: return "Already acquired";
        case CUDA_ERROR_NOT_MAPPED: return "Not mapped";
        case CUDA_ERROR_NOT_MAPPED_AS_ARRAY: return "Mapped resource not available for access as an array";
        case CUDA_ERROR_NOT_MAPPED_AS_POINTER: return "Mapped resource not available for access as a pointer";
        case CUDA_ERROR_ECC_UNCORRECTABLE: return "Uncorrectable ECC error detected";
        case CUDA_ERROR_UNSUPPORTED_LIMIT: return "CUlimit not supported by device";

        case CUDA_ERROR_INVALID_SOURCE: return "Invalid source";
        case CUDA_ERROR_FILE_NOT_FOUND: return "File not found";
        case CUDA_ERROR_SHARED_OBJECT_SYMBOL_NOT_FOUND: return "Link to a shared object failed to resolve";
        case CUDA_ERROR_SHARED_OBJECT_INIT_FAILED: return "Shared object initialization failed";

        case CUDA_ERROR_INVALID_HANDLE: return "Invalid handle";

        case CUDA_ERROR_NOT_FOUND: return "Not found";

        case CUDA_ERROR_NOT_READY: return "CUDA not ready";

        case CUDA_ERROR_LAUNCH_FAILED: return "Launch failed";
        case CUDA_ERROR_LAUNCH_OUT_OF_RESOURCES: return "Launch exceeded resources";
        case CUDA_ERROR_LAUNCH_TIMEOUT: return "Launch exceeded timeout";
        case CUDA_ERROR_LAUNCH_INCOMPATIBLE_TEXTURING: return "Launch with incompatible texturing";

        case CUDA_ERROR_UNKNOWN: return "Unknown error";

        default: return "Unknown CUDA error value";
    }
}

