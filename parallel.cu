#include <stdio.h>

#define m2a(i, j, n) (j + i*(n+1))

#define MAX_N 500
int n, m;
double A[MAX_N][MAX_N+1];

void read_matrix_from_file() {
    printf("Enter input file name: ");
    char file[32];
    //scanf("%s", file);
    printf("\n");

    //printf("Reading file %s\n", file);
    //FILE* f = fopen(file, "r");
    FILE* f = fopen("mat500.txt", "r");
    fscanf(f, "%d", &n);
    m = n + 1;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            int r;
            fscanf(f, "%d", &r);
            A[i][j] = r;
        }
    }
    fclose(f);
}

void print_matrix() {
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            printf("%.1f\t", A[i][j]);
        }
        printf("\n");
    }
}

__global__ void elimination(double* d_A, int n, int anchorIndex) {
    int rowIndex = threadIdx.x;
    if(rowIndex > anchorIndex) {
        int index = m2a(rowIndex, anchorIndex, n);
        if(d_A[index] != 0) {
            double f = - (d_A[index]) / d_A[m2a(anchorIndex, anchorIndex, n)];

            for(int k = 0; k < n+1; k++) {
                int to = m2a(rowIndex, k, n);
                int from = m2a(anchorIndex, k, n);
                d_A[to] += d_A[from] * f;
            }
        }
    }
}

int main(int argc, const char** args) {
    read_matrix_from_file();
    const int bytes = n*m*sizeof(double);

    double* d_A = nullptr;
    cudaMalloc((void**) &d_A, bytes);
    cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
    
    for(int i = 0; i < n; i++) {
        elimination<<<1, n>>>(d_A, n, i);
    }

    cudaMemcpy(A, d_A, bytes, cudaMemcpyDeviceToHost);
    cudaFree(d_A);

    print_matrix();

    return 0;
}