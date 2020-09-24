# CUDA_TUTO
Simple cuda functions for tutoring purposes.  

Compilation :  
  
In CMakeLists.txt replace   
 set(CMAKE_CUDA_COMPILER "/opt/apps/nvidia-cuda/10.1.168/bin/toolkit/bin/nvcc")  
by  
 set(CMAKE_CUDA_COMPILER "/usr/local/cuda/bin/nvcc")  
Or the actual location of your nvcc (found with which nvcc).  
  
$ mkdir build && cd build && cmake .. && make  

  -Display function :  

   Display the thread index, the block index and the global index from Kernel launch.  

   Usage 

   ./Display N 

   N is the maximal global index you want to display or  

   ./Display Nx Ny  

   Same as above in 2 dimensions with maximal global indexes equal to (Nx,Ny). 
   
   
 -Sum function :  

   Sum the elements of 2 arrays with optional streams and asynchronous copies.  

   Usage 

   ./Sum N   

   N is the maximal size of the 1d arrays or  

   ./Sum Nx Ny  

   where (Nx,Ny) are maximal sizes of the 2d arrays.
   
  
  
