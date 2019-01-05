# CUDA_TUTO
Simple cuda functions for tutoring purposes.

Compilation :

$ make 

  -Display function :

   Display the thread index, the block index and the global index from Kernel launch.

   Usage 

   ./Display N 

   N is the maximal global index you want to display or

   ./Display Nx Ny

   Same as above in 2 dimensions with maximal global indexes equal to (Nx,Ny). 
   
   
 -Sum function :

   Sum the indexes of 2 arrays with and without using streams and asynchronous copies.

   Usage 

   ./Sum N 

   N is the maximal dimension of the arrays or

   ./Sum Nx Ny

   where (Nx,Ny) are maximal dimensions of the 2d arrays.
   
  
  
