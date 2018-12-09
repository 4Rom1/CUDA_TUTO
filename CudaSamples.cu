#include <cuda.h>
#include <cuda_runtime.h>
#include "stdio.h"
#include <cstdlib>
#include "math.h"
#include "CudaSamples.h"
#define NWarps 32


__global__ void HelloWorld()
{
	//2D Index of current thread
        int index = threadIdx.x + blockDim.x * blockIdx.x;
        int tId = threadIdx.x;
        int BlockId=blockIdx.x;
	printf("Hi from thread number %d, Block number %d, global index %d\n",tId,BlockId,index);	
}
void CallHelloWorld(int N)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(N)),1,1);
//1 block per grid
	const dim3 grid(iDivUp(N,NWarps),1,1);
//Kernel launch
        HelloWorld<<<grid,block>>>();
}
