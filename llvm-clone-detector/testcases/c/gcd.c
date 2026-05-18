/* Test Case 4: GCD — C implementation */
#include <stdio.h>

int gcd(int a, int b) {
    while (b != 0) {
        int t = b;
        b = a % b;
        a = t;
    }
    return a;
}

int lcm(int a, int b) {
    return (a / gcd(a, b)) * b;
}

int main() {
    printf("gcd(48,18) = %d\n", gcd(48, 18));
    printf("lcm(4,6) = %d\n", lcm(4, 6));
    return 0;
}
