; ModuleID = 'bubble_sort.c'
source_filename = "bubble_sort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @bubble_sort(i32* %0, i32 %1) #0 {
entry:
  %arr = alloca i32*, align 8
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %0, i32** %arr, align 8
  store i32 %1, i32* %n, align 4
  store i32 0, i32* %i, align 4
  br label %loop.outer.cond

loop.outer.cond:
  %iv = load i32, i32* %i, align 4
  %nv = load i32, i32* %n, align 4
  %nm1 = sub nsw i32 %nv, 1
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
  %arrp = load i32*, i32** %arr, align 8
  %jv2 = load i32, i32* %j, align 4
  %gep_j = getelementptr inbounds i32, i32* %arrp, i32 %jv2
  %val_j = load i32, i32* %gep_j, align 4
  %jp1 = add nsw i32 %jv2, 1
  %gep_jp1 = getelementptr inbounds i32, i32* %arrp, i32 %jp1
  %val_jp1 = load i32, i32* %gep_jp1, align 4
  %cmp3 = icmp sgt i32 %val_j, %val_jp1
  br i1 %cmp3, label %swap, label %no_swap

swap:
  store i32 %val_j, i32* %tmp, align 4
  store i32 %val_jp1, i32* %gep_j, align 4
  %tv = load i32, i32* %tmp, align 4
  store i32 %tv, i32* %gep_jp1, align 4
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

attributes #0 = { nounwind uwtable }
