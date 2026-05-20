; ModuleID = 'bubble_sort.af16a788e4992075-cgu.0'
source_filename = "bubble_sort.af16a788e4992075-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h218d10f1a907cb44E", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6c0c501f0f1d790dE", ptr @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6c0c501f0f1d790dE" }>, align 8
@__rust_no_alloc_shim_is_unstable = external global i8
@alloc_49a1e817e911805af64bbc7efb390101 = private unnamed_addr constant <{ [1 x i8] }> <{ [1 x i8] c"\0A" }>, align 1
@alloc_d1a7a28b1b2f6258cb14ac97db016f09 = private unnamed_addr constant <{ ptr, [8 x i8] }> <{ ptr @alloc_49a1e817e911805af64bbc7efb390101, [8 x i8] c"\01\00\00\00\00\00\00\00" }>, align 8
@alloc_0242e8ee118de705af76c627590b82cc = private unnamed_addr constant <{ [1 x i8] }> <{ [1 x i8] c" " }>, align 1
@alloc_a0434d70b15bcc9ff1a7b717be16ed72 = private unnamed_addr constant <{ ptr, [8 x i8], ptr, [8 x i8] }> <{ ptr inttoptr (i64 1 to ptr), [8 x i8] zeroinitializer, ptr @alloc_0242e8ee118de705af76c627590b82cc, [8 x i8] c"\01\00\00\00\00\00\00\00" }>, align 8

; std::rt::lang_start
; Function Attrs: nonlazybind uwtable
define hidden noundef i64 @_ZN3std2rt10lang_start17h5dead333d3a647fdE(ptr noundef nonnull %main, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe) unnamed_addr #0 {
start:
  %_8 = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %_8)
  store ptr %main, ptr %_8, align 8
; call std::rt::lang_start_internal
  %0 = call noundef i64 @_ZN3std2rt19lang_start_internal17hbb268f70c879621dE(ptr noundef nonnull align 1 %_8, ptr noalias noundef nonnull readonly align 8 dereferenceable(48) @vtable.0, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %_8)
  ret i64 %0
}

; std::rt::lang_start::{{closure}}
; Function Attrs: inlinehint nonlazybind uwtable
define internal noundef i32 @"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6c0c501f0f1d790dE"(ptr noalias nocapture noundef readonly align 8 dereferenceable(8) %_1) unnamed_addr #1 {
start:
  %_4 = load ptr, ptr %_1, align 8, !nonnull !4, !noundef !4
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h88b06b790d59ddedE(ptr noundef nonnull %_4)
  ret i32 0
}

; std::sys::backtrace::__rust_begin_short_backtrace
; Function Attrs: noinline nonlazybind uwtable
define internal fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h88b06b790d59ddedE(ptr nocapture noundef nonnull readonly %f) unnamed_addr #2 {
start:
  tail call void %f()
  tail call void asm sideeffect "", "~{memory}"() #9, !srcloc !5
  ret void
}

; <&T as core::fmt::Display>::fmt
; Function Attrs: nonlazybind uwtable
define internal noundef zeroext i1 @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE"(ptr noalias nocapture noundef readonly align 8 dereferenceable(8) %self, ptr noalias noundef align 8 dereferenceable(64) %f) unnamed_addr #0 {
start:
  %_3 = load ptr, ptr %self, align 8, !nonnull !4, !align !6, !noundef !4
; call core::fmt::num::imp::<impl core::fmt::Display for i32>::fmt
  %_0 = tail call noundef zeroext i1 @"_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17h53356be712a6b291E"(ptr noalias noundef nonnull readonly align 4 dereferenceable(4) %_3, ptr noalias noundef nonnull align 8 dereferenceable(64) %f)
  ret i1 %_0
}

