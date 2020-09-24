cmake_minimum_required(VERSION 3.1)
project(Cuda_tuto CXX)


if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif (NOT CMAKE_BUILD_TYPE)

set(CMAKE_CUDA_COMPILER "/opt/apps/nvidia-cuda/10.1.168/bin/toolkit/bin/nvcc")

find_package(CUDA)

include_directories(. ${CUDA_INCLUDE_DIRS})

set(LIB_GPU "cuda_lib")

CUDA_ADD_LIBRARY(${LIB_GPU} SHARED CudaSamples.cu)

set(TARGET_NAME "Display")
CUDA_ADD_EXECUTABLE(${TARGET_NAME} Display.cu)
target_link_libraries(${TARGET_NAME} ${LIB_GPU} ${CUDA_LIBRARIES})
target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra -pedantic)

set(TARGET_NAME "Sum")
CUDA_ADD_EXECUTABLE(${TARGET_NAME} Sum.cu)
target_link_libraries(${TARGET_NAME} ${LIB_GPU} ${CUDA_LIBRARIES})
target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra -pedantic)

set(TARGET_NAME "MultiStream")
CUDA_ADD_EXECUTABLE(${TARGET_NAME} MultiStream.cu)
target_link_libraries(${TARGET_NAME} ${LIB_GPU} ${CUDA_LIBRARIES})
target_compile_options(${TARGET_NAME} PRIVATE -Wall -Wextra -pedantic)

