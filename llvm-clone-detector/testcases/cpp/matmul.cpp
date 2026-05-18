// Test Case 5: Matrix Multiply — C++
#include <iostream>
#include <array>

constexpr int N = 3;
using Matrix = std::array<std::array<int, N>, N>;

Matrix matmul(const Matrix& a, const Matrix& b) {
    Matrix c = {};
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            c[i][j] = 0;
            for (int k = 0; k < N; k++) {
                c[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    return c;
}

int main() {
    Matrix a = {{{1,2,3},{4,5,6},{7,8,9}}};
    Matrix b = {{{9,8,7},{6,5,4},{3,2,1}}};
    auto c = matmul(a, b);
    for (auto& row : c) {
        for (int x : row) std::cout << x << " ";
        std::cout << "\n";
    }
    return 0;
}
