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
__global__ void HelloWorld2D()
{
	//2D Index of current thread
        int index_x = threadIdx.x + blockDim.x * blockIdx.x;
        int tId_x = threadIdx.x;
        int BlockId_x=blockIdx.x;
        int index_y = threadIdx.y + blockDim.y * blockIdx.y;
        int tId_y = threadIdx.y;
        int BlockId_y=blockIdx.y;

	printf("Hi from thread X number %d, Block X number %d, global index X number%d\n",tId_x,BlockId_x,index_x);
	printf("Hi from thread Y number %d, Block Y number %d, global index Y number%d\n",tId_y,BlockId_y,index_y);	
}

void CallHelloWorld(int N)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(N)),1,1);
//1 block per grid
	const dim3 grid(iDivUp(N,NWarps),1,1);
//Kernel launch
        HelloWorld<<<grid,block>>>();
//Synchronize threads
        cudaDeviceSynchronize();
}

void CallHelloWorld2D(int Nx,int Ny)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(Nx)),min(float(NWarps),float(Ny)),1);
//1 block per grid
	const dim3 grid(iDivUp(Nx,NWarps),iDivUp(Ny,NWarps),1);
//Kernel launch
        HelloWorld2D<<<grid,block>>>();
//Synchronize threads
        cudaDeviceSynchronize();
}

