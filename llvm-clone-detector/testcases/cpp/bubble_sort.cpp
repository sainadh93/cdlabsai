// Test Case 1: Bubble Sort — C++ implementation
#include <iostream>
#include <vector>

void bubble_sort(std::vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }
}

int main() {
    std::vector<int> arr = {64, 34, 25, 12, 22, 11, 90};
    bubble_sort(arr);
    for (int x : arr)
        std::cout << x << " ";
    std::cout << std::endl;
    return 0;
}
