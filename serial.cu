#include <stdio.h>
#include <time.h>

#define MAX_N 5000
int n, m;
double A[MAX_N][MAX_N+1];

void print_matrix() {
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < m; j++) {
            printf("%.3f\t", A[i][j]);
        }
        printf("\n");
    }
}

void eliminate(int i, int j, double f) {
    for(int k = i; k < m; k++) {
        A[j][k] += f*A[i][k];
    }   
}

void backward_sub(int i) {
    double f = A[i][i];
    A[i][i] /= f;
    A[i][m-1] /= f;
    for(int j = i+1; j < m-1; j++) {
        A[i][j] /= f;
        A[i][m-1] -= (A[i][j]) * A[j][m-1];
        A[i][j] = 0;
    }
}

void gaussian() {
    // reduce to upper triangular
    for(int i = 0; i < n; i++) {
        for(int j = i + 1; j < n; j++) {
            if(A[j][i] != 0) {
                double f = - (A[j][i] / A[i][i]);
                eliminate(i, j, f);
            }
        }
    }

    for(int i = n-1; i >= 0; i--) {
        backward_sub(i);
    }
}

void read_matrix_from_file() {
    printf("Enter input file name: ");
    char file[32];
    scanf("%s", file);
    printf("\n");

    printf("Reading file %s\n", file);
    FILE* f = fopen(file, "r");
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

int main(int argc, const char** args) {
    read_matrix_from_file();
    
    printf("Gaussian elimination started...\n");
    clock_t start_time = clock();
    {
        gaussian();
    }
    clock_t end_time = clock() - start_time;
    double time_taken = ((double)end_time)/CLOCKS_PER_SEC;
    printf("Gaussian elimination completed. Time: %.3f seconds \n", time_taken);

    printf("\nSolutions:\n");
    for(int i = 0; i < n; i++) {
        printf("%.3f\t", A[i][n]);
    }

    return 0;
}