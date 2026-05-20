; ModuleID = '/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/cpp/matmul.cpp'
source_filename = "/home/sai/llvm-clone-detector/llvm-clone-detector/testcases/cpp/matmul.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

module asm ".globl _ZSt21ios_base_library_initv"

%"struct.std::array" = type { [3 x %"struct.std::array.0"] }
%"struct.std::array.0" = type { [3 x i32] }
%"class.std::basic_ostream" = type { ptr, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", ptr, i8, i8, ptr, ptr, ptr, ptr }
%"class.std::ios_base" = type { ptr, i64, i64, i32, i32, i32, ptr, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, ptr, %"class.std::locale" }
%"struct.std::ios_base::_Words" = type { ptr, i64 }
%"class.std::locale" = type { ptr }

@__const.main.a = private unnamed_addr constant %"struct.std::array" { [3 x %"struct.std::array.0"] [%"struct.std::array.0" { [3 x i32] [i32 1, i32 2, i32 3] }, %"struct.std::array.0" { [3 x i32] [i32 4, i32 5, i32 6] }, %"struct.std::array.0" { [3 x i32] [i32 7, i32 8, i32 9] }] }, align 4
@__const.main.b = private unnamed_addr constant %"struct.std::array" { [3 x %"struct.std::array.0"] [%"struct.std::array.0" { [3 x i32] [i32 9, i32 8, i32 7] }, %"struct.std::array.0" { [3 x i32] [i32 6, i32 5, i32 4] }, %"struct.std::array.0" { [3 x i32] [i32 3, i32 2, i32 1] }] }, align 4
@_ZSt4cout = external global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z6matmulRKSt5arrayIS_IiLm3EELm3EES3_(ptr dead_on_unwind noalias nocapture writable writeonly sret(%"struct.std::array") align 4 %0, ptr nocapture noundef nonnull readonly align 4 dereferenceable(36) %1, ptr nocapture noundef nonnull readonly align 4 dereferenceable(36) %2) local_unnamed_addr #0 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %0, i8 0, i64 36, i1 false)
  br label %4

4:                                                ; preds = %3, %9
  %5 = phi i64 [ 0, %3 ], [ %10, %9 ]
  %6 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr %0, i64 0, i64 %5
  %7 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr %1, i64 0, i64 %5
  br label %12

8:                                                ; preds = %9
  ret void

9:                                                ; preds = %16
  %10 = add nuw nsw i64 %5, 1
  %11 = icmp eq i64 %10, 3
  br i1 %11, label %8, label %4, !llvm.loop !5

12:                                               ; preds = %4, %16
  %13 = phi i64 [ 0, %4 ], [ %17, %16 ]
  %14 = getelementptr inbounds [3 x i32], ptr %6, i64 0, i64 %13
  store i32 0, ptr %14, align 4, !tbaa !8
  %15 = getelementptr inbounds [3 x i32], ptr %2, i64 0, i64 %13
  br label %19

16:                                               ; preds = %19
  store i32 %27, ptr %14, align 4, !tbaa !8
  %17 = add nuw nsw i64 %13, 1
  %18 = icmp eq i64 %17, 3
  br i1 %18, label %9, label %12, !llvm.loop !12

19:                                               ; preds = %12, %19
  %20 = phi i64 [ 0, %12 ], [ %28, %19 ]
  %21 = phi i32 [ 0, %12 ], [ %27, %19 ]
  %22 = getelementptr inbounds [3 x i32], ptr %7, i64 0, i64 %20
  %23 = load i32, ptr %22, align 4, !tbaa !8
  %24 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr %15, i64 0, i64 %20
  %25 = load i32, ptr %24, align 4, !tbaa !8
  %26 = mul nsw i32 %25, %23
  %27 = add nsw i32 %21, %26
  %28 = add nuw nsw i64 %20, 1
  %29 = icmp eq i64 %28, 3
  br i1 %29, label %16, label %19, !llvm.loop !13
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() local_unnamed_addr #3 {
  %1 = alloca %"struct.std::array", align 4
  call void @llvm.lifetime.start.p0(i64 36, ptr nonnull %1) #6
  tail call void @llvm.experimental.noalias.scope.decl(metadata !14)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(36) %1, i8 0, i64 36, i1 false), !alias.scope !14
  br label %2

