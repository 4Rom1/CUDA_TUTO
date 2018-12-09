#include <cstdio>

#include <cstdlib>

#include <string> 

#include <iostream>

#include <sys/time.h>

#include <unistd.h>

#include <sstream>

#include "CudaSamples.h"


/*Compile with : g++ -std=c++0x  `pkg-config --cflags opencv` Extract.cpp `pkg-config --libs opencv` -o Extract*/

int main (int argc, char* argv[])
{
int N=4;
N=atoi(argv[1]);
CallHelloWorld(N);
}
