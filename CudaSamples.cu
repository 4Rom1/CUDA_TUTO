#include <cuda.h>
#include <cuda_runtime.h>
#include "stdio.h"
#include <cstdlib>
#include "math.h"
#include "CudaSamples.h"
#define NWarps 32

__global__ void HelloWorld()
{
	//Global index build with blocks and threads
        int index = threadIdx.x + blockDim.x * blockIdx.x;
        int tId = threadIdx.x;
        int BlockId=blockIdx.x;
	printf("Hi from thread number %d, Block number %d, global index %d\n",tId,BlockId,index);	
}
__global__ void HelloWorld2D()
{
	//2D global index
        int index_x = threadIdx.x + blockDim.x * blockIdx.x;
        int tId_x = threadIdx.x;
        int BlockId_x=blockIdx.x;
        int index_y = threadIdx.y + blockDim.y * blockIdx.y;
        int tId_y = threadIdx.y;
        int BlockId_y=blockIdx.y;

	printf("Hi from thread X number %d, Block X number %d, global index X number%d\n",tId_x,BlockId_x,index_x);
	printf("Hi from thread Y number %d, Block Y number %d, global index Y number%d\n\n",tId_y,BlockId_y,index_y);	
}

void CallHelloWorld(int N)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(N)),1,1);
//1d blocks per grid
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
//2d blocks per grid
	const dim3 grid(iDivUp(Nx,NWarps),iDivUp(Ny,NWarps),1);
//Kernel launch
        HelloWorld2D<<<grid,block>>>();
//Synchronize threads
        cudaDeviceSynchronize();
}

__global__ void KernelSumUp(int *Input1, int *Input2, int *Output, int Dim)
{
	//Global index build with blocks and threads
        int index = threadIdx.x + blockDim.x * blockIdx.x;
        if(index<Dim)
         {
          Output[index]=Input1[index]+Input2[index];
         }	
}
__global__ void KernelSumUp2D(int *Input1, int *Input2, int *Output, int Width, int Height)
{
	//2D global Index mapping 
        int index_x = threadIdx.x + blockDim.x * blockIdx.x;
        //
        int index_y = threadIdx.y + blockDim.y * blockIdx.y;
        //
        if(index_x<Width && index_y<Height)
         {
        //2d mapping
        int Index_xy=index_y*Width+index_x; 
        Output[Index_xy]=Input1[Index_xy]+Input2[Index_xy];		
         }
}

void SumUp(int *Input1, int *Input2, int *Output, int Dim)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(Dim)),1,1);
//blocks per grid
	const dim3 grid(iDivUp(Dim,NWarps),1,1);
//Kernel launch
        KernelSumUp<<<grid,block>>>(Input1, Input2, Output, Dim);
//Synchronize threads
        cudaDeviceSynchronize();
}

void SumUp2D(int *Input1, int *Input2, int *Output, int Width, int Height)
{
//N Threads per block 
	const dim3 block(min(float(NWarps),float(Width)),min(float(NWarps),float(Height)),1);
//2d blocks per grid
	const dim3 grid(iDivUp(Width,NWarps),iDivUp(Height,NWarps),1);
//Kernel launch
        KernelSumUp2D<<<grid,block>>>(Input1, Input2, Output, Width, Height);
//Synchronize threads
        cudaDeviceSynchronize();
}

