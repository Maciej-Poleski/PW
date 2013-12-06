#include <cstdio>
#include <climits>

#define SERIAL_SCALE 1

#define SERIAL_PART (1<<SERIAL_SCALE)

extern "C" {
    /**
     * @param input Cała tablica do posortowania
     * @param output Wynik: Wszystkie prefix sum z kolejnych bloków
     * @param args args[0]=pozycja bitu (0..30)
     */
__global__
void kernelMain(int *input, int *output, int *sumGlobal, int bitMask){
    //int thid = (blockIdx.x * blockDim.x) + threadIdx.x; // Globalny ID wątku (mało przydatne)
    __shared__ int mem[SERIAL_PART][1024+3];
    int baseOffset=(blockIdx.x * blockDim.x)*SERIAL_PART; // Przesunięcie obecnego ciągu bloków

    for(int i=0;i<SERIAL_PART;++i)
    {
        mem[i][threadIdx.x]= ((input[baseOffset+i*blockDim.x+threadIdx.x]&bitMask)==0);
    }
    __syncthreads();
    for(int shift=1;shift<1024;shift*=2)
    {
        //scan
        for(int i=0;i<SERIAL_PART;++i)
        {
            int v=mem[i][threadIdx.x];
            if(threadIdx.x>=shift)
            {
                v+=mem[i][threadIdx.x-shift];
            }
            __syncthreads();
            mem[i][threadIdx.x]=v;
        }
    }
    //__syncthreads();
    for(int i=0;i<SERIAL_PART;++i)
    {
        output[baseOffset+i*blockDim.x+threadIdx.x]=mem[i][threadIdx.x];
        if(threadIdx.x == blockDim.x-1)
        {
            sumGlobal[blockIdx.x * SERIAL_PART + i + 1] = mem[i][threadIdx.x];
        }
    }
}

/**
 * @param input Wejściowa tablica liczb
 * @param output Wyjściowa tablica liczb
 * @param sumLocal Tablica prefix sum kolejnych bloków
 * @param sumGlobal Tablica prefix sum (zewnętrzna) ostatnich sum z kolejnych bloków
 * @param args args[0]=pozycja bitu (0..30), args[1]=pozycja pierwszej liczby z 1 w output
 * @param
 */
__global__
void kernelShuffle(int *input,int *output,int *sumLocal,int *sumGlobal,int bitMask,int sumLast)
{
    int baseOffset=(blockIdx.x * blockDim.x)*SERIAL_PART; // Przesunięcie obecnego ciągu bloków
    __shared__ int sumGlobalS[SERIAL_PART][1024];
        for(int i=0;i<SERIAL_PART;++i)
        {
	    int in=baseOffset+i*blockDim.x+threadIdx.x;
            sumGlobalS[i][threadIdx.x]=sumGlobal[blockIdx.x*SERIAL_PART+i]+sumLocal[in];
        }
    __syncthreads();
    for(int i=0;i<SERIAL_PART;++i)
    {
        int in=baseOffset+i*blockDim.x+threadIdx.x;
        if((input[in]&bitMask)==0)
        {
            //printf("%d -> [%d]\n",input[in],sumLocal[in]+sumGlobal[blockIdx.x*SERIAL_PART+i]-1);
            output[sumGlobalS[i][threadIdx.x]-1]=input[in];
        }
        else
        {
            //printf("%d -> [%d]\n",input[in],args[1]+in-(sumLocal[in]+sumGlobal[blockIdx.x*SERIAL_PART+i]));
            output[sumLast+in-(sumGlobalS[i][threadIdx.x])]=input[in];
        }
    }
}

}