; core::ops::function::FnOnce::call_once{{vtable.shim}}
; Function Attrs: inlinehint nonlazybind uwtable
define internal noundef i32 @"_ZN4core3ops8function6FnOnce40call_once$u7b$$u7b$vtable.shim$u7d$$u7d$17h218d10f1a907cb44E"(ptr nocapture noundef readonly %_1) unnamed_addr #1 personality ptr @rust_eh_personality {
start:
  %0 = load ptr, ptr %_1, align 8, !nonnull !4, !noundef !4
; call std::sys::backtrace::__rust_begin_short_backtrace
  tail call fastcc void @_ZN3std3sys9backtrace28__rust_begin_short_backtrace17h88b06b790d59ddedE(ptr noundef nonnull readonly %0), !noalias !7
  ret i32 0
}

; bubble_sort::main
; Function Attrs: nonlazybind uwtable
define internal void @_ZN11bubble_sort4main17h75dea304ea2888beE() unnamed_addr #0 personality ptr @rust_eh_personality {
start:
  %_21 = alloca [48 x i8], align 8
  %_17 = alloca [16 x i8], align 8
  %_15 = alloca [48 x i8], align 8
  %x = alloca [8 x i8], align 8
  %arr = alloca [24 x i8], align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %arr)
  %0 = load volatile i8, ptr @__rust_no_alloc_shim_is_unstable, align 1
  %_0.i.i.i = tail call noalias noundef align 4 dereferenceable_or_null(28) ptr @__rust_alloc(i64 noundef 28, i64 noundef 4) #9
  %1 = icmp eq ptr %_0.i.i.i, null
  br i1 %1, label %bb2.i, label %_ZN5alloc5alloc15exchange_malloc17h08b988c9fc7ce06fE.exit

bb2.i:                                            ; preds = %start
; call alloc::alloc::handle_alloc_error
  tail call void @_ZN5alloc5alloc18handle_alloc_error17h70c6ae3a3d9755c5E(i64 noundef 4, i64 noundef 28) #10
  unreachable

_ZN5alloc5alloc15exchange_malloc17h08b988c9fc7ce06fE.exit: ; preds = %start
  store i32 64, ptr %_0.i.i.i, align 4
  %2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  store i32 34, ptr %2, align 4
  %3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  store i32 25, ptr %3, align 4
  %4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  store i32 12, ptr %4, align 4
  %5 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  store i32 22, ptr %5, align 4
  %6 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 20
  store i32 11, ptr %6, align 4
  %7 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 24
  store i32 90, ptr %7, align 4
  store i64 7, ptr %arr, align 8, !alias.scope !10, !noalias !15
  %8 = getelementptr inbounds i8, ptr %arr, i64 8
  store ptr %_0.i.i.i, ptr %8, align 8, !alias.scope !10, !noalias !15
  %9 = getelementptr inbounds i8, ptr %arr, i64 16
  store i64 7, ptr %9, align 8, !alias.scope !10, !noalias !15
  %_22.i = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i = load i32, ptr %_0.i.i16.i, align 4, !noalias !18, !noundef !4
  %_21.i = icmp sgt i32 %_22.i, %_25.i
  br i1 %_21.i, label %bb15.i, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1"

bb15.i.122:                                       ; preds = %bb18.i.5
  store i32 %_25.i.119, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.116, ptr %_0.i.i16.i.118, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.1"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.1": ; preds = %bb15.i.122, %bb18.i.5
  %_0.i.i.i2.1.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_22.i.1.1 = load i32, ptr %_0.i.i.i2.1.1, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.1.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_25.i.1.1 = load i32, ptr %_0.i.i16.i.1.1, align 4, !noalias !18, !noundef !4
  %_21.i.1.1 = icmp sgt i32 %_22.i.1.1, %_25.i.1.1
  br i1 %_21.i.1.1, label %bb15.i.1.1, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.1"

