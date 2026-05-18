; ModuleID = 'bubble_sort.cpp'
source_filename = "bubble_sort.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; C++ bubble_sort with vector — demangled: bubble_sort(std::vector<int>&)
define dso_local void @_Z11bubble_sortRSt6vectorIiSaIiEE(i8* %0) #0 {
entry:
  %vec = alloca i8*, align 8
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i8* %0, i8** %vec, align 8
  ; call size() — simplified
  %nv = call i32 @_ZNKSt6vectorIiSaIiEE4sizeEv(i8* %0)
  store i32 %nv, i32* %n, align 4
  store i32 0, i32* %i, align 4
  br label %loop.outer.cond

loop.outer.cond:
  %iv = load i32, i32* %i, align 4
  %nmv = load i32, i32* %n, align 4
  %nm1 = sub nsw i32 %nmv, 1
  %cmp = icmp slt i32 %iv, %nm1
  br i1 %cmp, label %loop.outer.body, label %loop.outer.end

loop.outer.body:
  store i32 0, i32* %j, align 4
  br label %loop.inner.cond

loop.inner.cond:
  %jv = load i32, i32* %j, align 4
  %iv2 = load i32, i32* %i, align 4
  %nv2 = load i32, i32* %n, align 4
  %limit = sub nsw i32 %nv2, %iv2
  %limitm1 = sub nsw i32 %limit, 1
  %cmp2 = icmp slt i32 %jv, %limitm1
  br i1 %cmp2, label %loop.inner.body, label %loop.inner.end

loop.inner.body:
  %jv2 = load i32, i32* %j, align 4
  %elem_j = call i32* @_ZNSt6vectorIiSaIiEEixEm(i8* %0, i32 %jv2)
  %val_j = load i32, i32* %elem_j, align 4
  %jp1 = add nsw i32 %jv2, 1
  %elem_jp1 = call i32* @_ZNSt6vectorIiSaIiEEixEm(i8* %0, i32 %jp1)
  %val_jp1 = load i32, i32* %elem_jp1, align 4
  %cmp3 = icmp sgt i32 %val_j, %val_jp1
  br i1 %cmp3, label %do_swap, label %no_swap

do_swap:
  call void @_ZSt4swapIiENSt9enable_ifIXsr6__and_ISt6detail15__is_swappable_nIiEEE5valueEvE4typeERiS4_(i32* %elem_j, i32* %elem_jp1)
  br label %no_swap

no_swap:
  %jv3 = load i32, i32* %j, align 4
  %jinc = add nsw i32 %jv3, 1
  store i32 %jinc, i32* %j, align 4
  br label %loop.inner.cond

loop.inner.end:
  %iv3 = load i32, i32* %i, align 4
  %iinc = add nsw i32 %iv3, 1
  store i32 %iinc, i32* %i, align 4
  br label %loop.outer.cond

loop.outer.end:
  ret void
}

declare i32 @_ZNKSt6vectorIiSaIiEE4sizeEv(i8*)
declare i32* @_ZNSt6vectorIiSaIiEEixEm(i8*, i32)
declare void @_ZSt4swapIiENSt9enable_ifIXsr6__and_ISt6detail15__is_swappable_nIiEEE5valueEvE4typeERiS4_(i32*, i32*)

attributes #0 = { nounwind uwtable }
