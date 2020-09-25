#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <sys/time.h>
#include <unistd.h>
#include "CudaSamples.h"

int main(int argc, char *argv[]) {
  int Nx = 4, Ny = 4;
  printf("Usage : Display N\n");
  printf("N : maximal global dimension or\n");
  printf("Display Nx Ny\n");
  printf("Nx max global dimension x, Ny max global dimension y\n");
  if (argc >= 2) {
    Nx = atoi(argv[1]);
  }
  //
  printf("Calling print 1D N=%d\n", Nx);
  CallHelloWorld(Nx);
  //
  if (argc >= 3) {
    Ny = atoi(argv[2]);
    printf("Calling print 2D Nx=%d, Ny=%d\n", Nx, Ny);
    CallHelloWorld2D(Nx, Ny);
  }
}