2:                                                ; preds = %6, %0
  %3 = phi i64 [ 0, %0 ], [ %7, %6 ]
  %4 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr %1, i64 0, i64 %3
  %5 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr @__const.main.a, i64 0, i64 %3
  br label %9

6:                                                ; preds = %13
  %7 = add nuw nsw i64 %3, 1
  %8 = icmp eq i64 %7, 3
  br i1 %8, label %28, label %2, !llvm.loop !5

9:                                                ; preds = %13, %2
  %10 = phi i64 [ 0, %2 ], [ %14, %13 ]
  %11 = getelementptr inbounds [3 x i32], ptr %4, i64 0, i64 %10
  store i32 0, ptr %11, align 4, !tbaa !8, !alias.scope !14
  %12 = getelementptr inbounds [3 x i32], ptr @__const.main.b, i64 0, i64 %10
  br label %16

13:                                               ; preds = %16
  store i32 %24, ptr %11, align 4, !tbaa !8, !alias.scope !14
  %14 = add nuw nsw i64 %10, 1
  %15 = icmp eq i64 %14, 3
  br i1 %15, label %6, label %9, !llvm.loop !12

16:                                               ; preds = %16, %9
  %17 = phi i64 [ 0, %9 ], [ %25, %16 ]
  %18 = phi i32 [ 0, %9 ], [ %24, %16 ]
  %19 = getelementptr inbounds [3 x i32], ptr %5, i64 0, i64 %17
  %20 = load i32, ptr %19, align 4, !tbaa !8, !noalias !14
  %21 = getelementptr inbounds [3 x %"struct.std::array.0"], ptr %12, i64 0, i64 %17
  %22 = load i32, ptr %21, align 4, !tbaa !8, !noalias !14
  %23 = mul nsw i32 %22, %20
  %24 = add nsw i32 %23, %18
  %25 = add nuw nsw i64 %17, 1
  %26 = icmp eq i64 %25, 3
  br i1 %26, label %13, label %16, !llvm.loop !13

27:                                               ; preds = %33
  call void @llvm.lifetime.end.p0(i64 36, ptr nonnull %1) #6
  ret i32 0

28:                                               ; preds = %6, %33
  %29 = phi i64 [ %30, %33 ], [ 0, %6 ]
  %30 = add nuw nsw i64 %29, 12
  %31 = getelementptr inbounds i8, ptr %1, i64 %30
  %32 = getelementptr inbounds i8, ptr %1, i64 %29
  br label %36

33:                                               ; preds = %36
  %34 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.1, i64 noundef 1)
  %35 = icmp eq i64 %30, 36
  br i1 %35, label %27, label %28, !llvm.loop !17

36:                                               ; preds = %28, %36
  %37 = phi ptr [ %41, %36 ], [ %32, %28 ]
  %38 = load i32, ptr %37, align 4, !tbaa !8
  %39 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef %38)
  %40 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %39, ptr noundef nonnull @.str, i64 noundef 1)
  %41 = getelementptr inbounds i32, ptr %37, i64 1
  %42 = icmp eq ptr %41, %31
  br i1 %42, label %33, label %36, !llvm.loop !18
}

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8), i32 noundef) local_unnamed_addr #4

declare noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef, i64 noundef) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #5

attributes #0 = { mustprogress nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { mustprogress norecurse uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
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
!11 = !{!"Simple C++ TBAA"}
!12 = distinct !{!12, !6, !7}
!13 = distinct !{!13, !6, !7}
!14 = !{!15}
!15 = distinct !{!15, !16, !"_Z6matmulRKSt5arrayIS_IiLm3EELm3EES3_: argument 0"}
!16 = distinct !{!16, !"_Z6matmulRKSt5arrayIS_IiLm3EELm3EES3_"}
!17 = distinct !{!17, !7}
!18 = distinct !{!18, !7}
