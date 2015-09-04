#Using -Ofast instead of -O3 might result in faster code, but is supported only by newer GCC versions
CFLAGS = -lm -pthread -g -O0 -DDEBUG -march=native -Wall -funroll-loops -Wno-unused-result
NVFLAGS = -g -G -O0 -DDEBUG --ptxas-options=-v
CFLAGS = -lm -pthread -O2 -march=native -Wall -funroll-loops -Wno-unused-result
NVFLAGS = -O2 --ptxas-options=-v
CPP = g++
all: word2vec 

cbow.o: cbow.cu
	nvcc $(NVFLAGS) -c $<

word2vec: cbow.o word2vec.o
	nvcc $(NVFLAGS) word2vec.o cbow.o -o $@ $(LFLAGS) $(LIBS)
	rm *.o

word2vec.o : word2vec.cpp
	$(CPP) word2vec.cpp -c $< $(CFLAGS)

clean:
	rm -rf word2vec *.o
