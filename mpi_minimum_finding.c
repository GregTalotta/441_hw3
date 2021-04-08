#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N 8 * 1000000

int findMinimum(int a[], int low, int high);

int main(int argc, char *argv[])
{
    int *a, *temp;
    int i;
    int rank, p;
    int tag = 0;
    MPI_Status status;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &p);

    a = (int *)malloc(sizeof(int) * N);
    temp = (int *)malloc(sizeof(int)*1);
    if (rank == 0)
    {
        for (i = 0; i < N; i++)
            a[i] = rand() % 100000;
    }
    MPI_Bcast(a, N, MPI_INT, 0, MPI_COMM_WORLD);

    // Compute low and high indices of array our process will sort
    int numToSort = N / p;
    int low = rank * numToSort;
    int high = low + numToSort - 1;

    // Mergesort for each of the 8 processes
    temp[0] = findMinimum(a, low, high);

    if (rank != 0)
    {
        MPI_Send(temp, 1, MPI_INT, 0, tag, MPI_COMM_WORLD);
    }
    // Wait for each process to finish sorting their block
    MPI_Barrier(MPI_COMM_WORLD);

    if (rank == 0)
    {
        int min = temp[0];
        for (source = 1; source < p; source++)
        {
            MPI_Recv(temp, 1, MPI_INT, source, tag, MPI_COMM_WORLD, &status);
            if(temp[0]<min){
                min = temp[0];
            }
        }
        printf("Minimal value is: ", temp);
    }
    free(a);
    free(temp);
    MPI_Finalize();
    return 0;
}

int findMinimum(int a[], int low, int high)
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
