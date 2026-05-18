/* Test Case 3: Linear Search — C */
#include <stdio.h>

int linear_search(int *arr, int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;
        }
    }
    return -1;
}

/* Test Case 5 (failure): Binary search — structurally different */
int binary_search(int *arr, int n, int target) {
    int low = 0, high = n - 1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

int main() {
    int arr[] = {10, 20, 30, 40, 50};
    printf("linear_search: %d\n", linear_search(arr, 5, 30));
    printf("binary_search: %d\n", binary_search(arr, 5, 30));
    return 0;
}