bb15.i.1.1:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.1"
  store i32 %_25.i.1.1, ptr %_0.i.i.i2.1.1, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.1.1, ptr %_0.i.i16.i.1.1, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.1"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.1": ; preds = %bb15.i.1.1, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.1"
  %_0.i.i.i2.2.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_22.i.2.1 = load i32, ptr %_0.i.i.i2.2.1, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.2.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_25.i.2.1 = load i32, ptr %_0.i.i16.i.2.1, align 4, !noalias !18, !noundef !4
  %_21.i.2.1 = icmp sgt i32 %_22.i.2.1, %_25.i.2.1
  br i1 %_21.i.2.1, label %bb15.i.2.1, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.1"

bb15.i.2.1:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.1"
  store i32 %_25.i.2.1, ptr %_0.i.i.i2.2.1, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.2.1, ptr %_0.i.i16.i.2.1, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.1"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.1": ; preds = %bb15.i.2.1, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.1"
  %_0.i.i.i2.3.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_22.i.3.1 = load i32, ptr %_0.i.i.i2.3.1, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.3.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  %_25.i.3.1 = load i32, ptr %_0.i.i16.i.3.1, align 4, !noalias !18, !noundef !4
  %_21.i.3.1 = icmp sgt i32 %_22.i.3.1, %_25.i.3.1
  br i1 %_21.i.3.1, label %bb15.i.3.1, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4.1"

bb15.i.3.1:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.1"
  store i32 %_25.i.3.1, ptr %_0.i.i.i2.3.1, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.3.1, ptr %_0.i.i16.i.3.1, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4.1"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4.1": ; preds = %bb15.i.3.1, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.1"
  %_0.i.i.i2.4.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  %_22.i.4.1 = load i32, ptr %_0.i.i.i2.4.1, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.4.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 20
  %_25.i.4.1 = load i32, ptr %_0.i.i16.i.4.1, align 4, !noalias !18, !noundef !4
  %_21.i.4.1 = icmp sgt i32 %_22.i.4.1, %_25.i.4.1
  br i1 %_21.i.4.1, label %bb15.i.4.1, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.229"

bb15.i.4.1:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4.1"
  store i32 %_25.i.4.1, ptr %_0.i.i.i2.4.1, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.4.1, ptr %_0.i.i16.i.4.1, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.229"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.229": ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4.1", %bb15.i.4.1
  %_22.i.228 = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.230 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i.231 = load i32, ptr %_0.i.i16.i.230, align 4, !noalias !18, !noundef !4
  %_21.i.232 = icmp sgt i32 %_22.i.228, %_25.i.231
  br i1 %_21.i.232, label %bb15.i.234, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.2"

bb15.i.234:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.229"
  store i32 %_25.i.231, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.228, ptr %_0.i.i16.i.230, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.2"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.2": ; preds = %bb15.i.234, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.229"
  %_0.i.i.i2.1.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_22.i.1.2 = load i32, ptr %_0.i.i.i2.1.2, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.1.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_25.i.1.2 = load i32, ptr %_0.i.i16.i.1.2, align 4, !noalias !18, !noundef !4
  %_21.i.1.2 = icmp sgt i32 %_22.i.1.2, %_25.i.1.2
  br i1 %_21.i.1.2, label %bb15.i.1.2, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.2"

bb15.i.1.2:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.2"
  store i32 %_25.i.1.2, ptr %_0.i.i.i2.1.2, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.1.2, ptr %_0.i.i16.i.1.2, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.2"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.2": ; preds = %bb15.i.1.2, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.2"
  %_0.i.i.i2.2.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_22.i.2.2 = load i32, ptr %_0.i.i.i2.2.2, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.2.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_25.i.2.2 = load i32, ptr %_0.i.i16.i.2.2, align 4, !noalias !18, !noundef !4
  %_21.i.2.2 = icmp sgt i32 %_22.i.2.2, %_25.i.2.2
  br i1 %_21.i.2.2, label %bb15.i.2.2, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.2"

