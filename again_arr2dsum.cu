#include "stdio.h"
#define DIM 8

__global__ void add(int* a, int* c)
{
    int row = blockIdx.x;
    int column = threadIdx.x;
    c[row] += a[(DIM*row)+column];
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

    add <<<DIM, DIM >>> (dev_a, dev_c);

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
                 