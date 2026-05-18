; ModuleID = 'bubble_sort.rs'
source_filename = "bubble_sort.rs"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Rust bubble_sort — mangled name stripped for normalization
define void @_ZN11bubble_sort11bubble_sort17h3a9d8f2e1c4b5d6eE(i8* %0) unnamed_addr #0 {
entry:
  %vec_ptr = alloca i8*, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i8* %0, i8** %vec_ptr, align 8
  %len = call i64 @_ZN3std3vec3Vec3lenEv(i8* %0)
  store i64 %len, i64* %n, align 8
  store i64 0, i64* %i, align 8
  br label %loop.outer.cond

loop.outer.cond:
  %iv = load i64, i64* %i, align 8
  %nv = load i64, i64* %n, align 8
  %nm1 = sub nuw nsw i64 %nv, 1
  %cmp = icmp ult i64 %iv, %nm1
  br i1 %cmp, label %loop.outer.body, label %loop.outer.end

loop.outer.body:
  store i64 0, i64* %j, align 8
  br label %loop.inner.cond

loop.inner.cond:
  %jv = load i64, i64* %j, align 8
  %iv2 = load i64, i64* %i, align 8
  %nv2 = load i64, i64* %n, align 8
  %limit = sub nuw nsw i64 %nv2, %iv2
  %limitm1 = sub nuw nsw i64 %limit, 1
  %cmp2 = icmp ult i64 %jv, %limitm1
  br i1 %cmp2, label %loop.inner.body, label %loop.inner.end

loop.inner.body:
  %jv2 = load i64, i64* %j, align 8
  %vp = load i8*, i8** %vec_ptr, align 8
  %elem_j = call i32* @_ZN3std3vec3Vec10index_implEm(i8* %vp, i64 %jv2)
  %val_j = load i32, i32* %elem_j, align 4
  %jp1 = add nuw nsw i64 %jv2, 1
  %elem_jp1 = call i32* @_ZN3std3vec3Vec10index_implEm(i8* %vp, i64 %jp1)
  %val_jp1 = load i32, i32* %elem_jp1, align 4
  %cmp3 = icmp sgt i32 %val_j, %val_jp1
  br i1 %cmp3, label %do_swap, label %no_swap

do_swap:
  call void @_ZN3std3vec3Vec4swapEm(i8* %vp, i64 %jv2, i64 %jp1)
  br label %no_swap

no_swap:
  %jv3 = load i64, i64* %j, align 8
  %jinc = add nuw nsw i64 %jv3, 1
  store i64 %jinc, i64* %j, align 8
  br label %loop.inner.cond

loop.inner.end:
  %iv3 = load i64, i64* %i, align 8
  %iinc = add nuw nsw i64 %iv3, 1
  store i64 %iinc, i64* %i, align 8
  br label %loop.outer.cond

loop.outer.end:
  ret void
}

declare i64 @_ZN3std3vec3Vec3lenEv(i8*)
declare i32* @_ZN3std3vec3Vec10index_implEm(i8*, i64)
declare void @_ZN3std3vec3Vec4swapEm(i8*, i64, i64)

attributes #0 = { nounwind }
