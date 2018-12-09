#include <cuda.h>
#include <cuda_runtime.h>
#include "stdio.h"
#include <cstdlib>


__global__ void HelloWorld()
{
	//2D Index of current thread
	const int ThreadXIndex = threadIdx.x;
	printf("Hi from thread number %d\n",ThreadXIndex);	
}
void CallHelloWorld(int N)
{
//N Threads per block 
	const dim3 block(N,1);
//1 block per grid
	const dim3 grid(1);
//Kernel launch
        HelloWorld<<<grid,block>>>();
}
