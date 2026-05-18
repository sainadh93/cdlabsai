; ModuleID = 'factorial.c'
source_filename = "factorial.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @factorial(i32 %0) #0 {
entry:
  %n = alloca i32, align 4
  %result = alloca i64, align 8
  %i = alloca i32, align 4
  store i32 %0, i32* %n, align 4
  %nv = load i32, i32* %n, align 4
  %cmp = icmp sle i32 %nv, 1
  br i1 %cmp, label %ret_one, label %loop_init

ret_one:
  ret i64 1

loop_init:
  store i64 1, i64* %result, align 8
  store i32 2, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %iv = load i32, i32* %i, align 4
  %nv2 = load i32, i32* %n, align 4
  %cmp2 = icmp sle i32 %iv, %nv2
  br i1 %cmp2, label %loop.body, label %loop.end

loop.body:
  %rv = load i64, i64* %result, align 8
  %iv2 = load i32, i32* %i, align 4
  %iv64 = sext i32 %iv2 to i64
  %mul = mul nsw i64 %rv, %iv64
  store i64 %mul, i64* %result, align 8
  %inc = add nsw i32 %iv2, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  %retval = load i64, i64* %result, align 8
  ret i64 %retval
}

define dso_local i32 @gcd(i32 %0, i32 %1) #0 {
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

define dso_local i32 @linear_search(i32* %0, i32 %1, i32 %2) #0 {
entry:
  %arr = alloca i32*, align 8
  %n = alloca i32, align 4
  %target = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %0, i32** %arr, align 8
  store i32 %1, i32* %n, align 4
  store i32 %2, i32* %target, align 4
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %iv = load i32, i32* %i, align 4
  %nv = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %iv, %nv
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %arrp = load i32*, i32** %arr, align 8
  %iv2 = load i32, i32* %i, align 4
  %gep = getelementptr inbounds i32, i32* %arrp, i32 %iv2
  %elem = load i32, i32* %gep, align 4
  %tv = load i32, i32* %target, align 4
  %eq = icmp eq i32 %elem, %tv
  br i1 %eq, label %found, label %not_found

found:
  %idx = load i32, i32* %i, align 4
  ret i32 %idx

not_found:
  %iv3 = load i32, i32* %i, align 4
  %inc = add nsw i32 %iv3, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 -1
}

define dso_local i32 @binary_search(i32* %0, i32 %1, i32 %2) #0 {
entry:
  %arr = alloca i32*, align 8
  %n = alloca i32, align 4
  %target = alloca i32, align 4
  %low = alloca i32, align 4
  %high = alloca i32, align 4
  %mid = alloca i32, align 4
  store i32* %0, i32** %arr, align 8
  store i32 %1, i32* %n, align 4
  store i32 %2, i32* %target, align 4
  store i32 0, i32* %low, align 4
  %nv = load i32, i32* %n, align 4
  %nm1 = sub nsw i32 %nv, 1
  store i32 %nm1, i32* %high, align 4
  br label %loop.cond

loop.cond:
  %lv = load i32, i32* %low, align 4
  %hv = load i32, i32* %high, align 4
  %cmp = icmp sle i32 %lv, %hv
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %lv2 = load i32, i32* %low, align 4
  %hv2 = load i32, i32* %high, align 4
  %diff = sub nsw i32 %hv2, %lv2
  %half = sdiv i32 %diff, 2
  %midv = add nsw i32 %lv2, %half
  store i32 %midv, i32* %mid, align 4
  %arrp = load i32*, i32** %arr, align 8
  %midgep = getelementptr inbounds i32, i32* %arrp, i32 %midv
  %midval = load i32, i32* %midgep, align 4
  %tv = load i32, i32* %target, align 4
  %eq = icmp eq i32 %midval, %tv
  br i1 %eq, label %found, label %check_side

check_side:
  %lt = icmp slt i32 %midval, %tv
  br i1 %lt, label %go_right, label %go_left

go_right:
  %mv = load i32, i32* %mid, align 4
  %np1 = add nsw i32 %mv, 1
  store i32 %np1, i32* %low, align 4
  br label %loop.cond

go_left:
  %mv2 = load i32, i32* %mid, align 4
  %nm1b = sub nsw i32 %mv2, 1
  store i32 %nm1b, i32* %high, align 4
  br label %loop.cond

found:
  %retmid = load i32, i32* %mid, align 4
  ret i32 %retmid

loop.end:
  ret i32 -1
}

attributes #0 = { nounwind }
