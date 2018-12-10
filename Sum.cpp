#include <cstdio>

#include <cstdlib>

#include <string> 

#include <iostream>

#include <sys/time.h>

#include <unistd.h>

#include <sstream>

#include "CudaSamples.h"
//
#include <cuda.h>
//
// Inputs array with random numbers [1,9999].
void Randomize(int *array, int N){
  srand (time(NULL)); // initialization.

  for(int i = 0; i < N; i++){
    array[i] = (int) rand() % 10000;
  }
}
//
//
void SumCPU(int *Input1,int *Input2,int *Output, int N) {
//
	for(int i = 0; i < N ; i++) {
		Output[i] = Input1[i] + Input2[i];
	}
}
//
int CompareOutputs(int *Output1,int *Output2, int N) {
//
       int Diff=0;
	for(int i = 0; i < N ; i++) {
		Diff += (Output1[i] - Output2[i])*(Output1[i] - Output2[i]);
	}
      if(Diff==0){return 1;}
      else{return 0;}	
}
//
int main (int argc, char* argv[])
{
int Nx=4,Ny=4;
int *Input1, *Input2, *Output, *Input1CPU, *Input2CPU, *OutputCPU;
printf("Usage : ./Sum N\n");
printf("N : maximal global dimension or\n");
printf("./Sum Nx Ny\n");
printf("Nx max global dimension x, Ny max global dimension y\n");
  if(argc >= 2)
     {
 Nx=atoi(argv[1]);
     }
//
 printf("Calling sum up 1d, N=%d\n",Nx);
 SumUp(Input1, Input2, Output, Nx);
//
  if(argc >= 3)
     { 
   Ny=atoi(argv[2]);
   printf("Calling sum up 2D Nx=%d, Ny=%d\n",Nx,Ny);
   SumUp2D(Input1, Input2, Output, Nx,Ny);
     }
    
  
}
