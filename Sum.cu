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
#include <sys/time.h>
//
#include <pthread.h>
//
int main (int argc,const char* argv[])
{
int Nx=4,Ny=4;

struct timeval begin, end;
uint32_t delta_time=0;

printf("Usage : ./Sum N\n");
printf("N : maximal global dimension or\n");
printf("./Sum Nx Ny\n");
printf("Nx max global dimension x, Ny max global dimension y\n");
int Check1=0;
int Check2=0;
  if(argc >= 2)
     {
 Nx=atoi(argv[1]);
     }
//Cuda runtime intialization
for (int ii=0;ii<20;ii++)
 cudaFree(0);

 printf("Calling sum up 1d, N=%d\n",Nx);
 Check1=SumUp(Nx);
  if(Check1)
  {printf("Sum non identique, Diff square = %d\n",Check1);}
  else
  {printf("Sum identiques\n");}
//
 printf("Calling sum up 1d asynchronous, N=%d\n",Nx);
 Check1=SumUpStreams(Nx);
//
  if(Check1)
  {printf("Sum non identique, Diff square = %d\n",Check1);}
  else
  {printf("Sum identiques\n");}

  
  if(argc >= 3)
     { 
   Ny=atoi(argv[2]);
   printf("Calling sum up 2D Nx=%d, Ny=%d\n",Nx,Ny);
   Check2=SumUp2D(Nx,Ny);
  if(Check2)
  {printf("Sum non identique, Diff square = %d\n",Check2);}
  else
  {printf("Sum identiques\n");}
     }   

//Pthread example
    const int num_threads = 8;
    pthread_t threads[num_threads];

    for (int i = 0; i < num_threads; i++) {
        if (pthread_create(&threads[i], NULL, SumUpVoid, &Nx)) {
            fprintf(stderr, "Error creating threadn");
            return 1;
        }
    }

    for (int i = 0; i < num_threads; i++) {
        if(pthread_join(threads[i], NULL)) {
            fprintf(stderr, "Error joining threadn");
            return 2;
        }
    }

    cudaDeviceReset();


}
