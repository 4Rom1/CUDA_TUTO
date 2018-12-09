#Compile with : nvcc http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
CPP = g++ 
CPP_FLAGS = -Wall -Wextra -Werror -pedantic -g 
#OPENCVFLAG = `pkg-config --cflags opencv`
#LIBOPENCV = `pkg-config --libs opencv`
NVCC = nvcc
NVCCFLAG = -x cu -I. -dc
NVCCARCH = -arch=sm_35

Targets = Main

all : Main 

Main: Main.cpp CudaSamples.cu
	$(NVCC) -o Main Main.cpp CudaSamples.cu
clean:
	touch $(Targets); rm Main;


