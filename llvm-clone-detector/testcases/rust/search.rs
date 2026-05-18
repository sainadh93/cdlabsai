// Test Case 3: Linear Search — Rust
fn linear_search(arr: &[i32], target: i32) -> i32 {
    for (i, &val) in arr.iter().enumerate() {
        if val == target {
            return i as i32;
        }
    }
    -1
}

// Test Case 4: GCD — Euclidean algorithm (for cross-lang C/Rust comparison)
fn gcd(mut a: i32, mut b: i32) -> i32 {
    while b != 0 {
        let t = b;
        b = a % b;
        a = t;
    }
    a
}

fn main() {
    let arr = [10, 20, 30, 40, 50];
    println!("linear_search: {}", linear_search(&arr, 30));
    println!("gcd(48,18): {}", gcd(48, 18));
}
