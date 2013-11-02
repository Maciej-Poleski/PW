CUDA_INSTALL_PATH ?= /usr/local/cuda

CXX := /usr/bin/g++-4.6
CC := /usr/bin/gcc-4.6
LINK := /usr/bin/g++-4.6 -fPIC
CCPATH := ./gcc-4.6
NVCC  := $(CUDA_INSTALL_PATH)/bin/nvcc -ccbin $(CCPATH)

# Includes
INCLUDES = -I. -I$(CUDA_INSTALL_PATH)/include

# Libraries
LIB_CUDA := -L/usr/lib/nvidia-current -lcuda


# Options
NVCCOPTIONS = -arch sm_20 -ptx

# Common flags
COMMONFLAGS += $(INCLUDES) -DDEBUG
NVCCFLAGS += $(COMMONFLAGS) $(NVCCOPTIONS)
CXXFLAGS += $(COMMONFLAGS) -g3
CFLAGS += $(COMMONFLAGS) -g3

CUDA_OBJS = cuMin.ptx 
OBJS = demo.cpp.o cuMin.cpp.o
TARGET = solution.x
LINKLINE = $(LINK) -o $(TARGET) $(OBJS) $(LIB_CUDA)

.SUFFIXES:	.c	.cpp	.cu	.o	
%.c.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.ptx: %.cu
	$(NVCC) $(NVCCFLAGS) $< -o $@

%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): prepare $(OBJS) $(CUDA_OBJS)
	$(LINKLINE)

clean:
	rm -rf $(TARGET) *.o *.ptx

prepare:
	rm -rf $(CCPATH);\
	mkdir -p $(CCPATH);\
	ln -s $(CXX) $(CCPATH)/g++;\
	ln -s $(CC) $(CCPATH)/gcc;
