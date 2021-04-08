#include "stdio.h"

#define N 8 * 1000000

_device_ int findMinimum(int a[], int low, int high)
{
    int min = a[low];
    for (int i = low; i < high; ++i)
    {
        if (min > a[i])
        {
            min = a[i];
        }
    }
    return min;
}

__global__ void min(int a[], int c[])
{
    int rank = threadIdx.x;
    int p = sizeof(dev_c)/sizeof(int);
    int numToSort = (8 * 1000000) / p;
    int low = rank * numToSort;
    int high = low + numToSort - 1;
    int c[rank] = findMinimum(dev_a, low, high);
}

int main()
{
    int num_threads = 8;
    int a[N];
    int *dev_a;
    int c[num_threads];
    int *dev_c;
    cudaMalloc((void**)&dev_a, N * sizeof(int));
    cudaMalloc((void**)&dev_c, num_threads * sizeof(int));
    for (i = 0; i < N; i++)
    {
        a[i] = rand() % 1000000000;
    }
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_c, c, num_threads * sizeof(int), cudaMemcpyHostToDevice);
    dim3 grid(1);
    dim3 threads(num_threads);
    min <<<grid, threads >>> (dev_a, dev_c);
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();  // Waits for threads to finish
    int min = c[0];
    for(int i = 0; i < num_threads; ++i){
        if(min > c[i]){
            min = c[i];
            printf("Minimal value parallel with cuda is: %d\n", min);
        }
    }
    return 0;
}
