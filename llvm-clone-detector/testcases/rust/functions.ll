; ModuleID = 'search.rs'
source_filename = "search.rs"
target triple = "x86_64-unknown-linux-gnu"

; Rust linear_search — same algorithm as C linear_search
define i32 @_ZN6search13linear_search17hf1e2d3c4b5a6e7f8E(i32* %0, i64 %1, i32 %2) unnamed_addr #0 {
entry:
  %arr = alloca i32*, align 8
  %len = alloca i64, align 8
  %target = alloca i32, align 4
  %i = alloca i64, align 8
  store i32* %0, i32** %arr, align 8
  store i64 %1, i64* %len, align 8
  store i32 %2, i32* %target, align 4
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %iv = load i64, i64* %i, align 8
  %lv = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %lv
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %arrp = load i32*, i32** %arr, align 8
  %iv2 = load i64, i64* %i, align 8
  %gep = getelementptr inbounds i32, i32* %arrp, i64 %iv2
  %elem = load i32, i32* %gep, align 4
  %tv = load i32, i32* %target, align 4
  %eq = icmp eq i32 %elem, %tv
  br i1 %eq, label %found, label %not_found

found:
  %idx = load i64, i64* %i, align 8
  %idx32 = trunc i64 %idx to i32
  ret i32 %idx32

not_found:
  %iv3 = load i64, i64* %i, align 8
  %inc = add nuw nsw i64 %iv3, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  ret i32 -1
}

; Rust gcd — same Euclidean algorithm as C gcd
define i32 @_ZN6search3gcd17ha1b2c3d4e5f6a7b8E(i32 %0, i32 %1) unnamed_addr #0 {
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %t = alloca i32, align 4
  store i32 %0, i32* %a, align 4
  store i32 %1, i32* %b, align 4
  br label %loop.cond

loop.cond:
  %bv = load i32, i32* %b, align 4
  %cmp = icmp ne i32 %bv, 0
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %bv2 = load i32, i32* %b, align 4
  store i32 %bv2, i32* %t, align 4
  %av = load i32, i32* %a, align 4
  %rem = srem i32 %av, %bv2
  store i32 %rem, i32* %b, align 4
  %tv = load i32, i32* %t, align 4
  store i32 %tv, i32* %a, align 4
  br label %loop.cond

loop.end:
  %retval = load i32, i32* %a, align 4
  ret i32 %retval
}

attributes #0 = { nounwind }
