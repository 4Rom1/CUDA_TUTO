#include <cstdio>

#include <cstdlib>

#include <string> 

#include <iostream>

#include <sys/time.h>

#include <unistd.h>

#include <sstream>

#include "CudaSamples.h"


int main (int argc, char* argv[])
{
int Nx=4,Ny=4;
int *Input1, *Input2, *Output;
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
    printf("Calling print 2D Nx=%d, Ny=%d\n",Nx,Ny);
    SumUp2D(Input1, Input2, Output, Nx,Ny);
     }
}
