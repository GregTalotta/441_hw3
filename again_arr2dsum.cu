#include "stdio.h"
#define DIM 8
const int THREADS_PER_BLOCK = 8;
const int NUM_BLOCKS = 8; 

__global__ void add(int* a, int* c)
{
    __shared__ int chache[THREADS_PER_BLOCK];
    int tid = threadIdx.x + (blockIdx.x * blockDim.x);
    int cacheIndex = threadIdx.x;
    int temp = 0;
    temp = a[tid];
    cache[cacheIndex] = temp;

    int i = blockDim.x / 2;
    while (i > 0)
    {
        if (cacheIndex < i)
            cache[cacheIndex] += cache[cacheIndex + i];
        __syncthreads();
        i /= 2;
    }
    if (threadIdx.x == 0)         // if at thread 0 in this block
        c[blockIdx.x] = cache[0]; // save the sum in global memory

}

int main()
{
    int a[DIM][DIM], c[DIM];
    int* dev_a, * dev_c;

    cudaMalloc((void**)&dev_a, DIM * DIM * sizeof(int));
    cudaMalloc((void**)&dev_c, DIM * sizeof(int));

    for (int y = 0; y < DIM; y++)              // Fill Arrays
        for (int x = 0; x < DIM; x++)
            a[y][x] = 7;

    for(int i = 0; i < DIM; ++i){
        c[i]=0;
    }
    cudaMemcpy(dev_a, a, DIM * DIM * sizeof(int), cudaMemcpyHostToDevice);

    
    add <<<NUM_BLOCKS, THREADS_PER_BLOCK >>> (dev_a, dev_c);

    cudaMemcpy(c, dev_c, DIM * sizeof(int), cudaMemcpyDeviceToHost);
    int total = 0;
    for(int i = 0; i < DIM; ++i){
        total += c[i];
        printf("c is: %d\n", c[i]);
    }
    printf("Total sum of all elements is: %d\n", total);
    cudaFree(dev_a);
    cudaFree(dev_c);
    return 0;
}
