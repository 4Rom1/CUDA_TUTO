#ifndef CudaSamples_H
#define CudaSamples_H
//

inline int iDivUp(int a, int b) { return (a % b != 0) ? (a / b + 1) : (a / b); }

void CallHelloWorld(int N);

void CallHelloWorld2D(int Nx,int Ny);

int SumUp(int Dim);

int SumUp2D(int Width, int Height);

#endif