bb15.i.2.2:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.2"
  store i32 %_25.i.2.2, ptr %_0.i.i.i2.2.2, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.2.2, ptr %_0.i.i16.i.2.2, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.2"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.2": ; preds = %bb15.i.2.2, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.2"
  %_0.i.i.i2.3.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_22.i.3.2 = load i32, ptr %_0.i.i.i2.3.2, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.3.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  %_25.i.3.2 = load i32, ptr %_0.i.i16.i.3.2, align 4, !noalias !18, !noundef !4
  %_21.i.3.2 = icmp sgt i32 %_22.i.3.2, %_25.i.3.2
  br i1 %_21.i.3.2, label %bb15.i.3.2, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.341"

bb15.i.3.2:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.2"
  store i32 %_25.i.3.2, ptr %_0.i.i.i2.3.2, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.3.2, ptr %_0.i.i16.i.3.2, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.341"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.341": ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3.2", %bb15.i.3.2
  %_22.i.340 = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.342 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i.343 = load i32, ptr %_0.i.i16.i.342, align 4, !noalias !18, !noundef !4
  %_21.i.344 = icmp sgt i32 %_22.i.340, %_25.i.343
  br i1 %_21.i.344, label %bb15.i.346, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.3"

bb15.i.346:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.341"
  store i32 %_25.i.343, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.340, ptr %_0.i.i16.i.342, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.3"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.3": ; preds = %bb15.i.346, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.341"
  %_0.i.i.i2.1.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_22.i.1.3 = load i32, ptr %_0.i.i.i2.1.3, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.1.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_25.i.1.3 = load i32, ptr %_0.i.i16.i.1.3, align 4, !noalias !18, !noundef !4
  %_21.i.1.3 = icmp sgt i32 %_22.i.1.3, %_25.i.1.3
  br i1 %_21.i.1.3, label %bb15.i.1.3, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.3"

bb15.i.1.3:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.3"
  store i32 %_25.i.1.3, ptr %_0.i.i.i2.1.3, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.1.3, ptr %_0.i.i16.i.1.3, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.3"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.3": ; preds = %bb15.i.1.3, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.3"
  %_0.i.i.i2.2.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_22.i.2.3 = load i32, ptr %_0.i.i.i2.2.3, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.2.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_25.i.2.3 = load i32, ptr %_0.i.i16.i.2.3, align 4, !noalias !18, !noundef !4
  %_21.i.2.3 = icmp sgt i32 %_22.i.2.3, %_25.i.2.3
  br i1 %_21.i.2.3, label %bb15.i.2.3, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.453"

bb15.i.2.3:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.3"
  store i32 %_25.i.2.3, ptr %_0.i.i.i2.2.3, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.2.3, ptr %_0.i.i16.i.2.3, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.453"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.453": ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2.3", %bb15.i.2.3
  %_22.i.452 = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.454 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i.455 = load i32, ptr %_0.i.i16.i.454, align 4, !noalias !18, !noundef !4
  %_21.i.456 = icmp sgt i32 %_22.i.452, %_25.i.455
  br i1 %_21.i.456, label %bb15.i.458, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.4"

bb15.i.458:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.453"
  store i32 %_25.i.455, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.452, ptr %_0.i.i16.i.454, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.4"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.4": ; preds = %bb15.i.458, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.453"
  %_0.i.i.i2.1.4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_22.i.1.4 = load i32, ptr %_0.i.i.i2.1.4, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.1.4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_25.i.1.4 = load i32, ptr %_0.i.i16.i.1.4, align 4, !noalias !18, !noundef !4
  %_21.i.1.4 = icmp sgt i32 %_22.i.1.4, %_25.i.1.4
  br i1 %_21.i.1.4, label %bb15.i.1.4, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.563"

bb15.i.1.4:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.4"
  store i32 %_25.i.1.4, ptr %_0.i.i.i2.1.4, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.1.4, ptr %_0.i.i16.i.1.4, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.563"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.563": ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.4", %bb15.i.1.4
  %_22.i.562 = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.564 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i.565 = load i32, ptr %_0.i.i16.i.564, align 4, !noalias !18, !noundef !4
  %_21.i.566 = icmp sgt i32 %_22.i.562, %_25.i.565
  br i1 %_21.i.566, label %bb15.i.568, label %bb3.loopexit.i.5

