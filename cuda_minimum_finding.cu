#include "stdio.h"

#define N 8 * 1000000

__global__ void hello()
{
    printf("hello, world from the GPU\n");
}

int main()
{
    int a[N];
    int *dev_a;
    cudaMalloc((void**)&dev_a, N * sizeof(int));
    for (i = 0; i < N; i++)
    {
        a[i] = rand() % 1000000000;
    }
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    
    dim3 grid(1);
    dim3 threads(8);
    hello <<<grid, threads >>> (dev_a, );
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();  // Waits for threads to finish
    return 0;
}
