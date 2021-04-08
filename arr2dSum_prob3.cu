#include "stdio.h"
#define COLUMNS 4
#define ROWS 3

__global__ void add(int* a, int* c)
{
    int column = blockIdx.x;
    int total = 0;
    for(int i = 0; i < ROWS; ++i){
        total += a[COLUMNS*i + column];
    }
    c[column]=total;
}

int main()
{
    int a[ROWS][COLUMNS], c[COLUMNS];
    int* dev_a, * dev_c;

    cudaMalloc((void**)&dev_a, ROWS * COLUMNS * sizeof(int));
    cudaMalloc((void**)&dev_c, COLUMNS * sizeof(int));

    for (int y = 0; y < ROWS; y++)              // Fill Arrays
        for (int x = 0; x < COLUMNS; x++)
            a[y][x] = 7;

    cudaMemcpy(dev_a, a, ROWS * COLUMNS * sizeof(int), cudaMemcpyHostToDevice);

    add <<<1, COLUMNS >>> (dev_a, dev_c);

    cudaMemcpy(c, dev_c, COLUMNS * sizeof(int), cudaMemcpyDeviceToHost);
    int total = 0;
    for(int i = 0; i < COLUMNS; ++i){
        total += c[0];
    }
    printf("Total sum of all elements is: %d\n", total);
    cudaFree(dev_a);
    cudaFree(dev_c);
    return 0;
}
                 