bb15.i.568:                                       ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.563"
  store i32 %_25.i.565, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.562, ptr %_0.i.i16.i.564, align 4, !alias.scope !21, !noalias !18
  br label %bb3.loopexit.i.5

bb3.loopexit.i.5:                                 ; preds = %bb15.i.568, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.563"
  %_18.sroa.4.0._17.sroa_idx = getelementptr inbounds i8, ptr %_17, i64 8
  %10 = getelementptr inbounds i8, ptr %_15, i64 8
  %11 = getelementptr inbounds i8, ptr %_15, i64 32
  %12 = getelementptr inbounds i8, ptr %_15, i64 16
  %13 = getelementptr inbounds i8, ptr %_15, i64 24
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %_0.i.i.i, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12 unwind label %cleanup.loopexit

bb15.i:                                           ; preds = %_ZN5alloc5alloc15exchange_malloc17h08b988c9fc7ce06fE.exit
  store i32 %_25.i, ptr %_0.i.i.i, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i, ptr %_0.i.i16.i, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1": ; preds = %bb15.i, %_ZN5alloc5alloc15exchange_malloc17h08b988c9fc7ce06fE.exit
  %_0.i.i.i2.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_22.i.1 = load i32, ptr %_0.i.i.i2.1, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_25.i.1 = load i32, ptr %_0.i.i16.i.1, align 4, !noalias !18, !noundef !4
  %_21.i.1 = icmp sgt i32 %_22.i.1, %_25.i.1
  br i1 %_21.i.1, label %bb15.i.1, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2"

bb15.i.1:                                         ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1"
  store i32 %_25.i.1, ptr %_0.i.i.i2.1, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.1, ptr %_0.i.i16.i.1, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2": ; preds = %bb15.i.1, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1"
  %_0.i.i.i2.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  %_22.i.2 = load i32, ptr %_0.i.i.i2.2, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_25.i.2 = load i32, ptr %_0.i.i16.i.2, align 4, !noalias !18, !noundef !4
  %_21.i.2 = icmp sgt i32 %_22.i.2, %_25.i.2
  br i1 %_21.i.2, label %bb15.i.2, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3"

bb15.i.2:                                         ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2"
  store i32 %_25.i.2, ptr %_0.i.i.i2.2, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.2, ptr %_0.i.i16.i.2, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3": ; preds = %bb15.i.2, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.2"
  %_0.i.i.i2.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  %_22.i.3 = load i32, ptr %_0.i.i.i2.3, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  %_25.i.3 = load i32, ptr %_0.i.i16.i.3, align 4, !noalias !18, !noundef !4
  %_21.i.3 = icmp sgt i32 %_22.i.3, %_25.i.3
  br i1 %_21.i.3, label %bb15.i.3, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4"

bb15.i.3:                                         ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3"
  store i32 %_25.i.3, ptr %_0.i.i.i2.3, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.3, ptr %_0.i.i16.i.3, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4": ; preds = %bb15.i.3, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.3"
  %_0.i.i.i2.4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  %_22.i.4 = load i32, ptr %_0.i.i.i2.4, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 20
  %_25.i.4 = load i32, ptr %_0.i.i16.i.4, align 4, !noalias !18, !noundef !4
  %_21.i.4 = icmp sgt i32 %_22.i.4, %_25.i.4
  br i1 %_21.i.4, label %bb15.i.4, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.5"

bb15.i.4:                                         ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4"
  store i32 %_25.i.4, ptr %_0.i.i.i2.4, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.4, ptr %_0.i.i16.i.4, align 4, !alias.scope !21, !noalias !18
  br label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.5"

"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.5": ; preds = %bb15.i.4, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.4"
  %_0.i.i.i2.5 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 20
  %_22.i.5 = load i32, ptr %_0.i.i.i2.5, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.5 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 24
  %_25.i.5 = load i32, ptr %_0.i.i16.i.5, align 4, !noalias !18, !noundef !4
  %_21.i.5 = icmp sgt i32 %_22.i.5, %_25.i.5
  br i1 %_21.i.5, label %bb15.i.5, label %bb18.i.5

