/* Test Case 2: Factorial — C implementation */
#include <stdio.h>

long factorial(int n) {
    if (n <= 1) return 1;
    long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

/* Recursive variant — should NOT match iterative */
long factorial_recursive(int n) {
    if (n <= 1) return 1;
    return n * factorial_recursive(n - 1);
}

int main() {
    for (int i = 0; i <= 10; i++)
        printf("%d! = %ld\n", i, factorial(i));
    return 0;
}
