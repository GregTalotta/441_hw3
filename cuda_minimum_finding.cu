#include "stdio.h"

#define N 8000000

__device__ int findMinimum(int a[], int low, int high)
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

__global__ void min(int *a, int *c)
{
    int rank = threadIdx.x;
    int p = sizeof(c)/sizeof(int);
    int numToSort = (8 * 1000000) / p;
    int low = rank * numToSort;
    int high = low + numToSort - 1;
    c[rank] = findMinimum(a, low, high);
    printf("crash here 2.5 \n");
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
    for (int i = 0; i < N; i++)
    {
        a[i] = rand() % 1000000000;
    }
    printf("crash here 1 \n");
    cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_c, c, num_threads * sizeof(int), cudaMemcpyHostToDevice);
    printf("crash here 2 \n");
    dim3 grid(1);
    dim3 threads(num_threads);
    min <<<grid, threads >>> (dev_a, dev_c);
    cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
    printf("crash here 3 \n");
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
