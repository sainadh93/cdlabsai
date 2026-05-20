
#include <stdio.h>


int count_positive(int *arr, int n) {
    int count = 0;
    for (int i = 0; i < n; i++) {
        if (arr[i] > 0) {
            count++;
        }
    }
    return count;
}


int sum_positive(int *arr, int n) {
    int result = 0;
    for (int i = 0; i < n; i++) {
        if (arr[i] > 0) {
            result = result + arr[i];
        }
    }
    return result;
}

void matrix_operation(int **matrix, int rows, int cols, int **output) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            output[j][i] = matrix[i][j];
        }
    }
}


int process_data(double val1, float val2) {
    int x = (int)val1;
    int y = (int)val2;
    int z;  // Unknown initialization
    
    if (x > y) {
        z = x - y;
    } else {
        z = y - x;
    }
    return z;
}

int main() {
    int arr[] = {-5, 3, -2, 7, 0, 4};
    int n = 6;
    
    printf("Count positive: %d\n", count_positive(arr, n));
    printf("Sum positive: %d\n", sum_positive(arr, n));
    printf("Absolute difference: %d\n", process_data(3.5, 2.1));
    
    return 0;
}
