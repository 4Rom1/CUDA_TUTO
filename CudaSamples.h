#ifndef CudaSamples_H
#define CudaSamples_H
#define NWarps 32
#include <cuda_runtime.h>
#include <vector>
//

inline int iDivUp(int a, int b) { return (a % b != 0) ? (a / b + 1) : (a / b); }

void CallHelloWorld(int N);

void CallHelloWorld2D(int Nx, int Ny);

int SumUp(int Dim);

int SumUp2D(int Width, int Height);

int SumUpStreams(int Dim);

void *SumUpStreamsVoid(void *PtDim);

void *SumUpVoid(void *PtDim);

void parallelSqrtExp(float *data, 
  std::vector<cudaStream_t> streams, int N, int num_streams);

#define TIME_DIFFS(t1, t2) t2.tv_usec - t1.tv_usec

#endif
