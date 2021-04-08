#include "stdio.h"
#include "stdlib.h"

#define N 8000000
#define T 8

__global__ void find_min(int *a, int *c)
{
    int rank = threadIdx.x;
    int numToSort = (8000000) / T;
    int low = rank * numToSort;
    int high = low + numToSort - 1;
    int min = a[low];
    for (int i = low; i < high; ++i)
    {
        if (min > a[i])
        {
            min = a[i];
        }
    }
    c[rank] = min;
    printf("crash here 2.5 \n");
}

int main()
{
    printf("start\n");
    int *a;
    a = (int *)malloc(sizeof(int) * N);
    int *dev_a;
    int c[T];
    int *dev_c;
    printf("crash here 0 \n");
    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_c, T * sizeof(int));
    for (int i = 0; i < N; ++i)
    {
        a[i] = rand() % 1000000000;
    }
    for(int i = 0; i < T; ++i){
        c[i] = 1000000001;
    }
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_c, c, T * sizeof(int), cudaMemcpyHostToDevice);
    dim3 grid(1);
    find_min <<<grid, T >>> (dev_a, dev_c);
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();  // Waits for threads to finish
    int min = c[0];
    for(int i = 0; i < T; ++i){
        if(min > c[i]){
            min = c[i];
        }
    }
    printf("Minimal value parallel with cuda is: %d\n", min);
    min = a[0];
        for(int i =0; i < N; ++i){
            if(min > a[i]){
                min = a[i];
            }
        }
        printf("Minimal value sequential: %d\n", min);
    return 0;
}