bb15.i.5:                                         ; preds = %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.5"
  store i32 %_25.i.5, ptr %_0.i.i.i2.5, align 4, !alias.scope !21, !noalias !18
  store i32 %_22.i.5, ptr %_0.i.i16.i.5, align 4, !alias.scope !21, !noalias !18
  br label %bb18.i.5

bb18.i.5:                                         ; preds = %bb15.i.5, %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.5"
  %_22.i.116 = load i32, ptr %_0.i.i.i, align 4, !noalias !18, !noundef !4
  %_0.i.i16.i.118 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  %_25.i.119 = load i32, ptr %_0.i.i16.i.118, align 4, !noalias !18, !noundef !4
  %_21.i.120 = icmp sgt i32 %_22.i.116, %_25.i.119
  br i1 %_21.i.120, label %bb15.i.122, label %"_ZN81_$LT$alloc..vec..Vec$LT$T$C$A$GT$$u20$as$u20$core..ops..index..Index$LT$I$GT$$GT$5index17h9f158b47fbecfd17E.exit.i.1.1"

cleanup.loopexit:                                 ; preds = %bb12.5, %bb12.4, %bb12.3, %bb12.2, %bb12.1, %bb12, %bb3.loopexit.i.5
  %lpad.loopexit = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup.loopexit.split-lp:                        ; preds = %bb12.6
  %lpad.loopexit.split-lp = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup:                                          ; preds = %cleanup.loopexit.split-lp, %cleanup.loopexit
  %lpad.phi = phi { ptr, i32 } [ %lpad.loopexit, %cleanup.loopexit ], [ %lpad.loopexit.split-lp, %cleanup.loopexit.split-lp ]
; invoke alloc::raw_vec::RawVecInner<A>::deallocate
  invoke void @"_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$10deallocate17he8c77187e5bd8a64E"(ptr noalias noundef nonnull align 8 dereferenceable(16) %arr, i64 noundef 4, i64 noundef 4)
          to label %bb17 unwind label %terminate

bb14:                                             ; preds = %bb12.6
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_21)
; call alloc::raw_vec::RawVecInner<A>::deallocate
  call void @"_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$10deallocate17he8c77187e5bd8a64E"(ptr noalias noundef nonnull align 8 dereferenceable(16) %arr, i64 noundef 4, i64 noundef 4)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %arr)
  ret void

bb12:                                             ; preds = %bb3.loopexit.i.5
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.1 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 4
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.1, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.1 unwind label %cleanup.loopexit

bb12.1:                                           ; preds = %bb12
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.2 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.2, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.2 unwind label %cleanup.loopexit

bb12.2:                                           ; preds = %bb12.1
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.3 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 12
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.3, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.3 unwind label %cleanup.loopexit

bb12.3:                                           ; preds = %bb12.2
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.4 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 16
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.4, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.4 unwind label %cleanup.loopexit

bb12.4:                                           ; preds = %bb12.3
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.5 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 20
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.5, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.5 unwind label %cleanup.loopexit

bb12.5:                                           ; preds = %bb12.4
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  %iter.sroa.0.0.ptr.6 = getelementptr inbounds i8, ptr %_0.i.i.i, i64 24
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %x)
  store ptr %iter.sroa.0.0.ptr.6, ptr %x, align 8
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %_17)
  store ptr %x, ptr %_17, align 8
  store ptr @"_ZN44_$LT$$RF$T$u20$as$u20$core..fmt..Display$GT$3fmt17h31ec6178f8785b3dE", ptr %_18.sroa.4.0._17.sroa_idx, align 8
  store ptr @alloc_a0434d70b15bcc9ff1a7b717be16ed72, ptr %_15, align 8, !alias.scope !24, !noalias !27
  store i64 2, ptr %10, align 8, !alias.scope !24, !noalias !27
  store ptr null, ptr %11, align 8, !alias.scope !24, !noalias !27
  store ptr %_17, ptr %12, align 8, !alias.scope !24, !noalias !27
  store i64 1, ptr %13, align 8, !alias.scope !24, !noalias !27
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_15)
          to label %bb12.6 unwind label %cleanup.loopexit

