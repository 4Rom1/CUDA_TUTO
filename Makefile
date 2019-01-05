#Compile with : nvcc http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
CPP = g++ 
CPP_FLAGS = -Wall -Wextra -Werror -pedantic -g 
#OPENCVFLAG = `pkg-config --cflags opencv`
#LIBOPENCV = `pkg-config --libs opencv`
NVCC = nvcc
NVCCFLAG = -x cu -I. -dc
NVCCARCH = -arch=sm_35

Targets = Display

all : Display Sum

Display: Display.cu CudaSamples.cu
	$(NVCC) -o Display Display.cu CudaSamples.cu
	
Sum: Sum.cu CudaSamples.cu
	$(NVCC) -o Sum Sum.cu CudaSamples.cu
	
clean:
	touch $(Targets); rm Display; rm Sum;


