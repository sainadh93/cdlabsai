/* Test Case 5: Matrix Multiply — C */
#include <stdio.h>
#define N 3

void matmul(int a[N][N], int b[N][N], int c[N][N]) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            c[i][j] = 0;
            for (int k = 0; k < N; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

int main() {
    int a[N][N] = {{1,2,3},{4,5,6},{7,8,9}};
    int b[N][N] = {{9,8,7},{6,5,4},{3,2,1}};
    int c[N][N] = {0};
    matmul(a, b, c);
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++)
            printf("%4d", c[i][j]);
        printf("\n");
    }
    return 0;
}
