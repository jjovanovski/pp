#include <stdio.h>
#include <stdlib.h>

#define MAX_N 5000
#define MAX_VALUE 20
int A[MAX_N][MAX_N+1];

int random_int() {
    return (rand())%(2*MAX_VALUE) - MAX_VALUE;
}

int main(int argc, const char** args) {
    // read the output file name
    printf("Enter output file name: ");
    char file[32];
    scanf("%s", file);
    printf("\n");

    // read the number of variables (x1, x2...)
    int n;
    printf("Enter the number of variables: ");
    scanf("%d", &n);
    printf("\n");

    // generate random values for the variables (the solution of the system)
    srand(100);
    int solutions[MAX_N];
    printf("Solutions:\n");
    for(int i = 0; i < n; i++) {
        solutions[i] = random_int();
        printf("%d\t", solutions[i]);
    }

    // generate random coefficients for the system, evalaute them for the specific values of x1,x2... and store the system as a matrix
    for(int i = 0; i < n; i++) {
        int rhs = 0;
        for(int j = 0; j < n; j++) {
            A[i][j] = random_int();
            rhs += A[i][j] * solutions[j];
        }
        A[i][n] = rhs;
    }

    // write the matrix to the output file
    FILE* f = fopen(file, "w");
    fprintf(f, "%d ", n);
    for(int i = 0; i < n; i++) {
        for(int j = 0; j <= n; j++) {
            fprintf(f, "%d ", A[i][j]);
        }
    }
    fclose(f);

    /*printf("\nMatrix:\n");
    printf("double A[%d][%d] = {", n, n + 1);
    for(int i = 0; i < n; i++) {
        printf("{");
        for(int j = 0; j <= n; j++) {
            printf("%d", A[i][j]);
            if(j < n) printf(", ");
        }
        printf("}");

        if(i < n-1) printf(", ");
    }
    printf("};");*/

    return 0;
}