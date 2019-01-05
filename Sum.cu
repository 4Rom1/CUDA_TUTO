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
#define TIME_DIFFS(t1, t2) \
t2.tv_usec - t1.tv_usec  
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
//Time initialization
  gettimeofday(&begin,NULL);
 printf("Calling sum up 1d, N=%d\n",Nx);
 Check1=SumUp(Nx);
  if(Check1)
  {printf("Sum non identique, Diff square = %d\n",Check1);}
  else
  {printf("Sum identiques\n");}
//Time end
     gettimeofday(&end,NULL);
     delta_time=TIME_DIFFS(begin, end); 
//Define the maximum size of active space B and residual space
    printf("time spent synchronous sum %u micros\n", delta_time);
//Time initialization
  gettimeofday(&begin,NULL);
 printf("Calling sum up 1d asynchronous, N=%d\n",Nx);
 Check1=SumUpStreams(Nx);
//Time end
     gettimeofday(&end,NULL);
     delta_time=TIME_DIFFS(begin, end); 
//Define the maximum size of active space B and residual space
    printf("time spent asynchronous sum %u micros\n", delta_time);
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

}
