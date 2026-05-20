; ModuleID = '/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/factorial.c'
source_filename = "/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/factorial.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"%d! = %ld\0A\00", align 1

; Function Attrs: nofree norecurse nosync nounwind memory(none) uwtable
define dso_local i64 @factorial(i32 noundef %0) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 2
  br i1 %2, label %12, label %3

3:                                                ; preds = %1
  %4 = add nuw i32 %0, 1
  %5 = zext i32 %4 to i64
  br label %6

6:                                                ; preds = %3, %6
  %7 = phi i64 [ 2, %3 ], [ %10, %6 ]
  %8 = phi i64 [ 1, %3 ], [ %9, %6 ]
  %9 = mul nsw i64 %8, %7
  %10 = add nuw nsw i64 %7, 1
  %11 = icmp eq i64 %10, %5
  br i1 %11, label %12, label %6, !llvm.loop !5

12:                                               ; preds = %6, %1
  %13 = phi i64 [ 1, %1 ], [ %9, %6 ]
  ret i64 %13
}

; Function Attrs: nofree nosync nounwind memory(none) uwtable
define dso_local i64 @factorial_recursive(i32 noundef %0) local_unnamed_addr #1 {
  br label %2

2:                                                ; preds = %6, %1
  %3 = phi i64 [ 1, %1 ], [ %9, %6 ]
  %4 = phi i32 [ %0, %1 ], [ %8, %6 ]
  %5 = icmp slt i32 %4, 2
  br i1 %5, label %10, label %6

6:                                                ; preds = %2
  %7 = zext nneg i32 %4 to i64
  %8 = add nsw i32 %4, -1
  %9 = mul nsw i64 %3, %7
  br label %2

10:                                               ; preds = %2
  %11 = mul nsw i64 %3, 1
  ret i64 %11
}

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #2 {
  br label %2

1:                                                ; preds = %11
  ret i32 0

2:                                                ; preds = %0, %11
  %3 = phi i64 [ 0, %0 ], [ %15, %11 ]
  %4 = icmp ult i64 %3, 2
  br i1 %4, label %11, label %5

5:                                                ; preds = %2, %5
  %6 = phi i64 [ %9, %5 ], [ 2, %2 ]
  %7 = phi i64 [ %8, %5 ], [ 1, %2 ]
  %8 = mul nsw i64 %7, %6
  %9 = add nuw nsw i64 %6, 1
  %10 = icmp eq i64 %6, %3
  br i1 %10, label %11, label %5, !llvm.loop !5

11:                                               ; preds = %5, %2
  %12 = phi i64 [ 1, %2 ], [ %8, %5 ]
  %13 = trunc i64 %3 to i32
  %14 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %13, i64 noundef %12)
  %15 = add nuw nsw i64 %3, 1
  %16 = icmp eq i64 %15, 11
  br i1 %16, label %1, label %2, !llvm.loop !8
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #3

attributes #0 = { nofree norecurse nosync nounwind memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6, !7}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!"llvm.loop.unroll.disable"}
!8 = distinct !{!8, !6, !7}