bb12.6:                                           ; preds = %bb12.5
  call void @llvm.lifetime.end.p0(i64 48, ptr nonnull %_15)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %_17)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %x)
  call void @llvm.lifetime.start.p0(i64 48, ptr nonnull %_21)
  store ptr @alloc_d1a7a28b1b2f6258cb14ac97db016f09, ptr %_21, align 8, !alias.scope !29
  %14 = getelementptr inbounds i8, ptr %_21, i64 8
  store i64 1, ptr %14, align 8, !alias.scope !29
  %15 = getelementptr inbounds i8, ptr %_21, i64 32
  store ptr null, ptr %15, align 8, !alias.scope !29
  %16 = getelementptr inbounds i8, ptr %_21, i64 16
  store ptr inttoptr (i64 8 to ptr), ptr %16, align 8, !alias.scope !29
  %17 = getelementptr inbounds i8, ptr %_21, i64 24
  store i64 0, ptr %17, align 8, !alias.scope !29
; invoke std::io::stdio::_print
  invoke void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef nonnull align 8 dereferenceable(48) %_21)
          to label %bb14 unwind label %cleanup.loopexit.split-lp

terminate:                                        ; preds = %cleanup
  %18 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_ZN4core9panicking16panic_in_cleanup17hd5047d4811141a2eE() #11
  unreachable

bb17:                                             ; preds = %cleanup
  resume { ptr, i32 } %lpad.phi
}

; std::rt::lang_start_internal
; Function Attrs: nonlazybind uwtable
declare noundef i64 @_ZN3std2rt19lang_start_internal17hbb268f70c879621dE(ptr noundef nonnull align 1, ptr noalias noundef readonly align 8 dereferenceable(48), i64 noundef, ptr noundef, i8 noundef) unnamed_addr #0

; core::fmt::num::imp::<impl core::fmt::Display for i32>::fmt
; Function Attrs: nonlazybind uwtable
declare noundef zeroext i1 @"_ZN4core3fmt3num3imp52_$LT$impl$u20$core..fmt..Display$u20$for$u20$i32$GT$3fmt17h53356be712a6b291E"(ptr noalias noundef readonly align 4 dereferenceable(4), ptr noalias noundef align 8 dereferenceable(64)) unnamed_addr #0

; Function Attrs: nounwind nonlazybind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef range(i32 1, 17), i64 noundef, ptr noundef, ptr noundef) unnamed_addr #3

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind nonlazybind optsize uwtable
declare void @_ZN4core9panicking16panic_in_cleanup17hd5047d4811141a2eE() unnamed_addr #4

; alloc::alloc::handle_alloc_error
; Function Attrs: cold minsize noreturn nonlazybind optsize uwtable
declare void @_ZN5alloc5alloc18handle_alloc_error17h70c6ae3a3d9755c5E(i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #5

; Function Attrs: nounwind nonlazybind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @__rust_alloc(i64 noundef, i64 allocalign noundef) unnamed_addr #6

; alloc::raw_vec::RawVecInner<A>::deallocate
; Function Attrs: nonlazybind uwtable
declare void @"_ZN5alloc7raw_vec20RawVecInner$LT$A$GT$10deallocate17he8c77187e5bd8a64E"(ptr noalias noundef align 8 dereferenceable(16), i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #0

; std::io::stdio::_print
; Function Attrs: nonlazybind uwtable
declare void @_ZN3std2io5stdio6_print17h2bb3f89bb77308e4E(ptr noalias nocapture noundef align 8 dereferenceable(48)) unnamed_addr #0

; Function Attrs: nonlazybind
define noundef i32 @main(i32 %0, ptr %1) unnamed_addr #7 {
top:
  %_8.i = alloca [8 x i8], align 8
  %2 = sext i32 %0 to i64
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %_8.i)
  store ptr @_ZN11bubble_sort4main17h75dea304ea2888beE, ptr %_8.i, align 8
; call std::rt::lang_start_internal
  %3 = call noundef i64 @_ZN3std2rt19lang_start_internal17hbb268f70c879621dE(ptr noundef nonnull align 1 %_8.i, ptr noalias noundef nonnull readonly align 8 dereferenceable(48) @vtable.0, i64 noundef %2, ptr noundef %1, i8 noundef 0)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %_8.i)
  %4 = trunc i64 %3 to i32
  ret i32 %4
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #8

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #8

