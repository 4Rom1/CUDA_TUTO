#include "CudaSamples.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <sys/time.h>

// Inputs array with random numbers [1,9999].
void Randomize(int *array, int N) {
  srand(time(NULL)); // initialization.

  for (int i = 0; i < N; i++) {
    array[i] = (int)rand() % 10000;
  }
}
//
//
int CompareOutputs(int *Input1, int *Input2, int *Output, int N) {
  //
  int Diff = 0;
  for (int i = 0; i < N; i++) {
    Diff += ((Input1[i] + Input2[i] - Output[i]) *
             (Input1[i] + Input2[i] - Output[i]));
  }
  return Diff;
}
//
__global__ void HelloWorld() {
  // Global index build with blocks and threads
  const int index = threadIdx.x + blockDim.x * blockIdx.x;
  const int tId = threadIdx.x;
  const int BlockId = blockIdx.x;
  printf("Hi from thread number %d, Block number %d, global index %d\n", tId,
         BlockId, index);
}
__global__ void HelloWorld2D() {
  // 2D global index
  const int index_x = threadIdx.x + blockDim.x * blockIdx.x;
  const int tId_x = threadIdx.x;
  const int BlockId_x = blockIdx.x;
  const int index_y = threadIdx.y + blockDim.y * blockIdx.y;
  const int tId_y = threadIdx.y;
  const int BlockId_y = blockIdx.y;

  printf("Hi from thread X number %d, Block X number %d, global index X "
         "number%d\n",
         tId_x, BlockId_x, index_x);
  printf("Hi from thread Y number %d, Block Y number %d, global index Y "
         "number%d\n\n",
         tId_y, BlockId_y, index_y);
}

void CallHelloWorld(int N) {
  // N Threads per block
  const dim3 block(min(float(NWarps), float(N)), 1, 1);
  // 1d blocks per grid
  const dim3 grid(iDivUp(N, NWarps), 1, 1);
  // Kernel launch
  HelloWorld<<<grid, block>>>();
  // Synchronize threads
  GPU_ERROR_CHECK(cudaDeviceSynchronize())
}

void CallHelloWorld2D(int Nx, int Ny) {
  // N Threads per block
  const dim3 block(min(NWarps, Nx), min(NWarps, Ny), 1);
  // 2d blocks per grid
  const dim3 grid(iDivUp(Nx, NWarps), iDivUp(Ny, NWarps), 1);
  // Kernel launch
  HelloWorld2D<<<grid, block>>>();
  // Synchronize threads
  GPU_ERROR_CHECK(cudaDeviceSynchronize())
}

__global__ void KernelSumUp(int *Input1, int *Input2, int *Output, int Dim) {
  // Global index build with blocks and threads
  const int index = threadIdx.x + blockDim.x * blockIdx.x;
  if (index < Dim) {
    Output[index] = Input1[index] + Input2[index];
  }
}
__global__ void KernelSumUp2D(int *Input1, int *Input2, int *Output, int Width,
                              int Height) {
  // 2D global Index mapping
  const int index_x = threadIdx.x + blockDim.x * blockIdx.x;
  //
  const int index_y = threadIdx.y + blockDim.y * blockIdx.y;
  //
  if (index_x < Width && index_y < Height) {
    // 2d mapping
    const int Index_xy = index_y * Width + index_x;
    Output[Index_xy] = Input1[Index_xy] + Input2[Index_xy];
  }
}

