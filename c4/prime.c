#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#define LIMIT 30000000

bool is_prime(int n) {
    if (n < 2) return false;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return false;
    }
    return true;
}

bool is_xor_prime(int n) {
    int digit_xor = 0;
    while (n > 0) {
        digit_xor ^= n % 10;
        n /= 10;
    }
    return is_prime(digit_xor);
}

int main() {
    clock_t start_time = clock();

    int xor_prime_count = 0;
    int xor_prime_value = 0;
    for (int i = 2; i < LIMIT; i++) {
        if (is_xor_prime(i)) {
            xor_prime_count++;
            if (xor_prime_count == 5000000) {
                xor_prime_value = i;
                break;
            }
        }
    }

    clock_t end_time = clock();
    double time_taken = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    printf("Result: %d\n", xor_prime_value);
    printf("Time taken: %f seconds\n", time_taken);

    return 0;
}