attributes #0 = { nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { inlinehint nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { noinline nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #3 = { nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #4 = { cold minsize noinline noreturn nounwind nonlazybind optsize uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #5 = { cold minsize noreturn nonlazybind optsize uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #6 = { nounwind nonlazybind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #7 = { nonlazybind "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #8 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { nounwind }
attributes #10 = { noreturn }
attributes #11 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"PIE Level", i32 2}
!2 = !{i32 2, !"RtLibUseGOT", i32 1}
!3 = !{!"rustc version 1.85.0 (4d91de4e4 2025-02-17)"}
!4 = !{}
!5 = !{i64 15556981435090139}
!6 = !{i64 4}
!7 = !{!8}
!8 = distinct !{!8, !9, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6c0c501f0f1d790dE: %_1"}
!9 = distinct !{!9, !"_ZN3std2rt10lang_start28_$u7b$$u7b$closure$u7d$$u7d$17h6c0c501f0f1d790dE"}
!10 = !{!11, !13}
!11 = distinct !{!11, !12, !"_ZN5alloc5slice4hack8into_vec17h6f285887e1cae3e3E: %_0"}
!12 = distinct !{!12, !"_ZN5alloc5slice4hack8into_vec17h6f285887e1cae3e3E"}
!13 = distinct !{!13, !14, !"_ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$8into_vec17hf46be5c2269af103E: %_0"}
!14 = distinct !{!14, !"_ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$8into_vec17hf46be5c2269af103E"}
!15 = !{!16, !17}
!16 = distinct !{!16, !12, !"_ZN5alloc5slice4hack8into_vec17h6f285887e1cae3e3E: %b.0"}
!17 = distinct !{!17, !14, !"_ZN5alloc5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$8into_vec17hf46be5c2269af103E: %self.0"}
!18 = !{!19}
!19 = distinct !{!19, !20, !"_ZN11bubble_sort11bubble_sort17h577a143471766006E: %arr"}
!20 = distinct !{!20, !"_ZN11bubble_sort11bubble_sort17h577a143471766006E"}
!21 = !{!22}
!22 = distinct !{!22, !23, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17h2110496e0b9bd947E: %self.0"}
!23 = distinct !{!23, !"_ZN4core5slice29_$LT$impl$u20$$u5b$T$u5d$$GT$4swap17h2110496e0b9bd947E"}
!24 = !{!25}
!25 = distinct !{!25, !26, !"_ZN4core3fmt9Arguments6new_v117h2de2efd54bdb5bf9E: %_0"}
!26 = distinct !{!26, !"_ZN4core3fmt9Arguments6new_v117h2de2efd54bdb5bf9E"}
!27 = !{!28}
!28 = distinct !{!28, !26, !"_ZN4core3fmt9Arguments6new_v117h2de2efd54bdb5bf9E: %args"}
!29 = !{!30}
!30 = distinct !{!30, !31, !"_ZN4core3fmt9Arguments9new_const17h4887d677b69a67d1E: %_0"}
!31 = distinct !{!31, !"_ZN4core3fmt9Arguments9new_const17h4887d677b69a67d1E"}
