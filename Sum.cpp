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
int main (int argc,const char* argv[])
{
int Nx=4,Ny=4;
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
//
 printf("Calling sum up 1d, N=%d\n",Nx);
 Check1=SumUp(Nx);
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
