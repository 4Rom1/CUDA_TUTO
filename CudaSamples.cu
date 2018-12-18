#include <cuda.h>
#include <cuda_runtime.h>
#include "stdio.h"
#include <cstdlib>
#include "math.h"
#include "CudaSamples.h"
#define NWarps 32

// Inputs array with random numbers [1,9999].
void Randomize(int *array, int N){
  srand (time(NULL)); // initialization.

  for(int i = 0; i < N; i++){
    array[i] = (int) rand() % 10000;
  }
}
//
//
int CompareOutputs(int *Input1,int *Input2, int *Output, int N) {
//
       int Diff=0;
	for(int i = 0; i < N ; i++) {
		Diff += ((Input1[i] + Input2[i] - Output[i])*(Input1[i] + Input2[i] - Output[i]));
	}
        return Diff;	
}
//
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
	const dim3 block(min(NWarps,Nx),min(NWarps,Ny),1);
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
          //printf("Index %d, Input1[index] %d Input2[index] %d\n",index,Input1[index],Input2[index]);
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

int SumUp(int Dim)
{
   //
   int NBytes = sizeof(int)*Dim;
   //
   int *Input1Dev, *Input2Dev, *OutputDev;
   //
   int *Input1, *Input2, *Output;
   //
   Input1 = new int[Dim];
   Input2 = new int[Dim];
   Output = new int[Dim];

   Randomize(Input1, Dim);

   Randomize(Input2, Dim);


   (cudaMalloc(&Input1Dev,NBytes));
   (cudaMalloc(&Input2Dev,NBytes));
   (cudaMalloc(&OutputDev,NBytes));
   //
   (cudaMemcpy(Input1Dev,Input1,NBytes,cudaMemcpyHostToDevice));
   (cudaMemcpy(Input2Dev,Input2,NBytes,cudaMemcpyHostToDevice));   
   //
   
//N Threads per block 
	const dim3 block(min(NWarps,Dim),1,1);
//blocks per grid
	const dim3 grid(iDivUp(Dim,NWarps),1,1);
//Kernel launch
        KernelSumUp<<<grid,block>>>(Input1Dev, Input2Dev, OutputDev, Dim);
//Synchronize threads
         cudaDeviceSynchronize();
//        
 (cudaMemcpy(Output,OutputDev,NBytes,cudaMemcpyDeviceToHost));   
//
         cudaFree(Input1Dev);
         cudaFree(Input2Dev);
         cudaFree(OutputDev);
//
int Check=CompareOutputs(Input1,Input2, Output,Dim); 

         delete [] Input1;
         delete [] Input2;
         delete [] Output;
         
         return Check;
}

int SumUp2D(int Width, int Height)
{
   int NBytes = sizeof(int)*Width*Height;
//
   int *Input1, *Input2, *Output;
//
   int Dim=Width*Height;
   Input1 = new int[Dim];
   Input2 = new int[Dim];
   Output = new int[Dim];
//
   int *Input1Dev, *Input2Dev, *OutputDev;
//
   (cudaMalloc(&Input1Dev,NBytes));
   (cudaMalloc(&Input2Dev,NBytes));
   (cudaMalloc(&OutputDev,NBytes));
//
   Randomize(Input1, Dim);
//
   Randomize(Input2, Dim);

   (cudaMemcpy(Input1Dev,Input1,NBytes,cudaMemcpyHostToDevice));
   (cudaMemcpy(Input2Dev,Input2,NBytes,cudaMemcpyHostToDevice));  
//N Threads per block 
	const dim3 block(min(NWarps,Width),min(NWarps,Height),1);
//2d blocks per grid
	const dim3 grid(iDivUp(Width,NWarps),iDivUp(Height,NWarps),1);
//Kernel launch
        KernelSumUp2D<<<grid,block>>>(Input1Dev, Input2Dev, OutputDev, Width, Height);
//Synchronize threads
        cudaDeviceSynchronize();
//
    (cudaMemcpy(Output,OutputDev,NBytes,cudaMemcpyDeviceToHost)); 

int Check=CompareOutputs(Input1,Input2, Output,Dim); 

         delete [] Input1;
         delete [] Input2;
         delete [] Output;
         
         return Check;        
}