int SumUp(int Dim) {
  struct timeval begin, end;
  //
  int NBytes = sizeof(int) * Dim;
  //
  int *Input1Dev, *Input2Dev, *OutputDev;
  //
  int *Input1, *Input2, *Output;
  //
  Input1 = new int[Dim];
  Input2 = new int[Dim];
  Output = new int[Dim];

  Randomize(Input1, Dim);

  Randomize(Input2, Dim);

  gettimeofday(&begin, NULL);

  (cudaMalloc(&Input1Dev, NBytes));
  (cudaMalloc(&Input2Dev, NBytes));
  (cudaMalloc(&OutputDev, NBytes));
  //
  gettimeofday(&end, NULL);
  unsigned int delta_time = TIME_DIFFS(begin, end);
  printf("time spent for allocation %u micros\n", delta_time);
  gettimeofday(&begin, NULL);
  (cudaMemcpy(Input1Dev, Input1, NBytes, cudaMemcpyHostToDevice));
  (cudaMemcpy(Input2Dev, Input2, NBytes, cudaMemcpyHostToDevice));
  //
  gettimeofday(&end, NULL);
  delta_time = TIME_DIFFS(begin, end);
  printf("time spent for synchronous copy %u micros\n", delta_time);
  // N Threads per block
  const dim3 block(min(NWarps, Dim), 1, 1);
  // blocks per grid
  const dim3 grid(iDivUp(Dim, NWarps), 1, 1);
  // Kernel launch
  gettimeofday(&begin, NULL);
  KernelSumUp<<<grid, block>>>(Input1Dev, Input2Dev, OutputDev, Dim);
  // Synchronize threads
  GPU_ERROR_CHECK(cudaDeviceSynchronize())
  //
  gettimeofday(&end, NULL);
  delta_time = TIME_DIFFS(begin, end);
  printf("time spent for one kernel launch synchronized %u micros\n",
         delta_time);
  GPU_ERROR_CHECK(cudaMemcpy(Output, OutputDev, NBytes, cudaMemcpyDeviceToHost))
  //
  cudaFree(Input1Dev);
  cudaFree(Input2Dev);
  cudaFree(OutputDev);
  //
  int Check = CompareOutputs(Input1, Input2, Output, Dim);

  delete[] Input1;
  delete[] Input2;
  delete[] Output;

  return Check;
}
int SumUpStreams(int Dim) {
  struct timeval begin, end;
  //
  int NBytes = sizeof(int) * Dim;
  //
  int *Input1Dev, *Input2Dev, *OutputDev;
  //
  int *Input1, *Input2, *Output;
  //
  cudaStream_t stream1, stream2;
  //
  gettimeofday(&begin, NULL);
  cudaStreamCreate(&stream1);
  cudaStreamCreate(&stream2);
  gettimeofday(&end, NULL);
  unsigned int delta_time = TIME_DIFFS(begin, end);
  printf("time spent for stream creation %u micros\n", delta_time);

  Input1 = new int[Dim];
  Input2 = new int[Dim];
  Output = new int[Dim];

  Randomize(Input1, Dim);

  Randomize(Input2, Dim);

  gettimeofday(&begin, NULL);
  cudaMalloc(&Input1Dev, NBytes);
  cudaMalloc(&Input2Dev, NBytes);
  cudaMalloc(&OutputDev, NBytes);
  gettimeofday(&end, NULL);
  delta_time = TIME_DIFFS(begin, end);
  printf("time spent for allocation %u micros\n", delta_time);
  gettimeofday(&begin, NULL);
  // Asynchronous copy in parrallel
  cudaMemcpyAsync(Input1Dev, Input1, NBytes, cudaMemcpyHostToDevice, stream1);
  cudaMemcpyAsync(Input2Dev, Input2, NBytes, cudaMemcpyHostToDevice, stream2);
  // Synchronize threads and streams
  GPU_ERROR_CHECK(cudaDeviceSynchronize())
  gettimeofday(&end, NULL);
  delta_time = TIME_DIFFS(begin, end);
  printf("time spent for asynchronous copy %u micros\n", delta_time);
  // N/2 Threads per block
  const dim3 block(min(NWarps, iDivUp(Dim, 2)), 1, 1);
  // blocks per grid
  const dim3 grid(iDivUp(iDivUp(Dim, 2), NWarps), 1, 1);
  // Kernel launch both streams in parallel
  gettimeofday(&begin, NULL);
  KernelSumUp<<<grid, block, 0, stream1>>>(Input1Dev, Input2Dev, OutputDev,
                                           Dim / 2);
  KernelSumUp<<<grid, block, 0, stream2>>>(&Input1Dev[Dim / 2],
                                           &Input2Dev[Dim / 2],
                                           &OutputDev[Dim / 2], iDivUp(Dim, 2));
  // Synchronize threads and streams
  GPU_ERROR_CHECK(cudaDeviceSynchronize())

  gettimeofday(&end, NULL);
  delta_time = TIME_DIFFS(begin, end);
  printf("time spent for 2 non synchronous kernel launch %u micros\n",
         delta_time);
  //
  GPU_ERROR_CHECK(cudaMemcpy(Output, OutputDev, NBytes, cudaMemcpyDeviceToHost))
  //
  cudaFree(Input1Dev);
  cudaFree(Input2Dev);
  cudaFree(OutputDev);
  //
  int Check = CompareOutputs(Input1, Input2, Output, Dim);

  delete[] Input1;
  delete[] Input2;
  delete[] Output;

  return Check;
}

int SumUp2D(int Width, int Height) {
  int NBytes = sizeof(int) * Width * Height;
  //
  int *Input1, *Input2, *Output;
  //
  int Dim = Width * Height;
  Input1 = new int[Dim];
  Input2 = new int[Dim];
  Output = new int[Dim];
  //
  int *Input1Dev, *Input2Dev, *OutputDev;
  //
  GPU_ERROR_CHECK(cudaMalloc(&Input1Dev, NBytes))
  GPU_ERROR_CHECK(cudaMalloc(&Input2Dev, NBytes))
  GPU_ERROR_CHECK(cudaMalloc(&OutputDev, NBytes))
  //
  Randomize(Input1, Dim);
  //
  Randomize(Input2, Dim);

  GPU_ERROR_CHECK(cudaMemcpy(Input1Dev, Input1, NBytes, cudaMemcpyHostToDevice))
  GPU_ERROR_CHECK(cudaMemcpy(Input2Dev, Input2, NBytes, cudaMemcpyHostToDevice))
  // N Threads per block
  const dim3 block(min(NWarps, Width), min(NWarps, Height), 1);
  // 2d blocks per grid
  const dim3 grid(iDivUp(Width, NWarps), iDivUp(Height, NWarps), 1);
  // Kernel launch
  KernelSumUp2D<<<grid, block>>>(Input1Dev, Input2Dev, OutputDev, Width,
                                 Height);
  // Synchronize threads
  GPU_ERROR_CHECK(cudaDeviceSynchronize())
  //
  GPU_ERROR_CHECK(cudaMemcpy(Output, OutputDev, NBytes, cudaMemcpyDeviceToHost))

  int Check = CompareOutputs(Input1, Input2, Output, Dim);

  delete[] Input1;
  delete[] Input2;
  delete[] Output;

  return Check;
}

__global__ void ParSqrtExp(float *x, int n) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  for (int ii = tid; ii < n; ii += blockDim.x * gridDim.x) {
    x[ii] = float(tid);
  }
}

void parallelSqrtExp(float *data, 
  std::vector<cudaStream_t> streams, int N, int num_streams) {

  for (int i = 0; i < num_streams; i++) {
    ParSqrtExp<<<1, 1024, 0, streams[i]>>>(&data[i * N], N);
  }
}
