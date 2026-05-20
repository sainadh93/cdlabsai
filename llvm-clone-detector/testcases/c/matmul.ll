; ModuleID = '/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/matmul.c'
source_filename = "/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/c/matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [3 x [3 x i32]] [[3 x i32] [i32 1, i32 2, i32 3], [3 x i32] [i32 4, i32 5, i32 6], [3 x i32] [i32 7, i32 8, i32 9]], align 16
@__const.main.b = private unnamed_addr constant [3 x [3 x i32]] [[3 x i32] [i32 9, i32 8, i32 7], [3 x i32] [i32 6, i32 5, i32 4], [3 x i32] [i32 3, i32 2, i32 1]], align 16
@.str = private unnamed_addr constant [4 x i8] c"%4d\00", align 1

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @matmul(ptr nocapture noundef readonly %0, ptr nocapture noundef readonly %1, ptr nocapture noundef writeonly %2) local_unnamed_addr #0 {
  br label %4

4:                                                ; preds = %3, %7
  %5 = phi i64 [ 0, %3 ], [ %8, %7 ]
  br label %10

6:                                                ; preds = %7
  ret void

7:                                                ; preds = %13
  %8 = add nuw nsw i64 %5, 1
  %9 = icmp eq i64 %8, 3
  br i1 %9, label %6, label %4, !llvm.loop !5

10:                                               ; preds = %4, %13
  %11 = phi i64 [ 0, %4 ], [ %14, %13 ]
  %12 = getelementptr inbounds [3 x i32], ptr %2, i64 %5, i64 %11
  store i32 0, ptr %12, align 4, !tbaa !8
  br label %16

13:                                               ; preds = %16
  %14 = add nuw nsw i64 %11, 1
  %15 = icmp eq i64 %14, 3
  br i1 %15, label %7, label %10, !llvm.loop !12

16:                                               ; preds = %10, %16
  %17 = phi i64 [ 0, %10 ], [ %25, %16 ]
  %18 = phi i32 [ 0, %10 ], [ %24, %16 ]
  %19 = getelementptr inbounds [3 x i32], ptr %0, i64 %5, i64 %17
  %20 = load i32, ptr %19, align 4, !tbaa !8
  %21 = getelementptr inbounds [3 x i32], ptr %1, i64 %17, i64 %11
  %22 = load i32, ptr %21, align 4, !tbaa !8
  %23 = mul nsw i32 %22, %20
  %24 = add nsw i32 %18, %23
  store i32 %24, ptr %12, align 4, !tbaa !8
  %25 = add nuw nsw i64 %17, 1
  %26 = icmp eq i64 %25, 3
  br i1 %26, label %13, label %16, !llvm.loop !13
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #2 {
  %1 = alloca [3 x [3 x i32]], align 16
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %1) #6
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(36) %1, i8 0, i64 36, i1 false)
  br label %2

2:                                                ; preds = %4, %0
  %3 = phi i64 [ 0, %0 ], [ %5, %4 ]
  br label %7

4:                                                ; preds = %10
  %5 = add nuw nsw i64 %3, 1
  %6 = icmp eq i64 %5, 3
  br i1 %6, label %24, label %2, !llvm.loop !5

7:                                                ; preds = %10, %2
  %8 = phi i64 [ 0, %2 ], [ %11, %10 ]
  %9 = getelementptr inbounds [3 x i32], ptr %1, i64 %3, i64 %8
  store i32 0, ptr %9, align 4, !tbaa !8
  br label %13

10:                                               ; preds = %13
  store i32 %21, ptr %9, align 4, !tbaa !8
  %11 = add nuw nsw i64 %8, 1
  %12 = icmp eq i64 %11, 3
  br i1 %12, label %4, label %7, !llvm.loop !12

13:                                               ; preds = %13, %7
  %14 = phi i64 [ 0, %7 ], [ %22, %13 ]
  %15 = phi i32 [ 0, %7 ], [ %21, %13 ]
  %16 = getelementptr inbounds [3 x i32], ptr @__const.main.a, i64 %3, i64 %14
  %17 = load i32, ptr %16, align 4, !tbaa !8
  %18 = getelementptr inbounds [3 x i32], ptr @__const.main.b, i64 %14, i64 %8
  %19 = load i32, ptr %18, align 4, !tbaa !8
  %20 = mul nsw i32 %19, %17
  %21 = add nsw i32 %20, %15
  %22 = add nuw nsw i64 %14, 1
  %23 = icmp eq i64 %22, 3
  br i1 %23, label %10, label %13, !llvm.loop !13

24:                                               ; preds = %4, %27
  %25 = phi i64 [ %29, %27 ], [ 0, %4 ]
  br label %31

26:                                               ; preds = %27
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %1) #6
  ret i32 0

27:                                               ; preds = %31
  %28 = tail call i32 @putchar(i32 10)
  %29 = add nuw nsw i64 %25, 1
  %30 = icmp eq i64 %29, 3
  br i1 %30, label %26, label %24, !llvm.loop !14

31:                                               ; preds = %24, %31
  %32 = phi i64 [ 0, %24 ], [ %36, %31 ]
  %33 = getelementptr inbounds [3 x [3 x i32]], ptr %1, i64 0, i64 %25, i64 %32
  %34 = load i32, ptr %33, align 4, !tbaa !8
  %35 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i32 noundef %34)
  %36 = add nuw nsw i64 %32, 1
  %37 = icmp eq i64 %36, 3
  br i1 %37, label %27, label %31, !llvm.loop !15
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nofree nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
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
!14 = distinct !{!14, !6, !7}
!15 = distinct !{!15, !6, !7}
