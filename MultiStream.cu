#include "CudaSamples.h"
#include <pthread.h>
#include <stdio.h>

int main(int argc, const char *argv[]) {
  int N = 4;
  //
  printf("Usage : MultiStream N\n");
  printf("N : maximal global dimension\n");
  printf("Profile nvprof --export-profile FileName.prof ./MultiStream N\n");
  //
  if (argc >= 2) {
    N = atoi(argv[1]);
  }
  //
  const int num_streams = 8;
  cudaStream_t streams[num_streams];
  //
  for (int i = 0; i < num_streams; i++) {
    cudaStreamCreate(&streams[i]);
  }
  //
  float *data;
  //

  //
  cudaMalloc(&data, N * sizeof(float) * num_streams);
  for (int i = 0; i < num_streams; i++) {
    ParSqrtExp<<<1, 1024, 0, streams[i]>>>(&data[i * N], N);
  }
  //
  cudaDeviceSynchronize();
  cudaFree(data);
  return 0;
}
