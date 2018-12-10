#ifndef CudaSamples_H
#define CudaSamples_H
//

inline int iDivUp(int a, int b) { return (a % b != 0) ? (a / b + 1) : (a / b); }

void CallHelloWorld(int N);

void CallHelloWorld2D(int Nx,int Ny);

void SumUp(int *Input1, int *Input2, int *Output, int Dim);

void SumUp2D(int *Input1, int *Input2, int *Output, int Width, int Height);

#endif
