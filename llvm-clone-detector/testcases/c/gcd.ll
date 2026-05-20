; ModuleID = '/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/gcd.c'
source_filename = "/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/gcd.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.arr = private unnamed_addr constant [7 x i32] [i32 64, i32 34, i32 25, i32 12, i32 22, i32 11, i32 90], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @bubble_sort(ptr nocapture noundef %0, i32 noundef %1) local_unnamed_addr #0 {
  %3 = add i32 %1, -1
  %4 = icmp sgt i32 %1, 1
  br i1 %4, label %5, label %12

5:                                                ; preds = %2, %13
  %6 = phi i32 [ %15, %13 ], [ %3, %2 ]
  %7 = phi i32 [ %14, %13 ], [ 0, %2 ]
  %8 = sub nsw i32 %7, %1
  %9 = icmp slt i32 %8, -1
  br i1 %9, label %10, label %13

10:                                               ; preds = %5
  %11 = zext i32 %6 to i64
  br label %17

12:                                               ; preds = %13, %2
  ret void

13:                                               ; preds = %26, %5
  %14 = add nuw nsw i32 %7, 1
  %15 = add i32 %6, -1
  %16 = icmp eq i32 %14, %3
  br i1 %16, label %12, label %5, !llvm.loop !5

17:                                               ; preds = %10, %26
  %18 = phi i64 [ 0, %10 ], [ %21, %26 ]
  %19 = getelementptr inbounds i32, ptr %0, i64 %18
  %20 = load i32, ptr %19, align 4, !tbaa !8
  %21 = add nuw nsw i64 %18, 1
  %22 = getelementptr inbounds i32, ptr %0, i64 %21
  %23 = load i32, ptr %22, align 4, !tbaa !8
  %24 = icmp sgt i32 %20, %23
  br i1 %24, label %25, label %26

25:                                               ; preds = %17
  store i32 %23, ptr %19, align 4, !tbaa !8
  store i32 %20, ptr %22, align 4, !tbaa !8
  br label %26

26:                                               ; preds = %17, %25
  %27 = icmp eq i64 %21, %11
  br i1 %27, label %13, label %17, !llvm.loop !12
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #2 {
  %1 = alloca [7 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 28, ptr nonnull %1) #6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(28) %1, ptr noundef nonnull align 16 dereferenceable(28) @__const.main.arr, i64 28, i1 false)
  br label %2

2:                                                ; preds = %5, %0
  %3 = phi i64 [ %7, %5 ], [ 6, %0 ]
  %4 = phi i32 [ %6, %5 ], [ 0, %0 ]
  br label %9

5:                                                ; preds = %18
  %6 = add nuw nsw i32 %4, 1
  %7 = add nsw i64 %3, -1
  %8 = icmp eq i32 %6, 6
  br i1 %8, label %22, label %2, !llvm.loop !5

9:                                                ; preds = %18, %2
  %10 = phi i64 [ 0, %2 ], [ %13, %18 ]
  %11 = getelementptr inbounds i32, ptr %1, i64 %10
  %12 = load i32, ptr %11, align 4, !tbaa !8
  %13 = add nuw nsw i64 %10, 1
  %14 = getelementptr inbounds i32, ptr %1, i64 %13
  %15 = load i32, ptr %14, align 4, !tbaa !8
  %16 = icmp sgt i32 %12, %15
  br i1 %16, label %17, label %18

17:                                               ; preds = %9
  store i32 %15, ptr %11, align 4, !tbaa !8
  store i32 %12, ptr %14, align 4, !tbaa !8
  br label %18

18:                                               ; preds = %17, %9
  %19 = icmp eq i64 %13, %3
  br i1 %19, label %5, label %9, !llvm.loop !12

20:                                               ; preds = %22
  %21 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0(i64 28, ptr nonnull %1) #6
  ret i32 0

22:                                               ; preds = %5, %22
  %23 = phi i64 [ %27, %22 ], [ 0, %5 ]
  %24 = getelementptr inbounds [7 x i32], ptr %1, i64 0, i64 %23
  %25 = load i32, ptr %24, align 4, !tbaa !8
  %26 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %25)
  %27 = add nuw nsw i64 %23, 1
  %28 = icmp eq i64 %27, 7
  br i1 %28, label %20, label %22, !llvm.loop !13
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

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
!8 = !{!9, !9, i64 0}
!9 = !{!"int", !10, i64 0}
!10 = !{!"omnipotent char", !11, i64 0}
!11 = !{!"Simple C/C++ TBAA"}
!12 = distinct !{!12, !6, !7}
!13 = distinct !{!13, !6, !7}
