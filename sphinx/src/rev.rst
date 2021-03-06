svn http://dart.googlecode.com/svn/branches/bleeding_edge/
svn http://dart.googlecode.com/svn/trunk

--- template
rev

リビジョンログを読んで興味深かったもの抜粋
2013/08

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
------------------------------------------------------------------------
r25944 | rmacnak@google.com | 2013-08-09 05:25:46 +0900 (金, 09  8月 2013) | 5 lines
Make ClosureMirror handle instances of user-defined classes that implement call.
R=asiva@google.com
Review URL: https://codereview.chromium.org//22625003


r25942 | rmacnak@google.com | 2013-08-09 05:06:56 +0900 (金, 09  8月 2013) | 6 lines
Reflection on generics.
R=ahe@google.com, regis@google.com
Review URL: https://codereview.chromium.org//22292002



r25938 | srdjan@google.com | 2013-08-09 03:31:53 +0900 (金, 09  8月 2013) | 5 lines
Fix Issue 12322: the analysis requires stored guarded_cid to be returned when requested;
only when computing result of LoadField instruction should we not trust guarded_cid
for externalizable cids.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//22335005


r25930 | rmacnak@google.com | 2013-08-09 01:50:11 +0900 (金, 09  8月 2013) | 6 lines
Fix attempt to find metadata of a library with no metadata.
BUG=12206
R=hausner@google.com
Review URL: https://codereview.chromium.org//22460008


r25929 | cbracken@google.com | 2013-08-09 01:40:45 +0900 (金, 09  8月 2013) | 5 lines
Cleanup: Use array syntax instead of pointer arithmetic
R=asiva@google.com
Review URL: https://codereview.chromium.org//22381002


r25928 | srdjan@google.com | 2013-08-09 01:19:23 +0900 (金, 09  8月 2013) | 5 lines
Add a performance assert that we do not emit a null check for smi class-ids.
Instead we should use CheckSmiInstr which does a bit test.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//22629005


r25927 | johnmccutchan@google.com | 2013-08-09 00:44:21 +0900 (金, 09  8月 2013) | 6 lines
Remove race(s) in vmservice tests.
BUG=https://code.google.com/p/dart/issues/detail?id=12294
R=iposva@google.com
Review URL: https://codereview.chromium.org//22607005


r25922 | hausner@google.com | 2013-08-08 20:22:59 +0900 (木, 08  8月 2013) | 5 lines
Follow-up to capturing instantiator
Add boolean result to CaptureVariable, as suggested by Regis.
Review URL: https://codereview.chromium.org//22678002


r25918 | fschneider@google.com | 2013-08-08 17:20:10 +0900 (木, 08  8月 2013) | 17 lines
Fix bug with optimized try-catch on ARM/MIPS.
The constant pool pointer must be restored before any parallel moves at the catch-entry block.
In addition, this CL removes CatchEntryInstr and folds its functionality into CatchBlockEntryInstr.
Until now every catch-block started with CatchBlockEntryInstr followed by a CatchEntryInstr.
This simplifies a lot of code in the compiler and avoids issues
with allocator-move code inserted between the two instructions.

BUG=https://code.google.com/p/dart/issues/detail?id=12291
TEST=tests/language/try_catch4_test.dart
R=regis@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//22590002


r25909 | iposva@google.com | 2013-08-08 10:02:13 +0900 (木, 08  8月 2013) | 3 lines
- Remove unused run state from the isolate.
Review URL: https://codereview.chromium.org//22477005
class IsolateRunStateManagerを削除


r25907 | srdjan@google.com | 2013-08-08 08:01:43 +0900 (木, 08  8月 2013) | 5 lines
Implement IsNullCheck for CheckClassInstr.
If input is nullable expected type, then check for null only.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//22580005
null_check() -> IsNullCheck()



r25900 | johnmccutchan@google.com | 2013-08-08 05:35:37 +0900 (木, 08  8月 2013) | 5 lines
Expose classes, codes, functions, and libraries collections.
R=iposva@google.com
Review URL: https://codereview.chromium.org//22297008
vm/serviceに、vm/object_id_ring.h を追加

PRINT_RING_OBJ()
ServiceMessagehandlerEntry()にいろいろと追加
HandleをRingObjで管理。
libraries
functions
classes
codes



r25897 | johnmccutchan@google.com | 2013-08-08 04:52:32 +0900 (木, 08  8月 2013) | 6 lines
Escape strings when writing to JSON.
R=regis@google.com
Review URL: https://codereview.chromium.org//22599002
json_stream
Printf -> Addに変換


r25893 | srdjan@google.com | 2013-08-08 03:56:48 +0900 (木, 08  8月 2013) | 5 lines
Do not use guarded cid on externalizable cid-s (one and two byte strings).
An externalizable object can change its type on the fly and therefore
we cannot rely on the information obntained while storing into the field.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//22314017
guarded_cidがexternalizableのケースを追加
特に、externalizableなのは、OneByteStringとTwoByteStringが該当する。
どういうこった。



r25890 | cbracken@google.com | 2013-08-08 02:28:04 +0900 (木, 08  8月 2013) | 20 lines
Fixes to get Dart VM compiling on Ubuntu 13.04, Debian Wheezy.
* Convince gcc 4.7.x that len is initialized before use in callers of ReadFileFully()
* Cast RawObject* to intptr_t to avoid strict-aliasing error on gcc 4.7.x
* Replace two calls to strerror_r() with strerror() on Linux. When _GNU_SOURCE is
  defined to be non-zero (as it is on Dart Linux builds), strerror_r() is
  defined to return a char*, which is the correct error string to use. When
  _GNU_SOURCE is zero, the XSI-compliant definition is used and the error
  message is returned in the char* param. Surrounding error logging uses
  strerror() which solves the problem.
* Replace int literals with char literals in test string definition.
* co19 math/tan_A01_t01 passes on Ubuntu 13.04.

Original issues:
https://code.google.com/p/dart/issues/detail?id=12085
https://code.google.com/p/dart/issues/detail?id=8807
R=asiva@google.com
Review URL: https://codereview.chromium.org//22381002
gccのバージョンアップに伴い、修正。



r25884 | hausner@google.com | 2013-08-08 01:33:02 +0900 (木, 08  8月 2013) | 7 lines
Remove bogus assertion
Fix issue 12290.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//22594002
assert追加。


r25877 | hausner@google.com | 2013-08-08 00:15:02 +0900 (木, 08  8月 2013) | 12 lines
Fix access to type variables in initializer expressions
Allow initializer expressions to capture type arguments.
This used to crash because the receiver is not accessible in initializer expressions.
We don't need the receiver, we just need to mark it as captured.
Fixes issue 8847.
R=ahe@google.com
Review URL: https://codereview.chromium.org//22415002
scope内の CaptureVariableの処理を、
methodにくくりだした。リファクタリング。


r25875 | hausner@google.com | 2013-08-07 23:22:13 +0900 (水, 07  8月 2013) | 8 lines
Better error message for redefined local names
Improve error message when a name is defined in a scope and
and outer declaration of the name has been referenced before.
Fixes issue 7073.
Review URL: https://codereview.chromium.org//22567003
vm/parserのエラーメッセージ
current_block->scope()でない場合のエラーメッセージを追加し、
outer scopeでのredefineであると分かるようになった。


r25872 | sgjesse@google.com | 2013-08-07 21:55:09 +0900 (水, 07  8月 2013) | 16 lines
Add support for file URIs and extracting the file path from file URIs
A file URI can now be created directly using the constructor Uri.file.
The file path for a file URI can now be extracted using the toFilePath() method.
The path strings involved use either Windows or non-Windows
semantics. Both the Uri.file constructor and the toFilePath()
method have optional anamed arguments for specifying the semantics.
The default semantic is determined from the platform Dart is running on.
R=ahe@google.com, whesse@google.com
Review URL: https://codereview.chromium.org//21039005
bootstrap_natives
Uri_isWindowsPlatform


r25843 | asiva@google.com | 2013-08-07 07:58:53 +0900 (水, 07  8月 2013) | 5 lines
Rearrange some methods so that they get inlined.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//22307003
.ccと.h間でメソッドの実装を移動。


r25827 | asiva@google.com | 2013-08-07 04:27:48 +0900 (水, 07  8月 2013) | 10 lines
Auto create ApiLocalScope before calling native functions,
this ensures that native functions do not have to call Dart_EnterScope/Dart_ExitScope
when they callback into the VM.
Remove Dart_EnterScope/Dart_ExitScope calls around native functions in 'bin' directory.
R=regis@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//22303002
NativeCallWrapperにApiLocalScope()を挿入
binからEnterScope()/ExitScope()を取り除いた

stubにCallBootstrapCFunction()を追加



r25825 | srdjan@google.com | 2013-08-07 03:58:38 +0900 (水, 07  8月 2013) | 5 lines
When converting from equality to strict equality always note
that number check is not needed since equality on numbers cannot be converted to strict equality
(numbers override == operator).
R=asiva@google.com
Review URL: https://codereview.chromium.org//22465002
set_needs_number_check(false)


r25821 | iposva@google.com | 2013-08-07 02:51:17 +0900 (水, 07  8月 2013) | 3 lines
- Make sure to not skip frames too early.
Review URL: https://codereview.chromium.org//22451002
IsDebuggable()の場合、AddActivation()


r25816 | srdjan@google.com | 2013-08-07 00:46:28 +0900 (水, 07  8月 2013) | 5 lines
Inline fsin/fcos. Huge speedup on Box2D.
R=iposva@google.com
Review URL: https://codereview.chromium.org//22266005
SupportsInlinedTrigonometrics()を追加 ia32/x64はtrue

sin, cos を特殊化
MethodRecognizerで置換
ia32/x64は、fsin(), fcos()


r25814 | johnmccutchan@google.com | 2013-08-06 23:46:20 +0900 (火, 06  8月 2013) | 5 lines
Expose arguments and options to handlers through JSONStream
R=asiva@google.com
Review URL: https://codereview.chromium.org//22238002
SetArguments() SetOptions()
それぞれjson上で表示する。


r25810 | fschneider@google.com | 2013-08-06 21:43:09 +0900 (火, 06  8月 2013) | 19 lines
Fix register allocation bug in building use intervals.
This bug was only exposed on ARM, but can be a problem on other platforms as well.

When building the use intervals for a value that is used more than once at one instruction,
the use interval was not adjusted correctly:
Under certain conditions the resulting interval can be too short.
It can occur when the first use is a writable register use,
and the second use is a normal register use.
This CL grows the use intervals to the correct size in that case.
BUG=https://code.google.com/p/dart/issues/detail?id=11800
TEST=tests/language/regress_11800_test.dart
R=vegorov@google.com
Review URL: https://codereview.chromium.org//22412002
first_use_interval->start() == startのケースを追加。


r25805 | asiva@google.com | 2013-08-06 09:11:55 +0900 (火, 06  8月 2013) | 6 lines
Added unit test cases to try and reproduce issue 12137 (Things work as expected)
R=srdjan@google.com
Review URL: https://codereview.chromium.org//22287004
testのみ。


r25782 | regis@google.com | 2013-08-06 03:35:04 +0900 (火, 06  8月 2013) | 9 lines
Fix VM implementation of CastError not to extend TypeError (issue 5280).
Remove non-compliant fields in various Error classes (issue 10144).
Remove implicit constructor when patching in a constructor (issue 12217).
Patch corelib Error classes instead of declaring subclasses.
Update tests and status files.
R=asiva@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//21832003
ArgumentDefinitionTestを削除した。

CreateAndThrowTypeError()において、
TypeError or CastErrorを投げる

lib/errorsやpatchのほうを修正している。
corelibの中身をいろいろいじっている様子。修正量多い。


r25767 | fschneider@google.com | 2013-08-05 22:49:48 +0900 (月, 05  8月 2013) | 17 lines
Fix a bug in compilation of try-finally.
When nesting try-finally, the outer finally was incorrectly executed twice under certain conditions
(a return in the inner try-block and a outer finally-block that ends with throw)
This was because finally-code was inlined at return/break/continue statements
and it was associated with the wrong catch-handler when compiling.
This CL tracks indices of try-blocks in the parser so that each inlined
finally block has the correct catch handler index.
BUG=https://code.google.com/p/dart/issues/detail?id=11972
TEST=test/language/throw8_test.dart
R=hausner@google.com
Review URL: https://codereview.chromium.org//22184003
try_indexってのを用意した。
builderでTryBlockを生成する際に、try_indexを生成して埋め込む。
今のところは埋め込むだけかな。il_printerでもtry_indexを出力する。


r25765 | hausner@google.com | 2013-08-05 21:13:36 +0900 (月, 05  8月 2013) | 11 lines
Forwarding constructors are never const
Forwarding constructors of mixing application classes do not
inherit the super constructor's const-ness.
They are also never abstract or external.
Fixes issue 11917.
R=ahe@google.com
Review URL: https://codereview.chromium.org//22183002
class_finalizerのフラグを調整 not const. not abstract. not external.



r25753 | srdjan@google.com | 2013-08-03 08:07:55 +0900 (土, 03  8月 2013) | 5 lines
Adapt Random class to be able to run in javascript integer compatibility mode.
R=asiva@google.com, zra@google.com
Review URL: https://codereview.chromium.org//21966003
Randomクラスを修正し、遅い処理をVMのbootstrap_nativesに登録した。
nextSeedとsetupSeed


r25752 | zra@google.com | 2013-08-03 08:04:22 +0900 (土, 03  8月 2013) | 5 lines
Re-enable int intrinsics on ia32 in js in compat mode.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21961004
ia32の場合、Smi::kBits < 32の場合はintrinsicを使用すると。


r25750 | asiva@google.com | 2013-08-03 07:47:26 +0900 (土, 03  8月 2013) | 6 lines
Add Dart_GetNativeReceiver to special case access to the native field
of a receiver argument (helps eliminate number of validity checks).
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21986002
dart_api.hに追加
Dart_GetNativeReceiver()


r25749 | rmacnak@google.com | 2013-08-03 07:28:10 +0900 (土, 03  8月 2013) | 5 lines
Remove unused functions from dart_mirrors_api.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21623004
vm/mirrors_api_implの不要な命令を削除
大量に削除。。

include/dart_mirrors_api.h からも削除。全部bootstrapから経由するのかな。
Metadata Reflection
Closure Reflection
Libraries Reflection
Function and Variables Reflection
Classes and Interfaces Reflection



r25740 | zra@google.com | 2013-08-03 03:37:20 +0900 (土, 03  8月 2013) | 7 lines
Enables unboxed mints in ia32 javascript int compatability mode.
Also checks range information before emitting checks on x64.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21885003
throw_on_javascript_int_overflowが有効な場合、
deoptimizeが有効
throwされることが保証されていれば、deoptimizeする必要がないってことか。
EmitJavascriptOverflowCheck()で範囲チェックを生成している。

CodeGeneratorにUnaryMintOpを追加？
これがJavascriptOverflowCheckを生成する。


r25733 | zra@google.com | 2013-08-03 01:06:45 +0900 (土, 03  8月 2013) | 5 lines
Fixes obo error in javascript int checking.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21876005
EmitJavascriptOverflowCheck
MAX_EXACT_INT_TO_DOUBLE 2^53
IsJavascriptInt() を用意
((-0x20000000000000LL <= value) && (value <= 0x20000000000000LL));



r25731 | fschneider@google.com | 2013-08-02 20:32:05 +0900 (金, 02  8月 2013) | 12 lines
Improve performance of Dart_ListGetAsBytes.
This fixes two performance issues with Dart_ListGetAsBytes:
1. Avoid excessive handle allocation when copying from a generic List.
2. Add a fast path when copying from byte-size typed data view objects.
   The old version only supported typed data, but no views.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21562002
CopyBytes() memmoveでcopy
TypedDataView Bytes==1の場合は、CopyBytes()



r25726 | johnmccutchan@google.com | 2013-08-02 09:24:09 +0900 (金, 02  8月 2013) | 5 lines
Support stacktrace and objecthistogram service commands
R=asiva@google.com
Review URL: https://codereview.chromium.org//19870006
ObjectHistogramにPrintToJSONStream
JSON形式でServiceとして外部に出力するのだと思う。

DisassembleToJSONStream
ObjectのJSONStreamもある
これらはStackTraceをJSON形式で出力するためにある。

VmServiceから情報取得できるようになっている。

message_handlersのentryには、以下
name
stacktrace
objecthistogram


r25723 | zra@google.com | 2013-08-02 05:51:46 +0900 (金, 02  8月 2013) | 5 lines
Enables per-function far-branches for ARM and MIPS.
R=regis@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//21363003

branch offsetがoverflowしないことを期待してコンパイルするけど、
もしoverflowしてbailout(Branch offset overflow)したら、use_far_branches=trueを設定し、
最初に戻ってコンパイルしなおす。
ia32系はそんなことは起こらない。


r25721 | rmacnak@google.com | 2013-08-02 05:45:49 +0900 (金, 02  8月 2013) | 3 lines
Implement metadata for libraries. Partially addresses issue 10906.
AddLibraryMetadata()
IsLibraryのmetadataをサポート


r25717 | mlippautz@google.com | 2013-08-02 03:27:32 +0900 (金, 02  8月 2013) | 9 lines
Inline CreateClassMirror and remove dead code.
(Almost) no more embedding API, yay!
Fixes issue 12135.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21440002
vm/symbols.h
_LocalClassMirrorImpl
_LocalFunctionTypeMirrorImpl



r25711 | rmacnak@google.com | 2013-08-02 01:40:10 +0900 (金, 02  8月 2013) | 5 lines
Implement mirror equality on the VM. Resolves issue 12026.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21381002
bootstrap_natives.h
MirrorReference_equals
lib/mirrors


r25706 | fschneider@google.com | 2013-08-01 21:03:21 +0900 (木, 01  8月 2013) | 14 lines
Enable allocation sinking for non-implicit closures.

In optimized code we can eliminate the allocation of closures that are not
escaping and where all calls are inlined.

Closures are currently allocated with a special IL instruction (CreateClosure).
This CL changes this for non-implicit closures and allocates them like normal objects.
The fields for the function and the context are initialized like instance fields.
This way object allocation sinking can handle closures like any other objects.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19370003

function.IsNonImplicitClosureFunction()の場合に、
closureに対して AllocateObjectInstrを用意
set_closure_function
closureにtype parameter
SetOffsetでLocalTempを設定
必要な要素をすべてをAllocateObjectに対して設定する。

AllocateObjectInstrに変換したことにより、StoreSinkingの対象になったのか。


r25692 | srdjan@google.com | 2013-08-01 08:50:56 +0900 (木, 01  8月 2013) | 5 lines
Fix performance degradation in DeltaBlue. When converting equality to strict-equality,
note that no special number checks must be done.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//21422002
strict_comp->set_needs_number_check(false)を挿入



r25691 | asiva@google.com | 2013-08-01 08:47:04 +0900 (木, 01  8月 2013) | 6 lines
Fix incorrect usage of NoGCScope in previous change
(dart objects are being allocated so it is possible to have GC).
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21252005
dart_api_impl.h
SetReturn系からNoGCScopeを削除。


r25689 | mlippautz@google.com | 2013-08-01 08:31:14 +0900 (木, 01  8月 2013) | 5 lines
Also fixes issue 11897.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21124011
bootstrap_natives.h
FunctionTypeMirror_parameters
FunctionTypeMirror_return_type
TypedefMirror_referent


r25688 | asiva@google.com | 2013-08-01 08:27:25 +0900 (木, 01  8月 2013) | 6 lines
Fix for issue 12136 (do not try to copy type arguments if the base class has no type arguments).
R=regis@google.com
Review URL: https://codereview.chromium.org//20575003
super classにtype argsをcopyする。


r25687 | regis@google.com | 2013-08-01 08:26:26 +0900 (木, 01  8月 2013) | 6 lines
Set local function type as uninstantiated when applicable (fix issue 12127).
Add language regression test.
R=zra@google.com
Review URL: https://codereview.chromium.org//21274007
ResetIsFinalized()を挿入


r25686 | srdjan@google.com | 2013-08-01 08:13:01 +0900 (木, 01  8月 2013) | 3 lines
Fix build failures on buidl bot (compiles fine on my Mac Pro).
Review URL: https://codereview.chromium.org//21417003
testの修正


r25685 | srdjan@google.com | 2013-08-01 07:57:33 +0900 (木, 01  8月 2013) | 5 lines
Implement some conditional moves instructions for ia32/x64.
Use them in MinMax instruction implementation.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//21307004
以下のアセンブラを追加
cmovgeq
cmovlessq

if min/max
j
movl
をcmovに置換


r25677 | zra@google.com | 2013-08-01 03:16:53 +0900 (木, 01  8月 2013) | 3 lines
Fix build fail on mac.
Review URL: https://codereview.chromium.org//21029008
longlongの定数の末尾に、LLを付加


r25676 | asiva@google.com | 2013-08-01 03:05:05 +0900 (木, 01  8月 2013) | 12 lines
- Add following additional methods to the API to make returning values
  from Dartium easier:
  Dart_SetBooleanReturnValue
  Dart_SetIntegerReturnValue
  Dart_SetDoubleReturnValue

- Use Isolate value stored in NativeArguments instead of calling
  Isolate::Current

R=srdjan@google.com
Review URL: https://codereview.chromium.org//21319002
dart_api.h に 上記APIを追加

引数のintptr_t bool doubleから、SetRetrunValueでobjを生成する。


r25675 | zra@google.com | 2013-08-01 02:51:23 +0900 (木, 01  8月 2013) | 5 lines
Fixes javascript integer overflow check.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21301003
CheckFiftyThreeBitOverflow() -> CheckJavascriptIntegerOverflow()

+// dart2js represents integers as double precision floats. It does this using
+// a sign bit and 53 fraction bits. This gives us the range
+// -2^54 - 1 ... 2^54 - 1, i.e. the same as a 54-bit signed integer
+// without the most negative number. Thus, here we check if the value is
+// a 54-bit signed integer and not -2^54
+static bool Is54BitNoMinInt(int64_t value) {

x64のemitterは、Emit54BitOverflowCheckになった。



r25666 | regis@google.com | 2013-08-01 00:20:28 +0900 (木, 01  8月 2013) | 9 lines
Update VM to handle malformed types according to revised spec (issues 9055,
12105, 7247).
Update language tests.
Update status files.
Allow map literals to specify a key type that is not a String.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21049012
LinkedHashMap<String, V> -> <K, V>へ変更
map typeをK,Vとして取得して、type argumentsに挿入する。


r25665 | fschneider@google.com | 2013-07-31 23:57:49 +0900 (水, 31  7月 2013) | 10 lines
Fix crash bug in the polymorphic inlining.
When inlining a polymorphic call site,
we need to update the use lists so that the graph entry blocks of all
the callee-graphs are removed from the environment use lists.
TEST=tests/language/allocation_sinking_inlining_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21272003
UnuseAllInputs()を挿入。これで一時的に性能劣化


r25651 | mlippautz@google.com | 2013-07-31 07:57:59 +0900 (水, 31  7月 2013) | 5 lines
R=asiva@google.com, rmacnak@google.com
Review URL: https://codereview.chromium.org//20216002
bootstrap_natives.h

ClassMirror_type_variables
LocalTypeVariableMirror_owner
LocalTypeVariableMirror_upper_bound

object.hの中に、type parametersの参照を返す処理を追加



r25647 | mlippautz@google.com | 2013-07-31 07:22:17 +0900 (水, 31  7月 2013) | 8 lines
Hoist .simpleName and .qualifiedName up to _LocalDeclarationMirrorImpl.
Current tests already cover this change.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21281002
bootstrap_natives.h
MethodMirror_name

r25640 | mlippautz@google.com | 2013-07-31 05:52:44 +0900 (水, 31  7月 2013) | 6 lines
Inline CreateLibraryMirror.
R=asiva@google.com, rmacnak@google.com
Review URL: https://codereview.chromium.org//21092004
vm/symbols.hに
_LocalLibraryMirrorImplを追加
CreateLibraryMirrorUsingApi()を展開


r25638 | zra@google.com | 2013-07-31 05:49:22 +0900 (水, 31  7月 2013) | 5 lines
Implements the two argument shuffle SIMD instruction for ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//21004011
vzipqw アセンブラを追加

Float32x4TwoArgShuffleInstrを実装

shuffleといいながら、ARMの場合はvmovqで適切な場所を入れ替えるだけでOK


r25636 | srdjan@google.com | 2013-07-31 05:44:25 +0900 (水, 31  7月 2013) | 5 lines
Optimize equuality operation for two Boolean arguments.
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//21013005
HasOnlyTwoOf()に変更
StrictifyEqualityCompareWithICData()を追加

unary_ic_dataのpolymorphic_checksを展開して、StrictCompareInstrを挿入する。


r25625 | srdjan@google.com | 2013-07-31 01:57:11 +0900 (水, 31  7月 2013) | 5 lines
Fix incorrectly factored-out code in https://codereview.chromium.org/20468002/
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//21081003
bugfixかな？


r25617 | zra@google.com | 2013-07-31 00:33:36 +0900 (水, 31  7月 2013) | 5 lines
Implements far-branches on ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//21159002
オプション use_far_branches=false
class PatchFarBranch を追加

assemblerのBindを修正、
CanEncodeBranchOffset()でfar branchか判定し、far branchもemitできる。



r25601 | rmacnak@google.com | 2013-07-30 10:09:05 +0900 (火, 30  7月 2013) | 5 lines
Create the local MirrorSystem with internal code.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20851002
bootstrap_natives
_LocallIsolateMirrorImpl
_LocalMirrorSsytemImpl


r25599 | rmacnak@google.com | 2013-07-30 09:29:52 +0900 (火, 30  7月 2013) | 5 lines
Ensure FunctionTypeMirrors have a proper reflectee and implement ClassMirror.superinterfaces
with internal code.
Remove some unnecessary fields and constructor arguments.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21010005
bootstrap_natives.h
ClassMirror_interfacesを追加
lib/mirrorsに変更


r25594 | rmacnak@google.com | 2013-07-30 08:57:31 +0900 (火, 30  7月 2013) | 5 lines
Implement reflect() with Dart code,
InstanceMirror.type and ClosureMirror.function with internal code.
R=asiva@google.com
Review URL: https://codereview.chromium.org//21119002
bootstrap_natives
Mirrors_makeLocalInstanceMirror -> ClosureMirror_function

呼出を置換
_Mirrors.makeLocalInstanceMirror -> reflect()

内部やC++インターフェースでは、reflect()してますよってことか。


r25580 | johnmccutchan@google.com | 2013-07-30 03:57:35 +0900 (火, 30  7月 2013) | 5 lines
Inline two argument shuffle operations on IA32 and X64.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//20467004
movhlps unpcklps unpckhpsを追加
Float32x4TwoArgShuffleInstrを追加

Float32x4にshuffle系のAPIを実装
WithZWinXY
InterleaveXY
InterleaveZW
InterleaveXYPairs
InterleaveZWPairs
をinlineしたinstrで置換して高速化


r25573 | fschneider@google.com | 2013-07-30 01:56:39 +0900 (火, 30  7月 2013) | 8 lines
Simplify allocation stub for closures.
The compiler never generates code for allocating implicit static closures
using the allocation stub.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//21067002
RUNTIME_ENTRYのAllocateImplicitStaticClosureを削除

push popのあたりを共通化して、
kAllocateClosureRuntimeEntryを呼び出すように変更したのかな。


r25567 | fschneider@google.com | 2013-07-30 00:23:41 +0900 (火, 30  7月 2013) | 3 lines
Reland r25551: Allow inlining of closures with a context change.
Review URL: https://codereview.chromium.org//21087002
r25558 | fschneider@google.com | 2013-07-29 21:33:40 +0900 (月, 29  7月 2013) | 5 lines
Revert r25551 to help figure out mysterious build bot timeouts.
TBR=ricow@google.com
Review URL: https://codereview.chromium.org//20999005
r25551 | fschneider@google.com | 2013-07-29 18:44:02 +0900 (月, 29  7月 2013) | 14 lines
Allow inlining of closures with a context change.
This CL removes the remaining missing cases when inlining closure calls.

In order to benefit for code using forEach, I added GrowableObjectArray.forEach
to the functions that should always be inlined.

I also renamed BuildLoadContext/BuildStoreContext helpers in the flow
graph builder to better match what they do.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19721004
InlineBailoutを削除したので、適応範囲が広がっているのかも。
GrowableObjectArray, forEachも

StoreLocal/LoadLocalのBailoutを削除したのと併せて、
closure callをStore context valueとして扱い、inline展開されるのかな。


r25543 | zra@google.com | 2013-07-27 08:30:32 +0900 (土, 27  7月 2013) | 19 lines
Implements far branch targets for MIPS.

This change adds a flag --mips-far-branches,
which when set causes relative branches to be converted to absolute branches by determining the PC,
adding the branch offset to it, and using the jr or jalr instruction to jump if the branch test passes.

This procedure clobbers the assembler temporary TMP,
so TMP can no longer be used in a branch test or in the branch delay slot of a relative branch.
Because TMP can't be used in a branch test, a new temporary is introduced CMPRES2.
This change replaces TMP with CMPRES1 or another register where TMP can no longer be used.

Tests that were failing due to a too-far relative have the
--mips-far-branches flag set.
R=regis@google.com
Review URL: https://codereview.chromium.org//20369003
修正量が多い。
オプション use_far_branches=false
PatchFarJump classを作成
Assemblerに大量追加


r25535 | srdjan@google.com | 2013-07-27 05:17:04 +0900 (土, 27  7月 2013) | 5 lines
Make sure that ICData always contains valid data (non-null values).
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//20755004
ICDataのコンストラクタを修正


r25533 | rmacnak@google.com | 2013-07-27 03:29:38 +0900 (土, 27  7月 2013) | 5 lines
Make ClassMirror.constructors an internal native and lazy.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20564002
bootstrapに ClassMirror_constructorsを追加
lib/mirror の修正
NativeEntryに移動


r25532 | regis@google.com | 2013-07-27 03:18:56 +0900 (土, 27  7月 2013) | 7 lines
Delay resolution of redirecting factory targets in order to avoid class
finalization cycles (issue 12041).
Ensure that a super class is finalized before the class extending it.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20503003
ResolveRedirectingFactory()を追加して、リファクタリングかな。


r25522 | srdjan@google.com | 2013-07-27 01:48:46 +0900 (土, 27  7月 2013) | 6 lines
Allow equality operation on mixed double/smi arguments.
Fix a bug in relational operations in 64 bit mode:
if ICData specifies double and Smi as possible arguments,
we generate code for double and unbox or convert to double the inputs.
These works only if smi can fit into the double.
Current solution for 64-bit architecture is to disallow two smi-s
as input to a polymorphic comparison instruction (equality, relational).
R=johnmccutchan@google.com
Review URL: https://codereview.chromium.org//20468002
receiver_cidからoeration_cidへ変更

Comparisonを特殊化。
HasTwoDoubleOrSmi()っって追加
53bit以内ならやるのかな。


r25508 | rmacnak@google.com | 2013-07-26 07:45:07 +0900 (金, 26  7月 2013) | 5 lines
Implement ClassMirror.superclass with internal code for ordinary (but not function type) classes.
Resolves issue 5794 and issue 9434.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20465002
bootstrapに ClassMirror_supertypeを追加
lib/mirror の修正


r25499 | mlippautz@google.com | 2013-07-26 06:10:09 +0900 (金, 26  7月 2013) | 5 lines
R=asiva@google.com
Review URL: https://codereview.chromium.org//20208002
bootstrapに MethodMirror_parametersを追加
lib/mirror の修正


r25492 | asiva@google.com | 2013-07-26 04:28:53 +0900 (金, 26  7月 2013) | 12 lines
Fix for issue 11680
- implicitly store a full stack trace in Error objects when they are thrown.
- the shlFromInt on Mints and Bigints was trying to allocate a new OutOfMemory
  exception objects instead of using the pre-allocated exception object.
  Made the implementation of these methods native so that they can use the pre-allocated object.
- Ensure that it is not possible to allocate new OutOfMemory or StackOverflow exception objects.
R=ahe@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//19106008
Stacktraceのインスタンスを生成し、ThrowException
インスタンスを生成し、func_array, code_array, offset_list
StacktraceのInstanceからLookupStacktraceField() / setField できると。

bootstrapに以下を追加
Mint_shlFromInt
Bigint_shlFromInt
どっちもexceptionつくってThrowするだけだな。。
lib/intからVM内に処理を移した。


r25481 | johnmccutchan@google.com | 2013-07-26 02:31:19 +0900 (金, 26  7月 2013) | 5 lines
Allow SIMD types to be used on mips
R=regis@google.com
Review URL: https://codereview.chromium.org//20125005
オプション enable_simd_inline=true
mipsの場合はfalse
kUnboxedFloatを有効にするか、抑止するかをコントロールする。


r25473 | srdjan@google.com | 2013-07-26 00:42:26 +0900 (金, 26  7月 2013) | 5 lines
Optimize division for two Smi-s as well. Gives ~ 15% speedup on NavierStokes.
R=regis@google.com
Review URL: https://codereview.chromium.org//20198002
if (op_kind != Token::kDIV)
CheckEitherNonSmiInstrを挿入。


r25463 | whesse@google.com | 2013-07-25 18:37:38 +0900 (木, 25  7月 2013) | 6 lines
Improve certificate tests that hit google.com.
R=sgjesse@google.com
Review URL: https://codereview.chromium.org//19558011
vm/benchmark_test.ccの修正


r25451 | rmacnak@google.com | 2013-07-25 08:51:15 +0900 (木, 25  7月 2013) | 5 lines
Make LibraryMirror.members an internal native and lazy.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20119002
LibraryMirror_members
をlib/mirror側に追加。


r25450 | mlippautz@google.com | 2013-07-25 08:35:15 +0900 (木, 25  7月 2013) | 6 lines
Inline CreateParameterMirrorList() functionality.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19856003
result.set_referent して、return result.raw();


r25449 | srdjan@google.com | 2013-07-25 08:20:26 +0900 (木, 25  7月 2013) | 5 lines
Allocate comments in old space.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20180003
CommentsをHeap::kOld


r25447 | rmacnak@google.com | 2013-07-25 07:06:04 +0900 (木, 25  7月 2013) | 5 lines
Add a VM benchmark for creating the local MirrorSystem.
R=asiva@google.com
Review URL: https://codereview.chromium.org//20147002
benchmark_test.cc の修正


r25445 | srdjan@google.com | 2013-07-25 06:56:18 +0900 (木, 25  7月 2013) | 5 lines
Fix a crash in Meteor, debug mode.
BitAnd instruction cannot deoptimize, therefore does not allow accessing its deopt_id.
R=regis@google.com
Review URL: https://codereview.chromium.org//20158002
BIT_AND はdeoptimizeできないとか。


r25443 | johnmccutchan@google.com | 2013-07-25 06:29:45 +0900 (木, 25  7月 2013) | 5 lines
Add two argument shuffle operations to Float32x4
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19646005
bootstrapに追加
withZWinXY
interleaveXY
interleaveZW
interleaveXYPairs
interleaveZWPairs
これは珍しく、lib/simd128.ccに実装を書いている。


r25384 | rmacnak@google.com | 2013-07-24 08:54:16 +0900 (水, 24  7月 2013) | 5 lines
Make ClassMirror.members internal-native and lazy.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19496003
bootstrap_nativesに、ClassMirror_membersを追加
lib/mirrorsに処理追加


r25382 | regis@google.com | 2013-07-24 08:17:42 +0900 (水, 24  7月 2013) | 7 lines
Implement more restrictive checking of typedefs illegally referring to
themselves and fix vm issue 9611.
Update a test and add a test.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19997003
finalizerに IsParameterTypeCycleFree()を追加  IsAliasCycleFreeをチェックする


r25367 | srdjan@google.com | 2013-07-24 05:40:31 +0900 (水, 24  7月 2013) | 5 lines
Optimize double min/max by reducing the code size
(reusing left register as result removes the need to copy left into result).
Add code for two Smi arguments.
R=regis@google.com, zra@google.com
Review URL: https://codereview.chromium.org//19695007
MathMinMaxInstrの実装を改善


r25358 | zra@google.com | 2013-07-24 05:02:12 +0900 (水, 24  7月 2013) | 5 lines
Implements Float32x4 and Uint32x4 instructions for ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//19978004
arm assemblerに、ia32/x64と同じI/Fで命令を追加
Vreciprocalqs
VreciprocalSqrtqs
Vsqrtqs
Vdivqs
UNIMPLEMENTEDを置き換え
Uint32x4の各種命令を実装


r25354 | asiva@google.com | 2013-07-24 03:57:05 +0900 (水, 24  7月 2013) | 25 lines
Add a new Dart API call Dart_GetNativeFieldOfArgument
which combines Dart_GetNativeArgument and Dart_GetNativeInstanceField

Dartium always gets the receiver by first getting the NativeArgument
corresponding to 0 using Dart_GetNativeArgument and then invokes
Dart_GetNativeInstanceField on the returned handle to get the native
field corresponding to the native DOM element.

When Dartium is changed to use this combined API call the numbers for a
sample Dromaeo-drt benchmark is as follows:

Dromaeo-drt getAttribute runs-per-second 653.0
Dromaeo-drt element_property_access runs-per-second 579.0
Dromaeo-drt setAttribute runs-per-second 396.0
Dromaeo-drt element_property_assignment runs-per-second 539.0

When the old API calls are used:
Dromaeo-drt getAttribute runs-per-second 596.0
Dromaeo-drt element_property_access runs-per-second 528.0
Dromaeo-drt setAttribute runs-per-second 385.0
Dromaeo-drt element_property_assignment runs-per-second 513.49
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19563005
dart_apiに追加
Dart_GetNativeFieldOfArgument()
instance.GetNativeField(isolate, fld_index)して返す。


r25353 | srdjan@google.com | 2013-07-24 03:38:03 +0900 (水, 24  7月 2013) | 5 lines
Make sure that all objects store in the Code object live in old space.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19990006
Heap::kOldを追加。


r25352 | zra@google.com | 2013-07-24 03:25:44 +0900 (水, 24  7月 2013) | 8 lines
Increases the number of ARM floating-point registers.
This is to be consistent with VFPv3_D32. Later, we'll detect VFPv3_D16 at runtime.
R=regis@google.com
Review URL: https://codereview.chromium.org//19806005
vldmd vstmd の引数をcountに変更


r25325 | mlippautz@google.com | 2013-07-23 09:39:28 +0900 (火, 23  7月 2013) | 8 lines
Local change to make the type getter lazy.
This change adds the last piece missing
to inline functionality of CreateMethodMirror and its parameters. (Separate CL.)
R=asiva@google.com
Review URL: https://codereview.chromium.org//19983003
bootstrapにParameterMirror_typeを追加
あとはlib/mirror側かな。


r25324 | regis@google.com | 2013-07-23 09:19:39 +0900 (火, 23  7月 2013) | 6 lines
Refactor resolution code in the vm to properly handle ambiguity errors.  Add test.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19662003
lookupの引数に、ambiquity_error_msg=NULLを追加
error handingをシンプルにした。


r25320 | zra@google.com | 2013-07-23 08:26:12 +0900 (火, 23  7月 2013) | 9 lines
Adds more SIMD instructions for ARM.
Adds the vnegqs, vabsqs, and vandq instructions.
Also reverts the increase in the number of floating point registers
since it is causing crashes on hardware.
R=regis@google.com
Review URL: https://codereview.chromium.org//19493004
vandq
vabsqs
vnegqs
を追加
assemberの追加と、UTのみ。


r25317 | rmacnak@google.com | 2013-07-23 08:05:54 +0900 (火, 23  7月 2013) | 5 lines
Implement VariableMirror creation with non-API code.
To break circular initialization, have them find their type lazily.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19512003
GetFieldReferent()
bootstrap, symbolsに_LocalVariableMirrorImplを追加
lib/mirrorから参照



r25315 | mlippautz@google.com | 2013-07-23 07:49:08 +0900 (火, 23  7月 2013) | 6 lines
This change introduces nothing new. It only fixes the native entrypoints to use the right macros.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19500016
GetClassReferent()
GetFunctionReferent()
GetLibraryReferent()
lib/mirrorから参照
全部Object::Handle()で返す。


r25314 | srdjan@google.com | 2013-07-23 07:43:51 +0900 (火, 23  7月 2013) | 5 lines
FIx a typo in SIMMIPS min/max and enable min_max_test for SIMMIPS
by splitting the main functions into two parts.
R=regis@google.com
Review URL: https://codereview.chromium.org//19653008
typo right -> left


r25306 | srdjan@google.com | 2013-07-23 06:37:43 +0900 (火, 23  7月 2013) | 5 lines
Fix math min/max for -0.0 case. Enable min_max_test to run in optimizing compiler as well.
R=regis@google.com, zra@google.com
Review URL: https://codereview.chromium.org//19482023
Check for negative zeroのケースを考慮。
movmskpdの後に testl NOT_ZERO


r25301 | johnmccutchan@google.com | 2013-07-23 05:20:50 +0900 (火, 23  7月 2013) | 5 lines
Add two argument SSE shuffle instructions
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19940005
以下のSSE shuffleを追加
movhlps
movlhps
unpcklps
unpckhps
unpcklpd
unpckhpd

ia32/x64、UTのみ追加。


r25292 | asiva@google.com | 2013-07-23 03:46:14 +0900 (火, 23  7月 2013) | 9 lines
Reuse the top ApiLocalScope so that we do not allocate and free an ApiLocalScope
for each Dart_EnterScope/Dart_ExitScope sequence.
The runtime of UseDartApi benchmark on linux ia32 improves from 187316 to 121083.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19974002
new ApiLocalScope -> Reinit

vm/dart_api_state.hも修正して、Reinitを積極導入かな。 reusable_scope_


r25291 | zra@google.com | 2013-07-23 03:19:44 +0900 (火, 23  7月 2013) | 5 lines
Adds reciprocal squre root SIMD instructions for ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//19875002
SIMDの追加
vrsqrteqs
vrsqrtsqs
assemblerとUT追加のみ。


r25288 | srdjan@google.com | 2013-07-23 02:51:03 +0900 (火, 23  7月 2013) | 3 lines
Fix simmips build, remove unnecessary temp register.
Review URL: https://codereview.chromium.org//19849004
temp registerの削除。


r25287 | srdjan@google.com | 2013-07-23 02:27:45 +0900 (火, 23  7月 2013) | 5 lines
Recognize Math's min and max function for doubles and inline the operation.
R=regis@google.com, zra@google.com
Review URL: https://codereview.chromium.org//19792007
MathMinMaxInstr命令を追加
Recognizerにマッチしたら置換するはず。
min/maxはdoubleのときだけ置換する。今のところは。
comisd命令で比較し、
min/maxにおうじてconditionを設定し、jump
resultにrightかleftを設定して返す。


r25279 | johnmccutchan@google.com | 2013-07-23 00:39:03 +0900 (火, 23  7月 2013) | 5 lines
VM Service isolate listing
R=asiva@google.com
Review URL: https://codereview.chromium.org//19622003
vm/service.h|ccを新規追加。Serviceは、isolateに外部から接続してstatsやstateを返す。
bin/vmservice にも様々追加している。
基本的にはisolateの特定のportにmessageを投げると、messageで返してくれる。


r25267 | floitsch@google.com | 2013-07-22 21:25:16 +0900 (月, 22  7月 2013) | 5 lines
Remove dart:codec and move classes into dart:convert.
R=sgjesse@google.com
Review URL: https://codereview.chromium.org//19941002
kCodecとkConvertをvmのbootstrapとObjectStoreに追加した。
coreライブラリに追加。


r25252 | mlippautz@google.com | 2013-07-20 08:17:47 +0900 (土, 20  7月 2013) | 8 lines
Since returnType is represented by a mirror, we make it lazy.
We do not use a lazy mirror anymore, but instead create a type mirror upon first access.
CreateTypeMirror is already factored out of MethodMirror_return_type
since it is needed by others mirrors (future CLs).
Also introduces CreateMirror() which will be used in future CLs.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19780002
RawFunction* GetFunctionReference()を追加
bootstrapにMethodMirror_return_typeを追加
parser用のsymbolに、_SpecialTypeMirrorImplを追加


r25246 | mlippautz@google.com | 2013-07-20 06:49:45 +0900 (土, 20  7月 2013) | 6 lines
Rename: DartLibraryCalls::ExceptionCreate -> InstanceCreate
R=asiva@google.com
Review URL: https://codereview.chromium.org//19678024
ExceptionCreate -> InstanceCreate


r25245 | zra@google.com | 2013-07-20 06:32:03 +0900 (土, 20  7月 2013) | 7 lines
Adds ARM SIMD instructions.
vminqs, maxqs, vrecpeqs (Reciprocal estimate), vrecpsqs (Reciprocal Newton-Raphson step).
R=regis@google.com
Review URL: https://codereview.chromium.org//19773017
命令追加のみ。assemblerを追加しただけ。
vminqs
vmaxqs
vrecpeqs
vrecpsqs


r25234 | srdjan@google.com | 2013-07-20 03:20:21 +0900 (土, 20  7月 2013) | 5 lines
Minor cleanup: use deopt-id instead od static call instruction as argument for MathSqrtInstr.
R=regis@google.com
Review URL: https://codereview.chromium.org//19779011
MathSqrtInstrの引数を、instance_call -> deopt_id


r25233 | regis@google.com | 2013-07-20 03:08:17 +0900 (土, 20  7月 2013) | 4 lines
Use library prefixes in scope of the mixin class when compiling a functions of
a mixin application (issue 11891).
Review URL: https://codereview.chromium.org//19763007
vm/parser
lib_prefixの取得方法を変更。mixin()ケースを考慮。


r25227 | johnmccutchan@google.com | 2013-07-20 02:03:09 +0900 (土, 20  7月 2013) | 5 lines
Add all 256 shuffle methods to Float32x4
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19564014
_Float32x4に、_shuffleを実装。
xxxx/yyyy/zzzz/wwwwなどはすべて削除。

armの場合は vdupをemit
x86はshufpsをwrapしたのみ。


r25225 | srdjan@google.com | 2013-07-20 01:49:29 +0900 (土, 20  7月 2013) | 5 lines
Collect both arguments for math's min/max static functions.
Later that information will be used to inline the operation if possible.
R=regis@google.com
Review URL: https://codereview.chromium.org//19774007
code_generatorに、StaticCallMissHandlerTwoArgs()を追加した。
min/max/identialをRECOGNIZERに追加した。

stub経由で呼ばれるのだが、static callでmin/max/identicalを呼ぶのではなく、
ic_data、ClassIdを収集するようにした。

r25219 | zra@google.com | 2013-07-20 00:28:53 +0900 (土, 20  7月 2013) | 5 lines
Enables more SIMD tests for ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//19779006
Float32x4ComparisonInstr
Float32x4WithInstr
を実装。
r25189で追加した命令を生成する。


r25200 | fschneider@google.com | 2013-07-19 18:15:28 +0900 (金, 19  7月 2013) | 20 lines
Replace ChainContextInstr with existing IL instructions.
v0 <- AllocateContext(...)

      ChainContext(v0)

is changed into 

v1 <- CurrentContext
    StoreField(v0.parent = v1)
    StoreContext(v0)

Since v0 is used twice, I used a TempLocalScope in the graph builder to store the allocated context.
As a result ChainContextInstr can be completely removed from the compiler.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19569002
ChainContextInstr命令を削除し、既存の命令で置換。

ChainContextInstrは、
StoreIntoObject()
MoveRegister()
の2命令

を、flow_graph_builderで
AllocateContext で領域を作ることなく、既存のContextにStoreFieldできるのかな。
こっちのほうが効率的かも。


r25193 | rmacnak@google.com | 2013-07-19 09:44:36 +0900 (金, 19  7月 2013) | 7 lines
Make the ClassMirrors created through reflectClass() find their owners (libraries) lazily.
Remove an unused parameter that was threaded through a number of mirror creation functions.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19188004
vm/bootstrap_natives ClassMirror_libraryを追加
他はlib/mirrors


r25189 | zra@google.com | 2013-07-19 07:56:45 +0900 (金, 19  7月 2013) | 5 lines
Implements ARM SIMD comparison instructions.
R=regis@google.com
Review URL: https://codereview.chromium.org//19678020
以下を追加
vornq(QReg, QReg, QReg)
vceqqi(sz, QReg, QReg, QReg)
vceqqs(QReg, QReg, QReg)
vcgeqi(sz, QReg, QReg, QReg)
vcugeqi(sz, QReg, QReg, QReg)
vcgeqs(QReg, QReg, QReg)
vcgtqi(sz, QReg, QReg, QReg)
vcugtqi(sz, QReg, QReg, QReg)
vcgtqs(QReg, QReg, QReg)
assemblerを追加したのみかな。


r25186 | mlippautz@google.com | 2013-07-19 07:04:57 +0900 (金, 19  7月 2013) | 20 lines
If we have the owner mirror at creation time (which right now is a lazy mirror), we will use it.
Eventually lazy mirrors will go away and we will not have to resolve() in dart code anymore.
If we don't have it, for example for a nested closure,
we set it null and construct it lazily at access time.

Example:

outer() {
  inner() {}
  var closureMirror = reflect(inner);
  print(closureMirror.function.owner);  // Should be a MethodMirror on outer, that is constructed lazily.
}

Since we need to be able to construct the chain of owners (back up to library),
we need to handle all cases in the lazy creation.
The CL also adds wrappers that can be called with native objects.
At some point these wrapper will create the mirrors without referring to the ones using embedded API.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19579006
MethodMirror_ownerをbootstrap_nativesに追加
大部分はlib/mirrorの修正


r25165 | zra@google.com | 2013-07-19 03:40:27 +0900 (金, 19  7月 2013) | 7 lines
Enables a SIMD test for ARM.
Required adding the veorq, vmovq, and vdup instructions.
R=regis@google.com
Review URL: https://codereview.chromium.org//19776007
NEONの以下を追加
vmovq
veorq
vorrq
vdup

arm実装の
BoxFloat32x4Instr
UnboxFloat32x4Instr

Boxは、
TryAllocate
StoreDtoOffset(even
StoreDToOffset(odd

Unboxは、
LoadDFromOffset(even
LoadDFromOffset(odd

NEONは必須ではないので、BoxとUnboxにはSlowPathを並行実装している。



r25162 | srdjan@google.com | 2013-07-19 03:15:29 +0900 (金, 19  7月 2013) | 5 lines
Cleanup: remove argument descriptor parameter when calling inline cache miss handler.
R=zra@google.com
Review URL: https://codereview.chromium.org//19547003
InlineCacheMissHandler()の引数から、argument_descripterを削除。


r25146 | fschneider@google.com | 2013-07-18 23:13:38 +0900 (木, 18  7月 2013) | 11 lines
Disable allocation sinking in the presence of try-catch.
Allocation sinking does not handle the case of optimized try-catch yet.
I added a TODO to support it at a later point.
BUG=https://code.google.com/p/dart/issues/detail?id=11873
TEST=tests/language/try_catch_optimized2_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19462004
graph_entry()->SuccessorCount() != 1の場合はStoreSinkingを抑止する。



r25137 | asiva@google.com | 2013-07-18 09:28:03 +0900 (木, 18  7月 2013) | 7 lines
Allow type objects to be passed in to Dart_GetStaticFields
(This is in sync with the change to have the entire Dart API surface
accept type objects instead of exposing the class objects).
R=jacobr@google.com
Review URL: https://codereview.chromium.org//19713002
debugger_api_implの、Dart_GetStaticFields()を実装
isolate->debugger()->GetStaticFields(cls)
を呼び出す。


r25136 | regis@google.com | 2013-07-18 09:23:04 +0900 (木, 18  7月 2013) | 5 lines
Fix generic mixins (issue 11803).
R=hausner@google.com
Review URL: https://codereview.chromium.org//19669010
class_finalizerの修正
mixinしたクラスから、interfaceに型パラメータを設定する。


r25126 | rmacnak@google.com | 2013-07-18 06:50:54 +0900 (木, 18  7月 2013) | 5 lines
Implement metadata as an internal native.
Be honest about which mirrors don't yet support metadata introspection.
R=asiva@google.com
Review URL: https://codereview.chromium.org//19235015
VMReferenceを削除
VMReferenceからPersistentHandleやWeakPersistentHandleを呼び出していたけど、、


r25122 | zra@google.com | 2013-07-18 05:54:34 +0900 (木, 18  7月 2013) | 7 lines
Replaces Location::ToStackSlotAddress() with Location::ToStackSlotOffset()
This way, Location no longer mentions the architecture specific Address class.
R=regis@google.com
Review URL: https://codereview.chromium.org//19464002
Address -> intptr_t * word
にして、各アーキテクチャごとに修正。


r25103 | srdjan@google.com | 2013-07-18 01:03:07 +0900 (木, 18  7月 2013) | 5 lines
Cleanups.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//19395003
compilerとoptimizerをリファクタリングかな。
InstanceCallInstr -> deopt_id


r25090 | fschneider@google.com | 2013-07-17 20:35:20 +0900 (水, 17  7月 2013) | 5 lines
Fix bug in compile-type propagation of the optimizing compiler.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//19506007
bugなのか。toからotherに変更かな。


r25073 | zra@google.com | 2013-07-17 06:18:26 +0900 (水, 17  7月 2013) | 7 lines
Adds the vtbl ARM SIMD instruction.
It is needed for the Float32x4ShuffleInstr of the intermediate language.
R=regis@google.com
Review URL: https://codereview.chromium.org//19400003
vtblを追加。


r25064 | zra@google.com | 2013-07-17 03:32:40 +0900 (水, 17  7月 2013) | 5 lines
Merges ARM load/store type enums into one enum.
R=regis@google.com
Review URL: https://codereview.chromium.org//19256021
kLoadWord/kStoreWord -> kWord


r25063 | johnmccutchan@google.com | 2013-07-17 03:31:25 +0900 (水, 17  7月 2013) | 5 lines
Object ID Ring with tests
R=iposva@google.com
Review URL: https://codereview.chromium.org//18259014
vm/object_id_ring.h を追加。ObjectIdRingってなんだ。
ring->GetIdForObject(obj) ってな具合でring_idを取得する。
もしくは、ring->GetobjectForId(ring_id) でObjectを取得する。
普通にring式にidを付与していく。maxを超えたら0初期化。
kMaxId = 0x3FFFFFFF, kDefaultCapacity = 1024

Scavenger::IterateObjectIdTable()でisolate->object_id_ring() を使用する。
IterateRoots()に、IterateObjectIdTable()を挿入した。GCの新しいRootなのか。

GCMarkerでもRootに登録している。


r25057 | fschneider@google.com | 2013-07-17 01:45:27 +0900 (水, 17  7月 2013) | 8 lines
Always try to inline certain core library functions.
Inlining moveNext and get:iterator enables the iterator object for allocation sinking.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19223002
INLINE_WHITE_LISTってのが追加されて、
ListIterator, moveNextと
_GrowableObjectArray, get:iterator
を確実にinlineして、StoreSinkingしやすくする。らしい。


r25056 | regis@google.com | 2013-07-17 01:35:55 +0900 (水, 17  7月 2013) | 5 lines
Allow the optimizer to canonicalize instantiated function types (issue 11775).
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19260003
Type::Canonicalize()の修正かな。
-    if (!type.IsFinalized()) {
-      ASSERT((index == 0) && cls.IsSignatureClass());
-      index++;
-      continue;
-    }
Canonicalizeが走るタイミングでは、すべてIsFinalizeっぽい。



r25053 | regis@google.com | 2013-07-17 01:29:59 +0900 (水, 17  7月 2013) | 5 lines
Use proper internal name for implicit static final getters.
R=hausner@google.com
Review URL: https://codereview.chromium.org//19287003
kConstImplicitGetter -> kImplicitStaticFinalGetter に変更


r25052 | zra@google.com | 2013-07-17 01:13:56 +0900 (水, 17  7月 2013) | 5 lines
Implements ARM SIMD multiplication and subtraction instructions.
R=regis@google.com
Review URL: https://codereview.chromium.org//19290006
vsubqi(int, QReg, QReg)
vsubqs(QReg, QReg, QReg)
vmulqi(int, QReg, QReg)
vmulqs(QReg, QReg,QReg)
を追加

r25041 | fschneider@google.com | 2013-07-16 18:38:13 +0900 (火, 16  7月 2013) | 27 lines
Change resolving of instance methods to check early for name mismatch.
The names of actual arguments are checked at resolving time
for a mismatch instead of deferring this check to the function prologue
(emitted as part of the CopyParameters() prologue).

For example:

class A {
  foo({a:42}) => null;
}

main() {
  var a = new A();
    a.foo(b:123);  // noSuchMethod: no named parameter named "b".
}

This enables e.g. fast noSuchMethod invocation in the case of a named argument mismatch.
It also makes the function prologue for instance functions that
use optional parameters shorter by omitting the check for a name mismatch there.
R=regis@google.com
Review URL: https://codereview.chromium.org//19200002
ResolveDynamic()を ArgumentsDescriptorを直接引数に渡すように修正。
AreValidArguments()で判定するらしい。
実行時にcheck_collect_named_argsでチェックする。


r25024 | rmacnak@google.com | 2013-07-16 06:14:43 +0900 (火, 16  7月 2013) | 5 lines
Implement the invoke methods (invoke, getField, setField, newInstance, apply) as internal natives.
R=asiva@google.com
Review URL: https://codereview.chromium.org//18463003
dart_entryの修正
InvokeConstructor(klass, constructor, arguments) から、InvokeFunctionを使って呼び出す。
ClassMirror_invokeConstructorから呼び出す。

例外に以下を追加。
kMirroredUncaughtExceptionError
kMirroredCompilationError

ClassMirrorとInstanceMirrorとLibraryMirrorをBootstrapを追加

上記を使ってlib/mirrorを大幅修正。



r25001 | fschneider@google.com | 2013-07-15 20:12:09 +0900 (月, 15  7月 2013) | 24 lines
Faster invocation of fields as methods.
Until now there was a large discrepancy between

x.f() and
(x.f)()

This CL makes x.f() as fast as (x.f)() by automatically
generating  a intermediate dispatcher function that loads
the field and invokes the result as a closure.

The approach resembles the one taken for fast noSuchMethod
invocation and reuses the same per-class cache of dispatcher functions.

It also fixes a bug in the debugger so that VM-generated implicit dispatcher functions
(like for noSuchMethod, or field-as-method invocation) don't show up the debuggers stack trace.
BUG=https://code.google.com/p/dart/issues/detail?id=11041
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18750004
field containing closureの高速化

NoSuchMethodDispatcher -> InvocationDispatcherに変更

ResolveCallThroughGetterを
receiver_classごとにGetInvocationDispatcherを管理するようにした。
その後DartEntry::InvokeFunctionで呼び出す。
修正前は、InvokeClosureにargumentsとarguments_descriptor付きで呼んでいた。

no_such_method_cache_ -> invocation_dispatcher_cache_に変更
objectにinvocation_dispatcher_cache()を追加して、receiverごとに管理するのだと思う。
RawFunctionにkInvokeFieldDispatcherを追加

x.f()  <-- こっちのが遅いのが問題だったので、vmの内部処理を両方同じにしたのだと思う。
(x.f)()


r24999 | floitsch@google.com | 2013-07-15 19:26:38 +0900 (月, 15  7月 2013) | 7 lines
First version of Codecs and Converters.
No chunked conversions, yet.
R=asiva@google.com, lrn@google.com
Review URL: https://codereview.chromium.org//19000006
ObjectStore::kCodec, ObjectStore::kConvert
標準ライブラリが増えた。ObjectStoreにも登録。
sdk/lib/codec
sdk/lib/convert
utfとjsonパッケージを、codecとconvertの組み合わせに変更するのかな。


r25000 | floitsch@google.com | 2013-07-15 19:32:37 +0900 (月, 15  7月 2013) | 13 lines
Cleanup VM error handling.
Unify the way the runtime throws errors.
With this patch the VM goes through one location and always invokes the constructor of the errors.
It also makes it easier to rename fields in the error classes.
R=asiva@google.com
Committed: https://code.google.com/p/dart/source/detail?r=24995
Reverted: https://code.google.com/p/dart/source/detail?r=24997
Review URL: https://codereview.chromium.org//18531003
r24997 | floitsch@google.com | 2013-07-15 19:18:50 +0900 (月, 15  7月 2013) | 5 lines
Revert "Cleanup VM error handling."
This reverts commit r24995.
Review URL: https://codereview.chromium.org//19172002
r24995 | floitsch@google.com | 2013-07-15 18:28:28 +0900 (月, 15  7月 2013) | 9 lines
Cleanup VM error handling.
Unify the way the runtime throws errors.
With this patch the VM goes through one location and always invokes the constructor of the errors.
It also makes it easier to rename fields in the error classes.
R=asiva@google.com
Review URL: https://codereview.chromium.org//18531003
CoreLibraryの名称を4つほどprivateに変更し、上記のSymbolに変換。
kAssertion, kCast, kType, kFallThrough, kAbstractClassInstantiation
vm/exceptionの修正

Exceptionクラスに要素を設定する(SetField)のではなく、
argmentsに要素が詰めている
script.url
line
column
src_type_name
dst_type_name
dst_name
malformed_error

vm内では上記をつめて戻してくるのに対して、
libのレイヤーでもSetFieldではなく、argumentsのSetAtに変更。


r24982 | zra@google.com | 2013-07-13 08:22:50 +0900 (土, 13  7月 2013) | 11 lines
Begins implementation of ARM neon instructions.
Just adds the vadd instruction,
but also changes the arm assembler to expose the Q registers rather than the D registers.
Q0 = D1:D0 = S3:S2:S1:S0.
This is similar to how ia32 and x64 use only the xmm registers for floating point.
R=regis@google.com
Review URL: https://codereview.chromium.org//18684008
vaddqiの実装を追加
vaddqs
併せてQRegisterが追加
QRegisterを追加に伴い、QRegからDRegへの変換を追加して、
各所を置換し、いままでどおり動くようにしている。
QRegを使用したvaddqiとvaddqsはassemblerに追加されたが、UTのみで実コードではemitされない。


r24979 | zra@google.com | 2013-07-13 08:06:27 +0900 (土, 13  7月 2013) | 9 lines
Removes checks for stack overflow from arm and mips simulators
The checks were performed before runtime and native calls,
but if we abort on an assertion failure there, then we
never make it to the StackOverflow runtime call.
R=regis@google.com
Review URL: https://codereview.chromium.org//18704006
assertしなくなった。


r24977 | hausner@google.com | 2013-07-13 07:09:18 +0900 (土, 13  7月 2013) | 7 lines
Implement forwarding constructors for mixins By popular demand, fixes issue dartbug.com/9339
R=srdjan@google.com
Review URL: https://codereview.chromium.org//19023005
extends + mixinしたクラスの、extendsしたクラスのsuper constructorを呼べるようになった。
GenerateSuperConstructorCall()でforwarding_argsを引数に追加。
forwarding_argsってので、constructorの引数をとりあえずparseするらしい。


r24965 | regis@google.com | 2013-07-13 02:59:17 +0900 (土, 13  7月 2013) | 6 lines
Stop resolving classes prematurely in the vm (issue 11023).
Add missing class finalization to mirrors tests.
R=hausner@google.com
Review URL: https://codereview.chromium.org//19030004
でかい修正だな。。

mirrorとclass parseとfinalizer周りの修正
kTryResolve -> kResolveTypeParameters

基本的にはclassのresolveはfinalizerで行う
classが見つからない場合、ambiquity_errorを投げるようになった


r24962 | regis@google.com | 2013-07-13 02:37:38 +0900 (土, 13  7月 2013) | 5 lines
Fix type check elimination bug in code generator (issue 11792).
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18147021
dst_type.IsMalformed()を追加してまわった。


r24961 | srdjan@google.com | 2013-07-13 02:31:19 +0900 (土, 13  7月 2013) | 5 lines
Fix wrong type test optimization when testing against a signature class:
we must always consider the instance type arguments as well.
FIxes failing tests when run with --optimization-counter-threshold=5.
R=regis@google.com
Review URL: https://codereview.chromium.org//18807007
!type_class.IsSignatureClass()のチェックを挿入。


r24960 | zra@google.com | 2013-07-13 01:56:38 +0900 (土, 13  7月 2013) | 5 lines
Fixes bug in double to int conversion on arm.
R=regis@google.com
Review URL: https://codereview.chromium.org//18295007
double to intでNaNのチェックが足りなかった。
vcmpd
vmstatで確認


r24954 | fschneider@google.com | 2013-07-13 01:02:02 +0900 (土, 13  7月 2013) | 10 lines
Fix bug in the inliner when dealing with named optional parameters.
In case of a name mismatch the inliner would still inline the target
method as if nothing was wrong. Added a check that all actual named
arguments are matched against a formal parameter.

TEST=tests/language/named_parameters_with_conversions_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18170003
void -> bool AdjustForOptionalParameters()に変更。


r24953 | fschneider@google.com | 2013-07-13 00:50:24 +0900 (土, 13  7月 2013) | 13 lines
Guard against entering a noSuchMethod dispatcher twice into ICData.
This may occur in optimized code when called via the megamorphic cache miss handler.

For now, I fixed it by checking if there is already an entry in the IC data.
I'll discuss with Kevin how to handle the extraordinary cases like
noSuchMethod and implicit closure invocation in the megamorphic cache.

BUG=https://code.google.com/p/dart/issues/detail?id=11786
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18469003
AddReceiverCheck()が足りなかったのでcrashしていた。ので追加挿入。


r24939 | fschneider@google.com | 2013-07-12 17:27:35 +0900 (金, 12  7月 2013) | 12 lines
Prune variables that are not live at block entry from the environment.

If a variable is not live at a block entry,
replace it with the null-constant in the environment.
This can occur when there is a partially dead variable stores.

Fewer environment uses mean shorter live ranges and better register allocation.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18558008
!variable_liveness の場合、envの対応変数にconstant_nullを設定する


r24922 | srdjan@google.com | 2013-07-12 02:32:16 +0900 (金, 12  7月 2013) | 5 lines
List class was not initialized properly (it has type parameters).
Do not preinitialize it incorrectly, instead let it be loaded and finalized the normal way.
R=asiva@google.com
Review URL: https://codereview.chromium.org//18737004
List classの初期化の変更？


r24906 | fschneider@google.com | 2013-07-11 19:01:50 +0900 (木, 11  7月 2013) | 14 lines
Correct handling of named optional parameters with noSuchMethod invocations.

This CL fixes a performance bug with noSuchMethod and named parameters.
It also simplifies the platform-specific code by removing special casing
for the noSuchMethod-dispatcher functions in the flow graph compiler.

Before using named optional parameters would still go through the slow runtime in certain conditions:
When running without inlining, or when the dispatcher function was not inlined because of
e.g. inlining size heuristics, noSuchMethod would be slow if invoked with named parameters.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18209024
NoSuchMethodDispatcherでもArgumentDescriptorを使用するように全面的に修正。



r24900 | asiva@google.com | 2013-07-11 09:33:41 +0900 (木, 11  7月 2013) | 5 lines
Fix for issue 11770.
R=iposva@google.com, regis@google.com
Review URL: https://codereview.chromium.org//18881009
testの変更のみ。


r24896 | zra@google.com | 2013-07-11 08:45:18 +0900 (木, 11  7月 2013) | 5 lines
Implements OSR for arm and mips.
R=regis@google.com
Review URL: https://codereview.chromium.org//19017007
armでuse_osrできるようになった。
EmitFrameEntryで、LoadPoolPointer()を使っているのが、x86との違いかな。


r24895 | mlippautz@google.com | 2013-07-11 08:08:36 +0900 (木, 11  7月 2013) | 8 lines
Fix closure creation from function.
A closure created from a function should also inherit its token end position and result type.
R=hausner@google.com
Review URL: https://codereview.chromium.org//19021002
set_end_token_pos()を追加。closureにtoken_posの埋め込みをすると。


r24876 | fschneider@google.com | 2013-07-10 19:09:14 +0900 (水, 10  7月 2013) | 21 lines
Support fast noSuchMethod dispatch for any number of arguments.
Until now, the fast dispatch was only available with getters and zero argument methods.

This CL generalizes the approach to any number of arguments.
The dispatcher functions that are auto-generated by the compiler are not attached to the class anymore.
Instead the dispatcher is only stored in the IC data of each call site.
Each class contains a cache of dispatcher function that map
(name, arguments descriptor) => dispatcher.
This also fixes a bug where the VM report a wrong error message when throwing a NoSuchMethodError.
BUG=https://code.google.com/p/dart/issues/detail?id=11528
BUG=https://code.google.com/p/dart/issues/detail?id=11223
TEST=tests/language/no_such_method_dispatcher_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18097004
static CreateNoSuchMethodDispatcherをprivateなほうに移動。
ObjectStoreにキャッシュしておく。キャッシュは線形リスト。
Classのreceiverごとにキャッシュを生成しておく。
Getの際にnullだった場合に、CreateNoSuchMethodDispatcher()で生成してキャッシュする。

receiver_class.GetNoSuchMethoDispatcher()で呼び出すと。saved_args_desc()はセット。


r24872 | mlippautz@google.com | 2013-07-10 10:08:19 +0900 (水, 10  7月 2013) | 9 lines
Add a MirrorReference reflectee to MethodMirrors. Name getter now refers to
internal function object, providing a name for for all cases and not only for
the ones a name has been provided in the constructor.
Fixes http://dartbug.com/6335
R=asiva@google.com, rmacnak@google.com
Review URL: https://codereview.chromium.org//18473005
bootstrap_nativesに、MethodMirror_nameを追加
vmに他に修正はなし。


r24869 | asiva@google.com | 2013-07-10 09:24:53 +0900 (水, 10  7月 2013) | 10 lines
Fix for issue 11649:
- fields in type objects were being serialized as references but since we do
  a canonicalization of type objects this will not work. The fields need to
  be serialized as inlined objects.
- classes in the object store where being serialized incorrectly for script
  snapshots.
R=regis@google.com
Review URL: https://codereview.chromium.org//18946003
snapshotの修正
ReadObjectRef() -> readObjectImpl()

ObjectStoreの要素だった場合、
class_idだけでWrite/readできるっぽい。

snapshotではIsSingletonとかIsObjectStoreとかで判定していたけど、
今はSingleton含めてすべてObjectStoreに一元化しているはずなので。。


r24868 | srdjan@google.com | 2013-07-10 08:43:46 +0900 (水, 10  7月 2013) | 5 lines
FIx HasTypeArguments test.
R=asiva@google.com, regis@google.com
Review URL: https://codereview.chromium.org//18627003
HasTypeArguments
is_type_finalized -> is_finalized


r24864 | srdjan@google.com | 2013-07-10 05:45:32 +0900 (水, 10  7月 2013) | 5 lines
Fix 11701: method became huge because of inlining.
Add caller size threshold (50000 IR instructions). If exceeded, inlining stops.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//18271007
inlining_caller_size_threshold=50,000 を追加し、
あまりにでかくなる場合は抑止する。


r24861 | regis@google.com | 2013-07-10 04:35:56 +0900 (水, 10  7月 2013) | 7 lines
Support type parameters and classes as expression in the vm.
Turn many compile-time errors into runtime errors per latest spec.
Triage affected tests.
R=hausner@google.com
Review URL: https://codereview.chromium.org//18801007
nodeごとにinstantiateTypeを持てるようになった。

InstantiateTypeをIRに追加
AssignNodeを改造し、特定の条件や、TypeParameterを参照し、
CaptureInstantiator()

InstantiateTypeInstrは、Emit時にkInstantiateTypeRuntimeEntryを呼び出す
これは実行時にエラーチェックをする。

または、expressionのNoSuchMethodErrorも投げるようになったのかな。


r24845 | zra@google.com | 2013-07-10 00:19:47 +0900 (水, 10  7月 2013) | 5 lines
Removes undefined shifting behavior from BitVector::Equals.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//18341023
リファクタリングか


r24844 | johnmccutchan@google.com | 2013-07-09 23:59:01 +0900 (火, 09  7月 2013) | 5 lines
Call shutdown callback before the isolate is destroyed
R=asiva@google.com
Review URL: https://codereview.chromium.org//18862004
RunShutdownCallback()を追加した


r24841 | johnmccutchan@google.com | 2013-07-09 23:07:14 +0900 (火, 09  7月 2013) | 5 lines
JSONStream Print Dart Objects
R=iposva@google.com
Review URL: https://codereview.chromium.org//18472009
JSONStreamを開いて、Dart Objectの情報をPrintする
親のObjectに、virtual void PrintToJSONStream()を追加した。
内部の実装はまだ。


r24830 | hausner@google.com | 2013-07-09 07:40:35 +0900 (火, 09  7月 2013) | 11 lines
Generate better debugging info for actor phase check
The phase check was generated at a token position that was one token
past the end of the constructor body, which threw debugger clients off.
Fixes issue 8916.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18465007
最初に生成したbody_posを設定するように修正と。


r24826 | rmacnak@google.com | 2013-07-09 07:05:15 +0900 (火, 09  7月 2013) | 7 lines
Add a MirrorReference reflectee for ClassMirrors.
Rewrite the name accessor in terms of it, at least for the non-special cases.
(This is a continuation of 18562005.)
R=asiva@google.com
Review URL: https://codereview.chromium.org//18465006
ClassMirror_name
をbootstrapに追加
内部ではMirrorReferenceを使用している。

Api::UnwrapHandle(handle)
ってな具合で作成


r24822 | iposva@google.com | 2013-07-09 06:41:05 +0900 (火, 09  7月 2013) | 8 lines
Reland r24563 and r24564 with fixes cumbersome API leading to leaks.
- Add a WeakTable to the VM. This is used to remember the
  native peers registered through the Dart C API as well
  as assigning identity hashcodes to objects when needed.
- Use the hashcode to lookup entries in the Expando.
Review URL: https://codereview.chromium.org//18826007
WeakTableを追加
Heapを生成時に、WeakTableを、weak_selector=2の数だけ、newとoldそれぞれ用に作成する。
合計4個かな。

peerの代わりに、
SetValue(key, val)で登録できる。
keyからhashを生成し、OpenAddressingで配置。衝突したら隣へ(idx + 1)
Peerは以前はstd::mapだった。

Scavenger GCMarkerから、ProcessPeerReferents -> ProcessWeakTable()
hashtableだけど、Processの際は内部をidxで線形走査
Scavengerの場合は、CopyGC用にforwardしてSetWeakEntry() 要は再設定
GCMarkerの場合は、!IsMarkedなgc対象のobjをweak_entryから取り除く。

bootstrap_nativesに、Object_getHash, Object_setHashを追加
上記もpeerと同じくweak_tableを使用する。
ScavengerのSetHash() -> SetWeakEntry, GetHash() -> GetWeakEntryを呼び出す。
それぞれweak_tableへのSetValue


r24821 | regis@google.com | 2013-07-09 06:23:27 +0900 (火, 09  7月 2013) | 5 lines
Add missing store instruction in MIPS stub.
R=zra@google.com
Review URL: https://codereview.chromium.org//18282004
delay_slot()->swを追加


r24805 | hausner@google.com | 2013-07-09 01:48:51 +0900 (火, 09  7月 2013) | 7 lines
Small cleanup in parser
When creating the type of the receiver variable 'this', use the token position of the class.
R=regis@google.com
Review URL: https://codereview.chromium.org//18801005
ReceiverType()の引数がなくなった。。


r24801 | fschneider@google.com | 2013-07-09 01:27:46 +0900 (火, 09  7月 2013) | 5 lines
Inline native setters for length and data in the optimizer.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//18292003
GrowableObjectArray _setData, _setLengthをIRに変換した。
どちらもStoreVMFieldInstrにする。
これでDeltaBlueのスコアが若干上がったらしい。


r24762 | hausner@google.com | 2013-07-04 08:26:03 +0900 (木, 04  7月 2013) | 8 lines
Add debugging info for 'this'
Token range for 'this' was wrong in the debug info, so its value was
not shown in most functions. Fixes issue 11435.
R=regis@google.com
Review URL: https://codereview.chromium.org//18272027
receiverのtoken_posがごっちゃになっていたのかな。


r24749 | hausner@google.com | 2013-07-04 05:47:14 +0900 (木, 04  7月 2013) | 14 lines
Partial solution to analyze potentially constant expressions

This change adds code that detects if an expression can definitively
never be constant. We use this to analyze the initializer expressions
in const constructors. This check is not entirely water tight, but
together with the checks in canonicalization code catches most
illegal initializer expressions.

The const constructor of class Symbol turns out to be illegal. The
name verification check can't be part of the constructor code.
R=iposva@google.com
Review URL: https://codereview.chromium.org//18649003
constant expressionが部分的に実装
主にcomarisonとBinaryOpに対して。


r24736 | floitsch@google.com | 2013-07-04 03:02:11 +0900 (木, 04  7月 2013) | 11 lines
Relax method override restrictions.
This implements part of issue 11495.
BUG= http://dartbug.com/11495
R=regis@google.com
Committed: https://code.google.com/p/dart/source/detail?r=24731
Reverted: https://code.google.com/p/dart/source/detail?r=24733
Review URL: https://codereview.chromium.org//18600007
r24733 | floitsch@google.com | 2013-07-04 01:39:51 +0900 (木, 04  7月 2013) | 7 lines
Revert "Relax method override restrictions."
Revert "Update status file."
This reverts commit r24731.
This reverts commit r24732.
Review URL: https://codereview.chromium.org//18652002
r24731 | floitsch@google.com | 2013-07-04 01:20:05 +0900 (木, 04  7月 2013) | 8 lines
Relax method override restrictions.
This implements part of issue 11495.
BUG= http://dartbug.com/11495
R=regis@google.com
Review URL: https://codereview.chromium.org//18600007
optional named parameterのvalidationが削除された？
最終的にnoSuchMethodを投げろということか


r24726 | floitsch@google.com | 2013-07-03 23:51:30 +0900 (水, 03  7月 2013) | 6 lines
Add stackTrace to Error object.
R=lrn@google.com
Review URL: https://codereview.chromium.org//18529003
vm内はTODOコメント修正のみ。


r24712 | iposva@google.com | 2013-07-03 10:37:02 +0900 (水, 03  7月 2013) | 7 lines
Fix bug 11637:
- Handle repeated private name mangling which can been introduced with mixins.
R=rmacnak@google.com
mixinの際にmanglingがよくなかったのか。
mixinはmixinした順番にmangling済みクラス名を並べる


r24704 | hausner@google.com | 2013-07-03 05:09:24 +0900 (水, 03  7月 2013) | 8 lines
Const constructor must have const super initializer
Compile time error if a const constructor calls a non-const super
constructor (either explicitly or implicitly).
R=regis@google.com
Review URL: https://codereview.chromium.org//18558002
const constructorがconstだった場合、superもconstであることを求める。


r24697 | johnmccutchan@google.com | 2013-07-03 01:58:02 +0900 (水, 03  7月 2013) | 5 lines
JSONStream and tests
R=iposva@google.com
Review URL: https://codereview.chromium.org//18168003
vm/json_stream.ccを追加。
どこかで使っているわけではないが、今のjsonは既にあるオブジェクトをparseするだけなので、
stream系のAPIを追加する予定なのかな。
Print系のメソッドしか追加されていない。


r24694 | rmacnak@google.com | 2013-07-03 01:17:25 +0900 (水, 03  7月 2013) | 5 lines
Add a VM defined class VMReference as an opaque pointer for Dart code to VM internal objects.
R=asiva@google.com
Review URL: https://codereview.chromium.org//18242003
MirrorReference
を実装した。mirrorライブラリ用みたい。


r24691 | hausner@google.com | 2013-07-03 00:21:22 +0900 (水, 03  7月 2013) | 7 lines
Fix a debugger step regression
Fix stepping after hitting a user breakpoint.
R=devoncarew@google.com
Review URL: https://codereview.chromium.org//18435002
Steppingのタイミングがuserと設定と被っていたのか。。


r24648 | asiva@google.com | 2013-07-02 04:46:42 +0900 (火, 02  7月 2013) | 6 lines
Add Dart_GetSupertype to the dart debugger API so that the dartium
debugger interface can use this instead of Dart_GetSuperClass.
R=regis@google.com
Review URL: https://codereview.chromium.org//18238003
API Dart_GetSupertype()を追加
super_type_args_arrayを元に、instantiated_typeをかえす。


r24639 | zra@google.com | 2013-07-02 03:37:10 +0900 (火, 02  7月 2013) | 5 lines
Fixes ARM assembler test for hardware.
R=regis@google.com
Review URL: https://codereview.chromium.org//18326012
simulator使用時には、IntegerDivide()を実行しないように制御


r24635 | zra@google.com | 2013-07-02 02:44:09 +0900 (火, 02  7月 2013) | 5 lines
Adds support for integer division for ARM chips without the sdiv instruction.
R=regis@google.com
Review URL: https://codereview.chromium.org//18331006
ARMにIntegerDivide()を追加
integer_division_supported()の場合、sdivを実行。
そうでない場合、castを挟んでvdivdを使用する。

integer_division_supportedかどうか参照するために、
/proc/cpuinfoを参照して、文字列を探すと、、
V8もplatform-linuxで同じコードになっていた。


r24632 | hausner@google.com | 2013-07-02 02:29:18 +0900 (火, 02  7月 2013) | 9 lines
Better single stepping in VM debugger
Single stepping now steps into the next dart code that the
user is interested in, including from one asynchronous task to the next.
R=asiva@google.com
Review URL: https://codereview.chromium.org//17846009
SetSingleStep()ってのが追加
SingleStep()対象の関数は、optimizeの対象から外す。

JITコンパイルしたコードは、Isolateからstep_offset()のフラグが立っているかどうかで判定する。

VM側からは、debuggerへcallback()して制御を移す仕組みになっている。


r24616 | zra@google.com | 2013-06-29 08:48:13 +0900 (土, 29  6月 2013) | 5 lines
Optimize functions containing try-catch on MIPS.
R=regis@google.com
Review URL: https://codereview.chromium.org//18243002
r24615 | regis@google.com | 2013-06-29 08:09:34 +0900 (土, 29  6月 2013) | 5 lines
Optimize functions containing try-catch on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//18223010
EmitInstructionPrologue
MayThrowだったら、EmitTrySync

try-catchでは、localsやparametersをtry-catchのブロックごとに
stackへコピーするための領域を確保している。
try-catchの最適化は、
各ブロックごとにコピーした領域を作成せず、
既存のstackへ乗ったlocalsやparametersが格納されている領域を使いまわせ最適化なのかな。

そのために、EmitTrySyncは、
try-catchの中のブロックにおいて、location情報を更新する。
具体的には、コピーした領域を作成しようとするタイミングでは、
primitiveなデータがレジスタへ乗ったままの可能性があるため、
(1) registerに割り当てられたものは、Stackへpushし、pushされたstackをlocation情報に設定する。
(2) localsやparamertersをstackへそのままコピーするコードを生成するのではなく、
既存のstackのindexへlocation情報を張り直す。


r24612 | srdjan@google.com | 2013-06-29 07:30:59 +0900 (土, 29  6月 2013) | 5 lines
Fix 11574: Smi is a subtype of parametrizable Compare.
R=regis@google.com, zra@google.com
Review URL: https://codereview.chromium.org//18054022
intはscaleしていくので、IsSubtypeOf()で判定する。


r24598 | srdjan@google.com | 2013-06-29 02:41:51 +0900 (土, 29  6月 2013) | 3 lines
Fixed crash in EqualityCompareInstr::IsCheckedStrictEqual :
update unary_ic_data_ if ic_data_ is set at a later stage.
Review URL: https://codereview.chromium.org//18089019
r24592 | srdjan@google.com | 2013-06-29 01:15:50 +0900 (土, 29  6月 2013) | 5 lines
Equality can be converted to a strict equality with checks.
If the number of checks exceeds the threshold
(--max_equality_polymorphic_checks=32) use megamorphic dispatch instead.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//18053010
32って、、megamorphic dispatchとの閾値が32って、hash呼び出すmegamorphicが遅いのか。


r24583 | kmillikin@google.com | 2013-06-28 21:28:56 +0900 (金, 28  6月 2013) | 11 lines
Fix a VM bug in the handling of try/catch/finally.
In the case that code in the catch block threw in any fashion, the finally block was not executed.
Fix this by properly treating the finally block of try/catch/finally
as an exception handler for the catch block.
R=fschneider@google.com, srdjan@google.com
BUG=https://code.google.com/p/dart/issues/detail?id=430
Review URL: https://codereview.chromium.org//17893003
catch_blockがない場合
AllocateTryIndex()で生成して、set
CatchBlockEntryInstrを生成してくっつける。

finally_blockがない場合
contextをloadして例外を取得し、
stacktraceをRethrowする命令列を作成し、追加する。

r24565 | iposva@google.com | 2013-06-28 09:27:25 +0900 (金, 28  6月 2013) | 3 lines
- Revert r24564 and r24563 due to unexplained malloc corruption.
Review URL: https://codereview.chromium.org//18051007
r24564 | iposva@google.com | 2013-06-28 09:10:39 +0900 (金, 28  6月 2013) | 3 lines
- Fix compilation errors. Apparently clang != clang everywhere.
Review URL: https://codereview.chromium.org//18080007
for文を、int ループに変更

r24563 | iposva@google.com | 2013-06-28 09:01:47 +0900 (金, 28  6月 2013) | 8 lines
- Add a WeakTable to the VM. This is used to remember the native peers registered
  through the Dart C API as well as assigning identity hashcodes to objects when needed.
- Use the hashcode to lookup entries in the Expando.
R=asiva@google.com
Review URL: https://codereview.chromium.org//17992002
peerの代わりに、
weak_table.h .cppを追加。

scavenger GCMarkerから、ProcessWeakTable()になった。

WeakTable::SetValue(key, val)
keyからHashを生成
Peerは以前線形リストだったのが、HashTableに変わったと。


r24561 | zra@google.com | 2013-06-28 08:11:13 +0900 (金, 28  6月 2013) | 5 lines
Fixes bug in mips left shift.
R=regis@google.com
Review URL: https://codereview.chromium.org//18053013
mips向け、アセンブラの修正


r24557 | srdjan@google.com | 2013-06-28 06:52:49 +0900 (金, 28  6月 2013) | 5 lines
Split IdenticalWithNumberCheck in two versions:
once called from unoptimized  code the other called from optimzied code.
Only the one for unoptimized code will be able to stop for single stepping.
The optimized version is a leaf stub and cannot cause GC.
R=hausner@google.com
Review URL: https://codereview.chromium.org//18130004
Unoptimized版とOptimize版にわけて、stub生成。
これは全アーキテクチャ向けに修正してる。4並列メンテはきついっすね。
Optimized版のほうが引数の操作が多いですね。



r24556 | regis@google.com | 2013-06-28 06:51:55 +0900 (金, 28  6月 2013) | 5 lines
Remove obsolete #ifdefs excluding MIPS target.
R=zra@google.com
Review URL: https://codereview.chromium.org//18153002
ifdefを消してテストを有効にした。


r24549 | zra@google.com | 2013-06-28 05:46:28 +0900 (金, 28  6月 2013) | 5 lines
Fixes a bug in the mips Random_nextState intrinsic.
R=regis@google.com
Review URL: https://codereview.chromium.org//18141002
mipsのintrinsicsを修正。


r24548 | regis@google.com | 2013-06-28 05:16:53 +0900 (金, 28  6月 2013) | 5 lines
Fix Random_nextState intrinsic on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//18054006
armのアセンブラ修正



r24541 | zra@google.com | 2013-06-28 04:03:04 +0900 (金, 28  6月 2013) | 8 lines
Adds missing case in mips double comparison.
Also, adds mips and simmips to runtime benchmark script, and fixes up a status file.
R=regis@google.com
Review URL: https://codereview.chromium.org//18123003
mips向け
conditionを参照し、NEのケースを追加。


r24539 | iposva@google.com | 2013-06-28 03:37:53 +0900 (金, 28  6月 2013) | 6 lines
- Remove arguments definition test from the VM.
- Update tests still referring to it.
R=regis@google.com
Review URL: https://codereview.chromium.org//17977002
ArgumentDefinitionTestNodeを削除
ASTとFlowGraphBuilder IRなどなど
大量に削除してるけど、何か言語仕様かえたんだっけ


r24537 | iposva@google.com | 2013-06-28 02:40:35 +0900 (金, 28  6月 2013) | 6 lines
- Protect against icount_ overflow in the delay slot and only stop if a stop_sim_at value has been set.
R=zra@google.com
Review URL: https://codereview.chromium.org//18055006
mips simulator stop_sim_at != 0


r24524 | zra@google.com | 2013-06-28 01:42:39 +0900 (金, 28  6月 2013) | 5 lines
Implements external array access for mips.
R=regis@google.com
Review URL: https://codereview.chromium.org//17907005
mips向け


r24519 | srdjan@google.com | 2013-06-28 00:26:16 +0900 (金, 28  6月 2013) | 5 lines
Add --deoptimization_counter_inlining_threshold=10 that stops inlining in a method that has reached it.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17770003
いろいろオプション追加して最適化を制御。
deoptimization_counter_licm_threshold=8
deoptimization_counter_inlining_threshold=12


r24515 | fschneider@google.com | 2013-06-27 22:26:23 +0900 (木, 27  6月 2013) | 12 lines
Fix a bug in allocation sinking and load elimination.
1. Aliasing information was not computed for allocations that
   are never used in a LoadField instruction.
2. CanBeAliased was not correct in the case of a StoreVMField.
BUG=https://code.google.com/p/dart/issues/detail?id=11538
TEST=runtime/vm/flow_graph_optimizer.cc
R=vegorov@google.com
Review URL: https://codereview.chromium.org//18055004
identity()が未設定だった。
not CanBeAliased()のものだけ、sinking


r24504 | regis@google.com | 2013-06-27 09:49:49 +0900 (木, 27  6月 2013) | 6 lines
Hide parent function name in name of closurized function to user (issue 5436).
Hide implicit parameter of closure to user.
R=iposva@google.com
Review URL: https://codereview.chromium.org//17904009
bugfix
stacktraceでnot ImplicitClosureの名称が、見えていた


r24500 | srdjan@google.com | 2013-06-27 09:05:10 +0900 (木, 27  6月 2013) | 5 lines
Add two-byte string support in codeunitAt intrinsic.
R=regis@google.com
Review URL: https://codereview.chromium.org//17907003
try_two_byte_stringを追加。
one-byteはSmiUntagするが、two-byteはSmiUntagしない。


r24493 | regis@google.com | 2013-06-27 07:14:42 +0900 (木, 27  6月 2013) | 5 lines
Fix code for store buffer update on ARM and MIPS (link register was trashed).
R=zra@google.com
Review URL: https://codereview.chromium.org//17868006
R0のみStack Pushするコードから、R0以外をStack PushList/PopListするようにした。
armでは上記のほうがよいのでしょうかね。。


r24491 | asiva@google.com | 2013-06-27 06:30:18 +0900 (木, 27  6月 2013) | 5 lines
Convert implementation in mirrors.cc to use Dart_GetType instead of Dart_GetClass.
R=regis@google.com
Review URL: https://codereview.chromium.org//17582016
dart_apiを、引数がclazzからobjectに変更し、objectからclassを取得するようにした。


r24485 | regis@google.com | 2013-06-27 04:58:49 +0900 (木, 27  6月 2013) | 11 lines
Fix and simplify invocation of noSuchMethod on all platforms after the wrong
number (or bad name) of arguments is passed.
The frame of the wrong method (the one invoked with the wrong number or name of
arguments) is not left on the stack and therefore not visible in the stack trace
anymore, which is much cleaner, especially since the leftover frame was not
fully initialized.
This change was already done on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//17857008
r24475を他の他のアーキテクチャにも適応かな。


r24481 | zra@google.com | 2013-06-27 02:43:48 +0900 (木, 27  6月 2013) | 5 lines
Fixes integer negate intrinsic for arm and mips.
R=regis@google.com
Review URL: https://codereview.chromium.org//17847006
negate overflowしたらreturn falseするんだけど、途中の制御を修正。
flagに悪影響でもあったのか。
test
b
rsbs
bx
return false


r24475 | regis@google.com | 2013-06-27 01:31:53 +0900 (木, 27  6月 2013) | 11 lines
Fix and simplify invocation of noSuchMethod on ARM after the wrong number of arguments is passed.
The frame of the wrong method (the one invoked with the wrong number of arguments)
is not left on the stack and therefore not visible in the stack trace anymore,
which is much cleaner, especially since the leftover frame was not fully initialized.
Note: We should simplify this on other platforms as well.
R=zra@google.com
Review URL: https://codereview.chromium.org//17766005
noSuchMethodの制御をシンプルにした。


r24473 | zra@google.com | 2013-06-27 00:48:22 +0900 (木, 27  6月 2013) | 7 lines
Fixes floating point bug in ARM simulator.
Adjusts status files to match.
R=regis@google.com
Review URL: https://codereview.chromium.org//17742003
simarmの修正
simulatorで、int <-> sreg/dreg がうまく動かなかったらしい。


r24465 | kmillikin@google.com | 2013-06-26 21:36:44 +0900 (水, 26  6月 2013) | 7 lines
Remove an unused field in the AST.
The try_index of catch clauses was set but never read.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17873002
set_try_index系を削除


r24459 | fschneider@google.com | 2013-06-26 18:20:46 +0900 (水, 26  6月 2013) | 15 lines
Support type arguments for allocation sinking in certain conditions.

The type arguments are treated like a normal field that is initialized
with the type arguments passed to the allocation stub. This CL restricts
the optimization to the case where no instantiator is passed
(instantiator == kNoInstantiator). In this case the type arguments are
either a constant or loaded from a field.

Also: improve variable liveness analysis by pruning partially dead
variables from the environment. At the beginning of each block, all 
variables that are _not_ in live-in are replaced with null.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//16799003

StoreSinkingは、HasSimpleTypeArguments()で判定
ArgumentCount() == 0の場合行う。Arg1が定数かつSmiで、kNoInstantiatorだったら行う？
どういうケースだったかわすれた。。Dart VMがprimitiveとして用意している型だったらOKってことかな。

もしArg > 0の場合、type argumentsを取得しておく。stackに乗せたいので。

InsertMaterializations()にて
type argumentsを持つ場合、Fieldとして作成し、AddFieldする。


r24457 | fschneider@google.com | 2013-06-26 17:44:00 +0900 (水, 26  6月 2013) | 11 lines
Correctly deal with method invocation of a getter.
If getter lookup succeeds, but getter invocation throws
an exception, the result is the thrown exception and
not as previously noSuchMethod invocation.
BUG=https://code.google.com/p/dart/issues/detail?id=11512
TEST=tests/language/method_invocation_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17675002
下記を削除
-  // 3. If the getter threw an exception, treat it as no such method.
-  if (value.IsUnhandledException()) return false;


r24443 | iposva@google.com | 2013-06-26 08:38:45 +0900 (水, 26  6月 2013) | 3 lines
- Revert r24441 until issues found have been addressed.
Review URL: https://codereview.chromium.org//17769004
r24441 | iposva@google.com | 2013-06-26 08:04:19 +0900 (水, 26  6月 2013) | 6 lines
- Trial balloon for removal of argument definition test.
  This change removes the support for the ? operator.
R=asiva@google.com, hausner@google.com
Review URL: https://codereview.chromium.org//17765003
kCONDITIONALをparserから削除。


r24438 | srdjan@google.com | 2013-06-26 07:53:45 +0900 (水, 26  6月 2013) | 5 lines
Fix bot redness: max_calls can be zero if no call was actually executed.
R=iposva@google.com
Review URL: https://codereview.chromium.org//17749004
max_countが0の場合、ratio = 0.0に。


r24436 | srdjan@google.com | 2013-06-26 07:12:49 +0900 (水, 26  6月 2013) | 5 lines
Use call counts to determine which static calls to inline.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17646002
ぼちぼちstatic callの活用ぽい。
StaticCallのCallSiteごとにStaticCallInfoでratioを管理する。
max_count = CallSiteで発生するic_call[i~n]の合計
ratio = static_call_counts / max_count

今のところratioを面白く使っているわけではない。


r24433 | srdjan@google.com | 2013-06-26 06:31:37 +0900 (水, 26  6月 2013) | 7 lines
Remove skip_static_calls_ as it uses an obsolete way to check for uncalled static calls.
Will be replaced by ICData tracking.
Add two different PCDescriptors to differentiate between optimized and unoptimized static calls
(the former loads args. descr, the later loads ICData before calling).
Populate static call's ic_data field when optimizing.
R=asiva@google.com
Review URL: https://codereview.chromium.org//17723002
EmitStaticCall() -> EmitOptimizedStaticCall() //Optimizedのほうは、stub経由でなく、直接飛ぶ。

ExtractUncalledStaticCallDeoptIds()は削除され、
CodePatcherは、
GetInstanceCallAt()とGetUnoptimizedStaitcCallAt()を呼び出す。
どちらも同様の引数で、icが存在する。


r24427 | zra@google.com | 2013-06-26 03:58:47 +0900 (水, 26  6月 2013) | 5 lines
Fixes bugs in arm and mips intrinsifier.
R=regis@google.com
Review URL: https://codereview.chromium.org//17634003
math系やcast系のintrinsiferを実装。


r24426 | vegorov@google.com | 2013-06-26 03:50:26 +0900 (水, 26  6月 2013) | 11 lines
Refactor load forwarding pass to use a Place abstraction.
Place describes a location that code can load from or store to.
Start forwarding loads through phis.
Previously load forwarding operated directly on load instructions which complicated certain things
e.g. implementation of a hash map had to allow looking up a load instruction by store instruction,
forwarding through phis might have required introducing synthetic load instructions
to be put into the map.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//17101028
オプション trace_load_optimization=falseを追加
AliasedSetの仕組みを保持しつつ、BitVectorからPlaceクラスへ変更。
loop中で、phiを挟んで依存を解析する。
修正量が半端ない。

place_idってのを導入して、get/setできるようになった。
move from/toでコピーも可能。
location情報として、enum Kind
kNone
kField   <-- これはInstance内で、対象のInstanceが固定される場合かな。
kVMField <-- これは、対象のcontext内で、複数のInstanceが想定される場合かな。 
             いや、InstのVMField由来だった。
kIndexed
kContext

instは下記に分類
kLoadField          //kField
kStoreInstanceField //kField
kStoreVMField       //kVMField
kLoadStaticField    //kField
kStoreStaticField   //kField
kLoadIndexed        //kIndexed
kStoreIndexed       //kIndexed
kCurrentContext     //kContext
kChainContext       //kContext
kStoreContext       //kContext



r24422 | asiva@google.com | 2013-06-26 02:25:35 +0900 (水, 26  6月 2013) | 5 lines
Fix Dart_GetType to get the correct number of type arguments.
R=regis@google.com
Review URL: https://codereview.chromium.org//17617006
cls.NumTypeParameters() == 0 かつ cls.NumTypeArguments() != 0の場合、エラー


r24391 | fschneider@google.com | 2013-06-25 19:56:44 +0900 (火, 25  6月 2013) | 9 lines
Inline object constructor already in the method recognizer.

The call is replaced with "return null".
This allows us to always inline calls to "Object."
without extra overhead in the generic flow graph inliner.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//17624010
ObjectConstructorをRecongnizerに追加した。
"Object."のコンストラクタをRecognizerで処理し、IRに展開されるようになった。
その後、不要なIRは削除される。

r24377 | rmacnak@google.com | 2013-06-25 08:47:00 +0900 (火, 25  6月 2013) | 5 lines
Removed dead code: ConsumeIdentChar
R=asiva@google.com
Review URL: https://codereview.chromium.org//17609004
scannerのConsumeIdentChars()を削除。


r24374 | johnmccutchan@google.com | 2013-06-25 07:45:12 +0900 (火, 25  6月 2013) | 6 lines
Remove --disable_privacy
BUG=https://code.google.com/p/dart/issues/detail?id=11493
R=hausner@google.com
Review URL: https://codereview.chromium.org//17621003
オプションのdisable_privacyを削除。scannerで使われていた。


r24373 | asiva@google.com | 2013-06-25 07:41:01 +0900 (火, 25  6月 2013) | 10 lines
- Create isolate specific resuable handles and use them in the hot lookup paths.
- Create a ResuableHandleScope class which ensures that we do not end up
  recursively reusing handles leading to corruption.

This change shows Dart2JSCompileAll runtime change from 739931 to about
645035 on my local machine.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16174008
usesable_handle_scope_active()ってのを追加

handleの使用を効率化するための仕組み。
REUSABLE_HANDLE_LIST(V)を定義して、
handle != NULLを継続してチェックする。

+#define REUSABLE_HANDLE_LIST(V)                                                \
+  V(Object)                                                                    \
+  V(Array)                                                                     \
+  V(String)                                                                    \
+  V(Instance)                                                                  \
+  V(Function)                                                                  \
+  V(Field)                                                                     \
+  V(Class)                                                                     \
+  V(AbstractType)                                                              \
+  V(TypeParameter)                                                             \
+  V(TypeArguments)                                                             \
上記をlookupするメソッドが、頻繁にhandleを新規割り当てるのを抑止したい。
そのため、宣言したscopeでのみreuseされるhandleを用意したのだと思う。。
専用のReusableHandleは、Isolateのコンストラクタで生成し、デストラクタで消去する。


r24371 | johnmccutchan@google.com | 2013-06-25 07:12:53 +0900 (火, 25  6月 2013) | 6 lines
Preallocate objects in Dart::InitializeIsolate not in Api::CheckIsolateState
BUG=https://code.google.com/p/dart/issues/detail?id=11396
R=iposva@google.com
Review URL: https://codereview.chromium.org//17066009
PreallocateObjects()だったら、object_store()->sticky_error()


r24365 | zra@google.com | 2013-06-25 05:16:16 +0900 (火, 25  6月 2013) | 10 lines
Enables more tests for SIMMIPS.
. Fixes register allocation bugs
. Implements float <-> double conversion in assembler and simulator.
. Fixes floating point argument passing for simarm and simmips,
  and floating point return for simarm, and adjusts tests to match.
R=regis@google.com
Review URL: https://codereview.chromium.org//17502002
MIPS向け


r24361 | zra@google.com | 2013-06-25 03:38:46 +0900 (火, 25  6月 2013) | 7 lines
Allows exception object to be null in simarm and simmips.
Also, updates status files.
R=regis@google.com
Review URL: https://codereview.chromium.org//17587015
毎回set_register()を呼ぶ。


r24351 | fschneider@google.com | 2013-06-25 02:18:51 +0900 (火, 25  6月 2013) | 16 lines
Reland: Optimizing noSuchMethod invocation with no arguments.
This is the same CL as https://codereview.chromium.org/17315008/ with one bug fixed:

If a method is invoked with a mismatching number of arguments, we don't
add a no-such-method-dispatcher function since the dispatcher currently
can only invoke noSuchMethod and would not work if the method
is invoked with correct arguments at a later point.

I extended the test to cover that case.

TEST=tests/language/no_such_method_dispatcher_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17571010

r24284 | fschneider@google.com | 2013-06-21 20:56:32 +0900 (金, 21  6月 2013) | 5 lines
Back out r24266 to investigate dartium test failure.
TBR=kmillikin@google.com
Review URL: https://codereview.chromium.org//17074003
r24266 | fschneider@google.com | 2013-06-21 16:31:51 +0900 (金, 21  6月 2013) | 18 lines
Optimizing noSuchMethod invocation with no arguments.

On each call that triggers a noSuchMethod invocation we 
attach a custom dispatch function that allocates the 
invocation object and invokes noSuchMethod. This dispatcher
is compiled and optimized like a normal Dart function.

Similar to method-extractors, these implicit dispatchers
do not show up as normal functions.

As a first step this CL only handles invocations of getters
and methods with no like o.foo or o.foo().
This CL gives a >25x speedup of such noSuchMethod invocations.
Calls with multiple arguments still go through the slow path.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17315008
noSuchMethod invocationを高速化。
dart2jsよりだいぶ遅いとmlで言われていたのを改善したのかな。

RawFunction::kNoSuchMethodDispatcherを新規追加
ポイントはcode_generatorかな。
InstanceFunctionLookup()において、
引数が1つの場合、CreateNoSuchMethodDispatcher()でJIT生成したRawFunctionを
InvokeFunction()で呼び出すように変更。
引数が複数の場合、これまでどおりInvokeNoSuchMethod()


r24325 | vegorov@google.com | 2013-06-24 21:16:10 +0900 (月, 24  6月 2013) | 6 lines
Ensure that allocation sinking candidates are classified as not-aliased before final load forwarding.
R=fschneider@google.com
BUG=dart:11436
Review URL: https://codereview.chromium.org//17577007
kAliasedからkNotAliasedに書き換え、、


r24307 | srdjan@google.com | 2013-06-22 08:35:10 +0900 (土, 22  6月 2013) | 6 lines
Change static calls in unoptimized code to always call via a stub.
Using ICData, the call count of static calls is collected as well.
TODO: Use call frequency to guide inlining.
R=asiva@google.com, hausner@google.com, zra@google.com
Review URL: https://codereview.chromium.org//17554003
static callもICDataを使ってcountするように修正。
以前は、callsiteのdescriptorでカウントしていたのかな。
raw_objectに、RawArray ic_data_でclass-idsごとに、targetとcountを記録
static_callだけ特別扱いする必要がなくなるのかな。

EmitUnoptimizedStaticCall()を追加
flow_graph_compilerは、is_optmizing()を参照し、
EmitStaticCall か EmitUnoptimizedStaticCallをEmitする。

stub UnoptimizedStaticCallを追加
ic_dataを取得し、そこのカウントをインクリメントする。
target_is_compiledか確認して、コンパイルに飛ぶか、targetに飛ぶ。

以前mainのコードをfiboを例に解説したが、もうあんな簡単なコードではなくなった。

r24295 | zra@google.com | 2013-06-22 01:43:43 +0900 (土, 22  6月 2013) | 5 lines
In FiftyThreeBitOverflow, stores overflowing value as a string.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17550009
Integer iからString i_strに変換して格納するようにした。

r24265 | lrn@google.com | 2013-06-21 16:31:48 +0900 (金, 21  6月 2013) | 8 lines
Move FiftythreeBitOverflowError to VM-only patch file.
The class is not meaningful in the core library, and should go away once dart2js has integers.
R=floitsch@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//17361004
FiftythreeBitOverflowErrorはvm onlyと。。


r24252 | johnmccutchan@google.com | 2013-06-21 05:51:14 +0900 (金, 21  6月 2013) | 6 lines
Stop unwanted class finalization when using dart:io HttpClient from builtin.dart
BUG=11232
R=iposva@google.com
Review URL: https://codereview.chromium.org//17503002
isolateに以下を追加
BlockClassFinalization()
UnblockClassFinalization()
AllowClassFinalization()

ClassFinalizationがシンプルになったかな。

r24247 | asiva@google.com | 2013-06-21 04:49:30 +0900 (金, 21  6月 2013) | 5 lines
Minor cleanups to use null_array(), null_object() and null_string() handles.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17501003
Array::Handle()からObject::null_array()に置換。下の続きかな。


r24239 | srdjan@google.com | 2013-06-21 01:29:39 +0900 (金, 21  6月 2013) | 5 lines
Store arguments descriptor in ICData.
Remove loading of arguments descriptor at unoptimized call site (the ones using ICData).
R=asiva@google.com, zra@google.com
Review URL: https://codereview.chromium.org//17421003
GetInstanceCalAt()にarguments descriptor arrayを渡さない仕様にした。
大規模なリファクタリング


r24214 | kmillikin@google.com | 2013-06-20 19:17:34 +0900 (木, 20  6月 2013) | 10 lines
Fix a bug in graph construction for for loops.
A refactoring in SVN r24088 introduced a bug in for loops.  Loops with
continue in the body and an empty update expression list will lose the
edge from the continue to the loop entry.
R=fschneider@google.com
BUG=11375
Review URL: https://codereview.chromium.org//17491003
graph builderのbug fix


r24206 | zra@google.com | 2013-06-20 07:33:57 +0900 (木, 20  6月 2013) | 7 lines
Removes references to LIB_DIR from gyp files.
This eliminates the cirular dependency warnings from make.
R=iposva@google.com
Review URL: https://codereview.chromium.org//17288009
buildの変更

r24195 | asiva@google.com | 2013-06-20 03:20:55 +0900 (木, 20  6月 2013) | 8 lines
Fix for issue 11262.
- Add Dart_InstanceGetType
- Wire Dart_New, Dart_Invoke and Dart_[G|S]etField to use types
R=regis@google.com, vsm@google.com
Review URL: https://codereview.chromium.org//17390008
Dart_InstanceGetType(instance)を追加
dart apiの修正


r24191 | regis@google.com | 2013-06-20 01:21:27 +0900 (木, 20  6月 2013) | 5 lines
Fix more register allocation bugs in optimized code on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//17176004
arm向け register allocatorの修正？
SmiUntagをIPレジスタを使用して行う。
TMPレジスタの挿入も行っている。


r24189 | vsm@google.com | 2013-06-20 00:48:23 +0900 (木, 20  6月 2013) | 17 lines
Add Dart_Allocate to the C++ API
This change allows us to allocate Dart objects from C++ without
invoking a constructor.  In turn, it allows us to declare Dartium DOM
types with no public generative constructor.

Note, the current constructor has to be public as dart:html Element is
subclassed by dart:svg SvgElement (and eventually by user defined
custom elements as well).
This leads to unfortunate holes such as: https://code.google.com/p/dart/issues/detail?id=11277

This should also give a modest boost in DOM perf as the existing
constructor does absolutely nothing.

BUG=11277
R=asiva@google.com
Review URL: https://codereview.chromium.org//16968006
Dart_Allocate(type)を追加
Instance::New(cls)をApi::NewHandle()でwrapする


r24184 | kmillikin@google.com | 2013-06-19 22:56:48 +0900 (水, 19  6月 2013) | 8 lines
Fix a small bug in trace printing for discovered loops.
Loop blocks were printed with their preorder number, which is hard to
correlate to the graph.  Use the block id instead.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//17283006
FindLoop()をstatic関数からmethodにしたのか。


r24175 | kmillikin@google.com | 2013-06-19 18:21:25 +0900 (水, 19  6月 2013) | 9 lines
Scale the OSR optimization threshold by loop nesting depth.
For on-stack replacement (OSR), code quality is better if we optimize at
the outermost hot loop.  Track loop nesting depth and scale the
threshold based on the loop depth to prefer outer loops over inner ones.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17315006
CheckStackOverflowInstrに、loop_depthをパラメータとして与える。
Emitする際に、(loop_depth + 1) * optimization_counter_threshold
と比較して、usage_counterが超えればOSRする。
loop_depthを与えて、loop_depthが深いループのheaderほどOSRし難くなっている。


r24172 | regis@google.com | 2013-06-19 17:28:32 +0900 (水, 19  6月 2013) | 5 lines
Fix register allocation bug in optimized code on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//17348005
OneByteStringCid系で、inを2で与えていた?


r24164 | devoncarew@google.com | 2013-06-19 06:56:00 +0900 (水, 19  6月 2013) | 7 lines
Fix for an issue w/ breakpointResolved events not being sent.
Added tests for breakpointResolved events.
Added tests for handling toString() invocations throwing exceptions,
and extended debug_lib.dart to supported verifying values of local variables.
R=hausner@google.com
Review URL: https://codereview.chromium.org//17112010
debugger SignalBpResolvedを挿入


r24156 | asiva@google.com | 2013-06-19 03:37:49 +0900 (水, 19  6月 2013) | 3 lines
Fix build break (add correct return type in test).
Review URL: https://codereview.chromium.org//17286009
r24154 | asiva@google.com | 2013-06-19 02:47:15 +0900 (水, 19  6月 2013) | 7 lines
Fix for issue 11262.
Provide support for types in the Dart API.
R=regis@google.com
Review URL: https://codereview.chromium.org//17346002
Dart_GetType(library, class_name, num, type_arguments)を追加


r24152 | zra@google.com | 2013-06-19 01:47:43 +0900 (水, 19  6月 2013) | 5 lines
Fixes buggy FPU tests for MIPS hardware.
R=regis@google.com
Review URL: https://codereview.chromium.org//15874005
mips向け


r24147 | zra@google.com | 2013-06-19 00:51:27 +0900 (水, 19  6月 2013) | 7 lines
Enables co19 tests for SIMMIPS.
Also fixes a bug in division.
R=regis@google.com
Review URL: https://codereview.chromium.org//17312003
sll -> srl


r24132 | kmillikin@google.com | 2013-06-18 20:06:18 +0900 (火, 18  6月 2013) | 8 lines
Ensure we perform the same checks for all optimizing compilations.
Ensure that we perform the same checks for on-stack replacement (OSR)
as for normal optimizing compilation.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17183003
CanOptimizeFunction()を追加
条件を見ると、
breakpointを持つ場合、false
deoptが多いと、false
optimization_filterに含む場合、false
is_optimizable、false


r24112 | srdjan@google.com | 2013-06-18 07:36:32 +0900 (火, 18  6月 2013) | 5 lines
Fix crash in OSR with --optimization-counter-threshold=-1:
do not check for OSR if the optimizaiton is disabled.
R=asiva@google.com
Review URL: https://codereview.chromium.org//17311002
CanOSRFunction()を追加
内部ではCanOptimizeFunction()に置き換えた


r24105 | fschneider@google.com | 2013-06-18 02:35:00 +0900 (火, 18  6月 2013) | 9 lines
Fix bug in register allocation at catch entry blocks.
The registers used to pass the exception and the stacktrace values
need to be blocked at catch block entry until after the CatchEntry
instruction which stores them into local variables.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//17232004
register allocator
BlockLocationを作る際に、NextInstructionPosでスキップする。


r24103 | srdjan@google.com | 2013-06-18 02:31:00 +0900 (火, 18  6月 2013) | 5 lines
Cosmetic change: s/arg_descriptor/args_descriptor/
R=asiva@google.com
Review URL: https://codereview.chromium.org//17141004
rename


r24098 | zra@google.com | 2013-06-18 00:58:31 +0900 (火, 18  6月 2013) | 5 lines
Enables language tests for SIMMIPS.
R=regis@google.com
Review URL: https://codereview.chromium.org//17131002
mips向け


r24088 | kmillikin@google.com | 2013-06-17 20:05:15 +0900 (月, 17  6月 2013) | 12 lines
Reapply "Initial implementation of on-stack replacement (OSR)."
This reapplies SVN r24024 with a bugfix.

After OSR compilation, restore the pre-OSR code (which might be already
optimized) rather than the unoptimized code (which might have its entry
patched).  When the optimized code entry is patched it is only safe to call
it as a static call, not as an instance call.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//17233003


r24062 | asiva@google.com | 2013-06-15 08:47:40 +0900 (土, 15  6月 2013) | 10 lines
Split dart_api.h into multiple parts:
dart_api.h - Has the core API functions
dart_mirrors_api.h - Has API functions to support Mirrors or reflection
dart_native_api.h - Has parts which support the native message handling,
                 profilling and other internal tools
R=sgjesse@google.com, vsm@google.com
Review URL: https://codereview.chromium.org//16973003
修正量は多く見える。。
vm/mirror_api_implとvm/native_api_implに分割かな。
ヘッダ側は、include/dart_native_api.h include/dart_mirror_api.h
こちらはVMの外部公開用

include/dart_native_api.h
Message sending/receiving from native code
Profiling support
Heap Profiler
Verification Tools

include/dart_mirror_api.h
Classes and Interfaces Reflection
Function and Variables Reflection
Libraries Reflection
Closures Reflection
Metadata Reflection

include/dart_api.h
Handles
Garbage Collection Callbacks
Initialization and Globals
Isolates
Messages and Ports
Scopes
Objects
Query Object Type (Instances)


r24059 | srdjan@google.com | 2013-06-15 07:58:48 +0900 (土, 15  6月 2013) | 5 lines
Fix a bug in instance canonicalization and add debug mode checks that we are not missing any fields.
R=asiva@google.com
Review URL: https://codereview.chromium.org//17104002
r23934に追加で修正
DEBUG時にポインタを辿ってvalidか確認する処理を追加

Instance::CheckAndCanonicalizeFields()を、 | IsArrayとしていたのを切り離して、
似たような処理をArray::にも作った。
処理内容は23934のArray版


r24051 | hausner@google.com | 2013-06-15 06:16:46 +0900 (土, 15  6月 2013) | 7 lines
Remove support for + prefix in number literals
Also fix some tests that expected + prefix in hex numbers to be illegal.
According to our documentation, int.parse() accepts + for numbers in all formats/radixes.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17103002
TIGHTADD から ADDへ変更
0xをつけるとhexとみなしていたのね。


r24050 | gbracha@google.com | 2013-06-15 06:12:58 +0900 (土, 15  6月 2013) | 5 lines
Changes to mirrors in support of metadata access at runtime.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16757007
bootstrapにMirrors_metadataを追加
lib/mirror系では、メソッドを大きく変更。 metadataに対応しているらしい。
get metadata


r24048 | asiva@google.com | 2013-06-15 05:02:57 +0900 (土, 15  6月 2013) | 5 lines
Add test to check that IsArray returns true for immutable array objects.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//17099005
testの修正


r24044 | srdjan@google.com | 2013-06-15 03:15:49 +0900 (土, 15  6月 2013) | 5 lines
Split LoadStatic into two instructions: load static field, load value from static field.
This allows to canonicalize loads, thus reducing the number of inlined constants.
Has large benefit on x64 (DeltaBlue).
Note different register allocation spec for ia32,
otherwise large regression in DeltaBlue is introduced.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15973010
IRを分割した？
LoadStaticFieldInstrを修正。
->StaticField()を追加して、ConstantとしてBindされる。
そのConstantをレジスタ割付する？
定数として扱い、in,outのlocationを与えて、レジスタ割付される。
うまくいけばmovがreduceされるのかも。


r24033 | regis@google.com | 2013-06-15 01:22:00 +0900 (土, 15  6月 2013) | 7 lines
Fix left shift with constant on ARM.
Implement float array store on ARM.
Update status files.
R=zra@google.com
Review URL: https://codereview.chromium.org//16951018
ARM向けにIRを実装
LoadUntaggedInstr, offset() - heapObjectTag
TypedDataFloat32/64
SHRの実装。


r24025 | kmillikin@google.com | 2013-06-14 19:30:53 +0900 (金, 14  6月 2013) | 7 lines
Revert "Initial implementation of on-stack replacement (OSR)."
This reverts commit 24024.
TBR=fschneider@google.com
Review URL: https://codereview.chromium.org//16888013

r24024 | kmillikin@google.com | 2013-06-14 19:10:55 +0900 (金, 14  6月 2013) | 13 lines
Initial implementation of on-stack replacement (OSR).
Add profiling support to select OSR candidates and launch the compiler
for OSR, followed by entry to the function at the OSR entry point.

Implemented only on IA32 and X64.  The initial implementation can be
improved in various ways --- specifically: tuning of profiling
parameters and incorporation of feedback about the actual values seen
at OSR entry.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//16693006


r24012 | asiva@google.com | 2013-06-14 06:21:44 +0900 (金, 14  6月 2013) | 7 lines
Fix warning in dartium builds:
warning: converting to non-pointer type ‘uword {aka long unsigned int}’
from NULL [-Wconversion-null]
R=hausner@google.com
Review URL: https://codereview.chromium.org//17000003
return NULL -> 0L;


r24011 | fschneider@google.com | 2013-06-14 06:09:51 +0900 (金, 14  6月 2013) | 11 lines
Remove invalid assertion in the type propagator.
Apart from instances and type arguments and null, there can also be constants
with Class objects in the intermediate language. This occurs e.g. when building
an object allocation with bounds check (AllocateObjectWithBoundsCheckInstr).
BUG=https://code.google.com/p/dart/issues/detail?id=11278
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16982003
assertを1行削除。IsAbstractTypeArguments()を削除か。


r23989 | fschneider@google.com | 2013-06-14 00:52:33 +0900 (金, 14  6月 2013) | 10 lines
Revert r23330 and r23136 because of a bug with loop invariant code motion.
This CL temporarily remove deoptimzation history which was put in to prevent
repeated deoptimization caused by loop invariant code motion.
It caused illegal code motion under certain conditions.
BUG=https://code.google.com/p/dart/issues/detail?id=11245
TEST=tests/language/licm3_test.dart
Review URL: https://codereview.chromium.org//16844011
revert。。


r23975 | iposva@google.com | 2013-06-13 22:02:46 +0900 (木, 13  6月 2013) | 4 lines
- Make sure BoundedType and MixinAppType have a name.
- Reenable test from r23964.
Review URL: https://codereview.chromium.org//16924005
_BoundedTypeってのと_MixinAppTypeってのがsymbol追加
mixin向けの予約クラス？になった。


r23955 | fschneider@google.com | 2013-06-13 18:08:05 +0900 (木, 13  6月 2013) | 9 lines
Fix bug in constant propagation with double-equality.
Don't optimize x == x and x != x if x is a double:
x == x is not true, if x == NaN.
TEST=tests/language/arithmetic_test.dart
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//16853005
IsNumber -> IsIntegerに限定
doubleのNaN向け


r23959 | bak@google.com | 2013-06-13 18:24:18 +0900 (木, 13  6月 2013) | 5 lines
Changed "%d" to ""%"Pd for platform indenpent printing of intptr_t.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16954003
%d -> %"Pd"

r23958 | bak@google.com | 2013-06-13 18:16:36 +0900 (木, 13  6月 2013) | 5 lines
Added files absent from last commit.
R=ricow@google.com
Review URL: https://codereview.chromium.org//16816012
r23954 | bak@google.com | 2013-06-13 18:06:43 +0900 (木, 13  6月 2013) | 5 lines
Object histogramin the vm (--print-object-histogram).
Reviewed and LGTMed in:
https://codereview.chromium.org/16077018/
Review URL: https://codereview.chromium.org//16853006

Isolateのshutdown時に下記みたいに出力する。
Printing Object Histogram
____bytes___count_description____________
   294472    6181 _ObjectArray@0x36924d72, library 'dart:core'
   263696    8466 _OneByteString@0x36924d72, library 'dart:core'
   145712     283 `PcDescriptors`
   122048     325 `Instructions`
    95104    1486 `Function`
bytesがトータルのメモリ消費量。countがobjectの個数。 descriptionがclassId

GCからUpdateObjectHistgram()ってのが叩けるようになった。
OldGCの直後に、Updateする。

MagerGCが走るたびにUpdateを行うため、その度にbytesとcountを加算している。
そのため、最終的にprintする際に、累積のbytesとcountを、mager_gc_countで割る。


r23942 | srdjan@google.com | 2013-06-13 08:15:12 +0900 (木, 13  6月 2013) | 5 lines
When unwraping handles, verify only if --verify_handles. Fixes issue 11265,
R=asiva@google.com
Review URL: https://codereview.chromium.org//16816007
ValidHandle系をassertに追加


r23940 | srdjan@google.com | 2013-06-13 07:33:11 +0900 (木, 13  6月 2013) | 5 lines
One more premature load-static node generation solved.
R=hausner@google.com
Review URL: https://codereview.chromium.org//16835002
getter.IsNull()はLoadStaticFieldNode()
IsNull()でない場合、StaticGetterNode()を生成する。


r23934 | srdjan@google.com | 2013-06-13 06:27:37 +0900 (木, 13  6月 2013) | 5 lines
When canonicalize instances check if all fields are canonical.
If a field is a non-canonical number or strings, canonicalize it.
Otherwise report an error if a field is not canonical.
R=hausner@google.com
Review URL: https://codereview.chromium.org//16780009
Instance::CheckAndCanonicalize()

Canonicalizeで、すでに全フィールドがCanonicalize済みか判定して、Errorを返す可能性がある。
InstanceかつSmiでない かつ Canonicalizeされていない場合が該当する。
NumberとStringは例外で、StringはSymbolsにCanonicalizeする。
SmiかつNumberクラスは、fieldに埋め込みなので問題なし。

NumberかつSmiって制御は分かりがたいように思う。


r23920 | regis@google.com | 2013-06-13 01:57:06 +0900 (木, 13  6月 2013) | 7 lines
Fix decoding of object pool access in code patching on ARM.
Fix shift by zero and divide by one on ARM.
Update test status files.
R=zra@google.com
Review URL: https://codereview.chromium.org//16695007
truncate 0を修正？ arm向け


r23912 | hausner@google.com | 2013-06-13 00:44:57 +0900 (木, 13  6月 2013) | 5 lines
Reified metadata in the VM
R=asiva@google.com
Review URL: https://codereview.chromium.org//16780008
apiに、
Dart_GetMetadata()

内部では、主にparserを修正。
AddClassMetadata(cls, token_pos)
AddFieldMetadata(field, token_pos)
AddFunctionMetadata(func, token_pos)

RawString* MakeMetadataName(obj)

metadataのサンプルは、vm/object_test.ccにある
class, field, functionに付く
@metaclass
class Meta {}

@metafield
var aField;

@metafunc
void main() {}

metadataは、parserで解析して、token_posとstringにする。


r23911 | regis@google.com | 2013-06-13 00:35:55 +0900 (木, 13  6月 2013) | 5 lines
Fix comment about super type of Object class.
R=asiva@google.com
Review URL: https://codereview.chromium.org//16109016
commentのみ


r23901 | fschneider@google.com | 2013-06-12 19:27:13 +0900 (水, 12  6月 2013) | 16 lines
Make constant propagation to fold x == x and re-run type propagation for better range analysis.
1. When comparing numbers, or strict-comparing objects, this can be folded into
   true/false.  Since this often occurs after inlining and store-to-load forwarding,
   constant propagation is repeated after these phases. The pattern looks like:

o.x = o.y;
if (o.x == o.y) { ... }

2. Load elimination may introduce new phis that may have smi-type. In order to
   get range information for these phis, I added a second phase of type propagation after
   load elimination.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//16813002
range_analysisの前に、propagate_typesを呼び出す。
UnboxPhis()の削除。 SelectRepresentations()を再度呼び出す。
is_checked_strict_equal()への置き換え


r23899 | fschneider@google.com | 2013-06-12 18:31:31 +0900 (水, 12  6月 2013) | 9 lines
Don't double-count stack slots when compiling optimized try-catch.
The fixed slots used by try-catch are already accounted for in the
register allocator. This change avoids wasting unnecessary stack space
for optimized functions containing try-catch.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//16520006
StackSizeを、optimizedの場合、spill_slot_countだけ返す。
try-catchのとき何かやってたんだっけ。。


r23887 | zra@google.com | 2013-06-12 08:47:03 +0900 (水, 12  6月 2013) | 5 lines
Fixes small bug in a MIPS stub.
R=asiva@google.com
Review URL: https://codereview.chromium.org//16454010
mips
T0 -> A0


r23886 | asiva@google.com | 2013-06-12 08:07:57 +0900 (水, 12  6月 2013) | 5 lines
Fix issue 11214 avoid length overflow in String::ConcatAll
R=hausner@google.com
Review URL: https://codereview.chromium.org//16783003
result_lenのオーバーフローチェックを追加。object_store()->out_of_memory()を投げる。


r23884 | asiva@google.com | 2013-06-12 06:52:39 +0900 (水, 12  6月 2013) | 8 lines
Make ImmutableArray a sub class of AllStatic.
This enables Array to be a FINAL_HEAP_OBJECT and the operators
'=' and '^=' would be a simpler implementation which does not
require a call to initializeHandle().
R=iposva@google.com
Review URL: https://codereview.chromium.org//16390002
ImmutableArrayクラスが、ArrayからAllStaticへ。。
Stringと似た扱いのようで。
Class::New<ImmutableArray>()だったのが、Class::New<Array>(kImmutableArrayCid)


r23877 | zra@google.com | 2013-06-12 05:08:40 +0900 (水, 12  6月 2013) | 11 lines
Enables more VM tests for SIMMIPS.
Implements:
- Megamorphic instance calls
- Left-shift
- Equality
- and various bug-fixes.
R=regis@google.com
Review URL: https://codereview.chromium.org//15934025
mips向けの修正だが、以下のARM向けと同じかな。
23188相当
23307相当


r23868 | regis@google.com | 2013-06-12 01:47:01 +0900 (水, 12  6月 2013) | 7 lines
Switch code generation on ARM from softfp ABI to hardfp ABI.
Support leaf float runtime calls in ARM simulator.
Enable previously failing tests.
R=zra@google.com
Review URL: https://codereview.chromium.org//16638012
ARM DTMP D0 -> D15
ARM STMP S0 -> S30
LEAF_RUNTIME_ENTRYの引数に、argument_countを追加。2以下が制約。
countはRedirectionのためなのか。。


r23847 | regis@google.com | 2013-06-11 21:22:04 +0900 (火, 11  6月 2013) | 5 lines
Move code setting super type of class Object to null from object.cc to parser.cc
R=iposva@google.com
Review URL: https://codereview.chromium.org//16434015
ObjectClassでなければ、super_typeにType::ObjectType()を設定。


r23825 | srdjan@google.com | 2013-06-11 04:32:03 +0900 (火, 11  6月 2013) | 6 lines
Make AST generation deterministic: always call a static getter if it exists,
regardless if the statuic field was initialized or not.
Previously we may have created a LoadStaticFieldNode dependgin
if the static field was already intialized at compile time.
Note that we do not generate implicit static getter nodes if their initialization is trivial.
R=hausner@google.com
Review URL: https://codereview.chromium.org//16136014
parser
もしconstantの場合、必要であればinitializeしてreturn null
もしくは、const implicit getterもしくはnullに初期化済みの場合、return null
ただのimplicit getterの場合、StaticGetterNodeを作成して返す。


r23785 | asiva@google.com | 2013-06-08 09:47:35 +0900 (土, 08  6月 2013) | 6 lines
Create specific null read only handles for the frequently used types
Array, String, Instance, Object and use them.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16336021
ReadOnlyHandle()系をいろいろと作成して、cacheして使う。
null_object, null_array, null_string, null_instance, null_abstract_type_arguments

r23774 | zra@google.com | 2013-06-08 06:28:49 +0900 (土, 08  6月 2013) | 10 lines
Improvements to 53-bit overflow checking.
- Integer literals that require more than 53 bits will cause a compile-time error.
- Checking is added to unary negate for the case that the most negative 53-bit integer is negated.
- The tests are improved to also check optimized code.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16664003
定数のinteger literalの53-bit overflow checkingを追加。parseの際に実行
実行時にBigint作成時にThrow


r23751 | hausner@google.com | 2013-06-08 01:31:33 +0900 (土, 08  6月 2013) | 8 lines
BREAKING CHANGE: Remove === and !== in the VM compiler
This change is long overdue. Fixed the last places where we still used ===.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16398006
scannerから、===と!==のscanを削除。
NE_STRICTとEQ_STRICTが生成されなくなった。


r23746 | iposva@google.com | 2013-06-08 00:31:05 +0900 (土, 08  6月 2013) | 6 lines
- Unpoison stack for ASan when tearing down stack frames during exception handling.
R=kcc@google.com
Review URL: https://codereview.chromium.org//15836008
ASan用のシンボルをexceptionに追加


r23727 | fschneider@google.com | 2013-06-07 16:13:54 +0900 (金, 07  6月 2013) | 8 lines
Change allocation policy for smi-comparison RHS back to register-or-constant.
Allowing any operand often results in suboptimal code, i.e. a value stays
in a spill slot even though register may be beneficial.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//15735028
Locationの指定が、AnyOrConstant から RegisterOrConstant
に変更


r23721 | zra@google.com | 2013-06-07 07:48:20 +0900 (金, 07  6月 2013) | 5 lines
Implements checks for 53-bit overflow for x64.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16398008
BinarySmi::CanDeoptは、FLAG_throw_on_javascript_int_overflowする場合、return true
その場合、Emit53BitOverflowCheck()
整数系の演算には、すべてEmit53BitOverflowCheck()が埋め込まれていて、
オプションtrueを与えた場合に限りemitする


r23718 | zra@google.com | 2013-06-07 06:52:26 +0900 (金, 07  6月 2013) | 5 lines
Fixes small ARM bugs, and updates status files.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16054007
Double_toInt()
NaNチェックを追加
vcmpd(D0, D0) //D0 DartFirstVolatileFpuReg, DTMP Overlaps with STMP
vmstat(cond=AL)


r23710 | asiva@google.com | 2013-06-07 03:47:51 +0900 (金, 07  6月 2013) | 7 lines
- Remove the unvisited handles code from handles implementation as it is not used anywhere
- Added IsFreeListElement to RawObject
R=hausner@google.com
Review URL: https://codereview.chromium.org//15995034
IsFreeListElement()を追加。どこでも使って無いけど。
不要なHandleのコードを削除。主に.hから。


r23698 | srdjan@google.com | 2013-06-07 02:11:07 +0900 (金, 07  6月 2013) | 5 lines
Small fix and cleanups.
R=vegorov@google.com, zra@google.com
Review URL: https://codereview.chromium.org//16566003
field type feedbackの結果、type == nullの場合、dynamic型に推論する。


r23688 | fschneider@google.com | 2013-06-06 23:41:58 +0900 (木, 06  6月 2013) | 17 lines
Improve array bounds check elimination for growable lists.

Previously we could not eliminate bounds checks for
growable lists, even though the length is not modified.

This CL removes obsolete restrictions and enables elimination
of checks as long as the length does not change.

This restriction were there originally because the CheckArrayBounds
instruction loaded the length from the array itself. Now, the length-load
and the  actual check are split into separate instructions.
Tracking side-effects for normal loads determines can now determine if
the length-load is invariant.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//15984010
FixedLengthArray以外にも適用範囲を広げた。


r23678 | fschneider@google.com | 2013-06-06 21:32:42 +0900 (木, 06  6月 2013) | 9 lines
Simplify AST by extending LetNode and replace CommaNode.
LetNode now supports a list of expressions as the body.
The last expression is the result value of the let-expression.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//16146008
CommaNodeを削除

VisitLetNode()
num_temps>0の場合に、nodesのtempをスキャンして、append, DeallocateTempIndex(), DropTempInstr()


r23640 | zra@google.com | 2013-06-06 02:18:07 +0900 (木, 06  6月 2013) | 5 lines
Adds a flag to the standalone vm to throw an exception on 53-bit integer overflow.
R=asiva@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//15743017
throw_on_javascript_int_overflow=false オプションを追加

SupportsUnboxedMints()が有効になるのは、sse4_1 and not javascript int overflow
CORE_INTEGER_LIB_INTRINSIC_LIST(V)
に名称変更
FiftyTreeBitOverflow()という名前でいろいろと修正追加
javascript interop


r23637 | asiva@google.com | 2013-06-06 01:42:38 +0900 (木, 06  6月 2013) | 7 lines
Fix for issue 4638 in bitmap builder.
- Check for maximum size of byte offset and fatal out if it is larger.
- Convert some of the InRange asserts to actual checks.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16356009
bitmapのInRangeの修正かな？
assertでなくfalseを返すようになった。

r23636 | asiva@google.com | 2013-06-06 01:21:04 +0900 (木, 06  6月 2013) | 9 lines
Fix for issue 1755.
Use 'new' in all the snapshot reallocation functions instead of realloc.
This would result in program termination when allocation fails and will
ensure that a NULL will not be returned.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16271010
apiのallocator()からUtils::Realloc()を呼び出す。。

以前はrealloc()を呼び出していたが、Utils::Realloc()の中では、
ElementTypeを新規作成してmemmoveである。。
ElementTypeってのはtemplate引数

r23634 | vegorov@google.com | 2013-06-06 00:37:23 +0900 (木, 06  6月 2013) | 8 lines
Ensure that all phis inserted by load optimizer have consistent representation.
Revert r23619.
R=srdjan@google.com
BUG=dart:11048
Review URL: https://codereview.chromium.org//16430002
inline_size_threshold=22に戻った。。

optimizer.UnboxPhis();ってのが追加
bbの走査、instの走査、phiを見つけたら、UnboxPhi()

phiのunbox. UnboxedDouble, UnboxedFloat32x4, UnboxedUint32x4
これはSelectRepresentations()から処理を移したのかな

最後にInsertConversionsFor()
phiをunboxedしたので、predecessorの使用点を、unboxedしたinstからの使用点に置き換える。


r23631 | vegorov@google.com | 2013-06-05 23:26:25 +0900 (水, 05  6月 2013) | 6 lines
IfConverted should unuse inputs of the join it removes.
R=srdjan@google.com
BUG=dart:11087
Review URL: https://codereview.chromium.org//16423005
UnuseAllInputs()が抜けてた。


r23619 | srdjan@google.com | 2013-06-05 07:33:13 +0900 (水, 05  6月 2013) | 6 lines
Reduce inlining threshold as a temporary workaround for crashes (Issue 11048).
Remove unneeded definitions.
R=asiva@google.com
Review URL: https://codereview.chromium.org//16373003
inline_size_threshold=20 に変更


r23614 | srdjan@google.com | 2013-06-05 05:16:29 +0900 (水, 05  6月 2013) | 5 lines
Fix Issue 11047: use binary search instead of linear search to locate a pc-offset
in the static call table.
R=asiva@google.com
Review URL: https://codereview.chromium.org//16295022
BinarySearchInSCallTable()を新規追加
whileで回す再帰しない。
GetStaticCallTargetFunctionAt()
呼び出し先を探すのが、速くなったのか。。？


r23597 | fschneider@google.com | 2013-06-04 23:35:43 +0900 (火, 04  6月 2013) | 12 lines
Enable optimization of try-finally in the VM's optimizing compiler.
I changed the status of two co19 tests that crash with a stack overflow
because of recursion in dart2js. Optimized functions may take more stack
space, and this CL enables optimizations for more functions in dart2js.
I added smaller versions of those two tests to our own test suite.
BUG=dart:8857
R=ahe@google.com
Review URL: https://codereview.chromium.org//15934013
Finallyがある場合に、optimizetionを無効にしていた。
今は有効になっている。



r23584 | lrn@google.com | 2013-06-04 19:33:11 +0900 (火, 04  6月 2013) | 18 lines
Rename RuntimeError to CyclicIntializationError, as per spec.
The RuntimeError has been used to report cyclic initialization errors in dart2js.
It has also been used for other, unrelated, uses, where it makes little to no sense.
The RuntimeError type has been removed, but added in js_helper.dart, where dart2js uses it.
Uses of new RuntimeError("some message") have been converted to
other errors (Argument/State/Unsupported). In some cases, just
throwing a String might have been just as good.
BUG=http://dartbug.com/11040
R=johnniwinther@google.com
Review URL: https://codereview.chromium.org//16154017
testのみ


r23571 | asiva@google.com | 2013-06-04 08:57:36 +0900 (火, 04  6月 2013) | 5 lines
Cache the isolate pointer in the parser object.
R=hausner@google.com
Review URL: https://codereview.chromium.org//16325014
parserでcurrent isolateのpointerをcache
毎回Isolate::Current()を唱えないように


r23553 | fschneider@google.com | 2013-06-04 02:09:09 +0900 (火, 04  6月 2013) | 16 lines
Fix two bugs in the Dart VM's super-noSuchMethod invocation.
1. The result value of an expression 
   "super.someMissingSetter = val" was incorrect in case of a noSuchMethod call.

To fix this I refactored the BuildStaticNoSuchMethod function. It now no longer
creates AST nodes and visits them, because the last argument may be needed saved
as a result value.

2. The evaluation order of "super[e1] = e2" was wrong in case of a noSuchMethod call.

BUG=dart:8917, dart:10965
TEST=tests/language/super_operator_index7_test.dart, tests/language/super_operator_index8_test.dart
R=srdjan@google.com
Review URL: https://codereview.chromium.org//15979010
ParsedFunction& からParserdFunction*へ変更
args_array->AddElement()
EnsureExpressionTemp()の新規追加

大部分はFlowGraphBuilderの修正かな。


r23551 | fschneider@google.com | 2013-06-04 01:56:45 +0900 (火, 04  6月 2013) | 9 lines
Avoid duplicate class-id checks in checked-strict equality operations.
The original IC data with two argument checks have to be converted to unary
checks before emitting code. Otherwise, there may be duplicate class-id checks.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16325011
original IC dataと比較するようにしたと。


r23509 | asiva@google.com | 2013-06-01 09:41:24 +0900 (土, 01  6月 2013) | 5 lines
Simplyfy the NumTypeArguments check.
R=regis@google.com
Review URL: https://codereview.chromium.org//16286002
Handleまわりを整理


r23506 | regis@google.com | 2013-06-01 08:51:38 +0900 (土, 01  6月 2013) | 6 lines
Fix leaf floating point runtime calls on ARM (work still needed in simulator).
Various cleanups.
R=zra@google.com
Review URL: https://codereview.chromium.org//15945006
D0とS0を、FPのScratchRegisterとして使うと。
LeafRuntimeCallでは、上記を使う。


r23502 | asiva@google.com | 2013-06-01 07:55:29 +0900 (土, 01  6月 2013) | 10 lines
More cleanup to avoid creation of redundant handles
- create read only handles for null object and sentinel smi value
- add a RawCast function to allow direct casting of Raw pointers without the
  need to create a Handle for it
- use Smi::Value where possible
- hoist out handle creation from some loops
RawCast()を追加。
Handle系の処理を、RawCastを使ってシンプルにした。


r23489 | zra@google.com | 2013-06-01 06:03:41 +0900 (土, 01  6月 2013) | 8 lines
Implements intrinsics for MIPS.
Also, adds the MADD, MADDU, MTLO, MTHI instructions
to the MIPS simulator, assembler, and disassembler.
R=regis@google.com
Review URL: https://codereview.chromium.org//16272004
MIPS向けに追加


r23484 | zra@google.com | 2013-06-01 03:41:41 +0900 (土, 01  6月 2013) | 5 lines
Changes to run "Hello, world!" on MIPS hardware.
R=regis@google.com
Review URL: https://codereview.chromium.org//16160013
MIPS向けに追加


r23476 | iposva@google.com | 2013-06-01 01:36:27 +0900 (土, 01  6月 2013) | 7 lines
- Modify dart_api.h to be a proper C API.
- Verify that dart_api.h can be used from C by changing the test_extension to be a pure C file.
R=asiva@google.com
Review URL: https://codereview.chromium.org//15689013
リファクタリング


r23448 | regis@google.com | 2013-05-31 09:38:21 +0900 (金, 31  5月 2013) | 6 lines
Enable language tests on SIMARM and mark 14 of them as failing.
Implement more features on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//16244007

IRを実装。
ArgumentDefinitionTestInstr
StringFromCharCodeInstr
AllocateObjectWithBoundCheckInstr
CloneContextInstr
MathSqrtInstr
SmiToDoubleInstr
DoubleToIntegerInstr
DoubleToSmiInstr
DoubleToDoubleInstr
InvokeMathCFunctionInstr

EmitSuperEqualityCallPrologue


r23436 | iposva@google.com | 2013-05-31 03:52:06 +0900 (金, 31  5月 2013) | 3 lines
- Adjust parameter types for Dart_NewWeakReferenceSet implementation.
Review URL: https://codereview.chromium.org//16247002
所々をHandleからWeakPersistentHandleに置き換え

r23421 | iposva@google.com | 2013-05-31 00:55:59 +0900 (金, 31  5月 2013) | 7 lines
- Add different types for persistent and weak persistent handles in the Dart C API.
- Adapt code in the runtime.
R=asiva@google.com
Review URL: https://codereview.chromium.org//15772005
C API向けの追加のHandle

dart_api_impl
Handleに、True, False Nullを追加

Handleに追加。
Persistent 内部ではPersistentHandle
WeakPersistent 内部ではFinalizablePersistentHandle

上記はいずれも、FreeHandle()で削除するぽい。Weakは後からGCされるはず。
DeletePersistantHandle
DeleteWeakPersistantHandle
PersistantHandleの場合、free_listにつなぐだけ。
Weakのほうは、rawとpeerとcallbackをnullに設定してfree_listにつなぐ。

normalとweakって何が違うんだっけ。
weakはpeerとcallbackがあるだけのようだけど、本当か？
クラス上の差異はないんだけど、、とおもったら、GCのVisitWeakPersistentHandles()
がmarkの起点に存在したので、これか。
Javaっぽく、Weakが参照持たなくなったら開放するのか。
Dart API的にはDeleteしないと内部が空にならない仕組み？

peerとcallbackなくなた？

r23402 | fschneider@google.com | 2013-05-30 21:25:39 +0900 (木, 30  5月 2013) | 5 lines
Fix warning about an unused private field.
TBR=vegorov@google.com
Review URL: https://codereview.chromium.org//15861025
value_を削除


r23401 | fschneider@google.com | 2013-05-30 21:19:21 +0900 (木, 30  5月 2013) | 19 lines
Eliminate temporary locals for some expressions

This CL affects a subset of expressions that use temporary locals: constructor
calls, array literals and and instance getter postfix-ops.

For expressions that are de-sugared in the parser I added LetNode.
It creates a scoped temporary local bound to an initializing expression.

For expressions where we need a temporary local at graph-building time,
I added a helper class TempLocalScope to easily create a single temporary
local in the graph builder since this is a frequently recurring pattern.

This simplifies code in the parser and the graph builder and also fixes a
bug with indexed-super invocation and NoSuchMethod.

BUG=dart:8918
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//14942010
bugfix:8918
LetNodeってなんだ、、contextを追加してローカル変数作成？
(super[0] = 42)って記述に対応すると？

解釈的には、新しいcontext内で完結するローカル変数を構築する際に、
一時的にcontextを作ってそこにローカル変数をpushする。

一時的なローカル変数をIRとして用意し、builderで構築
PushTempInstr
DropTempsInstr


r23375 | asiva@google.com | 2013-05-30 10:24:09 +0900 (木, 30  5月 2013) | 5 lines
More cleanup based on profile information.
R=iposva@google.com
Review URL: https://codereview.chromium.org//16163010
プロファイル情報を参照して、
不要なHandleを除去しているらしい。

r23373 | asiva@google.com | 2013-05-30 10:21:49 +0900 (木, 30  5月 2013) | 5 lines
Inline handle allocation.
R=hausner@google.com
Review URL: https://codereview.chromium.org//15950010
AllocateHandle() にinlineをつけた。


r23370 | regis@google.com | 2013-05-30 08:12:20 +0900 (木, 30  5月 2013) | 7 lines
Implement a few more features on ARM.
The vm tests byte_array_test and byte_array_optimized_test still fail due to
an inlining bug on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//15899010
intrinsicsのバグ取り
各種IRの実装。
BinarySmi
CheckEitherNonSmiInstr
BoxDoubleInstr
UnboxDoubleInstr
BinaryDoubleInstr
UnarySmiOpInstr


r23367 | zra@google.com | 2013-05-30 06:31:27 +0900 (木, 30  5月 2013) | 8 lines
Removes ARM mrc instruction.
It is a privileged instruction and was only being used in tests running on the simulator.
R=regis@google.com
Review URL: https://codereview.chromium.org//16194010
mrcを削除。mrcでARMのISAを確認していた。
何も見なくていいのか？

r23350 | srdjan@google.com | 2013-05-29 22:07:46 +0900 (水, 29  5月 2013) | 7 lines
Fix issue 3874:
non-deterministic AST generation caused by exceptions being thrown during parsing (StackOverFlow).
Mark functions that throw and exception as non-optimizable.
Fix flow graph printing (optimized vs non-optimized).
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15904010
set_is_optimizable(false)を設定する。
おもに、parserでIsUnhandledException()した場合と、ast perse時にerror起きたとき。


r23330 | fschneider@google.com | 2013-05-29 18:11:23 +0900 (水, 29  5月 2013) | 7 lines
Add a helper function for allocation of deoptimization history.
This CL addresses DBC comments from my previous CL (https://codereview.chromium.org/15779006/)
R=srdjan@google.com
Review URL: https://codereview.chromium.org//16099007
EnsureDeoptHistory()ってので綺麗にした。


r23322 | sgjesse@google.com | 2013-05-29 16:29:29 +0900 (水, 29  5月 2013) | 8 lines
Remove library dart:crypto
Moved the contnet of dart:crypto to the package pkg/crypto.
R=dgrove@google.com, floitsch@google.com, iposva@google.com, nweiz@google.com
Review URL: https://codereview.chromium.org//15820008
crypto_libraryをobject_storeから除去。


r23311 | zra@google.com | 2013-05-29 07:55:51 +0900 (水, 29  5月 2013) | 5 lines
Implements intrinsics for ARM.
R=regis@google.com
Review URL: https://codereview.chromium.org//15822008
arm版の
inline_allocを実装

ObjectArray_Allocate()を実装

kMaxElementsより大きければ、失敗。
ObjectArrayでは、
objectheader
type arguments
length
の順に埋め込む。
その後、raw_nullで全初期化。ループでraw_nullを埋める。

で、setIndexed()の際に、
enable_type_checksが有効である場合、
TypeArgumentsを取り出して、型チェックすると。。

TYPED_ARRAY_ALLOCATIONってのもある。
こちらは、0で初期化する。

以降も大量のARM Intrinsicsが続く。
余裕があれば全部コードおってもいいかも

あとは文字列系が見たいかも


r23307 | regis@google.com | 2013-05-29 06:10:32 +0900 (水, 29  5月 2013) | 6 lines
Implement shift left on ARM and re-enable previously disabled test.
Fix bug on ia32 and x64.
R=zra@google.com
Review URL: https://codereview.chromium.org//15827006
EmitSmiShiftLeft()

0x1Fより大きい場合、mov 0か
result がMintの場合、deopt。
OptimizerのUNIMPLEMENTEDが除去されていく。

r23293 | regis@google.com | 2013-05-29 02:14:47 +0900 (水, 29  5月 2013) | 5 lines
Fix equality code on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//16048002
stackへのPush Dropを整理したのかな。

r23266 | sgjesse@google.com | 2013-05-28 22:35:01 +0900 (火, 28  5月 2013) | 20 lines
Merge the dart:uri library into dart:core and update the Uri class
This merges the dart:uri library into dart:core removing the dart:uri library.
Besides moving the library the Url class has been changed.
* Removed existing Uri constructor as it was equivalent with Uri.parse
* Remamed constructor Uri.fromComponents to Uri
* Moved toplevel function encodeUriComponent to static method Uri.encodeComponent
* Moved toplevel function decodeUriComponent to static method Uri.decodeComponent
* Moved toplevel function encodeUri to static method Uri.encodeFull
* Moved toplevel function decodeUri to static method Uri.decodeFull
* Rename domain to host
* Added static methods Uri.encodeQueryComponent and Uri.decodeQueryComponent
* Added support for path generation and splitting
* Added support for query generation and splitting
* Added some level of normalization
R=floitsch@google.com, lrn@google.com, nweiz@google.com, scheglov@google.com
Review URL: https://codereview.chromium.org//16019002
vmでは、uriライブラリをobject_storeから削除するのみ。

r23249 | srdjan@google.com | 2013-05-28 19:44:02 +0900 (火, 28  5月 2013) | 5 lines
Use stack locations instead of register for binary Smi operations when possible.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//16126003
BinarySmiOperationをaddressを引数にとれるように修正。
Locationに、PreferRegisterを追加
IsStackSlot()で確認し、上記で追加したaddressを引数にとるBinarySmiOperationを実行する。
Register割付にてをいれているわけではないので、
たまたまstackに割付いていれば効果があるのかな。


r23243 | fschneider@google.com | 2013-05-28 18:30:43 +0900 (火, 28  5月 2013) | 11 lines
Remove pseudo-node from LoadLocalNode and replace it with a proper AST node.
The newly introduces CommaNode denotes a sequence of two nodes, the result
is the value of the second child node.
There are only two places where the pseudo-node was used, and therefore
it does not warrant adding an extra member to all LoadLocalNode objects.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15935005
LoadLocalNodeのPseudoがなくなって、、
CommaNodeってので置き換えた。用途不明だな。

r23214 | fschneider@google.com | 2013-05-27 20:43:19 +0900 (月, 27  5月 2013) | 5 lines
Small code cleanup in the parser.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15987003
制御ちょっとかえた。


r23213 | kmillikin@google.com | 2013-05-27 20:31:27 +0900 (月, 27  5月 2013) | 8 lines
Do not emit duplicate deoptimization entries for GotoInstr.
This is the uncontroversial part of https://codereview.chromium.org/15741002/
R=fschneider@google.com
Review URL: https://codereview.chromium.org//16020013
CanBecomeDeoptimizationTarget()に変更
GotoInstr::EmitのAddCurrentDescriptor()を削減

r23209 | fschneider@google.com | 2013-05-27 19:19:49 +0900 (月, 27  5月 2013) | 9 lines
Streamline IL for instantiating type arguments.
In some cases we would emit a InstantiateTypeArguments IL instruction that was a no-op.
This CL avoids this instruction when building the graph,
instead of emitting an empty instruction in the back-end.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15960009
type argumentsの修正を、全Archに行った。
builder側にifを移動して、条件下でBind


r23190 | zra@google.com | 2013-05-25 08:45:41 +0900 (土, 25  5月 2013) | 15 lines
Enables optimization on MIPS
- Exposes double precision rather than single precision floating point registers
  to architecture generic code. This entails a mechanical change in the assembler
  to floating point instructions.
- Adds slti, sltiu instructions for comparison with small immediates, and uses
  them in the Branch(Un)Signed* macros.
- Fixes a bug in the intermediate language comparison/branching instructions
  caused by using subu for comparison. Now it uses two slt instructions.
- Fixes register use bugs in intermediate language.
- More uses of NULLREG instead of loading Object::null()
R=regis@google.com
Review URL: https://codereview.chromium.org//16022011
mips向けも同様に実装。

r23189 | asiva@google.com | 2013-05-25 08:42:01 +0900 (土, 25  5月 2013) | 5 lines
More cleanups to avoid Handle creation in hot paths.
R=iposva@google.com
Review URL: https://codereview.chromium.org//15951003
リファクタリングで処理を共通化。
CheckFunctionType()
LookupFunction()
LookupFunctionAllowPrivate()
LookupField()


r23188 | regis@google.com | 2013-05-25 07:50:05 +0900 (土, 25  5月 2013) | 5 lines
Fix MegamorphicMiss stub on ARM.
R=zra@google.com
Review URL: https://codereview.chromium.org//15937010
r23169 | regis@google.com | 2013-05-25 03:52:34 +0900 (土, 25  5月 2013) | 9 lines
Fix a bug in optimized ARM code.
Fix a bug in deoptimization (wrong stack layout assumption, worked on Intel by chance).
Implement megamorphic instance call on ARM.
Improve line number reporting in simulator backtraces.
R=zra@google.com
Review URL: https://codereview.chromium.org//15692005
ARMにmegamorphic instance callを実装。megamorphicは、cacheをhash引きしてtargetを呼び出す実装。
PushList R0 R1がdeoptに追加した処理か。

r23153 | hausner@google.com | 2013-05-25 01:26:42 +0900 (土, 25  5月 2013) | 10 lines
Allow breakpoints on strict equal
The compiler turns equality checks with null into
strict equal comparisons. Make the compiler backend
create a pc descriptor for the runtime call so that
the debugger can break on x == null and x != null.
R=regis@google.com
Review URL: https://codereview.chromium.org//15946002
ComparisonInstrにtoken_posを引数で渡して、
最終的にAddCurrentDescriptor()をEmit


r23151 | zra@google.com | 2013-05-25 00:45:17 +0900 (土, 25  5月 2013) | 7 lines
Ensures that Bigints returned to Dart are all checked by Integer::AsValidInteger.
Rather than by ad-hoc checks at the point of return.
R=iposva@google.com
Review URL: https://codereview.chromium.org//15741019
Integerを生成する際に、
int64_tに収まるか判定し、収まらないのであればBigInt
収まればMint or Smiを生成する。
という処理をまとめた、NewFromUint64()を追加


r23142 | fschneider@google.com | 2013-05-24 21:52:44 +0900 (金, 24  5月 2013) | 5 lines
Support inlining function containing throw in the optimizer.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15730003
throwが1個あった場合にinliningにチャレンジすると。

throwがあった場合、固有の処理として、何かある？？？todo



r23136 | fschneider@google.com | 2013-05-24 21:03:40 +0900 (金, 24  5月 2013) | 11 lines
Add deoptimization history to optimized functions.
Each function that is optimized or inlined into an optimized
functions keeps an array of deoptimization ids.
This history is used to avoid repeated deoptimization caused by
speculative hoisting of check instructions.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15779006
deopt_historyを新規作成。
set_deopt_history()
deopt_hisotryはfunctionが保持する。

MayHoist()ってのではhistoryを参照し、
過去にdeoptの原因となっていたらhoistしない。


r23117 | asiva@google.com | 2013-05-24 09:39:59 +0900 (金, 24  5月 2013) | 6 lines
Remove checks for Expect and ExpectException from
Parser::ResolveNameInCurrentLibraryScope
R=iposva@google.com
Review URL: https://codereview.chromium.org//15934003
vm/parser
Expect ExpectExceptionを削除


r23115 | asiva@google.com | 2013-05-24 09:13:10 +0900 (金, 24  5月 2013) | 24 lines
Delay Class parsing until the class is actually used.
Prior to this change the initial heap sizes were as follows:
ia32:
Size of isolate snapshot = 1230921
New space (0k of 32768k) Old space (1446k of 1604k)

X64:
Size of isolate snapshot = 1223943
New space (0k of 32768k) Old space (2630k of 2692k)

After this change the initial heap sizes are as follows:
ia32:
Size of isolate snapshot = 686443
New space (0k of 32768k) Old space (677k of 836k)

X64:
Size of isolate snapshot = 684731
New space (0k of 32768k) Old space (1220k of 1412k)

R=hausner@google.com, iposva@google.com, regis@google.com
Review URL: https://codereview.chromium.org//14820028
どちらもold space削減ですね。。
オプション trace_class_finalization

EnsureIsFinalized()からたどればよいのかな。

objectにstate_bitsを追加している。
is_type_finalized()やismarked_for_parsing()で参照されている。
state_bitsに、PatchBitとSynthesizedClassBit TypeFinalizedBit MarkedForParsingBit
が追加されている。

!is_synthesized_class
の場合はParseしない。

ParseClassDefinition, Declarationってのがある。
kOld領域を占めているのはpending_classesっていうArray

Compiler::CompileClass()を新規追加している。ParseClass()を呼び出す。
内部では上記色々なフラグを参照して制御する。

Parseを遅らせても、snapshotからの起動速度はほとんど遅くならないということなのかな。


r23110 | asiva@google.com | 2013-05-24 07:59:26 +0900 (金, 24  5月 2013) | 6 lines
- Allocate symbols for 'get:' and 'set:'
- Remove some redundant handle creation
R=iposva@google.com
Review URL: https://codereview.chromium.org//15930003
不要なhandleを削除。
symbolにget: set:を追加しているけどどこで使っているのか。


r23094 | hausner@google.com | 2013-05-24 03:42:03 +0900 (金, 24  5月 2013) | 9 lines
Consolidate debug stubs
The new debug stub BreakpointRuntime gets the original stub address
from the debugger. With this scheme, we don't need a new debug stub
for every runtime stub that the debugger patches.
R=asiva@google.com
Review URL: https://codereview.chromium.org//15743019
kEqualNullとかいう意味不明なdeoptがなくなって、代わりにRuntimeCallを追加。妥当かも。
Debug時には、GenerateBreakpointRuntimeStub()でkBreakpointRuntimeHandlerRuntimeEntryを生成しておく。


r23071 | floitsch@google.com | 2013-05-23 23:30:16 +0900 (木, 23  5月 2013) | 14 lines
Rewrite double.parse.
BUG= http://dartbug.com/5654
R=lrn@google.com, srdjan@google.com
Committed: https://code.google.com/p/dart/source/detail?r=23062
Reverted: https://code.google.com/p/dart/source/detail?r=23065
Committed: https://code.google.com/p/dart/source/detail?r=23066
Reverted: https://code.google.com/p/dart/source/detail?r=23068
Review URL: https://codereview.chromium.org//15333006
r23062 | floitsch@google.com | 2013-05-23 21:00:45 +0900 (木, 23  5月 2013) | 6 lines
Rewrite double.parse.
BUG= http://dartbug.com/5654
R=lrn@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//15333006
lib/doubleの修正。


r23053 | fschneider@google.com | 2013-05-23 17:41:10 +0900 (木, 23  5月 2013) | 5 lines
Fix small bug in the inlining heuristics: Don't compare size with number of call sites.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//15740008
size -> call_site_countへ置換。 > FLAG_inlining_callee_call_sites_threshold


r23046 | asiva@google.com | 2013-05-23 09:26:33 +0900 (木, 23  5月 2013) | 5 lines
Remove some dead code.
R=hausner@google.com
Review URL: https://codereview.chromium.org//15740015
LookupFunctionInSource()を削除。

r23037 | regis@google.com | 2013-05-23 03:53:51 +0900 (木, 23  5月 2013) | 6 lines
Enable code optimization on ARM.
Disable failing tests.
R=zra@google.com
Review URL: https://codereview.chromium.org//15697009
ARMのOptimizeCounterThresholdを有効
EmitEqualityAsPolymorphicCal()
GenerateCallNoSuchMethodFunctionStub
GenerateInstanceOf
EmitTestAndCall


r23030 | asiva@google.com | 2013-05-23 02:25:25 +0900 (木, 23  5月 2013) | 7 lines
Create test isolates using a snapshot, this ensures that we do not depend
on the location of core libraries which can be a problem when we copy
the run_vm_tests executable to a different machine.
R=zra@google.com
Review URL: https://codereview.chromium.org//15736011
r23023 | asiva@google.com | 2013-05-23 01:07:25 +0900 (木, 23  5月 2013) | 8 lines
Fix runnning of vm benchmarks on golem.
Use snapshots for creating isolates used in the benchmarks,
that way they are not dependent on corelib source paths.
R=ajohnsen@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//15640002
assert 追加のみ。


r23020 | srdjan@google.com | 2013-05-23 00:20:55 +0900 (木, 23  5月 2013) | 5 lines
Improve constant propagation for Mint and Smi.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15507006
ConstantPropagator::HandleBinaryOp()を追加。
left and rightがIsConstantである場合に、ArighmeticOp、Canonicalize()で静的評価。
BinarySmiOp BinaryMintOp ShiftMintOpで静的評価。

r23018 | srdjan@google.com | 2013-05-22 23:32:18 +0900 (水, 22  5月 2013) | 5 lines
Allow stack location for some instructions (relational and equality comparison).
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15578003
ConstantInstrがisStackSlot()の場合には、comqをemit
locationで、AnyOrConstant()で必要なレジスタ割付を削減。

r22982 | kmillikin@google.com | 2013-05-22 15:21:57 +0900 (水, 22  5月 2013) | 10 lines
Remove the IC data array from the isolate.
Thread it as an argument rather than storing it in a global variable.
This means the programmer does not have to implement a shadow stack to save and
restore the data array,and there is no special handling needed for GC.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15470013
isolateがic_data_arrayを管理してたのをやめて、GetICData()に置換したと。。global variable.
GetICData自体はzonehandleで管理する。
修正後はic_data_arrayをGCの対象外にしている。 これがやりたかった？

isolateごとに分割して綺麗なICDataにすることないよねと？
compileの最初にic_data_arrayを取得し、builderには引数経由で渡す。

r22981 | kmillikin@google.com | 2013-05-22 15:21:03 +0900 (水, 22  5月 2013) | 9 lines
Remove an unnecessary setter.
A field of the CompilerDeoptInfo had a setter that was always and only
called immediately after construction.  Instead, set it in the constructor.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15563007
CompilerDeoptInfoのConstructor引数にEnvironmentを追加して、setterを削除。

r22974 | srdjan@google.com | 2013-05-22 09:06:18 +0900 (水, 22  5月 2013) | 3 lines
Fix broken Mac build.
Review URL: https://codereview.chromium.org//15412005
%d -> %"Pd"

r22972 | hausner@google.com | 2013-05-22 08:07:22 +0900 (水, 22  5月 2013) | 8 lines
Make VM debugger stop at every safe point
Debugger front-end can decide to ignore some steps and only halt
when the next line is reached.
R=iposva@google.com
Review URL: https://codereview.chromium.org//15359010
last_bpt_lineっていう変数で制御するのをやめた。

r22967 | regis@google.com | 2013-05-22 07:07:55 +0900 (水, 22  5月 2013) | 5 lines
Implement backtracing and toggling of execution tracing in ARM simulator.
R=zra@google.com
Review URL: https://codereview.chromium.org//14711013
stack_frameを改造して、pc_もiterateするようにしたと。
それ以前は、sp + SavedPcSlotFromSp * wordsize = pcで計算してた。

r22943 | fschneider@google.com | 2013-05-22 00:15:47 +0900 (水, 22  5月 2013) | 17 lines
Refactor the IL for object allocation with type arguments.
Two parts:

1. Change AllocateObjectWithBoundsCheck to a normal call that takes
   four arguments on the stack using PushArgument IL instructions.
   Before inputs were in registers and the instruction pushed them itself
   before the runtime call. This make the code more compact and simplifies
   the flow graph builder.

2. Simplify instructions for building constructor type arguments for another
   special case to simplify the instruction pattern and generate smaller
   code for that case.

R=srdjan@google.com
Review URL: https://codereview.chromium.org//15564004
call_argumentsのnull caseを除去して処理をsimpleに。
AllocateObjectWithBoundsCheckのEmitで、pushするのをすべて削除。
直接GenerateCallRuntimeする。すべてNodeに引数を埋め込んでいる。
stub側に処理が展開されているため、pushするコードをstub側に共通化してコードサイズを減らしている
ということのはず。


r22931 | fschneider@google.com | 2013-05-21 20:09:34 +0900 (火, 21  5月 2013) | 8 lines
Further improve and simplify IL for building constructor type arguments.
Generate constants in the IL directly if possible and avoid temporary
local store/load completely in some cases.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//14672035
type argumentsのshare系の処理。先月修正されてたとこかな。

機種依存で!use_insantiator_type_args
機種非依存部でExtractConstructorTypeArgumentsInstr()を生成するように代替


r22924 | kmillikin@google.com | 2013-05-21 18:34:50 +0900 (火, 21  5月 2013) | 11 lines
A few simple cleanups.
* Remove BlockEntryInstr::PrepareEntry and use EmitNativeCode to emit the
  native code.
* Use Array::element_offset in a few places.
* Comment and identifier fixes.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//15529003
PrepareEntryのEmitを削除し、
代わりにJoinEntryInstrとTargetEntryInstrのEmitNativeCodeに置換。


r22914 | asiva@google.com | 2013-05-21 10:02:28 +0900 (火, 21  5月 2013) | 8 lines
- Some of the pre registered classes like Int, Double etc. were not being
  marked as being prefinalized. Mark them as pre finalized.
- Replaced the check (cls.functions() != Object::empty_array().raw()) as
  indicating it is a pre-registered class.
R=regis@google.com
Review URL: https://codereview.chromium.org//15494008
snapshotせずにcoreを読み込む場合に、set_is_prefinalized()するようにした。
state_bitsのkPreFinalizedを立てると。

r22912 | srdjan@google.com | 2013-05-21 08:59:36 +0900 (火, 21  5月 2013) | 5 lines
Intrinsify random nextState, improve perfromance significantly.
R=zra@google.com
Review URL: https://codereview.chromium.org//15502004
64bit値を参照して遅かったnextState()をintrinsicに変換。
_nextState()をvmで実行すれば高速だが、jsではそうではないはず。

intrinsifer.hに定義を追加
_Random, _nextState() として追加している。これだけでintrinsiferに追加されるのだと思う。


r22904 | iposva@google.com | 2013-05-21 06:01:31 +0900 (火, 21  5月 2013) | 7 lines
- Add a GetClassId() to Object, so that we do not have to
create a temporary class handle only to get at an object's
class id, which is stored in the object header.
R=asiva@google.com
Review URL: https://codereview.chromium.org//15338008
GetClassId()
HeapになければSmi型、そうでないならGetClassId()を返す。
冗長なClass::Handleを削除するのが目的なのかな。
ObjectStoreへの参照がダイレクトに返るはず。

r22893 | asiva@google.com | 2013-05-21 01:02:30 +0900 (火, 21  5月 2013) | 5 lines
Add a call to CheckIsolateState in all paths of Dart_GetField and Dart_SetField.
R=ager@chromium.org
Review URL: https://codereview.chromium.org//15353002
APIのget/setを叩く度に、
CheckIsolateState()でIsErrorをチェックすると。。

r22889 | asiva@google.com | 2013-05-20 14:15:39 +0900 (月, 20  5月 2013) | 6 lines
Use handles to save the object being read before calling StorePointer to make sure we are GC safe.
R=iposva@google.com
Review URL: https://codereview.chromium.org//15383002
StorePointerの引数をArray::Handleしたものに変更。
リークしてたとか？

r22881 | srdjan@google.com | 2013-05-18 08:45:08 +0900 (土, 18  5月 2013) | 5 lines
Cleanups: addressed your comments from https://codereview.chromium.org/14962008/
R=iposva@google.com
Review URL: https://codereview.chromium.org//14845021
Mintっていう用語から、Int64に置き換わりつつ？
内部はMintだけど、APIレイヤーとかはInt64って呼ぶっぽい。


r22857 | hausner@google.com | 2013-05-18 02:08:09 +0900 (土, 18  5月 2013) | 8 lines
Make breakpoints on == fire reliably
Add breakpoints in the path taken if one of the operands
in a == b is null.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14991010
RuntimeEntry BreakpointEqualNullHandlerを追加
debugger SignalBpReached()

PcDescriptorにkEqualNullを追加 Stub for comparison with null.
IsSafePoint()に追加

EqualNullでBreakpointを設定するってどういうことなんだろうか。
nullpoint exceptionを発生せずに、自動的にbreakさせるってことなのか。
もしくは、nullのときにnoSuchMethod Exceptionのときか。

可能な限りdeoptさせずにdebugする方向にもっていくのかな。


r22818 | zra@google.com | 2013-05-17 06:18:04 +0900 (金, 17  5月 2013) | 5 lines
Impelemnts some FPU arithmetic function for the MIPS simulator, assembler, disassembler.
R=regis@google.com
Review URL: https://codereview.chromium.org//15038008
mipsの実装。

r22816 | srdjan@google.com | 2013-05-17 05:49:06 +0900 (金, 17  5月 2013) | 5 lines
Fix issue 5275: The VM must always generate the most compact form of an integer (Smi, Mint or Bigint).
Hide methods that can be used to bypass that assumption and require the use of Integer::NewXXX
which is guaranteed to return the most compact integer form.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14962008
RawMint(int64_t)
Smi::NewからInteger::Newに置換


r22810 | iposva@google.com | 2013-05-17 04:37:14 +0900 (金, 17  5月 2013) | 4 lines
- Create a local scope so that the GC can collect the external typed data.
Review URL: https://codereview.chromium.org//15070014
testコード。


r22806 | iposva@google.com | 2013-05-17 03:33:30 +0900 (金, 17  5月 2013) | 6 lines
Fix dartbug.com/10674:
- Make sure that Dart_NewExternalTypedData returns a local handle.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14676020
NewExternalTypedData()
Handle() を作って、Newしてかえす。

Handle(isolate, New(data, length))
Handle.AddFinalizer(peer, callback)
return Api::NewHandle(Isolate, result.raw());

Handleを確保して、WeakReferenceで参照された状態を作って、Peerとcallbackを設定。
中身のrawだけ返すと。


r22804 | srdjan@google.com | 2013-05-17 03:06:18 +0900 (金, 17  5月 2013) | 5 lines
Fix build breakage of simmips on Mac OS X: binary constants are nto C++ standard, but GCC specific.
R=zra@google.com
Review URL: https://codereview.chromium.org//14954013
mips向けの修正で、constants_mips.h


r22799 | hausner@google.com | 2013-05-17 00:44:05 +0900 (金, 17  5月 2013) | 8 lines
Allow breakpoints on one-liner functions
Fixes issue 10234. This is also the first step for setting
reliable breakpoints on a == b expressions.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//15000005
debuggerの修正
ResolveBreakpointPos()を追加。
IsSafePoint()っていう関数が作られている。
PcDescriptor::kIcCall kFuncCall kClosureCall kReturn
Dart VMは上記4つしかないのか。

r22763 | zra@google.com | 2013-05-16 08:51:17 +0900 (木, 16  5月 2013) | 5 lines
Implements int to double conversion instructions for MIPS simulator, assembler, disassembler.
R=regis@google.com
Review URL: https://codereview.chromium.org//15144004
cvtdw cvtdlを追加。


r22760 | srdjan@google.com | 2013-05-16 07:20:02 +0900 (木, 16  5月 2013) | 5 lines
Fix crash when running Richards with --inlining-depth-threshold=30 --inlining-size-threshold=10000:
IfThenElseInstr may end up with both inputs being constant.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//14787015
left rightがConstantである場合、NE_STRICTもしくはNEの場合に、Emit時に評価。
movl if_true or if_false


r22752 | zra@google.com | 2013-05-16 03:37:47 +0900 (木, 16  5月 2013) | 5 lines
Implements FPU compare and branching for MIPS simulator, assembler, disassembler.
R=regis@google.com
Review URL: https://codereview.chromium.org//14672037
mips向けの修正
GenerateGetStackPointerStubを実装。
FPU向けの命令を実装。
FpuBranchってなんだろ。。

r22744 | srdjan@google.com | 2013-05-16 00:37:14 +0900 (木, 16  5月 2013) | 5 lines
Fix failure in co19 test (tests/co19/src/LibTest/math/pow_A18_t01.dart),
where pow(1.0, NAN) returns 1.0 instead of NAN (replicate with --optimization-counter-threshold=5).
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14937006
kDoublePow、comisd movpasを生成する。

r22737 | fschneider@google.com | 2013-05-15 22:42:34 +0900 (水, 15  5月 2013) | 8 lines
Cleanup and avoid unnecessary code when building type arguments.
The code now uses only one temporary local instead of two.
It affect only unoptimized code since those temporaries are eliminated when translating into SSA.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//15001030
type argumentsの共通処理をリファクタリング
処理順番を変更。type argumentsをLoadLocalやExtractConstructorに変更する処理。


r22733 | kmillikin@google.com | 2013-05-15 21:10:16 +0900 (水, 15  5月 2013) | 11 lines
Polymorphic inlining - prevent hoisting the last class check.

Do not check the receiver directly, check an (immovable) redefinition of the receiver.
This prevents hoisting the class check out of a loop when the receiver is loop-invariant.

Hoisting such a check can lead to excessive deoptimization.
R=vegorov@google.com
BUG=dart:10634
Review URL: https://codereview.chromium.org//15076013
receiverからredefinitionに変更したのかな。バグ対


r22719 | regis@google.com | 2013-05-15 08:23:54 +0900 (水, 15  5月 2013) | 5 lines
Make deoptimization architecture dependent (it depends on the frame layout).
R=srdjan@google.com, zra@google.com
Review URL: https://codereview.chromium.org//15110003
ret addrがframeに積むのではなく、
PCをframeをつむように修正(表現を修正) 抽象化した表現に変更し、
結果、全アーキテクチャでDeoptを呼び出した際に、TOSにPcMarkerがくるはず。

CreateDeoptInfo()を各アーキテクチャ依存で定義するように変更した。

CreateDeoptInfoは、
(1) EmitMaterializations //unboxed objects
(2) MarkFrameStart() //real frame start
(3) AddPcMarker() //callee PC marker
(4) AddCallerFp()
(5) AddReturnAddress()
(6) EmitMaterializationArguments()
(7) environment(arguments) stack copy
(8) AddPcMarker()
(9) AddCallerFp()
(10) Loop Envrironment
(11) - AddReturnAddress()
(12) - arguments stack copy
(13) - local variable and descriptor stack copy
(14) - AddPcMarker()
(15) - AddCallerFp()
(16) AddCallerPc()  //for outermost environments
(17) Arguments stack copy //for outermost environments

ARM Dart Frame Layout
               |                    | <- TOS
Callee frame   | ...                |
               | saved PP           |    (PP of current frame)
               | saved FP           |    (FP of current frame)
               | saved LR           |    (PC of current frame)
               | callee's PC marker |
               +--------------------+
Current frame  | ...                | <- SP of current frame
               | first local        |
               | caller's PP        |
               | caller's FP        | <- FP of current frame
               | caller's LR        |    (PC of caller frame)
               | PC marker          |    (current frame's code entry + offset)
               +--------------------+
Caller frame   | last parameter     | <- SP of caller frame
               |  ...               |


IA32 Dart Frame Layout
               |                    | <- TOS
Callee frame   | ...                |
               | saved EBP          |    (EBP of current frame)
               | saved PC           |    (PC of current frame)
               +--------------------+
Current frame  | ...                | <- ESP of current frame
               | first local        |
               | PC marker          |    (current frame's code entry + offset)
               | caller's EBP       | <- EBP of current frame
               | caller's ret addr  |    (PC of caller frame)
               +--------------------+
Caller frame   | last parameter     | <- ESP of caller frame
               |  ...               |


X64 Dart Frame Layout
               |                    | <- TOS
Callee frame   | ...                |
               | saved RBP          |    (RBP of current frame)
               | saved PC           |    (PC of current frame)
               +--------------------+
Current frame  | ...                | <- RSP of current frame
               | first local        |
               | PC marker          |    (current frame's code entry + offset)
               | caller's RBP       | <- RBP of current frame
               | caller's ret addr  |    (PC of caller frame)
               +--------------------+
Caller frame   | last parameter     | <- RSP of caller frame
               |  ...               |



r22705 | iposva@google.com | 2013-05-15 05:33:04 +0900 (水, 15  5月 2013) | 9 lines
- Correctly handle negative constant indices when constant propagation has not eliminated range checks.
- Add test to verify the optimizer does not allow negative constant indices
  when eliminating array bounds checks.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14566020
FlowGraphOptimizerでeliminate bound checksを行っていたが、
その評価をCheckArrayBoundInstr::Emit時に行うようにした。削除可能なのは、lengthもindexもconstantに限る。

r22701 | srdjan@google.com | 2013-05-15 04:50:20 +0900 (水, 15  5月 2013) | 3 lines
Fix assert failures in checked mode: Redundant CheckArrayBoundInstr is not eliminated.
Review URL: https://codereview.chromium.org//14643018
消されると。

r22698 | iposva@google.com | 2013-05-15 03:39:44 +0900 (水, 15  5月 2013) | 8 lines
- Canonicalize array bounds checks to avoid deopting when comparing two constants.
- Add named locations for index and length to make using locs less confusing.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14979007
armとmips版のCheckArrayBoundInstrを実装。ついでにCanonicalize

r22695 | srdjan@google.com | 2013-05-15 03:16:44 +0900 (水, 15  5月 2013) | 5 lines
Added Object._cid getter, optimized it.
Added to (some) classes a static final _clCid.
Use those to test for exact type in VM's libraries.
R=iposva@google.com
Review URL: https://codereview.chromium.org//14703005
get:_cidを高速化？ bootstrap_natives.hについか。
InlineObjectCid()するだけ。

Library内で、charCodes is! xxx && charCodes is! yyy
みたいなケースを高速化する。code._cidで1回だけ読んで、 !=で比較すると。。
is演算子がボトルネックになりうるケースは、_cidを呼び出す。
基本的には、lib内で複数のクラスに継承、実装される可能性のある
親クラスがcidを組込みで持つときだけ効果があるのかな。


r22683 | johnmccutchan@google.com | 2013-05-15 00:52:40 +0900 (水, 15  5月 2013) | 5 lines
Unbox phis with Float32x4 or Uint32x4 type
R=vegorov@google.com
Review URL: https://codereview.chromium.org//15145002
phiのpromotionに、kFloat32x4とkUint32x4を追加。

r22665 | vegorov@google.com | 2013-05-14 19:28:31 +0900 (火, 14  5月 2013) | 6 lines
Basic support for LICM of fully invariant loads.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14268019
IsLoopInvariantLoadは、同じexpr_idかどうかで判定する。

MarkLoopInvariantLoads()
LoopHeaderにおいてLoop内のexpr_idを走査して全Add、再走査してRemoveAll()して残ったのが冗長なLoads


r22655 | srdjan@google.com | 2013-05-14 08:19:20 +0900 (火, 14  5月 2013) | 5 lines
Fix crash with --no-use-cha:
the optimizer expects a concrete type for array creation,
not dynamic as is the result because we cannot determine without CHA
if a class is guaranteed to have no sublcasses and has not been implemented.
Regardless of use_cha, always rely on known information for internal classes
that are not subtype or implemented by other clases.
R=asiva@google.com, vegorov@google.com
Review URL: https://codereview.chromium.org//15141004
use-chaを使用する場合、privateなクラスであるとわかっている場合、
chaを無効化するような修正を加えた。
IsKnownPrivateの判定結果はどんな感じなのだろうか。
Core Collection TypedData MathはPrivateClass

r22649 | johnmccutchan@google.com | 2013-05-14 05:22:06 +0900 (火, 14  5月 2013) | 5 lines
Inline Uint32x4 operations
R=srdjan@google.com
Review URL: https://codereview.chromium.org//15085006
select
flagXYZW系のinline

以下のIRを追加
Uint32x4BoolConstructor
Uint32x4GetFlag
Uint32x4Select
Uint32x4SetFlag
Uint32x4ToFloat32x4
BinaryUint32x4Op

TryInlineUint32x4Method()に集約されているはず。

BinaryUint32x4Op用のemitできると。
andps orps xorpsなどなど
mask and movups

SelectInstrは、
movpas notps andps andps orps


r22621 | fschneider@google.com | 2013-05-13 21:41:02 +0900 (月, 13  5月 2013) | 5 lines
Revert r22620 because of dart2js test failures.
TBR=kmillikin@google.com
Review URL: https://codereview.chromium.org//14935013
test failed, set_is_optimization(false)

r22620 | fschneider@google.com | 2013-05-13 21:09:14 +0900 (月, 13  5月 2013) | 10 lines
Enable optimizing try-finally.
Everything needed is already in place by my previous CL
(https://codereview.chromium.org/14682020/)
This just removes the early bailout in the parser.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//14757017

r22615 | fschneider@google.com | 2013-05-13 19:33:24 +0900 (月, 13  5月 2013) | 32 lines
Optimize functions containing try-catch.
This is a first step towards fully optimizing try-catch-finally.

At a catch entry, all local variables and parameters are expected at a fixed stack location.
There is a list of initial definitions at the catch entry block,
similar to the initial definitions at graph entry.

Inside every try-block there is a special prologue code before each call (instruction that may throw)
inside the try-block. This prologue is similar to a parallel move instruction:
It moves all locals+parameters to the locations expected by the catch-entry block.
The stack frame is extended with the corresponding number of fixed slots right below the normal spill slots.

Every function containing try-catch has additional compiler-generated local variables to pass the context,
the exception and the stack trace.

Variable liveness analysis is adapted to treat locals inside try{} blocks specially:
Every call has an implicit LoadLocal of every local variable.
This CL uses a safe approximiation of liveness which can be optimized further.

Current restrictions which are planned for future CLs:
* No inlining inside try-blocks.
* No inlining of functions containing try-catch.
* No try-finally yet.

R=kmillikin@google.com
Review URL: https://codereview.chromium.org//14682020
TryCatchAnalyzer::Optimize()を追加した。
intelの場合オプション optimize-try-catch=true

IRにMayThrow()っていう仮想関数を追加した。
キモはEmitTrySync()かな？

tryの中では、live_inやkillの制御がネガティブに倒されている。
またRegAllocのCatchEntryでは、killとlive_inをAllにリセットする。
その結果、Try-CatchにおけるStackの固定割付きを解析しやすくする。

tryの後にcatchが複数 + finalyのケースを想定し、
Tryブロック内の暗黙のLoadLocalを最適化する機会を提供したい。
そのために、Try-CatchをEntryPointとみなすのかな？


r22600 | srdjan@google.com | 2013-05-11 06:33:14 +0900 (土, 11  5月 2013) | 6 lines
A load static of an initialized static final field can be converted to its value,
as long as it is in old space or Smi, and can therefore be a literal node.
Add special objects to mark non_constant and unknown_constant in constant propagator
so that there is no confusion with sentinels used in the graph.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14969019
object.hに用意
unknown_constant non_constant

VisitLoadStaticField()において、
isFinal -> IsSmi || isOld の場合、そのままの値のpropagate
finalでない場合、non_constantを返す。

上記条件においては、non_constantと判定できるはず。ConstantPropagatorに影響あるはず。

r22596 | hausner@google.com | 2013-05-11 06:06:04 +0900 (土, 11  5月 2013) | 9 lines
Implement breakpoint for closure calls
Introduce a new PcDescriptor kind to distinguish closure calls from other runtime calls.
The debugger can patch these calls to set a breakpoint. When stepping into a closure call,
the debugger must fish out the closure object from the stack, find the function and set breakpoints in it.
Arm and Mips breakpoint stubs are not implemented yet.
ia32 and x64 stubs tested by hand. Automated test to follow.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14858033
CodeGenerator RuntimeEntryに、BreakpointClosureHelperを追加、
code_patcherの処理追加
ClosureCallに対して、code patcherで行うらしい
また、getArgDescなどのケアも存在する。

GenerateBreakpoint
EnterFrame
pushl
callruntime(BreakpointClosureHelper)
popl
LeaveFrame
jmp

ClosureCallの場合、PatchStaticCallを使って飛び先を切り替える、helperを呼び出す


r22528 | srdjan@google.com | 2013-05-09 05:03:33 +0900 (木, 09  5月 2013) | 5 lines
Inline _OneByteString._setAt.
The key knowledge is that _setAt is an internal method that has to be called
with correct arguments, therefore no checks are needed.
R=fschneider@google.com, zra@google.com
Review URL: https://codereview.chromium.org//14917020
OneByteString setAt()をintrinsicsとは別に、recognizerに追加した。
optimizerで、StoreIndexedInstrに置換する。


r22523 | asiva@google.com | 2013-05-09 03:56:38 +0900 (木, 09  5月 2013) | 7 lines
Remove print_bootstrap flag as it is not needed anymore considering that we
load core libraries directly from the sources and do not concatenate all the
files into a single script file.
R=regis@google.com
Review URL: https://codereview.chromium.org//14631014
オプション print_bootstrapを削除したらしい。。
ソースコードを復元して出力する必要はないよね。。


r22514 | asiva@google.com | 2013-05-09 01:42:46 +0900 (木, 09  5月 2013) | 13 lines
Final step towards loading core library scripts directly from the sources
- Modify bin.gypi to ensure that the io library and patch files are read
  directly from the sources. Remove the source buffer generation step in
  the gypi files for all the io library and patch files.
- Restructure the code a bit to eliminate some code duplication.
- Delete runtime/tools/concat_library.py
 R=ager@google.com, sgjesse@google.com
Review URL: https://codereview.chromium.org//14752008
bin/builtin.ccを修正しているのかな。
binの下のunreachableを実装しているのかな。


r22505 | podivilov@google.com | 2013-05-08 22:00:09 +0900 (水, 08  5月 2013) | 5 lines
Fix Clank+Dart compilation.
R=iposva@google.com
Review URL: https://codereview.chromium.org//15023007
runtime_configurations_android.gypiを新規追加


r22488 | asiva@google.com | 2013-05-08 09:44:50 +0900 (水, 08  5月 2013) | 5 lines
Minor cleanup.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14828006
whileをforに置換

r22485 | vegorov@google.com | 2013-05-08 08:40:42 +0900 (水, 08  5月 2013) | 29 lines
Implement a variation of scalar replacement for non-escaping allocations.
AllocationSinking pass discovers non-escaping allocations
that have no input uses other than uses in the stores into its own fields.
Every environment use of such allocation is replaced by a state snapshot
(MaterializeObject instruction) that describes the state of each initialized field in the object.
State snapshots are computed through an additional round of load-forwarding.

Once snapshots are computed allocations are removed from the graph.
MaterializeObject instructions are not compiled into native code
but produce deoptimization instructions instead that
describe how object should be materialized at deoptimization.
Deoptimization instructions now follow the following format:

[mat obj #1]...[mat obj #N][ret addr][... mat arguments ...][... real frames ...]

- the prefix describes each object to materialize on deopt via kMaterializeObject instruction;
- actual values that are needed for materialization are emited as a part of bottom-most stack frame.
  This is done to simplify implementation:
  they need to be discoverable by a GC during materialization phase.
  At the end of deoptimization they will be removed from the stack;
- normal stack slots can refer to materialized objects via kMaterializedObjectRef instruction.
  Additionally this change contains fixes in load-forwarding
  that are needed to guarantee that all artificial LoadField instructions inserted
  during AllocationSinking are correctly replaced with actual values.
  Limitations of the current implementation:
- can't eliminate allocations that flow into phis but otherwise don't actually escape;
- can't sink allocations out of loops;
- allocation with type arguments are not handled.

R=regis@google.com, srdjan@google.com, zra@google.com
Review URL: https://codereview.chromium.org//14935005
optimizerの修正
AllocationSinkingの追加。
escapeしないallocateを、MaterializeObjectInstrに置換する。
その後Allocateを削除する。
条件は、allocate後にsingle usesのみ。
簡易escape解析.Tracerなどの計算で一時オブジェクトを作るケースで重宝する。

MaterializeObjectInstrを追加。
最適化用のIRっぽい。AllocationSinking pass.で削除される。
EmitMaterializations()は空。

loadとのaliasの修正。load eliminationが捗るはず。
side effectの判定を調整し、independentの条件がいろいろ追加。

上記に合わせて、deoptinfoの修正。
allocateされなくなるため、deoptinfoの修正や
各deoptごとに情報を保持する必要がある。

CodeGeneratorのdeoptimizeのmaterializeに修正？
class DeferredObjectRef


r22471 | zra@google.com | 2013-05-08 03:21:18 +0900 (水, 08  5月 2013) | 9 lines
Fixes for integer division on ARM hardware so that assembler tests pass.
Now, all VM tests that pass on SIMARM, pass on ARM.
Also, more assertions in the ARM disassembler and simulator to
make sure that condition codes aren't used with bkpt.
R=regis@google.com
Review URL: https://codereview.chromium.org//14784011
CPUFeaturesで判定。
integer_division_supported = idiva

r22470 | regis@google.com | 2013-05-08 03:06:21 +0900 (水, 08  5月 2013) | 6 lines
Remove stack_frame_<arch>.cc files.
The architecture specific information is in stack_frame_<arch>.h files.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14925005
stack_frame.hに変換。

r22458 | kmillikin@google.com | 2013-05-07 21:50:37 +0900 (火, 07  5月 2013) | 9 lines
Use the constant pool for all constants, not just null.
Remove constants from the instruction stream in optimized code at SSA construction time.
Modify the range analysis pass to analyze values in the constant pool.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14846022
FlowGraphOptimizerからFlowGraphに変更？
FlowGraphに統一して、GetConstant()でpool登録、取得。
ConstantはFlowGraphで管理するけど、コンパイルのたびにFlowGraphを作り直すのは変わらないのかな。


r22452 | iposva@google.com | 2013-05-07 16:59:03 +0900 (火, 07  5月 2013) | 4 lines
Fix dartbug.com/10415:
- Append 'on "$os_$arch"' to the version string on the VM.
Review URL: https://codereview.chromium.org//14593004
OS::Name()を追加して、Version::String()でconcat


r22436 | asiva@google.com | 2013-05-07 03:16:25 +0900 (火, 07  5月 2013) | 11 lines
Third step towards loading core library scripts directly from the sources
- Read the patch source files using the source mapping array generated for
  patch files instead of relying on a generated buffer containing the sources.
- Modify the gyp files to ensure that all patch libraries are read directly
  from the sources. Remove the source buffer generation step in the gypi
  files for all patch files.
R=hausner@google.com, iposva@google.com
LoadPatchFiles()
よくわからん。。

r22434 | kmillikin@google.com | 2013-05-07 02:22:18 +0900 (火, 07  5月 2013) | 13 lines
Initial support for polymorphic inlining.
Consider each polymorphic variant separately for inlining in frequency
order.  Share inlined bodies for shared targets.

Insert an SSA redefinition of the receiver in each inlined variant to
prevent hoisting.  Hoisting code specialized to the receiver (e.g.,
direct access to internal fields of typed data arrays) out of the
inlined body is not safe.
R=fschneider@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//14740005
SortICDataByCount()でソートするのかな。
InheritDeoptTargetなんてものがあるのか。
これでdeoptinfoを調整しないと落ちるのかな。

以下のIRを追加
RedefinitionInstr
これはEmitでunreachableなのか。 
RemoveRedefinitions()ってのでRangeAnalysisの前に綺麗にする。
これは既存のIRをwrapして、何かするのか。IRのspillみたいなものんか

LoadClassIdInstr
これはSmiTag用の特殊パスを用意した、LoadClassId

本家の処理はInlinerにある
class PolymorphicInliner
PolymorphicInstanceCallをPolymorphicInlinerでinline()

TryInlining()でRedefinitionInstr()を生成し、calleeのargumentsをwrapするのか。

Inline()
  -> TryInlining()
  -> BuildDecisionGraph()
LoadClassIdInstrを生成して、StrictCompareの生成、

CheckInlineDuplicate()ってのがあって、複数targetの重複をチェックする。。
基底クラスの同じメソッドを呼び出す場合かな。

オプション制御はないらしい。

r22432 | asiva@google.com | 2013-05-07 02:07:34 +0900 (火, 07  5月 2013) | 5 lines
Fix for issue 10395, call noSuchMethod if a method is not found when using the Dart C API.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14980002
dart_api_implの修正
Errorの代わりに、InvokeNoSuchMethodを投げるようにした。

r22415 | kustermann@google.com | 2013-05-06 23:49:21 +0900 (月, 06  5月 2013) | 15 lines
Fixed bug in vm/benchmark_test.h
The Benchmark objects were marked as 'const', but Benchmark::CreateIsolate
writes to 'Benchmark::isolate_'. This was not discovered so far, since GCC
places the global Benchmark objects into a read-write section.

It turns out that clang is able to create the const Benchmark objects at
compile time and puts them into a read-only section of the ELF file (it probably
inlines the constructor).
Thus, at runtime Benchmark::CreateIsolate tries to write to a read-only address
and crashes with a SEGV.
R=iposva@google.com
Review URL: https://codereview.chromium.org//14988005
const抜いた


r22399 | srdjan@google.com | 2013-05-04 08:48:10 +0900 (土, 04  5月 2013) | 5 lines
Improve performance of String.fromCharCodes by implementing it in Dart.
Add tow internal natives to Dart in order to be able to allocate and fill a String.
Next step is to implement String.concatAll in Dart as well
and to inline String._setAt operation (currently intrinsified).
R=asiva@google.com
Review URL: https://codereview.chromium.org//14862006
intrinsicsにOneByteStringのsetAtとallocateを追加。
setAtは、ia32 asm 6命令くらい。
allocateはtryAllocateを呼び出す。

lib/string_patch.dartでは、createFromCharCodes()において、
上記の組込み関数を呼び出す。
s = allocate()
for(int i=0; i<charCodes.length;i++)
  s.setAt(i, charCodes[i])


r22394 | regis@google.com | 2013-05-04 06:42:16 +0900 (土, 04  5月 2013) | 6 lines
Introduce architecture specific headers describing Dart stack frames.
The actual cleanup will follow in another cl.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14831004

r22393 | iposva@google.com | 2013-05-04 05:59:42 +0900 (土, 04  5月 2013) | 8 lines
- Remember the fact that an object has been added to the
  store buffer by a bit in the header.
- This bit can be used to filter out redundant additions
  into the store buffer making the dedup sets not needed.
- Remove the need for a HashSet when remembering old to
  new references.
Review URL: https://codereview.chromium.org//14307013

GCで参照、操作するheaderに、rememberedbitを追加した。
この前freeを削除してwatchを移動したところ。
IsRemembered() SetRememberedBit()
UpdateStoreBufferの際には、RememberedBit()を参照して、すでにrememberedbitが立っているかチェックする。
重複したupdate処理は不要であるため、重複している場合省略する。
rememberedbitを立てるタイミングは、上記のチェックが終わった直後、GenerateUpdateStoreBufferStub()
以前は、とりあえずupdateを行い、updateの中で重複チェックをしていた。

また、old gcでも操作する。
oldでmarkAndPushされた際には、RememberedBitをclear
MarkObjectの際には、mark中のobjectがNewObjectかつOldObjectからの枝だった場合、
起点となっているOldObjectのRememberedSetを立てて、GC対象に追加する。

StoreBufferでは、deduplicationsetを使わないように修正。
StoreBufferBlockはシーケンシャルリストだったが、StoreBufferもリストに変更？
その結果、StoreBufferのContains()が、blockとbufferを二重にforループで走査してる。。


r22386 | regis@google.com | 2013-05-04 03:39:40 +0900 (土, 04  5月 2013) | 11 lines
Cleanup deoptimization code to make it architecture independent (in progress).
Implement some optimizing code on ARM in order to debug the above cleanup using
inline_stack_frame_test (still skipped in the vm status file).

This is not quite working yet, because CompilerDeoptInfo::CreateDeoptInfo
makes assumptions about the stack layout that are not valid for ARM or MIPS.
This will be cleaned up in a following cl.
R=srdjan@google.com, zra@google.com
Review URL: https://codereview.chromium.org//14812005
機種依存コードを整理。
おそらくPcSlotIndexFromSp = -1かな。
deopt infoの各種indexが定数のままだったので、
各アーキテクチャごとに定義。
ARMの場合、退避されているframeの要素が多いらしい。

+/* ARM Dart Frame Layout
+               |                   | <- TOS
+Callee frame   | ...               |
+               | current LR        |    (PC of current frame)
+               | PC Marker         |    (callee's frame code entry)
+               +-------------------+
+Current frame  | ...               | <- SP of current frame
+               | first local       |
+               | caller's PP       |
+               | caller's FP       | <- FP of current frame
+               | caller's LR       |    (PC of caller frame)
+               | PC Marker         |    (current frame's code entry)
+               +-------------------+
+Caller frame   | last parameter    |
+               |  ...              |
+*/
+

+/* X64 Dart Frame Layout
+               |                   | <- TOS
+Callee frame   | ...               |
+               | current ret addr  |    (PC of current frame)
+               +-------------------+
+Current frame  | ...               | <- RSP of current frame
+               | first local       |
+               | PC Marker         |    (current frame's code entry)
+               | caller's RBP      | <- RBP of current frame
+               | caller's ret addr |    (PC of caller frame)
+               +-------------------+
+Caller frame   | last parameter    |
+               |  ...              |
+*/

+/* IA32 Dart Frame Layout
+               |                   | <- TOS
+Callee frame   | ...               |
+               | current ret addr  |    (PC of current frame)
+               +-------------------+
+Current frame  | ...               | <- ESP of current frame
+               | first local       |
+               | PC Marker         |    (current frame's code entry)
+               | caller's EBP      | <- EBP of current frame
+               | caller's ret addr |    (PC of caller frame)
+               +-------------------+
+Caller frame   | last parameter    |
+               |  ...              |
+*/


r22396 | asiva@google.com | 2013-05-04 07:50:26 +0900 (土, 04  5月 2013) | 5 lines
Resubmit 22380 after fixing the windows build.
R=hausner@google.com
Review URL: https://codereview.chromium.org//14645025
r22382 | asiva@google.com | 2013-05-04 03:26:34 +0900 (土, 04  5月 2013) | 3 lines
Revert 22380 to investigate windows build break.
Review URL: https://codereview.chromium.org//14927003
r22380 | asiva@google.com | 2013-05-04 03:12:24 +0900 (土, 04  5月 2013) | 22 lines
Second step towards loading core library scripts directly from the sources
- Modify the library source generator to generate a source mapping array
  The generated array is of the following format:
  const char* dart::Bootstrap::corelib_source_paths_[] = {
    "dart:core", "/workspace1/dart-all/dart/sdk/lib/core/core.dart", 

    "bool.dart", "/workspace1/dart-all/dart/sdk/lib/core/bool.dart", 
    ...
    ...
  };

- Read the source file using the source mapping array instead of relying on
  a generated buffer containing the sources

- Modify the gyp files to ensure that all libraries are read directly
  from the sources. This CL does not change the patch part yet.
  Remove the source concatentation step in the gypi files for all the core
  libraries.

R=hausner@google.com, iposva@google.com
Review URL: https://codereview.chromium.org//14786012
vmからdartのソースコードを読み込んでbootstrapする部分の修正。makeと一緒に。
gypiも一緒に。
dart vmのbuildシステムは正直よくわからない。。

r22345 | asiva@google.com | 2013-05-03 08:10:53 +0900 (金, 03  5月 2013) | 7 lines
Potentially fix the crash reported in Issue 10385
- Fix use of a tagged pointer
- Fix a memory leak
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14623015
heap profierの修正？
data[0]を使わないように修正とk.

r22344 | zra@google.com | 2013-05-03 07:58:52 +0900 (金, 03  5月 2013) | 7 lines
Allows "Hello, world!" to run on ARM hardware.
Also, enables more vm tests on SIMMIPS.
R=regis@google.com
Review URL: https://codereview.chromium.org//14605006
ちょっとした修正だけど、
GenerateGetStackPointerを追加したのかな

r22340 | vegorov@google.com | 2013-05-03 06:20:49 +0900 (金, 03  5月 2013) | 13 lines
Improve load forwarding:
- stores/loads that access different fields can't alias each other;
- if result of the AllocateObject does not escape then stores/loads to it does not alias stores/loads to other objects.

Other:
- rename LoadFieldInstr's value to instance to better convey meaning and match StoreInstanceFieldInstr;
- slightly bump inlining_size_threshold;
- canonicalize UnboxDouble(BoxDouble(v)) and BoxDouble(UnboxDouble(v)) patterns;
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14872002
canonicalizeパスの実行を1回追加した。
propagateとallocateの間に1回追加。
boxdouble unboxdoubleのcanonicalizeを追加。

loadInstanceFieldに、load->setfieldを挿入ってどういうこった。。

ssaにaliasを導入して、load-store-loadの別名管理を行って、
load側のaliasの判定を強化。


r22331 | zra@google.com | 2013-05-03 02:53:34 +0900 (金, 03  5月 2013) | 12 lines
On MIPS, keeps Object::null() in a register.
On MIPS, we have a lot of registers, and we don't use very many of them.
This change removes the second temporary register TMP2, and instead
dedicates a register to holding Object::null(), which is used frequently
for comparisons, etc..
Also, uses branch delay slot when leaving a dart frame and returning.
R=regis@google.com
Review URL: https://codereview.chromium.org//14854010
mipsの修正かな。
TMP2 T9が削除。かわりにNULL REG = T8を導入かな。

r22313 | iposva@google.com | 2013-05-02 20:40:23 +0900 (木, 02  5月 2013) | 6 lines
- Fixed some old-style casts.
- Remove TODO as it is not feasible to ever enable.
R=kustermann@google.com
Review URL: https://codereview.chromium.org//14628009
old-style castは、VMのC++をさす。static_cast reintepreter_castへ置換かな。

r22285 | regis@google.com | 2013-05-02 06:33:08 +0900 (木, 02  5月 2013) | 6 lines
Fix ARM memory addressing mode 3 in assembler.
Update assembler test.
R=zra@google.com
Review URL: https://codereview.chromium.org//14637013
arm assemblerの修正
immediateのサポート追加？

r22278 | hausner@google.com | 2013-05-02 05:46:48 +0900 (木, 02  5月 2013) | 9 lines
BREAKING CHANGE: enforce part of directive
For historical reasons, the VM is currently too lenient when parsing library parts.
Files that get loaded through a 'part' directive must start with a 'part of libraryname;' clause.
The VM so far has not reported an error if the clause is missing.
This change enforces the grammar as the Spec mandates it.
Library parts that do not start with 'part of' will no longer compile.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14791005
part ofの導入？
内部ではparserのみ修正。かな。

r22277 | johnmccutchan@google.com | 2013-05-02 05:40:24 +0900 (木, 02  5月 2013) | 6 lines
Inline remaining Float32x4 operations.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14781002
いっぱい追加
negate clamp with toUint32x4
Float32x4ZeroArgInstrt
Float32x4ClampInstr
Float32x4WithInstr
Float32x4ToUint32x4Instr
Recognizerのパターンマッチが整理されて、
TryInlineFloat32x4Methodにまとめられた。

ZeroArgは、内部にkindを持っていて、
negateps absps

clanpは、minps maxpsをemit

with系がemitされた際には、unboxされたoutput registerが出力されるのか。

r22268 | hausner@google.com | 2013-05-02 03:34:48 +0900 (木, 02  5月 2013) | 8 lines
Loosen aggressive assert in debugger stack trace code
A closure may be called from native code.
In that case we will not find a saved context variable in the dart frame 'below' the closure.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14783002
correct stack trace errorの追加かな。

r22262 | zra@google.com | 2013-05-02 01:56:31 +0900 (木, 02  5月 2013) | 7 lines
On MIPS, uses more branch delay slots.
Also, tries to reorganize loops to look like what gcc produces.
R=regis@google.com
Review URL: https://codereview.chromium.org//14733002
mips向けの修正
量が多くて把握しきれないが、
LeaveStubFrameAndReturnってのが追加なのかな。


r22213 | hausner@google.com | 2013-05-01 08:03:30 +0900 (水, 01  5月 2013) | 6 lines
Instrument debugger to track down stack trace problems
- Print caller and callee if an expected saved current context is not found.
- Make removing a non-existing breakpoint a no-op.
Review URL: https://codereview.chromium.org//14664006
print-verboseの場合に、
StackTraceErrorを出力すると。

r22212 | srdjan@google.com | 2013-05-01 07:59:40 +0900 (水, 01  5月 2013) | 5 lines
Fix missing pc descriptor for NoSuchMethodExceptions
when calling closures with wrong number of arguments.
R=regis@google.com
Review URL: https://codereview.chromium.org//14715003
AddCurrentDescriptorを呼び出す処理を追加

r22209 | srdjan@google.com | 2013-05-01 07:05:14 +0900 (水, 01  5月 2013) | 44 lines
Fix error reporting when calling static methods and closures withh mismatched arguments.
Closures BEFORE:

----
Unhandled exception:
Class '(dynamic, dynamic, dynamic) => dynamic' has no instance method 'call'.

NoSuchMethodError : method not found: 'call'
Receiver: Closure: (dynamic, dynamic, dynamic, dynamic) => dynamic from Function 'foo':.
Arguments: [2]

Closures NOW:
----
Closure call with mismatched arguments: function 'A.foo'

NoSuchMethodError: incorrect number of arguments passed to method named 'A.foo'
Receiver: Closure: (dynamic, dynamic, dynamic, dynamic) => dynamic from Function 'foo':.
Tried calling: A.foo(2)
Found: A.foo(a, b, c)

Statics BEFORE:
----
Unhandled exception:
No top-level method 'foo' declared.

NoSuchMethodError : method not found: 'foo'
Receiver: Type: class '::'
Arguments: []

Statics NOW:
----
Unhandled exception:
No top-level method 'foo' with matching arguments declared.

NoSuchMethodError: incorrect number of arguments passed to method named 'foo'
Receiver: top-level
Tried calling: foo(...)
Found: foo(a, b, c)

R=regis@google.com
Review URL: https://codereview.chromium.org//14652008

r22196 | hausner@google.com | 2013-05-01 04:46:07 +0900 (水, 01  5月 2013) | 5 lines
Another fix for debugging stack traces and captured variables.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14449009
captured varの場合、local varible descritprを介して行う。
contextをたどりながら、対象のdescriptorを探すと。

r22185 | johnmccutchan@google.com | 2013-05-01 02:26:42 +0900 (水, 01  5月 2013) | 5 lines
Inline Float32x4 min,max,sqrt,reciprocal,reciprocalSqrt, and scale
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14432004
上記が組み込み関数になったのだ。
MinMaxInstr
minps maxps

ScaleInstr
shufps mulps

SqrtInstr
sqrtps
Reciprocal
reciprocol sqrt

reciprocolは
1/xの近似値を求める演算っぽい。divよりメリットがあるらしい。


r22181 | iposva@google.com | 2013-05-01 00:05:45 +0900 (水, 01  5月 2013) | 8 lines
- Remove kFreeBit, as it is not needed any longer
  except during snapshotting.
- Move the kWatchBit into the available space as its
  use does not overlap with snapshotting.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//14648004
objec headerのfree bitを削除？
freeのところには、watchedが移動した。
どっちもgcで使うビットで、free bitはsweepの際のfree listの管理につかっていたのかな。
watchedはold gcで使い続けるらしい.
mark bitだけで足りるため、freeは削除と。

r22180 | vegorov@google.com | 2013-04-30 23:25:16 +0900 (火, 30  4月 2013) | 9 lines
Track side-effect free paths in the graph to allow CSE and LICM for instructions
that depend on some side-effects.
Right now only a single side-effect is important for CSE/LICM purposes: externalization.
But abstractions are in place to introduce others if needed.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14021016
EffectSetクラスを作成。no-effect externalizationがある
BlockEffectクラスを作成。
修正が大規模すぐる。。
副作用の有無の処理じたいは変わっていないはず。


r22167 | fschneider@google.com | 2013-04-30 17:20:48 +0900 (火, 30  4月 2013) | 5 lines
Fix compiler warning about bool conversion.
R=iposva@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//14536002
return nullを削除。

r22159 | zra@google.com | 2013-04-30 09:35:09 +0900 (火, 30  4月 2013) | 8 lines
Uses slt and sltu for signed vs. unsigned comparison by the MIPS assembler.
Previously, the sequence subu/b{gt,le,...}z was used, which fails to
distinguish between signed and unsigned comparison.
R=regis@google.com
Review URL: https://codereview.chromium.org//14556002
mispの場合、unsignedless signedless などを導入しているらしい。

r22155 | regis@google.com | 2013-04-30 08:39:46 +0900 (火, 30  4月 2013) | 11 lines
Further improve type optimization reusing the type argument vector of the
instantiator of generic objects (fixes issue 10149).
This optimization considers the generic type argument vector of the instance
being allocated as well as the generic type argument vector of the compile
time type of the instantiator.
If the instance vector is a prefix of the instantiator vector,
the instantiator vector can be shared by the new instance.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14106013
canShareInstantiatorTypeArguments()
デフォルトfalseで、falseの場合、shareしないと。

r22154 | asiva@google.com | 2013-04-30 07:00:18 +0900 (火, 30  4月 2013) | 8 lines
First step towards loading the core library scripts directly from the sources
instead of concatenating all the scripts and linking them into the executable.
- Refactor the bootstrap script loading and compilation part to use a
  custom bootstrap library tag handler
R=iposva@google.com
Review URL: https://codereview.chromium.org//14520010
load scriptの処理が、objectとobject_storeに集約されたのかな。
bootstrapまわりは綺麗にリファクタリングされた。重複コードが色々と取り除かれた。

r22144 | johnmccutchan@google.com | 2013-04-30 04:17:38 +0900 (火, 30  4月 2013) | 5 lines
Inline Float32x4 comparison.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14288006
comp[eq gt gte lt lte ne]
IRを追加。
BoxUint32x4Instr
UnboxUint32x4Instr
Float32x4ComparisonInstr

unboxはfloat32x4のcheckとdeoptをセットして、movups
boxはTryAllocateして、movups

r22132 | zra@google.com | 2013-04-30 02:52:09 +0900 (火, 30  4月 2013) | 5 lines
Enables API tests on MIPS
R=regis@google.com
Review URL: https://codereview.chromium.org//14061012
mips向け
deoptimize系追加

r22124 | vegorov@google.com | 2013-04-30 00:51:15 +0900 (火, 30  4月 2013) | 6 lines
Ensure that safepoints are assigned to the live ranges of constants.
R=fschneider@google.com
BUG=dart:10272
Review URL: https://codereview.chromium.org//14542004
AssignSafePoints()の位置を変更。
constant用のパスを通ってもsafepointsは成立すると。

r22110 | vegorov@google.com | 2013-04-29 19:49:58 +0900 (月, 29  4月 2013) | 6 lines
Align code by 32 bytes to reduce benchmark flakiness on Intel CPUs.
R=iposva@google.com
Review URL: https://codereview.chromium.org//14158012
win linuxのalignを、ia32/x64の場合16から32へ変更。

r22096 | srdjan@google.com | 2013-04-27 09:04:21 +0900 (土, 27  4月 2013) | 5 lines
Move negative length checks from Dart into the native.
R=asiva@google.com
Review URL: https://codereview.chromium.org//14383016
negative length check時に例外を投げる処理を追加。
した結果、fingerprintが変更された。

r22088 | srdjan@google.com | 2013-04-27 06:20:49 +0900 (土, 27  4月 2013) | 3 lines
Fix recognition of factories (for setting result cid) and add them to checks.
Review URL: https://codereview.chromium.org//14386011
RECOGNIZED_LIST_FACTORYは.hへ移動。
symbols.hでも参照する必要があるため？

r22081 | vegorov@google.com | 2013-04-27 03:52:58 +0900 (土, 27  4月 2013) | 6 lines
Fix bad copy&paste in InvokeMathCFunctionInstr::AttributesEqual.
TBR=srdjan@google.com
Review URL: https://codereview.chromium.org//14521004
fix

r22078 | vegorov@google.com | 2013-04-27 03:10:59 +0900 (土, 27  4月 2013) | 8 lines
Cleanup implementation of SmiToDouble to use unboxed double result.
Allow CSE to eliminate redundant SmiToDouble, DoubleToDouble, InvokeMathCFunction instructions.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14031035
SmiToDoubleの値は、constantの場合oldに領域確保か。
emitの際は、cvtsi2sdを呼び出すだけ。???
SmiToDoubleInstrは、smiの値からunboxed doubleに変換する命令になりましたよと。
たしかに、doubleにboxingしてもすぐにunboxするし、無駄なのかも。

r22077 | asiva@google.com | 2013-04-27 03:01:43 +0900 (土, 27  4月 2013) | 5 lines
Fix some minor nits:
- Float32x4 and Uint32x4 were using the wrong script (corelib script).
- Uint32x4 was not being registered.
Review URL: https://codereview.chromium.org//14455009
冗長な宣言だった？

r22070 | hausner@google.com | 2013-04-27 00:27:00 +0900 (土, 27  4月 2013) | 5 lines
Fix context-allocated variables in stack traces
The debugger did not properly use saved contexts when collecting a stack trace.
Review URL: https://codereview.chromium.org//14503003
debuggerの機能。
以前修正したsaved contextの処理を綺麗にしたような。。

r22064 | iposva@google.com | 2013-04-26 15:57:29 +0900 (金, 26  4月 2013) | 7 lines
- Disassociate old page size from new allocatable size.
- Have a different cutoff for large page allocations
  and default old page size.
- Do not align old pages to old page size.
- Do not track used space during marking.
Review URL: https://codereview.chromium.org//14190014
sweepはちゃんと読んでないから。。
上記のコメントの元修正されているのかよくわからん。。

r22062 | regis@google.com | 2013-04-26 09:04:13 +0900 (金, 26  4月 2013) | 10 lines
Improve type optimization reusing the type argument vector of the instantiator of generic objects:
Do not require anymore that the vector be of the same length. A longer vector
with a compatible prefix is acceptable. This saves a class id check and length check.
We still require that the uninstantiated type argument vector be the identity
vector, i.e. consisting only of type parameters with consecutive indices
starting at zero. We will relax this requirement in a later change.
Review URL: https://codereview.chromium.org//14238036
type_argumentsのlengthが変わった？よくわからん。。
type_argumentsはgenericsで使用する型引数に相当する。
type_argumentsのlengthは固定だが、reuseできるように、length() >= xに変更したと。
インデックスの並びでidentityチェックを行い、長さは固定ではない。
という感じに制限を緩めて再利用していくらしい。

r22055 | johnmccutchan@google.com | 2013-04-26 07:03:05 +0900 (金, 26  4月 2013) | 3 lines
Inline Float32x4 constructors
Review URL: https://codereview.chromium.org//13936009
以下をIRにして高速化。
Constructor
zero
splat

r22042 | zra@google.com | 2013-04-26 03:03:15 +0900 (金, 26  4月 2013) | 9 lines
Adds support for debugger API on MIPS.

Enable debugger api tests on MIPS.
Enable isolate tests on MIPS.
Enable code descriptors tests on MIPS.
Enable snapshot tests on MIPS.
Enable heap tests on MIPS.
Review URL: https://codereview.chromium.org//14284020
mips実装。

r22032 | smok@google.com | 2013-04-25 23:22:30 +0900 (木, 25  4月 2013) | 3 lines
Put everything in runtime/bin into '::dart::bin' namespace.
Review URL: https://codereview.chromium.org//14341015
namespaceの変更らしい。
dart::bin::xx

r21980 | asiva@google.com | 2013-04-25 05:52:22 +0900 (木, 25  4月 2013) | 4 lines
Report OOM errors instead of asserting on allocation failures when sending
messages to other isolates.
Review URL: https://codereview.chromium.org//14273021
throwOOM
throwStackOverflow
どちらもdatastreamから
alloc_に失敗したら投げる

r21976 | hausner@google.com | 2013-04-25 05:26:14 +0900 (木, 25  4月 2013) | 6 lines
Fix debugging of top-level getters 
Parser didn't set the valid token range of top-level getters, so they
were invisible to the debugger.
Review URL: https://codereview.chromium.org//14426010
accessor_end_pos

r21972 | regis@google.com | 2013-04-25 03:55:52 +0900 (木, 25  4月 2013) | 4 lines
Enable api tests on ARM.
Disable generation of optimized code on ARM and MIPS.
Review URL: https://codereview.chromium.org//14476009
armとmipsはoptimizecount=-1で、走らない。
ARM版
LoadIndexedInstrの実装
CheckClassInstr
ARM版のdeoptimizeも順に実装？

r21964 | vegorov@google.com | 2013-04-25 02:51:10 +0900 (木, 25  4月 2013) | 8 lines
Preserve aggregate count when creating unary checks ICData.
We were reseting it to 1 which leads to worse inlining decisions
for example for user defined binary operators. Inliner considered them all cold.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14474007
GetCountAt()の実装を修正？
duplicate_class_idの際に、countをインクリメントすると。
inline展開等してunary checksを生成するコードが走る際に、countが壊れていたのかな。

r21951 | zra@google.com | 2013-04-25 00:36:40 +0900 (木, 25  4月 2013) | 5 lines
Implements missing features to run Hello, World in checked mode on MIPS.
Also re-enables a stack frame test that was disabled in checked mode.
Review URL: https://codereview.chromium.org//14431004
uninstantiated typetestのmips実装。

r21906 | zra@google.com | 2013-04-24 06:42:19 +0900 (水, 24  4月 2013) | 3 lines
Enables stack frame vm tests on MIPS.
Review URL: https://codereview.chromium.org//14446005
mips版実装かな。

r21898 | zra@google.com | 2013-04-24 03:15:52 +0900 (水, 24  4月 2013) | 4 lines
Implements catch on MIPS.
Enables UnhandledException test for MIPS.
Review URL: https://codereview.chromium.org//14289006
mips版実装かな。

r21897 | johnmccutchan@google.com | 2013-04-24 02:52:10 +0900 (水, 24  4月 2013) | 3 lines
Inline Float32x4 Getters
Review URL: https://codereview.chromium.org//13872020
get:x get:y get:z get:w
Float32x4ShuffleInstrの実装か。
うわー、、shufps()つかって,0xXXを引数指定。

r21890 | regis@google.com | 2013-04-24 01:10:22 +0900 (水, 24  4月 2013) | 9 lines
Support debugger API on ARM.
Support smull ARM instruction in order to detect 32-bit multiplication overflow.
Enable debugger api tests on ARM.
Enable isolate tests on ARM.
Enable code descriptors tests on ARM.
Enable snapshot tests on ARM.
Enable heap tests on ARM.
Review URL: https://codereview.chromium.org//13983016
object storeのARM実装。
ChainContextInstrの実装。
StoreVMFieldInstrの実装。

debugger用
PatchFunctionReturn()の実装。
RestoreFunctionReturn()の実装。部分的に書き換えてPatchingでBreakpoint？
dart vmはreturn codeの3命令をPatchしてBreakpoint用のentryに飛ぶのか。

r21880 | ager@google.com | 2013-04-23 22:12:51 +0900 (火, 23  4月 2013) | 6 lines
Yet another couple
R=srdjan@google.com
Review URL: https://codereview.chromium.org//13875007
r21879 | ager@google.com | 2013-04-23 22:09:38 +0900 (火, 23  4月 2013) | 9 lines
Update more fingerprints.
I'm sorry about all these individual changelists. Runs all debug
mode tests now, so this should be better.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//13843006
r21877 | ager@google.com | 2013-04-23 21:41:10 +0900 (火, 23  4月 2013) | 6 lines
Fixing more fingerprints. What is the right way to find all of these?
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14424009
finger printのupdate

r21876 | kmillikin@google.com | 2013-04-23 21:38:55 +0900 (火, 23  4月 2013) | 12 lines
Fix another unused-private-field clang error.
../../runtime/vm/intermediate_language.h:1093:20: error:
private field 'block_entry_' is not used [-Werror,-Wunused-private-field]
BlockEntryInstr* block_entry_;
R=kmillikin@google.com
Signed-off-by: Thiago Farina <tfarina@chromium.org>
Review URL: https://codereview.chromium.org//14341012
Patch from Thiago Farina <tfarina@chromium.org>.
ふむ。 -Wunused-private-field

r21875 | ager@google.com | 2013-04-23 21:23:27 +0900 (火, 23  4月 2013) | 6 lines
More fixes. Thanks to Slava for reminding me of check-function-fingerprints flag.
R=asiva@google.com, floitsch@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//14042012
r21873 | ager@google.com | 2013-04-23 21:06:00 +0900 (火, 23  4月 2013) | 6 lines
Fix wrong typed_data change.
R=asiva@google.com, floitsch@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//14091015
r21871 | ager@google.com | 2013-04-23 20:54:54 +0900 (火, 23  4月 2013) | 6 lines
Rename dart:typeddata to dart:typed_data.
R=asiva@google.com, floitsch@google.com, srdjan@google.com
Review URL: https://codereview.chromium.org//14426006
あー、、typeddataがtyped_dataにリネーム、、だと。

r21866 | vegorov@google.com | 2013-04-23 20:09:14 +0900 (火, 23  4月 2013) | 8 lines
Optimize static field and context load/stores as part of CSE pass.
This change also introduces basic abstractions for aliasing.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//14326006
isLoad/StoreStaticFieldを特殊化？ CorrentContextか。IndexedLoad/Storeか。
AliasとAliasSetクラスを追加。
ComputeAliasForStore
CSEでhash使ってload/storeのペアを判定していたが、複数のloadの種類をさらに集合として扱いながら、
同じ、違うを判定できるようにするため、idでなく、aliassetを使うようにした。

r21860 | iposva@google.com | 2013-04-23 15:55:17 +0900 (火, 23  4月 2013) | 3 lines
- Remove redundant include of platform/globals.h.
Review URL: https://codereview.chromium.org//14367034
不要なincludeの削除。

r21844 | iposva@google.com | 2013-04-23 06:43:57 +0900 (火, 23  4月 2013) | 3 lines
- Remove heap tracing.
Review URL: https://codereview.chromium.org//14179015
げげ、heap tracingを削除らしい。
もう使いませんってこと？

r21841 | johnmccutchan@google.com | 2013-04-23 06:35:31 +0900 (火, 23  4月 2013) | 3 lines
Mark Float32x4List as fixed length array.
Review URL: https://codereview.chromium.org//13932038
Float32x4Listのfixed length arrayか。

r21839 | zra@google.com | 2013-04-23 06:15:54 +0900 (火, 23  4月 2013) | 5 lines
Implements exception handler stub on MIPS.
Also enables codegen and object tests on MIPS.
Review URL: https://codereview.chromium.org//14273015
mips版の実装。
GenerateJumpToExceptionHandlerStub()

r21824 | zra@google.com | 2013-04-23 02:39:32 +0900 (火, 23  4月 2013) | 5 lines
Implements context allocation stub for MIPS.
Also removes uses of Push and Pop macros.
Review URL: https://codereview.chromium.org//14069019
mips版の実装。
GenerateAllocateContextStub()

r21811 | iposva@google.com | 2013-04-22 21:59:44 +0900 (月, 22  4月 2013) | 4 lines
Fix http://dartbug.com/9137 :
- Use non-normalized name when complaining about unrecognized flags.
Review URL: https://codereview.chromium.org//13483009
vm/flagsか。

r21809 | vegorov@google.com | 2013-04-22 21:30:05 +0900 (月, 22  4月 2013) | 8 lines
Ensure that type of the AssertAssignable instruction is recomputed.
If the previous type was more specific than destination type
but new value type is not than we need to update outgoing type to be destination type.
Otherwise a stale more specific type will be flowing out.
BUG=dart:10094
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//14034011
return CompileType::FromAbstractType(dst_type())

r21791 | kustermann@google.com | 2013-04-22 17:27:15 +0900 (月, 22  4月 2013) | 7 lines
Fast copy between TypedData and ExternalTypedData Until now,
copying data from TypedData to TypedData and from ExternalTypedData to ExternalTypedData was fast.
But copying between TypedData and ExternalTypedData was not handled in a fast way.
Review URL: https://codereview.chromium.org//14296006
copyのメソッドをtemplateで共通化したのかな。Copy() memmoveを使う。
templateのために、TypeDataElementTypeってのを作成。
TypedDataからTypedDataへのcopyだとこれまでどおりらしい。

r21788 | iposva@google.com | 2013-04-22 14:51:47 +0900 (月, 22  4月 2013) | 4 lines
- Use DISALLOW_ALLOCATION in Object class.
- Intercept operator delete in handles.
Review URL: https://codereview.chromium.org//13835014
BASE_OBJECT_IMPLEMENTATIONを修正
DISALLOW_ALLOCATIONで置き換え
deleteをunreachable()に変更。

r21786 | iposva@google.com | 2013-04-22 14:31:03 +0900 (月, 22  4月 2013) | 4 lines
- Reduce warnings about project settings in Xcode 4.
- Address compilation warnings found by clang.
Review URL: https://codereview.chromium.org//14084006
()の削除と、bool -> intptr_t

r21780 | regis@google.com | 2013-04-20 08:21:07 +0900 (土, 20  4月 2013) | 3 lines
Implement missing features to run Hello world! in checked mode on simulated ARM.
Review URL: https://codereview.chromium.org//14192032
LoadObjectに、引数Conditionを追加。
その結果、条件付きload/storeをemitできるようにした。

compare
LoadObject if NE
LoadObject if EQ
みたいな。

GenerateEqualityWithNullArgStub()
IC data objectは、Arrayなので、順番にloopでチェックすると。
R5がIC data object (preserved)
R6がic data array element.か
R6をインクリメントしながら、goto loop


r21778 | vegorov@google.com | 2013-04-20 07:42:46 +0900 (土, 20  4月 2013) | 12 lines
Fix clang unused-private-field error.
../../runtime/vm/dart_api_state.h:736:18: error:
private field 'key_' is not used [-Werror,-Wunused-private-field]

  ThreadLocalKey key_;
  ^
R=scheglov@google.com
TEST=ninja -C out/Debug
Signed-off-by: Thiago Farina <tfarina@chromium.org>
eview URL: https://codereview.chromium.org//14189023
Patch from Thiago Farina <tfarina@chromium.org>.
ふむ。unusedですか。

21766 | vegorov@google.com | 2013-04-20 05:14:44 +0900 (土, 20  4月 2013) | 7 lines
Drain StoreBufferBlock into store buffer instead of iterating over it directly.
This will deduplicate its entries.
StoreBufferBlock might be contain the same large object dozens of times
and without deduplication this will severely degrade GC performance
by revisiting the same large object for every time it is recorded in the StoreBufferBlock.
BUG=dart:10048
Review URL: https://codereview.chromium.org//14348026
scavengerに、
DrainBlock()ってのが追加かな。
リファクタリングと、DrainBlock()相当の処理を順番を入れ替えて、冗長な集合に対して処理しなくなったと。

r21764 | hausner@google.com | 2013-04-20 04:54:49 +0900 (土, 20  4月 2013) | 5 lines
Create handle scope in debugger callback
Fix issue 10052.
Review URL: https://codereview.chromium.org//14246043
dart api
Dart_EnterScope()で処理を囲んだ。
returnで抜けないよう制御を変えて、最後にDart_ExitScope()を挿入。

r21759 | zra@google.com | 2013-04-20 03:31:47 +0900 (土, 20  4月 2013) | 3 lines
Implements features to run "Hello, world!" on simulated MIPS.
Review URL: https://codereview.chromium.org//14246039
arm版と同様かな。
大量のパッチです。。

r21757 | zra@google.com | 2013-04-20 03:05:44 +0900 (土, 20  4月 2013) | 13 lines
Enables cross-compilation of the VM for ARM.

Uses the "toolset" feature of gyp to build the dart VM for ARM,
but restricts building of snapshot generation to the host machine.

For generated source files, it also changes to using
LIB_DIR instead of SHARED_INTERMEDIATE_DIR to avoid
generation of duplicate Makefile rules (gyp doesn't
know that generated source files from toolchains it
thinks are different will be the same.)
Review URL: https://codereview.chromium.org//12726011
featuresにおいて、integer_division_supported = false固定？

build時にオプション、toolset=host, target

platform/globals.h
simd_value_tの定義は、
typedef struct {
  union {
    uint32_t u;
    float    f;
  } data_[4];
} simd_value_t;

r21754 | srdjan@google.com | 2013-04-20 01:56:30 +0900 (土, 20  4月 2013) | 3 lines
Fully implement integer modulo in intrinsifier, fall-through only for throwing exceptions.
Also intrinsified remainder operation. TODO: generate inline code for both % and remainder.
Review URL: https://codereview.chromium.org//14205023
intrinsiferに追加。
Integer_modulo()
Integer_remainder()

r21753 | hausner@google.com | 2013-04-20 01:26:05 +0900 (土, 20  4月 2013) | 7 lines
Handle built-in function identical correctly
The parser, rather than the backend, recognizes the built-in function identical
and replaces is with the old token for the === operator. This fixes compile
time constant handling of calls to identical.
Review URL: https://codereview.chromium.org//14366007
top levelかつIdenticalだったら、ParserでComparisonNode, STRICTを生成する。
今までbuilderでStrictCompareに変換していた。

r21748 | regis@google.com | 2013-04-20 01:06:40 +0900 (土, 20  4月 2013) | 3 lines
Enable stack frame vm tests on ARM.
Review URL: https://codereview.chromium.org//14328026
ARM版
GenerateInstanceFunctionLookupStub()
GenerateInstantiatedTypeWithArgumentsTest()
is_instance is_not_instanceの生成らしい。
これって引数の型ごとに生成するのか。それとも内部向けなのか。
loadしたクラスごとかどうか、内部クラスのみかどうかは、Traceとって確認してみるか。

r21711 | srdjan@google.com | 2013-04-19 08:18:13 +0900 (金, 19  4月 2013) | 3 lines
Add flag --check-function-fingerprints,
it checks all function fingerprints of the intrinsifier and method recognizer.
Added flag to a test so that the fingerprints will be tested during a regular test.
Review URL: https://codereview.chromium.org//14247005
apiに、CheckFunctionFingerprints()を追加して、mainから叩く。
オプションは、bin/main.ccに追加。--check-function-fingerprints=false

r21709 | asiva@google.com | 2013-04-19 07:58:57 +0900 (金, 19  4月 2013) | 3 lines
Fix for issue 9617, throw a snapshot write error when encountering stacktrace objects
instead of an internal error.
Review URL: https://codereview.chromium.org//14348005
snapshotからExceptionを投げると？

r21708 | regis@google.com | 2013-04-19 07:19:49 +0900 (金, 19  4月 2013) | 5 lines
Implement catch on ARM.
Enabled UnhandledExceptions vm test.
Minor clean up.
Review URL: https://codereview.chromium.org//14362008
ReThrowInstr
CatchEntryInstrの実装かな。
catchは若干特殊で、catchしたexception_varとstacktrace_varを
それぞれ決められたRegに格納された状態でthrowされているんだけど、
spを拡張して、計算したFP + fp_sp_distに格納する。

fp_sp_distで各アーキ抽象化された。

r21696 | vegorov@google.com | 2013-04-19 04:52:26 +0900 (金, 19  4月 2013) | 6 lines
Convert EqualityCompare to StrictCompare
if reciever is either null or guaranteed to have default equality operator.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//13878017
optimizerで、StrictCompareに変換すると。
CanStrictifyEqualityComapre()で判定かな。
もしかして、これも結構パフォーマンスに影響ありそう。DeltaBlueとRichardsには効果あるみたい。

r21695 | regis@google.com | 2013-04-19 04:30:26 +0900 (金, 19  4月 2013) | 4 lines
Reset simulator top exit frame info when coming via long jump from a throw.
Thanks to Srdjan for reporting the crash on Mac.
Review URL: https://codereview.chromium.org//14141008
longjumpの際に、set_top_exit_frame_info(0)を追加？

r21692 | srdjan@google.com | 2013-04-19 03:37:24 +0900 (金, 19  4月 2013) | 3 lines
Detect leaf optimized methods and skip stack check overflow test in those,
unless it is in a loop (to be able to stop it).
Review URL: https://codereview.chromium.org//14308009
関数全体を命令順に走査して、
is_leaf = not closureFunction and is_optimizing() and !can_all(kNoCall)
命令を最後まで走査して、最終的に is_leafの場合、CheckStackOverflow()を削除。

r21689 | regis@google.com | 2013-04-19 03:32:06 +0900 (金, 19  4月 2013) | 3 lines
Merge JumpToErrorHandler and JumpToExceptionHandler stubs on all architectures.
Review URL: https://codereview.chromium.org//13874010
jumpToExceptionHandler()に統合？

r21688 | asiva@google.com | 2013-04-19 03:19:43 +0900 (金, 19  4月 2013) | 3 lines
Add endian parameter to the get/set functions in ByteData.
Review URL: https://codereview.chromium.org//14332002
ByteData_ToEndianXXX を用意。
osごとのendian変換用の関数を叩くはず。
ByteDataのapiから直接叩けるかは不明だな。。
ByteDataのget/setの引数に、endian指定できるようになる。host/little/bigかな。

r21680 | regis@google.com | 2013-04-19 01:23:25 +0900 (金, 19  4月 2013) | 6 lines
Implement long jump in ARM and MIPS simulators.
Implement error and exception handler stubs on ARM.
Hook up simulator for object tests.
Enable codegen and object tests on ARM.
Review URL: https://codereview.chromium.org//14309004
for ARM, ExceptionObjectReg = R0, StackTraceObjectReg = R1
simlatorにlogjumpを用意した。

r21667 | ajohnsen@google.com | 2013-04-18 17:13:49 +0900 (木, 18  4月 2013) | 5 lines
Fix incremental allocation of forward_list_ in dart_api_message.
Review URL: https://codereview.chromium.org//14031006
incremantal allocation

r21665 | sgjesse@google.com | 2013-04-18 16:33:24 +0900 (木, 18  4月 2013) | 5 lines
Add more tests of typed data serialization
R=asiva@google.com, ager@google.com
Review URL: https://codereview.chromium.org//14200031
snapshot testの追加。

r21647 | regis@google.com | 2013-04-18 03:48:40 +0900 (木, 18  4月 2013) | 3 lines
Minor cleanup of ARM stubs.
Review URL: https://codereview.chromium.org//14268006
コメントの修正や、brの修正。

r21626 | regis@google.com | 2013-04-18 01:02:02 +0900 (木, 18  4月 2013) | 5 lines
Uncomment more vm tests on ARM (and some on MIPS too).
Implement context allocation stub.  Some cleanup.
Review URL: https://codereview.chromium.org//14323003
ARMの実装追加。
AllocateContextInstr()
GenerateAllocateContextStub()
いつもどおりのallocate

r21610 | iposva@google.com | 2013-04-17 19:11:21 +0900 (水, 17  4月 2013) | 3 lines
- Implement reflectClass.
Review URL: https://codereview.chromium.org//14118011
Mirrors_makeLocalClasMirror ???
libにreflectClassの実装か。

r21593 | asiva@google.com | 2013-04-17 08:29:26 +0900 (水, 17  4月 2013) | 3 lines
Add utilities for converting from Host endianity to big endian and little endian formats
for the various OSs.
Review URL: https://codereview.chromium.org//14299008
HostToBig/LittleEndian32/64を準備

r21592 | hausner@google.com | 2013-04-17 08:24:21 +0900 (水, 17  4月 2013) | 3 lines
Add library id, location info to breakpointResolved event
Review URL: https://codereview.chromium.org//13940008
url linenumberが、locationになった。

r21591 | iposva@google.com | 2013-04-17 08:19:30 +0900 (水, 17  4月 2013) | 7 lines
- Add synchronous mirror API. Resurrects invoke, apply, newInstance,
  getField and setField as synchronous calls that accept isolate-local
getField and setField as synchronous calls that accept isolate-local object as arguments.
Originally reviewed as https://codereview.chromium.org/14044007/
Review URL: https://codereview.chromium.org//13942008
vm内はbootstrap_natives.hの修正のみ。引数変更。
最後の引数のtrueってなんだ。。async=falseがデフォルトになってる？trueでasync指定かな。

r21587 | asiva@google.com | 2013-04-17 07:51:24 +0900 (水, 17  4月 2013) | 3 lines
Fix for issue 9871 - Object::empty_array() returns a broken handle.
Review URL: https://codereview.chromium.org//14298012
handleで囲んだと。

r21582 | regis@google.com | 2013-04-17 06:53:09 +0900 (水, 17  4月 2013) | 3 lines
Implement missing features to run Hello world! on simulated ARM.
Review URL: https://codereview.chromium.org//14153004
ARM版
ClosureCallInstr()を実装。GenerateDartCall()を呼び出す。
StoreIndexedInstrを実装。
GuardFieldInstrを実装。
StoreInstanceFieldInstrを実装。
LoadStaticFieldInstr
StoreStaticField
CreateArrayInstr
LoadFieldInstr
InstantiateTypeArgumentsInstr
ExtractConstructorInstantiatorInstr
ThrowInstr
CurrentContextInstr
CreateClosureInstr

stub系も大量に追加
PushArgumentsArray()
GenerateAllocateARrayStub()
GenerateCallClosureFunctionStub()
GenerateAllocationStubForClosure()

r21577 | vegorov@google.com | 2013-04-17 05:55:42 +0900 (水, 17  4月 2013) | 7 lines
Change the order of blocking in AllocateRegistersLocally.
Programmer is free to specify any register as a fixed RegisterLocation
even one outside of the range available to the allocator itself.
Review URL: https://codereview.chromium.org//13963009
register blockingの順番を変更？
blocking true false true -> false xxx true true に変更したけど、よくわからん。。

r21579 | tball@google.com | 2013-04-17 06:05:37 +0900 (水, 17  4月 2013) | 3 lines
Resubmission of 21573, with corrected strndup call.
Review URL: https://codereview.chromium.org//14308006
r21575 | tball@google.com | 2013-04-17 05:47:32 +0900 (水, 17  4月 2013) | 1 line
Rolled back due to missing Windows strndup.
r21573 | tball@google.com | 2013-04-17 05:40:56 +0900 (水, 17  4月 2013) | 5 lines
Fixed stack trace for isolates without any Dart frames. Updated
stats display to display empty stack dumps, and reduced screen update time.
Review URL: https://codereview.chromium.org//13939003
isolate is_runnable()の場合はwaitすると。

r21569 | hausner@google.com | 2013-04-17 04:42:39 +0900 (水, 17  4月 2013) | 10 lines
Deprecate old debugger breakpoint handler
- Add new breakpoint handler callback that does not take a stack trace
- Remove deprecated handler from debugger core
- Adjust tests
- Old breakpoint handler support remain in code until Dartium
switches to new handler.
Review URL: https://codereview.chromium.org//14298002
何個かdeprecatedに指定されている。
最近dart_apiの整備が進んでいるのは、androidやchromeへの組込みが目標なんでしょうね。

r21561 | tball@google.com | 2013-04-17 02:50:25 +0900 (水, 17  4月 2013) | 3 lines
Added a run state field to Isolate, to show when it is executing code.
Review URL: https://codereview.chromium.org//13932024
IsolateRunStateを追加。
apiなりmessageで確認できると。

r21560 | srdjan@google.com | 2013-04-17 02:29:51 +0900 (水, 17  4月 2013) | 3 lines
Intrinsics: no need for store barrier when storing data-array into the growable array warpper
(since wrapper is guaranteed to be in new gen).
Review URL: https://codereview.chromium.org//13925025
Intrinsifier::GrowableArray_Allocate()
は、newgen固定なので、StoreIntoObjectNoBarrierを直接呼び出すと。

r21541 | johnmccutchan@google.com | 2013-04-16 19:04:34 +0900 (火, 16  4月 2013) | 3 lines
Binary Float32x4 ops.
Review URL: https://codereview.chromium.org//13867006
BinaryFloat32x4Op を追加
EmitNativeCodeも実装済み。
今のところ、addps, subps, mulps, divps

deopt
quadStackSlotの場合には、DeoptFloat32x4StackSlotInstr()を挿入する？

r21539 | kmillikin@google.com | 2013-04-16 17:40:27 +0900 (火, 16  4月 2013) | 14 lines
Refactor the code for making inlining decisions.
Separate the decision to inlin, which produces a graph to inline, from the
act of inlining itself.  For polymorphic inlining we need such a separation.

Change the function that integrates an inlined function graph into a caller
graph so that it operates on a graph entry and set of inlined exits rather
than on an entire flow graph.  Flow graphs represent a whole function so
this change allows us to replace an instruction with an arbitrary subgraph.
Change the name of the InliningContext class to InlineExitCollector to more
accurately reflect what it does.
InlineExitCollector
for polymorphic inliningのための修正って、第1候補だけinlineするのか。
inlineされた関数の複数の出口を収集しておいて、
2番目の候補の呼び出しに繋げるのかな。


r21532 | zra@google.com | 2013-04-16 09:25:03 +0900 (火, 16  4月 2013) | 3 lines
Implements write barrier on MIPS.
Review URL: https://codereview.chromium.org//13925024
mips版のStoreIntoObject系を実装。
nor and_ andi beqの4命令かな。

r21526 | srdjan@google.com | 2013-04-16 08:00:06 +0900 (火, 16  4月 2013) | 3 lines
Do not set growable array length unnecessarily.
Review URL: https://codereview.chromium.org//14265015
length > 0の場合のみ_setLengthU()

r21505 | iposva@google.com | 2013-04-16 04:46:21 +0900 (火, 16  4月 2013) | 3 lines
- Allow for experimentation with different header sizes.
Review URL: https://codereview.chromium.org//13951019
headerに、tagsとlengthを埋めるこれまでのケースの他に、
tagsのみ埋めるケースを追加。
leftover_sizeが0より小さい場合。externalのケースだと思うけど。

r21496 | ager@google.com | 2013-04-16 03:58:36 +0900 (火, 16  4月 2013) | 9 lines
Support Float32x4List in the embedding API.
This allows Dartium to use Float32x4List arguments to the webgl uniform4fv methods.
R=asiva@google.com, iposva@google.com, johnmccutchan@google.com
Review URL: https://codereview.chromium.org//14018018
dart apiにてFloat32x4をサポート

r21490 | srdjan@google.com | 2013-04-16 03:06:59 +0900 (火, 16  4月 2013) | 3 lines
Do not allocate unnecessary ObjectArrays.
When allocating an empty growable array,
pass it a compile time constant empty array instead of allocating a new empty array at runtime,
since the factory method will anyway allocate its own object array of length 4.
Review URL: https://codereview.chromium.org//14023005
parserの修正。
list.length() == 0の場合、LiteralNode()のみ確保。

r21489 | srdjan@google.com | 2013-04-16 03:06:23 +0900 (火, 16  4月 2013) | 8 lines
Run constant propagation one more time after canonicalization
so that following code can always return true:

foo() {
  var a = new List(0);
  return a.isEmpty();
}
Review URL: https://codereview.chromium.org//13932018
最適化を追加した。Canonicalizeの後に、ConstantPropagation

r21465 | ahe@google.com | 2013-04-16 00:42:44 +0900 (火, 16  4月 2013) | 3 lines
Rename InvocationMirror to Invocation.
Review URL: https://codereview.chromium.org//14049009
Invocationに変えただけ。

r21460 | ahe@google.com | 2013-04-16 00:00:45 +0900 (火, 16  4月 2013) | 3 lines
Update dart:mirrors to use Symbol.
Review URL: https://codereview.chromium.org//14173005
collection_dev_patch_cc ???

r21455 | sgjesse@google.com | 2013-04-15 23:19:46 +0900 (月, 15  4月 2013) | 9 lines
Add support for even more typed data on native ports
The only types missing now are: Float32x4, Float32x4List and
Uint32x4 (currently no Uint32x4List).
R=ager@google.com
Review URL: https://codereview.chromium.org//13998008
dart apiにx4系を追加

r21439 | vegorov@google.com | 2013-04-15 20:53:50 +0900 (月, 15  4月 2013) | 10 lines
Re-apply r20377.
Compute local variable liveness before translation to SSA.
Use it to remove dead values from deoptimization environments.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14215006
r20400 | vegorov@google.com | 2013-03-23 03:32:17 +0900 (土, 23  3月 2013) | 9 lines
Revert "Compute local variable liveness before translation to SSA."
Attaching environments to branches on strict comparisons breaks pattern matching in the optimizer
and regresses performance.
This reverts commit r20377.
TBR=kmillikin@google.com
Review URL: https://codereview.chromium.org//12827027
r20377 | vegorov@google.com | 2013-03-22 21:33:42 +0900 (金, 22  3月 2013) | 8 lines
Compute local variable liveness before translation to SSA.
Use it to remove dead values from deoptimization environments.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//12638040
SSALivenessAnalysisクラスを追加
個々の処理を集約した。
また、ComputeSSAで計算できるように、
FlowGraphにLivenessAnalysisを追加。定義箇所を移動したのかな。


r21425 | sgjesse@google.com | 2013-04-15 18:12:49 +0900 (月, 15  4月 2013) | 6 lines
Fix GCC compiler warning
TBR=ager@google.com
Review URL: https://codereview.chromium.org//14046010
r21423 | sgjesse@google.com | 2013-04-15 18:01:56 +0900 (月, 15  4月 2013) | 11 lines
Add support for more typed data types on native ports
Renamed the kUint8Array type for a Dart_CObject structure to
kByteArray to support all typed data types. The specific type is
stored in a separate type field. No matter what the specific type is,
the length of the byte array is always in bytes.
R=ager@google.com
Review URL: https://codereview.chromium.org//14142008
dart apiのDartCObjectUint8Arrayを追加したのかな。
dart apiを拡張した。


r21396 | zra@google.com | 2013-04-13 07:20:32 +0900 (土, 13  4月 2013) | 6 lines
Adds support for UseDartApi vm test on MIPS. Also, adds:
- xori instruction,
- SubuDetectOverflow (like AdduDetectOverflow).
Review URL: https://codereview.chromium.org//13884017
SubuDetectOverflow()の追加。
ParallelMoveResolverの実装。

r21392 | hausner@google.com | 2013-04-13 06:49:24 +0900 (土, 13  4月 2013) | 2 lines
More cleanups in debugger API and wire protocol
Review URL: https://codereview.chromium.org//13975018
dbg系messageの修正かな。

r21376 | zra@google.com | 2013-04-13 02:25:38 +0900 (土, 13  4月 2013) | 2 lines
Adds some floating point instructions to MIPS simulator, assembler, disassembler.
Review URL: https://codereview.chromium.org//14206002
addd adds ldc1 lwc1 mfc1 movd movs mtc1 sdc1 swc1 FRU版LoadImmediate()
ほとんどEmitFpu系の命令のはず。

FPU Reg 20 - 31はpreservedらしい
0-19までは使って問題無し。

r21374 | srdjan@google.com | 2013-04-13 02:15:59 +0900 (土, 13  4月 2013) | 2 lines
Simplify intrinsic for GrowableArray.setLength :
no need to check if the length is above the range of data, that has been checked before.
Review URL: https://codereview.chromium.org//14121010
setLength()のrange checkを削除。assembler 3命令減った。

r21373 | srdjan@google.com | 2013-04-13 01:51:48 +0900 (土, 13  4月 2013) | 2 lines
Revert to loop from rep movsb for copying one byte strings in order to restore performance.
Review URL: https://codereview.chromium.org//13922005
r21293 | srdjan@google.com | 2013-04-12 01:39:34 +0900 (金, 12  4月 2013) | 2 lines
Use rep_movsb for copying one-byte strings in substring intrinsic.
Review URL: https://codereview.chromium.org//14122002
rep_movsbを使用するようになった。

StringのEndIndex - StartIndexをECXに格納し、
rep movsbでコピーということかな。


r21371 | hausner@google.com | 2013-04-13 01:32:37 +0900 (土, 13  4月 2013) | 6 lines
Implement rethrow statement
Or: how to turn a 5 minute task into a 2 hour ordeal.
The actual business of the change is one line in token.h and one line in parser.cc.
Review URL: https://codereview.chromium.org//14012005
parserにrethrow tokenを追加
Fingerprintを大幅変更

r21370 | iposva@google.com | 2013-04-13 01:27:59 +0900 (土, 13  4月 2013) | 2 lines
- memmove instead of memcpy.
Review URL: https://codereview.chromium.org//14121009
os_macos.cc memmoveに変更

r21368 | iposva@google.com | 2013-04-13 01:19:10 +0900 (土, 13  4月 2013) | 2 lines
- Add OS::StrNDup instead of redefining it when needed.
Review URL: https://codereview.chromium.org//13994008
OS::StrNDup()を新規追加。文字の複製を行う関数

r21367 | vegorov@google.com | 2013-04-13 01:08:17 +0900 (土, 13  4月 2013) | 5 lines
Fix x64 build failing after r21366.
TBR=iposva@google.com
Review URL: https://codereview.chromium.org//13975010
r21366 | vegorov@google.com | 2013-04-13 01:03:07 +0900 (土, 13  4月 2013) | 7 lines
Fix bug in MegamorphicCacheMissHandler: put kNullCid into the cache when receiver is null.
We were putting kObjectCid before causing inline lookup code to always miss when receiver is null.
BUG=dart:9815
Review URL: https://codereview.chromium.org//13951007
cache.Insert()か

r21364 | vegorov@google.com | 2013-04-13 00:28:29 +0900 (土, 13  4月 2013) | 7 lines
Support IfThenElse instruction pattern for arbitrary smi constants.
Also fix bug in the IfThenElse::Canonicalize.
Review URL: https://codereview.chromium.org//13884009
is_power_of_two_kind以外のケースにも対応

r21353 | kmillikin@google.com | 2013-04-12 20:41:10 +0900 (金, 12  4月 2013) | 6 lines
Reapply "Incrementally recompute dominators when inlining."
Including a fix for a silly off-by-one bug.  GrowableArray::TruncateTo takes
the new length, not the new last index.
Review URL: https://codereview.chromium.org//14135006
r21270 | kmillikin@google.com | 2013-04-11 20:49:07 +0900 (木, 11  4月 2013) | 7 lines
Revert "Incrementally recompute dominators when inlining."
This reverts svn commit r21268 due to dart2js test failures.
TBR=fschneider@google.com
Review URL: https://codereview.chromium.org//13910003
r21268 | kmillikin@google.com | 2013-04-11 20:44:36 +0900 (木, 11  4月 2013) | 9 lines
Incrementally recompute dominators when inlining.
Before: we marked the entire graph's dominator tree invalid in case there
were multiple exits from an inlined function and recomputed dominators after
inlining.  Now: in case there are multiple exits we collect them in a fresh
join block and compute its immediate dominator as the nearest common
ancestor in the dominator tree over all predecessors.
Review URL: https://codereview.chromium.org//14067002
inline展開の際に、dominatorをメンテすると。
dominators.TruncateTo()
inline展開の度に、incrementalにdominatorをメンテすると。

r21351 | vegorov@google.com | 2013-04-12 20:19:34 +0900 (金, 12  4月 2013) | 6 lines
Ensure that all goto instructions have deoptimization target.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//12457034
DeoptBefore DeoptAfterは削除され、Deoptのみに統一？
Deoptimizeの処理がシンプルになったのかな。。

PhiHasSingleUse()の場合のみMatch()
join->InheritDeoptTarget()
branchのつなぎ替え時のdeopt情報をメンテするようになったということかな。
gotoのつなぎ替えに関連して、deoptのターゲットも切り替える必要があるということ？
自分でbranchのつなぎ替えをしていたときは、このポイントにハマって解決できずにいたので、
もう一度試してみるか。

r21317 | srdjan@google.com | 2013-04-12 06:27:19 +0900 (金, 12  4月 2013) | 2 lines
Better write barrier code for static fields if the value is known not to be Smi.
Review URL: https://codereview.chromium.org//14157005
StoreStaticFieldInstrにおいて、CanValueBeSmi()を導入。
StoreIntoObjectにおいて、can_value_be_smi = falseの場合はやくなる。

r21305 | hausner@google.com | 2013-04-12 04:26:25 +0900 (金, 12  4月 2013) | 2 lines
Remove legacy debugger API stuff. The removed functions do not appear to be used in Dartium.
Review URL: https://codereview.chromium.org//14029016
Deprecatedだったやつらを削除。
Dart_SetBreakpointAtLine()
Dart_DeleteBreakpoint()

r21276 | vegorov@google.com | 2013-04-11 22:08:08 +0900 (木, 11  4月 2013) | 7 lines
Fix bug introduced by r21269.
PageSpace::LargePageSizeFor should not use sizeof(HeapPage) directly
because real object start offset is additionally aligned.
Review URL: https://codereview.chromium.org//14158003
ObjectStoreOffset() RoundUP(sizeof HeapPage, OS::kMaxPreferredCodeAlignment)

r21274 | johnmccutchan@google.com | 2013-04-11 21:50:46 +0900 (木, 11  4月 2013) | 3 lines
Unboxed load/store indexed of Float32x4
Review URL: https://codereview.chromium.org//13818006
typedListにFloat32x4を追加
BoxFloat32x4Instrを追加。
ia32/x64向けにemitter追加
load/storeはmovups

BoxFloat32x4Instrを実装。
Boxなので、TryAllocate()のあとにmovups
UnboxFloat32x4Instrは、offsetからmovups

r21269 | vegorov@google.com | 2013-04-11 20:46:46 +0900 (木, 11  4月 2013) | 7 lines
Align start of the page's object area to match OS::kMaxPreferredCodeAlignment.
On ia32 we were aligning it only by 8 bytes
which would later negate all our attemps to align code objects by 16 or 32 bytes
as the very first code object would be misaligned
and the rest would have the same misalignment modulo preferred code alignment.
Review URL: https://codereview.chromium.org//13927008
object_start()のRoundUp()が、kObjectAlignmentからOS::kMaxPreferredCodeAlignmentに変更

r21252 | sgjesse@google.com | 2013-04-11 16:15:08 +0900 (木, 11  4月 2013) | 17 lines
Add support for typed data views on native threads
The deserializer running outside the VM can now decode typed data views.
As the typed data views are implemented as normal Dart
instances and not a internal VM object the deserializer have been
expanded to process serialized objects of the type used to create these views.
The typed data object that the view is based on will always be serialized as part of the message.
Currently only vews created with constructor Uint8List.view on top of an Uint8List are supported.
R=ager@google.com
BUG=https://code.google.com/p/dart/issues/detail?id=9484
Review URL: https://codereview.chromium.org//14065006
dart api
AllocateDartCObjectInternal()
AllocateDartCObjectClass()

r21235 | regis@google.com | 2013-04-11 07:34:02 +0900 (木, 11  4月 2013) | 5 lines
A patch class must be given the same name as the class it is patching, otherwise
the generic signature classes it defines will not match the patched generic
signature classes. Therefore, new signature classes will be introduced and the
original ones will not get finalized.
Review URL: https://codereview.chromium.org//14097006
symbolsからpatchを削除。
patchシンボルを使用せず、patchクラスと同じ名前というルールになる。

r21233 | zra@google.com | 2013-04-11 06:59:57 +0900 (木, 11  4月 2013) | 10 lines
Supports FrameLookup vm test on MIPS
As with the similar CL for ARM, also:
- Supports inline allocation of objects.
- Supports checking of inline cache and instance calls.
- Supports subtype test cache.
- Supports (some) equality checks.
- Supports for (some) conditional branches.
- Supports for pool pointer setup in stubs.
Review URL: https://codereview.chromium.org//14076005
Enter/LeaveStubFrame()

uses_pp object_pool

GenerateCallSubtypeTestStub()
GenerateSubtype1TestCacheLookup()
GenerateAllocationStubForClass()
GenerateUsageCounterIncrement()
GenerateNArgsCheckInlineCacheStub()
GenerateSubtypeNTestCacheStub()
GenerateIdenticalWithNumberCheckStub()
などなど


r21232 | srdjan@google.com | 2013-04-11 05:37:02 +0900 (木, 11  4月 2013) | 2 lines
Intrinsify OnebyteString's substringUnchecked. Significant performance improvement on Json benchmarks.
Review URL: https://codereview.chromium.org//13964002
この修正で、Richardのスコアが80くらい上ったみたい。

下記を組込み関数とした。
intrinsifer
OneByteString_substringUnchecked()
補助関数、TryAllocateOnebyteString()

r21217 | regis@google.com | 2013-04-11 01:43:39 +0900 (木, 11  4月 2013) | 6 lines
Prohibit use of dynamic when extending or implementing classes (was crashing).
Added test.
Fix typos in array patch.
Cleanup factory result finalization.
Do not verify field offsets after a finalization error.
Review URL: https://codereview.chromium.org//13992002
parser
// The type arguments of the result type are the type parameters of the
// current class. Note that in the case of a patch class, they are copied
// from the class being patched.


r21215 | vegorov@google.com | 2013-04-11 01:10:46 +0900 (木, 11  4月 2013) | 5 lines
Repair compilation with VTune support.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14063008
vm/vtune.hのinclude追加。

r21207 | vegorov@google.com | 2013-04-11 00:09:46 +0900 (木, 11  4月 2013) | 7 lines
Convert diamond shaped control flow into a single conditional instruction.
Adds a IfConverter pass that right now recognizes two simple patterns
cond ? 0 : 2^n and cond ? x : x+-1
that can be generated without branches on ia32 and x64 using setcc instruction.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//14057004
IRにIfThenElseを追加。
setcc(cond, dst)を出力するらしい。
ARMは今のところnot support
IfThenElseは、両方constantの場合、条件式を畳み込む。
IfConverter::Simplify()
condition, true value, false valueの形式に変換するのか。
emitの際には、conditionを出力して、setccを決め打ち。

r21200 | sgjesse@google.com | 2013-04-10 22:41:32 +0900 (水, 10  4月 2013) | 20 lines
Fix issue with serializing typed array views This makes the code

void isolate() {
  port.receive(print);
}

main() {
  Uint8List list = new Uint8List(1);
  spawnFunction(isolate).send([1, new Uint8List.view(list.buffer, 0, 1)]);
}

not crash.
R=asiva@google.com
Review URL: https://codereview.chromium.org//13866012
snapshotの際に、WriteInstanceRef
viewのserializeってどうやっているのか。。そもそもserializeできるのか。

r21175 | hausner@google.com | 2013-04-10 08:36:51 +0900 (水, 10  4月 2013) | 8 lines
Fix issue 9744
Allow for debugger stack frames that have no corresponding pc descriptor
entry, i.e. the PC is not at a known safe point. In that case, we cannot
return a code location nor variables.
Fixes 9744
Review URL: https://codereview.chromium.org//13948009
tokenpos -1やら todo

r21160 | iposva@google.com | 2013-04-10 02:51:24 +0900 (水, 10  4月 2013) | 2 lines
Changelist to land https://codereview.chromium.org/13452007/ for Siva.
Review URL: https://codereview.chromium.org//13813018
Dart_IsolateMakeRunnable()を追加
mutex lock/unlock?

IsolateSpawnStateを追加。
lib/isolate.ccから、vm/isolateに移動したのかな。

r21148 | vegorov@google.com | 2013-04-09 21:23:46 +0900 (火, 09  4月 2013) | 11 lines
Fix bug in ParallelMoveResolver::EmitSwap: implement swaps of FPU spill slots.

Remove representation from location.
Presence of representation in location encoding was violating the invariant
that unequal locations must be disjoint
(where equality for locations is defined in terms of bitwise equality of their encoding).
This could lead ParallelMoveResolver to treat XMM1 containing unboxed double as unequal location
to XMM1 containing unboxed mint, which is obviously incorrect.
For similar reason eliminate kFloat32x4StackSlot and kUint32x4StackSlot distinction is eliminated
and both are replaced with kQuadStackSlot.
Register allocator now guarantees that no kQuadStackSlot occupies
the same space as any other kDoubleStackSlot.
This also shrinks optimized stack when only doubles are used
(but might lead to a higher stack utilization when a mixture of doubles and quads is used).
Implement allocation of scratch Cpu and Xmm registers for ParallelMoveResolver.
This also allows to remove push(eax)/pop(eax) pairs when resolving memory-memory cycles on ia32.
BUG=dart:9710
Review URL: https://codereview.chromium.org//13801014
locationsに、kQuadStackSlotを追加。これはUI32x4SやF32x4Sを代替する。
つまりQuadStackSlotとして扱う。
Allocatorにquad spill slotを追加
spill時にneed quadとな。

class ScratchFpuRegisterScopeを新規追加
ParallelMoveResolverで、scratch registerを確保し、spillできるようになったのか？

どのタイミングでscratch registerを確保できるのだろうか。
double mint simd128のunboxing時？

r21118 | zra@google.com | 2013-04-09 07:04:27 +0900 (火, 09  4月 2013) | 4 lines
Introduces a second temporary register for MIPS assembler macros.
- Also, adds macros for comparisons followed by branches, and uses them.
Review URL: https://codereview.chromium.org//13483018
Mipsをちゃんとみてなかったけど、、
TMP1 = AT
TMP2 = T9 <-- こいつを追加した。
TMP  = TMP1

r21098 | hausner@google.com | 2013-04-09 03:31:56 +0900 (火, 09  4月 2013) | 5 lines
Add library id to code location object
Add libraryId field to the JSON Location object in the debugger wire protocol.
Review URL: https://codereview.chromium.org//13771013
libraryIdをprintfすると。

r21085 | zra@google.com | 2013-04-09 01:51:12 +0900 (火, 09  4月 2013) | 2 lines
Adds macros to the MIPS assembler for detecting overflow.
Review URL: https://codereview.chromium.org//13722022
AdduDetectOverflow()
addu
xor
xor
and
の4命令ってどういうこった。
これはmipsのみか。


r21083 | regis@google.com | 2013-04-09 01:44:39 +0900 (火, 09  4月 2013) | 3 lines
Implement write barrier on ARM.
Enable StoreIntoObject and DartEntry vm tests.
Review URL: https://codereview.chromium.org//13638019
下記命令では、IPレジスタをつかって、入力となるレジスタを壊さない。
IPは、Dart VM for ARMにおいてtempとして使いまわすルールである。

StoreIntoObjectFilterNoSmi()
bicは、value & ~objectによって、valueがnewgen, objectがoldgenであることをチェックしている。

StoreIntoObjectFilter()
Filterの場合、Smiの可能性もあり、and_でSmiとnewgenの条件を畳み込む。
その後にbic

StoreIntoObject()
can_value_be_smiの場合、Filter
Smiを取りえない場合、NoSmiを呼び出す。
updateする場合、BranchLink UpdateStoreBufferLabel()

StoreIntoObjectNoBarrier()
str命令のみ debug時はSToreIntoObjectFilterを呼び出す。

GenerateUpdateStoreBufferStub()
  bufferの更新
  もしoverflowしていたら、StoreBufferBlockProcessRuntimeEntryを呼び出す。


r21079 | floitsch@google.com | 2013-04-09 01:07:34 +0900 (火, 09  4月 2013) | 3 lines
Remove deprecated Expect from the libraries.
Review URL: https://codereview.chromium.org//13724021
testコードにExpectを追加。

r21074 | vegorov@google.com | 2013-04-08 23:32:46 +0900 (月, 08  4月 2013) | 8 lines
Use locale insensitive method to parse double literals.
Using strtod does not work because Dart grammar does not necessary match grammar used by strtod.
Some locales (e.g. Russian and Danish) use comma instead of dot for radix point.
R=iposva@google.com
Review URL: https://codereview.chromium.org//13529014
CStringToDouble()からStringToDouble()を呼び出している。
lib/double.ccからも、static関数として呼び出しているみたい。。

r21009 | hausner@google.com | 2013-04-06 08:45:14 +0900 (土, 06  4月 2013) | 5 lines
Add line table command to debugger
New command returns token information of a script. This will enable
the editor/debugger to translate token offsets to line numbers.
Review URL: https://codereview.chromium.org//13533016
Dart_ScriptGetTokenInfo()を追加
Arrayにtoken_lineを詰め込んでかえす
cmdに、getLineNumberTableってのが追加されて、上記を呼び出す。

r21008 | srdjan@google.com | 2013-04-06 08:26:53 +0900 (土, 06  4月 2013) | 2 lines
Restore r20998 with a bug fix: add field to guarded_fields_ when it contains relevant cid.
Was missing most cases and did not check for unique adds.
Review URL: https://codereview.chromium.org//13726023
r21001 | srdjan@google.com | 2013-04-06 06:44:17 +0900 (土, 06  4月 2013) | 2 lines
Revert r20998.
Review URL: https://codereview.chromium.org//13739002
r20998 | srdjan@google.com | 2013-04-06 06:01:30 +0900 (土, 06  4月 2013) | 2 lines
Fix guarded_cid handling: add field to list of guarded_field at LoadField creation time.
Review URL: https://codereview.chromium.org//13529021
inline展開の際に、guarded fieldsのarrayを引数で渡す。
inline展開する、親contextにおいて、guarded fieldsをdependenciesとして登録する。

loadがdynamic以外であるならば、loadのuseにNULLを渡して歩く。
NULLを渡すのは、たしかリセットして再度型伝搬させるのが目的だったか。
20549を参照。

r20996 | floitsch@google.com | 2013-04-06 04:43:16 +0900 (土, 06  4月 2013) | 6 lines
Remove Expect from core library.
Committed: https://code.google.com/p/dart/source/detail?r=19755
Reverted: http://code.google.com/p/dart/source/detail?r=19756
Review URL: https://codereview.chromium.org//12212016
testの追加。class Expectのかな。

r20981 | regis@google.com | 2013-04-06 01:46:53 +0900 (土, 06  4月 2013) | 2 lines
Support UseDartApi vm test on ARM.
Review URL: https://codereview.chromium.org//13671004
これも結構でかいパッチですね。下記を実装したっぽい。
ParallelMoveResolver
BinarySmiOp()
PolymorphicInstanceCall
GenerateOptimizeFunctionStub()

r20948 | asiva@google.com | 2013-04-05 14:19:36 +0900 (金, 05  4月 2013) | 7 lines
- Create an all static TypedDataView class which uses implicit field offset
  values to get direct access to the fields of a typed data view object.
- Added a verification step after class finalization to ensure that the
  implicit field offsets in TypedDataView match the actual values in the dart instance.
Review URL: https://codereview.chromium.org//13472019
TypedDataViewクラスを追加
作成されただけで、まだ外部のメソッドからbindされていない？

r20945 | johnmccutchan@google.com | 2013-04-05 08:23:30 +0900 (金, 05  4月 2013) | 3 lines
Flow graph SIMD changes
Review URL: https://codereview.chromium.org//13471013
UnboxedFloat32x4とUnboxedUint32x4も、representationに追加
上記において、parallel moveのemitにおいて、movupsを使用する。すばらしい。

r20938 | regis@google.com | 2013-04-05 05:24:49 +0900 (金, 05  4月 2013) | 6 lines
Prevent expensive and unnecessary error formatting in the case a bound check is
postponed to run time (issue 9106).
Eliminate bound check at compile time in some cases.
Fix bound checking of mutually referencing bounds.
Added test.
Review URL: https://codereview.chromium.org//13653005
finalizerでtype parameterのbound check

r20936 | tball@google.com | 2013-04-05 03:48:24 +0900 (金, 05  4月 2013) | 3 lines
Updated VM stacktrace support (20898) with platform-
independent version of strndup.
Review URL: https://codereview.chromium.org//13587008
kVmStatusInterrrupt
callbackを登録する処理と、reqを飛ばしてcallbackを呼び出す処理に分かれる。

GetStatusみたいな外部割り込みには、
MonitorLockerを使用する。

r20932 | zra@google.com | 2013-04-05 02:55:06 +0900 (金, 05  4月 2013) | 2 lines
Implements type checking in MIPS needed for FindCodeObject test.
Review URL: https://codereview.chromium.org//13619008
Mips版の、LoadClassId, LoadClassById, LoadClass
ARM版の20623に相当する。

r20924 | zra@google.com | 2013-04-05 01:56:00 +0900 (金, 05  4月 2013) | 8 lines
Fixes a bug in MIPS simulator runtime call handling.
Also:
- Fixes a bug in the MIPS SimulatorDebugger that
  causes a crash if the pc is an illegal address
- Reenables the FindCodeObject test on MIPS when
  checking is off
Review URL: https://codereview.chromium.org//13489008
mips simulatorの改善

r20921 | srdjan@google.com | 2013-04-05 01:13:50 +0900 (金, 05  4月 2013) | 3 lines
Fix checked mode crash when clearing reaching type of a value.
When replacing uses we clear type information that is set by a previous type propagation
(e.g. by CheckSmi).
This led to unexpected behavior:
value guarded by a CheckSmi but not Smi.
Adding another type propagation pass before code generation.
Review URL: https://codereview.chromium.org//13125002
ApplyClassIds()において、
loadのresult_cidがdynamicCidでない場合、setReachingType(NULL)

r20914 | fschneider@google.com | 2013-04-04 21:42:17 +0900 (木, 04  4月 2013) | 25 lines
Use range analysis to improve constant propagation.

This CL runs a second round of constant propagation after range
analysis to eliminate additional unreachable code. Range analysis
is changed to mark branches as constant if the constraints they
generate are unsatisfiable.

The second pass of constant propagation only visits branches and
removes unreachable code, but does not do full constant propagation.

This proves useful when inlining array view operations where the
following pattern occurs:

for (i = 0; i < length; i++) {
  if (i < 0 || i >= length) {
    throw 123;
  }
  foo();
}
In this example the if-statement will be eliminated completely.
Also, fix a bug in range analyis where constraints of already
constrained values were missing.
Review URL: https://codereview.chromium.org//13469013
RangeAnalysisの後に、ConstantPropagationを追加

RangeAnalysisにおいて、 true/false successorを設定する。
上記情報を参照して、InferRange()
set_constant_target()で飛び先を一意に指定する。

ConstantPropagationにvisitBranchを追加
true/falseにおいて、constant_targetを参照し、SetReachable()を設定する。
successorへの伝搬を、RangeAnalysisの結果を元に制御する。

上記の組み合わせで、到達しないブロックが判明し、
後続のパスで削除するか、ConstantPropagatorでbranchが書き換えられるはず。


r20902 | srdjan@google.com | 2013-04-04 07:34:02 +0900 (木, 04  4月 2013) | 2 lines
Fix issue 9644: object stores become large pieces of code if heap tracing is turned on;
jumps around the the store must not use near labels.
Review URL: https://codereview.chromium.org//13588005
jumpの際に、kNearJumpを指定しないように修正。

r20895 | zra@google.com | 2013-04-04 06:43:52 +0900 (木, 04  4月 2013) | 5 lines
Implements optional parameter handling in MIPS vm.
- Deocdes ic data and argument descriptor.
- Removes SUB instruction from assembler and disassembler.
Review URL: https://codereview.chromium.org//13474009
mipsのArgumentDescriptorの実装

CopyParameters()
PositionalArgumentsの後に、OptionalNamedArguments
おそらくARM版とほぼ同じ。
r20399を参照かな。ARMから2週間遅れくらい？

PushArgumentInstrの実装

r20890 | regis@google.com | 2013-04-04 05:17:14 +0900 (木, 04  4月 2013) | 11 lines
Support FrameLookup vm test on ARM, requiring among other things:
Maintain a separate top_exit_frame_info for simulated frames and use it to
verify that longjumps are safe.
Make sure unwinding of scopes works in the presence of a simulator.
Support inline allocation of objects.
Support checking of inline cache and instance calls.
Support subtype test cache.
Support (some) equality checks.
Support for (some) conditional branches.
Support for pool pointer setup in stubs.
Review URL: https://codereview.chromium.org//13502002

LoadFromOffset()

引数のuses_ppってなんだ、、
PPは、R10で、Caches object pool pointerらしい。

intermediate_language_arm.ccも実装が進んでいる
AssertBooleanInstrを実装。
TrueとFalseと比較して、どっちでも無い場合CallRuntime

CompareInstrの実装は複雑だ。。
Locationで、Mintはin*2 tmp*1 out*1
Doubleで、in*2 out*1なので、Doubleのほうが少ない。。
Smiも、in*2 out*1

基本的な構造はia32を引き継ぎつつ、asmを置換か。

GenerateAllocationStubForClass()
FLAG_inline_alloc

これは内部用のallocatorだっけか。
基本はcopy gc向けにtopとendのチェック。
内部用なので、既にsizeは分かっていると。

GenerateNArgsheckInlineCacheStub()
todo

GenerateOneArgCheckInlineCacheStub()
todo


r20885 | srdjan@google.com | 2013-04-04 04:42:29 +0900 (木, 04  4月 2013) | 3 lines
Mark CallLeafRuntimeStubCode as failing on Mips/Mac OS X.
Added some cleanups.
Review URL: https://codereview.chromium.org//13575002
Mac OS X.でsimmips clashらしい。

r20871 | srdjan@google.com | 2013-04-04 01:22:24 +0900 (木, 04  4月 2013) | 2 lines
Fix issue 9608: When replacing call with assert assignable, transfer call's deopt_id to the new node.
Review URL: https://codereview.chromium.org//13464021
assert追加。

r20828 | iposva@google.com | 2013-04-03 07:45:18 +0900 (水, 03  4月 2013) | 2 lines
- Remember objects (not addresses) in the old generation containing new pointers.
Review URL: https://codereview.chromium.org//13406004
StoreIntoObject()が、object != EAXの際に、1命令削減。

StoreBufferUpdateVisitorにおいて、
old_objを保存しておくようにしたと。
修正前は、StoreBufferのscanが必要/不要フラグだけだった。

代わりに、scavengerのstorebufferを走査する際に最内側ループからifがなくなった。。
if で判定して、duplicate++っていう修正前のコードが問題で、
修正後はduplicateを排除した。

r20816 | hausner@google.com | 2013-04-03 05:41:29 +0900 (水, 03  4月 2013) | 10 lines
Add text location in debugger event
- Adding token number in text location data. Line number will be
  removed when the editor knows how to convert a token number to its line number.
- "location" field in stack frames is now optional. If it is not present, there
  is no corresponding textual location for the code location.
- Add location info of "paused" and "interrupted" events.
  Stack trace will go away in these events.
Review URL: https://codereview.chromium.org//13144018
Dart_ActivationFrameGetLocation()
locationとtokenposを取得できるようになったと。。

r20813 | zra@google.com | 2013-04-03 05:24:55 +0900 (水, 03  4月 2013) | 2 lines
Adds native/leaf runtime call stub and redirection on MIPS.
Review URL: https://codereview.chromium.org//13473010
TargetAddress()やSetTargetAddress()
16bitごとに分けて格納か。

GenerateCallNativeCFunctionStub()
BranchPatchable()
label addressをやっぱり16bitごとに扱うと。

r20794 | zra@google.com | 2013-04-03 01:40:14 +0900 (水, 03  4月 2013) | 2 lines
Third codegen test passing for simulated MIPS.
Review URL: https://codereview.chromium.org//13407003
GenerateCallRuntimeStub
GenerateCallStaticFunctionStub

r20783 | srdjan@google.com | 2013-04-03 00:30:14 +0900 (水, 03  4月 2013) | 2 lines
Optimizes 'as' operation in similar way as 'instanceof':
collect type feedback in unoptimized mode and try to convert
it to a simple classcheck in optimized code.
Review URL: https://codereview.chromium.org//13190014
collect type feedbackは、InstanceCallInstr()で行っているのか。
ReplaceWithTypeCast()
asがtrueに確定なら、除去。
そうでないなら、assertAssignableInstrを挿入か。

r20770 | kasperl@google.com | 2013-04-02 20:51:36 +0900 (火, 02  4月 2013) | 9 lines
Add a new implementation of HashMap that uses JS objects for its (multiple) hash tables.
I'll start refactoring the implementation to make it a bit more
maintainable, but I wanted to get your first impressions.
R=erikcorry@google.com,lrn@google.com,srdjan@google.com
Review URL: https://codereview.chromium.org//12827018
lib/collection_patch.dart:patch class Hashmap<K, V>

r20760 | asiva@google.com | 2013-04-02 09:01:15 +0900 (火, 02  4月 2013) | 2 lines
First step for fixing Issue 9416.
Review URL: https://codereview.chromium.org//13351002
isolateのsticky errorの修正？

r20744 | srdjan@google.com | 2013-04-02 04:45:47 +0900 (火, 02  4月 2013) | 2 lines
When optimizing instanceof allow also for raw types (List, ..).
Review URL: https://codereview.chromium.org//13215006
TypeArgumentsが!is_raw_typeの場合に限り、return Bool::null()を返す。
今回から、hasTypeArguments() && !type_arguments.IsNull() && !IsRaw()
に限り、Bool::null()

r20734 | zra@google.com | 2013-04-02 02:02:44 +0900 (火, 02  4月 2013) | 2 lines
First two codegen tests passing on SIMMIPS
Review URL: https://codereview.chromium.org//13228002
Mips向け
LoadObject()の場合、
Smiはobject.raw()だけど、
InVMHeap()の場合、lowとhiに分けてrdにloadする。
どちらでもない場合、object poolから参照する。LoadWordFromPoolOffset()

EnterDartFrame()

r20701 | asiva@google.com | 2013-03-30 09:07:13 +0900 (土, 30  3月 2013) | 4 lines
- The callback_error_ handle was never being setup.
- Remove some unnecessary DARTSCOPE calls when true/false/null Dart_Handles are created.
Review URL: https://codereview.chromium.org//13171004
DART_SCOPEの用途がわからんな。

r20680 | asiva@google.com | 2013-03-30 03:33:54 +0900 (土, 30  3月 2013) | 2 lines
Remove support for 'dart:scalarlist' in the Dart VM.
Review URL: https://codereview.chromium.org//13139002
一通り削除。。

r20623 | regis@google.com | 2013-03-29 02:41:35 +0900 (金, 29  3月 2013) | 2 lines
Support checked mode for VM tests on ARM.
Review URL: https://codereview.chromium.org//12773008
LoadClassId()
  ClassIdTagBit == 16, ClassIdTagSize == 16
  tags_offset() + ClassIdTagBit / BitsPerTByte
LoadClassById()
  ldr result, isolate_offset + class_table_offset + table_offset
  ldr result, class_id, LSL, 2
LoadClass()
  LoadClassIdして、LoadClassById

flow_graph_compiler_arm.ccに、eliminate_type_checks
GenerateInstantiatedTypeNoArgumentsTest()
GenerateInlineInstanceof()
  voidの場合、null
  if TypeCheckAsClassEquality()
    Smiの場合、is_instance_lbl
    Smi以外の場合、CompareClassId() is_instance_lbl
  if IsInstantiated()
    HasTypeArguments()
    NoArgumentsTest()
  GenerateSubtype1TestCacheLookup()
  GenerateUninstantiatedTypeTest()

GenerateAssertAssignable()


r20595 | asiva@google.com | 2013-03-28 08:15:27 +0900 (木, 28  3月 2013) | 4 lines
More preparation for removal of dart:scalarlist
- remove the intrinsification of scalarlist functions
- changed class Ids to TypedData class Ids
Review URL: https://codereview.chromium.org//13004017
intrinsifierから一通り削除。

r20576 | regis@google.com | 2013-03-28 05:42:02 +0900 (木, 28  3月 2013) | 3 lines
Fix an F-bounded quantification bug (issue 9291).
Add regression test.
Review URL: https://codereview.chromium.org//13119022
F-bounded quantification対応
class A <T extends I<T>>

こういうtype parameterの解決は、class_finalizerで行う。
ResolveTypeのタイミングで、後回しにする。
一時的にpassし、cycleが解決されるまでループ。

r20565 | vegorov@google.com | 2013-03-28 02:13:58 +0900 (木, 28  3月 2013) | 7 lines
On x64 use 32bit idiv when possible instead of 64bit one.
64bit idiv requires twice as much cycles and has 2-3 times higher latency.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//12545067
Intrinsifer::Integer_modulo()
x64において、
operandがどっちも32bitに収まるなら、idivl
そうでないなら、idivq

truncDivide()も同様
32bit idivl
64bit idivq

x64において、32bitを扱う場合、movsxdを使用する。


r20563 | johnmccutchan@google.com | 2013-03-28 02:06:41 +0900 (木, 28  3月 2013) | 3 lines
Really remove SIMD types from dart:scalarlist. Fixes build.
Review URL: https://codereview.chromium.org//12907023
ByteArrayベースのsimd128系を削除。

r20559 | johnmccutchan@google.com | 2013-03-27 23:44:15 +0900 (水, 27  3月 2013) | 3 lines
Review changes
Review URL: https://codereview.chromium.org//12982010
20526のrecommit

r20550 | srdjan@google.com | 2013-03-27 08:41:27 +0900 (水, 27  3月 2013) | 3 lines
Improve code for !identical(a, b):
"x = (a === b); y = (x !== true)" => "y = (a !== b)".
Review URL: https://codereview.chromium.org//12852007
instcombine風な畳み込み。
どういうケースでこういうケースが出現するのだろうか。branch？

r20549 | srdjan@google.com | 2013-03-27 08:04:48 +0900 (水, 27  3月 2013) | 2 lines
Disable optimization in r20548 to make bots green again.
Review URL: https://codereview.chromium.org//12475019
r20548 | srdjan@google.com | 2013-03-27 07:02:09 +0900 (水, 27  3月 2013) | 2 lines
When attempting to to inline a field getter we use the incoming cid.
That type may differ between value()->Type() and value->definition()->Type()
if the definition is a load field with a guarded cid.
Therefore, if value's type is dynamic we check definition's type as well.
Review URL: https://codereview.chromium.org//12843043
即戻してるけど、
== typeの場合にNULL設定するってどういうこった。。
NULLにして、伝搬先の型を一度resetして、再度推論させたいのか。

r20547 | asiva@google.com | 2013-03-27 07:01:31 +0900 (水, 27  3月 2013) | 2 lines
More cleanup in preparation for removing support for dart:scalarlist in the VM.
Review URL: https://codereview.chromium.org//13093012
scalarlistからtypeddataに置き替え

r20545 | regis@google.com | 2013-03-27 06:26:03 +0900 (水, 27  3月 2013) | 3 lines
Fix issue 9442.
Add regression test.
Review URL: https://codereview.chromium.org//13046009
error checkのassertを追加

r20539 | zra@google.com | 2013-03-27 05:27:31 +0900 (水, 27  3月 2013) | 2 lines
Simplifies MIPS LoadWordFromPoolOffset
Review URL: https://codereview.chromium.org//13094015
simplifier

r20532 | asiva@google.com | 2013-03-27 03:46:44 +0900 (水, 27  3月 2013) | 3 lines
Fix some of the scalarlist tests to use TypedData VM classes.
This is in preparation for removing dart:scalarlist support from the VM.
Review URL: https://codereview.chromium.org//12907010
scalarlistが終了したお。。

r20527 | zra@google.com | 2013-03-27 02:50:43 +0900 (水, 27  3月 2013) | 2 lines
Adds Stop to MIPS. Starts on MIPS call patcher.
Review URL: https://codereview.chromium.org//12703028
CallPatternに、IcData()を追加

LoadWordFromPoolOffset()
  CanHoldでない場合、low hiに分けて扱うと。
AddObject()
  poolに登録済みかシーケンシャルサーチして、なければ末尾に追加すると。
AddExternalLabel()

labelはすべてarrayに貯められると。
この辺は普通のassemblerだから。。


r20526 | johnmccutchan@google.com | 2013-03-27 02:40:25 +0900 (水, 27  3月 2013) | 3 lines
Revert 12534006
Review URL: https://codereview.chromium.org//13093005
r20522 | johnmccutchan@google.com | 2013-03-27 01:50:26 +0900 (水, 27  3月 2013) | 3 lines
Port SIMD types from dart:scalarlist to dart:typeddata.
Review URL: https://codereview.chromium.org//12534006
TypedDataにsimd128を追加。scale=16
Float32x4Arrayのみかな。
って即revertか

r20500 | regis@google.com | 2013-03-26 08:50:41 +0900 (火, 26  3月 2013) | 3 lines
Change the order of loading ic_data and arguments descriptor prior to an
instance call on ARM.
Review URL: https://codereview.chromium.org//12964007
R5 -> R4だったのが、R4 -> R5になったのか
本当に順番を入れ替えただけですね。。

r20496 | tball@google.com | 2013-03-26 07:26:37 +0900 (火, 26  3月 2013) | 2 lines
Rollback stacktrace change.
Review URL: https://codereview.chromium.org//12894005
r20494 | tball@google.com | 2013-03-26 07:16:40 +0900 (火, 26  3月 2013) | 2 lines
Added VM support for isolate stacktrace status.
Review URL: https://codereview.chromium.org//12578022
isolateにstacktraceを出力させる、しかもjsonで。
GetStatus()か
なんだっけ、、portから接続して取得する機能をjson風にしたってことか。

r20493 | regis@google.com | 2013-03-26 07:14:17 +0900 (火, 26  3月 2013) | 3 lines
Update function subtyping rules to latest spec (issue 9057).
Update language tests and status files (and filed co19 issue 392).
Review URL: https://codereview.chromium.org//12940010
function subtypingってのは、引数の個数が少ない場合に、
optional parametersとfixed parametersとの関係上、
少ない場合にどの関数がマッチすべきかの条件を変更した。

r20483 | regis@google.com | 2013-03-26 05:29:47 +0900 (火, 26  3月 2013) | 5 lines
Do not use object pool for VM heap objects on ARM.
Update decoding of call pattern accordingly.
Add missing store barrier when storing object pool in instructions object.
Work with GrowableObjectArray in old heap space when assembling object pool.
Review URL: https://codereview.chromium.org//13070003
ARMでは、x86みたいにObject Poolは使わないと。。
ってわけでもないけど、Null True Falseを使わなくなっただけかな。。
やっぱりIsNull()は、Object Poolではなく、Immediateを使うと。

set_object_pool()の際に、StorePointer()でstore barrier

DecodeLoadObjectも面白い。
0xe59だったばあい、DecodeLoadWordFromPool()
そうでない場合、DecodeLoadWordImmediate()

object_poolは、今はArrayだけど、将来はGrowableObjectArrayにして、Old領域に確保するよと。


r20482 | asiva@google.com | 2013-03-26 05:18:44 +0900 (火, 26  3月 2013) | 3 lines
Handle TypedDataView objects in Dart_TypedDataAcquireData and
Dart_TypedDataReleaseData
Review URL: https://codereview.chromium.org//12937010
TypedDataViewを追加。
いつものmacroによる文字列連結

r20472 | hausner@google.com | 2013-03-26 04:05:21 +0900 (火, 26  3月 2013) | 4 lines
Fix fingerprint mismatches
TBR=iposva
Review URL: https://codereview.chromium.org//13030003
r20466 | hausner@google.com | 2013-03-26 03:11:08 +0900 (火, 26  3月 2013) | 7 lines
Remove legacy syntax support for library import
Remove legacy syntax for #import, #library and #source
Update test programs
Recalc fingerprints of inlined functions that were apparently
affected by the change of library name from "dart:io" to dart.io.
Review URL: https://codereview.chromium.org//12880023
old syntaxを修正するだけで、
このfingerprintsの修正は、、
どっかにfingerprints書き換えるマクロがあるのだろうか。。

r20450 | tball@google.com | 2013-03-26 01:21:58 +0900 (火, 26  3月 2013) | 3 lines
Added EXPECT_TRUE macro,
updated debugger unit tests to use it for API calls that return True.
Review URL: https://codereview.chromium.org//13009004
vm/unit_test.hの修正


r20426 | asiva@google.com | 2013-03-23 08:29:34 +0900 (土, 23  3月 2013) | 3 lines
Fix 9347, always send ExternalTypedData objects as TypedData objects when
sending them across isolates.
Review URL: https://codereview.chromium.org//12594013
マクロ作って囲った。。

r20423 | asiva@google.com | 2013-03-23 07:43:46 +0900 (土, 23  3月 2013) | 4 lines
- Canonicalize types, type_arguments only when the object is marked as being from the core libraries.
- adjust the snapshot write buffer growth policy
- turn off the heap growth rate adjustments when reading from a snapshot.
Review URL: https://codereview.chromium.org//12578009
heapに、GrowthControlState()を追加。
NoHeapGrowthControlScope()クラスを新規追加。

snapshot messageの際は、type canonicalするように変更
snapshotのkNumInitialReferences = 4 --> 64に変更。


r20419 | zra@google.com | 2013-03-23 06:37:10 +0900 (土, 23  3月 2013) | 2 lines
Adds branch instructions and labels to the MIPS simulator, assembler, disassembler.
Review URL: https://codereview.chromium.org//12634030
branch系の命令を一通り実装。
mipsの場合、delay slotもあるので、微妙に命令が分かれている。
simulator側にも実装。

r20399 | regis@google.com | 2013-03-23 03:30:35 +0900 (土, 23  3月 2013) | 5 lines
Implement optional parameter handling in ARM vm.
Enable FindCodeObject test on ARM (production mode only for now).
Make sure the object pool is allocated in the old space.
Some more code cleanup on IA32 and X64 (use named constants).
Review URL: https://codereview.chromium.org//12663024
ARM向け
CompileGraph()から呼ばれる、
CopyParameters() R4:arguments descriptor array
CompareObject()
EmitInstanceCall()
PushArgumentInstr StoreLocalInstrを実装。

CopyParameters()
関数のbodyを取得して、
R4からDescriptorの個数を取得し、チェック。wrangの場合jump
positional parametersを
ArgumentDescriptorから、FPに1個ずつコピーする。

その後、optional named parametersをコピーする。
これらはすべてlocal variableに格納されている。
同様に、FPへコピー。
named parametersは、この段階で位置が決まる。
順番は、CompareTo()の返値のindex。abcでソートのはず。

もしくは、optinal positional parametersをコピーする。

r20396 | asiva@google.com | 2013-03-23 03:14:37 +0900 (土, 23  3月 2013) | 2 lines
Implement creation of ByteData objects using the Dart API.
Review URL: https://codereview.chromium.org//12938010
以下をAPIに追加
GetByteDataConstructor()
NewByteData()
上記のExternal版

Symbolに、
ByteData
ByteDataDot  -> "ByteData."
ByteDataDotView -> "ByteData.view"
ByteDataView

Dotってなんだっけ？


r20394 | zra@google.com | 2013-03-23 03:11:05 +0900 (土, 23  3月 2013) | 13 lines
Drops into Simulator Debugger only in a session that is already interactive.
This change backs out an earlier change to the disassemblers that
made them return false if an instruction couldn't be decoded.
This was used in the simulator debuggers for arm and mips to avoid
executing an instruction that couldn't be decoded.
Instead, now when an unknown instruction is encountered in the simulator,
if the simulator is running interactively, we drop into
the debugger, and otherwise die. We detect that a simulator is
running interactively by setting a flag if we enter the debugger
for a user set break point.
Review URL: https://codereview.chromium.org//12903006
bool型からvoid型へ
これ、emulator向けの修正を戻したのか。

r20389 | srdjan@google.com | 2013-03-23 02:08:19 +0900 (土, 23  3月 2013) | 2 lines
Allow recursive inlining.
Review URL: https://codereview.chromium.org//12908005
オプション inline_recursive=true
を追加して制御を1文変更しただけ。

r20388 | hausner@google.com | 2013-03-23 02:06:42 +0900 (土, 23  3月 2013) | 6 lines
Support initialized mixin fields across scripts
Add capability to set parser to read tokens from different
scripts and token positions. This is used when the initializer
expression of a field resides in a different script.
Review URL: https://codereview.chromium.org//12827007
parser系のはずだけど、objectにTokenStreamなんてもんが定義されていたのか。
vm/datastreamってなんぞ。。

r20387 | asiva@google.com | 2013-03-23 02:04:08 +0900 (土, 23  3月 2013) | 2 lines
Limit handle scope to the loop in order to avoid creation of large number of handles
when finalizing classes of a large application.
Review URL: https://codereview.chromium.org//12593015
FinalizeClass()に、HANDLESCOPE(Isalte::current)
handleの操作はまだよくわからん。。

r20382 | vegorov@google.com | 2013-03-23 00:20:37 +0900 (土, 23  3月 2013) | 6 lines
Update stack map computation to match the way XMM registers are spilled on the slow path.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12995022
FpuRegisterSpillSlotっていうので置き換えただけ。
= FpuRegisterSize / kWordSize

r20380 | whesse@google.com | 2013-03-22 23:53:25 +0900 (金, 22  3月 2013) | 5 lines
dart:io | Fix error in deserializing of native port messages.
BUG=dartbug.com/9369
Review URL: https://codereview.chromium.org//12893013
AddBackRef()ってのを追加した。


r20374 | vegorov@google.com | 2013-03-22 20:44:38 +0900 (金, 22  3月 2013) | 10 lines
Register allocation tweaks:
- Improve heuristic detecting interference on the back-edge.
  Any value live_in for the loop header can introduce interfering moves
  at the back edge due to control flow resolution connecting split siblings.
  Apply adjustments based on this heuristic at the latest point when allocating a free register;
- Don't allocate a register for constants that have no constrained uses.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12946004
flow_graph_allocator
HasOnlyUnconstrainedUses()
で判定し、場合によってはレジスタ(constant)側を畳み込む。outのlocationはno_location。


r20373 | vegorov@google.com | 2013-03-22 20:28:13 +0900 (金, 22  3月 2013) | 5 lines
Use shorter write-barrier filtering sequence when value is known to be non-smi.
R=iposva@google.com
Review URL: https://codereview.chromium.org//12438032
StoreIntoObjectFilterNoSmi()を新規追加

StoreIntoObjectにおいて、
can value be smiの場合、
StoreIntoObjectFilter
smiでない場合、StoreIntoObjectFilterNoSmi()を呼び出す

can_value_be_smiは、最近追加した、fieldのtype feedbackを参照して判定する。
type feedbackの型がdynamicの場合に、return true


r20366 | aprelev@gmail.com | 2013-03-22 12:31:14 +0900 (金, 22  3月 2013) | 5 lines
Added support for redirecting factories in dart api.
BUG=dartbug.com/6958
Review URL: https://codereview.chromium.org//12496011
redirect factory?
factory関数で、redirectするファクトリを=で定義する。

r20349 | srdjan@google.com | 2013-03-22 05:57:45 +0900 (金, 22  3月 2013) | 2 lines
Fix crash caused by eliminating goto-s in unoptimized code. Added asserts
Review URL: https://codereview.chromium.org//12812026
is_Optimized()の場合にかぎり、compactBlock()

r20339 | asiva@google.com | 2013-03-22 03:47:49 +0900 (金, 22  3月 2013) | 2 lines
Write the magic number 0xf5f5dcdc into a script snapshot file and use this to distinguish
whether a script snapshot or a regular script file is being passed on the command line
(removed the --use-script-snapshot option).
Review URL: https://codereview.chromium.org//12438033
jr
jalr
movnなどの、EmitRTypeがspecialなものを追加。
なにが違うのか。レジスタをhi lowに分ける命令？
というか、複数のレジスタを暗黙的に使用する命令かな？

r20321 | zra@google.com | 2013-03-22 00:50:31 +0900 (金, 22  3月 2013) | 2 lines
Adds MIPS SPECIAL instructions to simulator, assembler, debugger.
Review URL: https://codereview.chromium.org//12837009

r20315 | fschneider@google.com | 2013-03-21 22:34:11 +0900 (木, 21  3月 2013) | 4 lines
Fail with fatal error instead of segmentation fault if virtual memory allocation fails.
BUG=dart:1754, dart:7995
Review URL: https://codereview.chromium.org//12580005
mmapのreserveに失敗した、
memoryを確保できなかったばあい、FATALを投げる。

r20299 | srdjan@google.com | 2013-03-21 08:26:07 +0900 (木, 21  3月 2013) | 2 lines
Add asserts to catch missing deoptimization info early.
Review URL: https://codereview.chromium.org//12806007
いろいろとassertを追加。

r20287 | johnmccutchan@google.com | 2013-03-21 05:29:00 +0900 (木, 21  3月 2013) | 3 lines
SIMD plumbing
Review URL: https://codereview.chromium.org//12871015
Float32x4 stackslot等
また、unboxedfloat32x4と、unboxedint32x4を、location型に加えたので、適時boxing unboxingがはいらなくなる。
deoptimizeのmatrializeにてを加えている。deoptimizeの際の退避処理
rawに、xyzwに加えた。配列の0123と同じだけど。。

runtime/platformに、simd128型をstructで宣言している。
read/write関数を宣言している。
これは、big littleを切り替えるためかな。


r20279 | hausner@google.com | 2013-03-21 02:04:28 +0900 (木, 21  3月 2013) | 4 lines
Properly handle cascades in top-level functions
Fix for bug 8530
Review URL: https://codereview.chromium.org//12647012
parser .periodとcascadeをわけた？


r20277 | asiva@google.com | 2013-03-21 00:41:29 +0900 (木, 21  3月 2013) | 2 lines
Remove redundant Dart_LoadEmbeddedScript as it doesn't seem to be used
in the VM and hopefully dartium can start using Dart_Script always.
Review URL: https://codereview.chromium.org//12919020
LoadEmbeddedScriptを削除し、LoadScriptに共通化。
デフォルトで引数、location = 0,0

r20254 | srdjan@google.com | 2013-03-20 07:43:03 +0900 (水, 20  3月 2013) | 2 lines
Improve code (less code, slightly faster) for polymorphic calls,
by loading the argument descriptor only once instead of once for each call.
Review URL: https://codereview.chromium.org//12646012
GenerateStaticCallから、GenerateDartCallに変更


r20248 | asiva@google.com | 2013-03-20 06:32:35 +0900 (水, 20  3月 2013) | 2 lines
Translate raw strings to regular strings during source code generation.
This should hopefully avoid issues with deciding when to escape special characters and when not to.
Review URL: https://codereview.chromium.org//12568007
escapeに\\と$を追加しているのを、関数にまとめた
is_rawっていうフラグがなくなった。


r20235 | vegorov@google.com | 2013-03-20 05:15:10 +0900 (水, 20  3月 2013) | 5 lines
Collect type feedback for fields.
Review URL: https://codereview.chromium.org//12529008

code_generatorに、
UpdateFieldCid()を追加。
loadしたvalueのclazz().id()を保存するぽい。
保存先は、vm/objectのField vm/raw_objectのRawFieldクラス
保存できるidは、1個だけ。 raw_ptr()->guarded_cid_に保存。
stub越しに呼び出すのだと思う。
RawFieldには、guarded_cid_とis_nulable_メンバを追加。
guardfieldのcidは1つだけだが、nullの可能性もあるため、is_nullableとguard_fieldに分けている。
2つ以上が与えられた場合、dynamicとする。

GuardField命令を新規追加。
builderでは、assignablevalueに対して、GuardFieldとStoreInstanceFieldを生成する。
GuardFieldはCanonicalize()でcidと等しければreturn null

optimizerでは、
guarded_cid != dynamicの場合、GuardFieldを挿入する。

parser
finalは、Nullableでない。

compilerでは、
compile後、field.RegisterDependentCode()で、依存を設定している。
依存をWeakPropertyにArrayの形で持たせる。これはOld領域に格納
依存関係は、Field 1-1 WeakProperty 1-* Code
こういう複雑なコードになっているのは、
Fieldがillegalになった際に、
inline展開を含めて,このfieldからxx型を前提にgetFieldしている
複数のCodeをdeoptimizeする必要があるから。

肝は、object.ccの、
UpdateCid()
RegisterDependentCode()
IsDependentCode()

特にUpdateCid()は、RUNTIME_ENTRYのUpdateFieldCid()から呼び出される。
+// Update global type feedback recorded for a field recording the assignment
+// of the given value.
+//   Arg0: Field object;
+//   Arg1: Value that is being stored.
これは、GuardFieldInstr::Emitに呼び出しを埋め込む。

上記をまとめると、
LoadField系に型情報がつくので、推論が捗る。
また、runtimeでsmi nullable notdynamic dynamicの判定が行いやすくなる効果もあるのかな？


r20211 | fschneider@google.com | 2013-03-20 00:54:28 +0900 (水, 20  3月 2013) | 2 lines
A CL that only removes dead code from the VM compiler.
Review URL: https://codereview.chromium.org//12740003
jit compilerのリファクタリング。

r20204 | fschneider@google.com | 2013-03-19 22:29:47 +0900 (火, 19  3月 2013) | 2 lines
Optimize smi multiply by 2 using shl by 1.
Review URL: https://codereview.chromium.org//12703011
Smiの*2を、shift 1でEmitするように修正。
全部emitでやるのか。。そのうちinstcombineみたいなのが追加されるのかもね。

r20200 | fschneider@google.com | 2013-03-19 21:35:57 +0900 (火, 19  3月 2013) | 4 lines
Fix ARM and MIPS build after my last commit.
TBR=vegorov@google.com
Review URL: https://codereview.chromium.org//12735016
20198向けのskeltonを追加。

r20198 | fschneider@google.com | 2013-03-19 21:06:23 +0900 (火, 19  3月 2013) | 31 lines
Replace scalarlist optimizations and split external array loads into two IL instructions.

This CL removes optimized access for scalarlist, and only the new TypedData classes
are optimized. I changed the runtime libraries core and math to use typedData
instead of scalarlist (Uint16List is used in StringBuffer, Uint32List by Math.random).

Instead of using LoadIndexed for internal and external arrays,
split external loads into a load of the backing store and a load
of the element.

v3 <- LoadIndexed(v1, index)

becomes

v2 <- LoadUntagged(v1, ExternalTypedData::data_offset)
v3 <- LoadIndexed(v2, index);

For this I introduce two new representations in the IL:

kUntagged (for values that hold a untagged pointer) and

kNoRepresentation (for instructions accept any input
representation)

Deoptimization does not need to know about kUntagged
since these values can never occur in the environment.

Also with this change:
* fix COMPILE_ASSERT and use it in one place.
* Cleanup IL printer output of deopt ids.
Review URL: https://codereview.chromium.org//12871010
enum Representationを追加。
Representationにおうじて、Allocatorではlocationの付け替えを行う。

RECOGNIZED_LISTから、ByteArrayBase系をすべて削除。
すべてTypedListに置き替え。
TryInlineByteArraySetIndexedを削除。

LoadUntagged命令を新規追加
Externalの場合、LoadUntaggedを挿入している。。
ia32ではmovl(this, offset)するだけ。

この修正からscalarlistが激遅になるので、順次typeddataに置き替えないといけない。


r20167 | hausner@google.com | 2013-03-19 02:34:16 +0900 (火, 19  3月 2013) | 10 lines
Revise duplicate interface check

Move check for duplicate interfaces from parser to class finalizer.
The parser only compared interfaces by name, which did not work
properly for qualified (imported) names. Now the check happens in the
class finalizer after types are finalized.

Sadly, our test harness does not appear to know how to handle multitests that import libraries.
Review URL: https://codereview.chromium.org//12837007
ParseInterfaceList()に置換。
Parserで、2重ループで冗長なインターフェースを検知するのをやめ。
AddInterface IfUniqeメソッドで何度もforを回すような処理を削除。

Parserでは、interfaceの登録のみ行う。
冗長なinterfaceはfinalizerでerrorを返す。ここはクラスごとに1重ループのみ

r20084 | hausner@google.com | 2013-03-16 00:59:24 +0900 (土, 16  3月 2013) | 12 lines
Mixins with Generics
This change adds support for generics to mixins.
It's not a particularly elegant implementation,
so I expect to change how it works internally in later checkins.

Also, there is still one aspect of the implementation that is incorrect.
In the case of typedef, the newly introduced name is not yet an alias for the mixin application.
Instead, the MA is a superclass of the typedef name.
That will need to be fixed in a later checkin. I don't want to make this change bigger.
Review URL: https://codereview.chromium.org//12779008
class MixinAppTypeを追加。Raw版もある。
super_typeとmixin_types[]を保持。
parserでsuper_typeは解決するのかな。
mixin_application_typeの配列も含めて、parserでMixinAppTypeを作成する。
interfacesは、parserではpending

finalizerでは、CloneTypeParameters()
superとmixin classesからtype parameterをかき集める。
TypedArguments cloned_type_paramsに全部一緒くたに突っ込む。
順番は、1. super 2. mixin types
superのみ、Backtick()を名称にconcatする
mixinのtype parameterは、そのまま取り込む。
withで指定した際のtype parameterは、同じであると判断すると。


r20078 | asiva@google.com | 2013-03-15 22:33:11 +0900 (金, 15  3月 2013) | 2 lines
Add the native intrinsic TypedData_setRange to optimize the setRange call
when the destination and source of setRange are of the same typeddata type.
Review URL: https://codereview.chromium.org//12881006
static void TypedData::Copy()を追加。
memmove

typeddata.dartにおいて、_setRangeはTypedData_setRangeを呼び出す。
typeddataなので、setRangeの際に、同じ型か判定する。

r20048 | regis@google.com | 2013-03-15 06:33:03 +0900 (金, 15  3月 2013) | 4 lines
Make allocation of Dart parameters and local variables architecture independent.
Enable a couple more vm tests on ARM.
Fix function usage counter access on ARM.
Review URL: https://codereview.chromium.org//12776006
Dart stack frame layout
以下のように抽象化。
int param_frame_index = (num_params == function.num_fixed_parameters()) ?
                        (kLastParamSlotIndex + num_params - 1) : kFirstLocalSlotIndex;

in ia32 and x64
LastParamSlotIndex = 2
FirstLocalSlotIndex = -2
in arm
LastParamSlotIndex = 3
FirstLocalSlotIndex = -2

parameter i will be at fp[LastParamSlotIndex + num_params - 1 - i]
local variable j will be at fp[FirstLocalSlotIndex - j]

r20043 | zra@google.com | 2013-03-15 03:56:07 +0900 (金, 15  3月 2013) | 2 lines
Fixes a build warning about a format string.
Review URL: https://codereview.chromium.org//12871004
%d -> %"Pd"

r20036 | fschneider@google.com | 2013-03-15 02:13:44 +0900 (金, 15  3月 2013) | 12 lines
Fix bug in optimized byte array views on tranferable backing stores.
This affects views when using scalarlist: The code generated
did not take the receiver class into account correctly,
so it only works for internal byte arrays.
For now, I just disable optimization for external backing stores.
The optimization will be added again for TypedDataViews in a future CL.
TEST=tests/standalone/byte_array_view_optimized_test.dart
Review URL: https://codereview.chromium.org//12779007
r20024 | fschneider@google.com | 2013-03-14 23:09:38 +0900 (木, 14  3月 2013) | 6 lines
Revert: Support TypedData getters/setters in the optimizer.
Revert https://code.google.com/p/dart/source/detail?r=20018
because this CL was not complete and broken.
Review URL: https://codereview.chromium.org//12742006
r20018 | fschneider@google.com | 2013-03-14 22:07:54 +0900 (木, 14  3月 2013) | 6 lines
Support TypedData getters/setters in the optimizer.
The optimizer now  handles _TypedList which replaces _ByteArrayBase
and functions on TypedList getX/setX where X = Int8, Uint8, Int16, etc. are optimized.
Review URL: https://codereview.chromium.org//12801003
MethodRecognizerにおいて、
ByteArrayBaseを削除して、TypedListに置換。？？？

r20025 | asiva@google.com | 2013-03-14 23:12:36 +0900 (木, 14  3月 2013) | 2 lines
Fix source generation for strings that have \$ in them.
Review URL: https://codereview.chromium.org//12605009
stringの中に、$がうまっている？ $の場合はescape


r20002 | fschneider@google.com | 2013-03-14 19:39:20 +0900 (木, 14  3月 2013) | 2 lines
Optimize TypedData in the same way as ScalarList.
Review URL: https://codereview.chromium.org//12775009
MethodRecognizer TypedDataLength
TypedDataには、Externalもいる。
scalarlistと同様に、typeddataも最適化中。caseを差し込むだけ。


r19998 | asiva@google.com | 2013-03-14 19:18:00 +0900 (木, 14  3月 2013) | 2 lines
Remove Dart_GetScriptSource as it is not used anywhere.
Review URL: https://codereview.chromium.org//12732007
DEPRECATEDがついていたんか。

r19996 | asiva@google.com | 2013-03-14 18:47:46 +0900 (木, 14  3月 2013) | 4 lines
Add a command line option to generate source code for a script
(apparently this would be useful for pretty printing the output of dart2dart)
Review URL: https://codereview.chromium.org//12517005
Dart_GenerateScriptSource()を新規追加。
dart2dartで使う？？？ minifyから復元したソースを参照させるってことかな。

mainのオプションに、--print-sourceを追加。
を使用すると、参照されているすべてのソースコードを表示させると。

r19961 | zra@google.com | 2013-03-14 04:00:53 +0900 (木, 14  3月 2013) | 2 lines
Fix build.
Review URL: https://codereview.chromium.org//12607009
int -> bool

r19958 | zra@google.com | 2013-03-14 03:43:16 +0900 (木, 14  3月 2013) | 8 lines
Copies Simulator Debugger from ARM to MIPS.
Also includes changes to keep it from aborting unexpectedly.
Among other things, I changed the Disassembler::Disassemble to return false
when the underlying decoder can't decode an instruction. Then,
the MIPS SimulatorDebugger will refuse to step or cont on an instruction
that the Disassembler can't decode.
Review URL: https://codereview.chromium.org//12431016
DecodeInstruction()の引数を変更
Disassemble系の返値をboolに変更した。

mips simulatorの改造
armからの移植かな。
SimulatorDebugger
と、Simulatorにunimplだった機能を実装。
decodeでfailureがわかるようになった。


r19954 | vegorov@google.com | 2013-03-14 03:28:07 +0900 (木, 14  3月 2013) | 6 lines
Run type propagation after LICM to ensure correct reaching types for hoisted values.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12690004
LICMの後に走るらしい。

r19932 | asiva@google.com | 2013-03-13 23:16:13 +0900 (水, 13  3月 2013) | 2 lines
Added check that the object being stored as a return value
in the NativeArguments array is a Dart instance.
Review URL: https://codereview.chromium.org//12744006
SET_NATIVE_RETVALマクロ
IsDartInstance()のチェックがはいるようになった。

r19918 | fschneider@google.com | 2013-03-13 19:06:34 +0900 (水, 13  3月 2013) | 2 lines
Remove some assertion code in the GC from the release build.
Review URL: https://codereview.chromium.org//12754003
assert用のflagをifdef DEBUGに移動。

r19917 | kmillikin@google.com | 2013-03-13 19:06:14 +0900 (水, 13  3月 2013) | 8 lines
Remove virtual functions on class InliningContext.
There is only one implementation of InliningContext, so there is no need for
virtual dispatch.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12518009
ValueInlineContextをInlineContextに置換？
ReplaceCallがvirtualでなくなったと？

r19894 | tball@google.com | 2013-03-13 05:42:36 +0900 (水, 13  3月 2013) | 2 lines
Disable stack context when its frame is for optimized code.
Review URL: https://codereview.chromium.org//12408015
optimizeしていない場合に限り、GetSavedContext()でctxを復元する。
optimizedの場合、ctx_がnullであるため、
debuggerのContextLevel()において、
ctx_.IsNullの場合unknownを返す。

r19864 | fschneider@google.com | 2013-03-12 22:51:32 +0900 (火, 12  3月 2013) | 11 lines
Add a new, separate block entry instruction for catch-blocks.
This is a preparation CL for supporting try-catch in optimized code. Until
now, we used normal TargetEntryInstr for catch blocks.
This meant carrying around handler_types_ and catch_try_index_ for blocks
that are not catch blocks which is not needed.
For now, CatchBlockEntry behaves the same as TargetBlockEntry except for
the additional members needed for catch blocks.
Review URL: https://codereview.chromium.org//12600012
CatchBlockEntryInstr : public BlockEntryInstrを新規追加。
TargetEntryInstrからtry catch系の機能を削除し、
try catchはCatchBlockEntryInstrに移動。


r19848 | asiva@google.com | 2013-03-12 19:57:48 +0900 (火, 12  3月 2013) | 3 lines
- Use dart:typedata types in the Dart API calls.
- Change the dart/io code to not use dart:scalarlist
Review URL: https://codereview.chromium.org//12730013
scalarlistからtypeddataに交代。

r19827 | regis@google.com | 2013-03-12 08:15:48 +0900 (火, 12  3月 2013) | 2 lines
Decode ic data and arguments descriptor passed in calls on ARM.
Review URL: https://codereview.chromium.org//12518016
LoadWordFromPoolOffset()で処理の共通化
immが小さければOffsetのまま使用できるし、そうでなければlo hiに分けて参照する。

PatchInstanceCallAt()
GetInstanceCallAt()

CallPatternがRawICDataとArgumentDescriptorを持つ。

CallPattern::ArgumentDescriptor()と、CallPattern::IcData()
どちらも object_poolから取得。indexは固定。-1だったら初期値かな？


r19819 | zra@google.com | 2013-03-12 05:50:50 +0900 (火, 12  3月 2013) | 7 lines
Adds MIPS instructions to simulator, assembler, disassembler
ins - bitfield insert
ext - bitfield extract
l{b,bu,h,hu,w} - load byte, unsigned byte, etc.
s{b,h,w} - store byte, halfword, word
Review URL: https://codereview.chromium.org//12519007
instructionにも追加されたし、Simulatorに追加。

r19810 | floitsch@google.com | 2013-03-12 03:54:37 +0900 (火, 12  3月 2013) | 5 lines
ceil/floor/truncate/round return integers.
This CL supercedes https://codereview.chromium.org/11748016/
Review URL: https://codereview.chromium.org//12317107
int型になった。。

r19789 | fschneider@google.com | 2013-03-11 22:03:46 +0900 (月, 11  3月 2013) | 4 lines
Remove unused context-level from LoadLocal/StoreLocal IL instructions.
This is left-over code that is not used anymore.
Review URL: https://codereview.chromium.org//12440015
LoadLocal/StoreLocalクラスから、context_levelフィールドを削除。

r19781 | fschneider@google.com | 2013-03-11 21:16:54 +0900 (月, 11  3月 2013) | 2 lines
Inline ByteArray setters like setUint8 in the optimizer.
Review URL: https://codereview.chromium.org//12378039
ByteArrayのsetterが非常に速くなった。
RECOGNIZED_LISTにsetterも追加されて、10倍高速になった。大体普通のList使うのと同等。

r19756 | floitsch@google.com | 2013-03-09 12:19:07 +0900 (土, 09  3月 2013) | 5 lines
Revert "Remove Expect from core library."
This reverts commit 19755.
Review URL: https://codereview.chromium.org//12743005
r19755 | floitsch@google.com | 2013-03-09 11:40:37 +0900 (土, 09  3月 2013) | 3 lines
Remove Expect from core library.
Review URL: https://codereview.chromium.org//12212016
import expectを削除。

r19752 | asiva@google.com | 2013-03-09 09:05:57 +0900 (土, 09  3月 2013) | 2 lines
Add the allocator intrinsics for dart:typeddata implementation.
Review URL: https://codereview.chromium.org//12547018
typeddataの_newマクロを作成
速攻でarmに入れてるのは、clientだからかな。
intrinsiferに、TYPEDDATAのINTRINSIC_LISTを追加している。

r19730 | zra@google.com | 2013-03-09 06:47:03 +0900 (土, 09  3月 2013) | 2 lines
Adds a few MIPS arithmetic instructions to the simulator, assembler, disassembler
Review URL: https://codereview.chromium.org//12545024
assembler_mips.hに追加。 主に算術命令
simulator_mipsも追加。
add i|iu|u|
and_ i
clo clz div divu lui mfhi mflo sll LoadImmediate


r19724 | regis@google.com | 2013-03-09 06:16:46 +0900 (土, 09  3月 2013) | 5 lines
Implement leaf runtime call stub on ARM and corresponding call redirection
in ARM simulator.
Implement jump patching on ARM.
Add missing ICache flush calls.
Review URL: https://codereview.chromium.org//12439005
BranchPatchable()
IPを16bitずつmovしたあと、
bx(IP)

SwapCode()
swapしたあと、ICacheをflush

JumpPatternクラスの実装
TargetAddress()
SetTargetAddress()
どちらも16bitずつアドレスをlo hiに分けて参照、設定している。


target addressを書き換えた際に、
CPU::FlushICache()
が新規に挿入されているけど、どういうこった。
しかも、x86 x64 armに。
実装されているのはarmのみ。おそらく、mipsも行うのだろう。
syscall(__ARM_NR_cacheflush, start, start + size, 0);
キャッシュラインを書き戻し、かつ、キャッシュラインを無効化する ???
host=armの場合のみ必要みたいだけど。

mipsにcode pattern等のskeltonを追加。

r19711 | vegorov@google.com | 2013-03-09 04:09:48 +0900 (土, 09  3月 2013) | 20 lines
Add pass to remove empty blocks and recompute fall-through targets.
This allows to cleanup the following code patterns:
1) chains of jumps:

  jxx block_a
...
block_a:
  jmp block_b

2) jumps over jumps

  jxx block_b
block_a:
  jmp block_c
  block_b:
  ...
Review URL: https://codereview.chromium.org//12412013
CompactBlock()
CompactBlocks()
jump labelをBlockInfoに集約して、labelを操作しやすくした。
また、fallthroughに対応して、EmitBranchの際に無駄なjumpを出力しないようになった。

r19708 | asiva@google.com | 2013-03-09 03:40:05 +0900 (土, 09  3月 2013) | 2 lines
Add the typed data classes to the do not extend list.
Review URL: https://codereview.chromium.org//12528013
typeddataの生成時、
macroで、DO_NOT_EXTEND_TYPED_DATA_CLASSESを宣言。

r19704 | regis@google.com | 2013-03-09 03:22:14 +0900 (土, 09  3月 2013) | 3 lines
Implement native call stub on ARM and native call redirection in ARM simulator.
Pass PatchStaticCall test.
Review URL: https://codereview.chromium.org//12629004
NativeCallInstrを実装。
GenerateCallNativeCFunctionStub()を実装。

simarm
cc/Dart2JSCompileAll: Skip
cc/FrameLookup: Skip
cc/IcDataAccess: Skip
cc/UseDartApi: Skip


r19690 | floitsch@google.com | 2013-03-08 22:07:18 +0900 (金, 08  3月 2013) | 3 lines
Remove deprecated StringBuffer.add, addAll and addCharCode.
Review URL: https://codereview.chromium.org//12473003
addからwriteに変わった。
IOSinkのapi修正が原因かな？

r19682 | kmillikin@google.com | 2013-03-08 20:14:08 +0900 (金, 08  3月 2013) | 14 lines
Implement a branch optimization pass.

Branch optimization pushes some branches that test the value of a phi
to the predecessor blocks.  This can avoid materializing a boolean
object solely for the purposes of branching on its boolean value.

The optimization is performed after inlinining which creates
opportunities, and before constant propagation, because it exposes
opportunities for unreachable code elimination.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12540002
BranchSimplifierの追加。
Match()
ToJoinEntry()
CloneConstant()
CloneBranch()

Canonicalize()とConstantPropagatorの間に実行する。

Branch(Comparison(kind, Phi, Constant))
上記において、comparisonとbranchを、phiのpredecessorにcloneする。
その際に、phiの値を、predecessorの各々の値に変換する。
特定ケースの、phiの値の上方への伝搬みたいなもん？

p = phi(a,b)
comparison kind, p, c
branch comparison

上記をパターンマッチして、
a=  b=
 \  /
  p = phi(a,b)
  cmp(p,c)
  branch --> goto loopexit
  |
  b --> backedge

以下に変換
a=...
c=...
cmp(a,c)
branch loopexit, b

b=...
c=...
cmp(b,c)
branch loopexit, b


r19679 | lrn@google.com | 2013-03-08 19:21:52 +0900 (金, 08  3月 2013) | 3 lines
Change VM's string-buffer patch to use a Uin16Array as backing buffer.
Review URL: https://codereview.chromium.org//12421002
StringBuffer_createStringFromUint16Array()
bootstrapnativesに追加。

r19669 | iposva@google.com | 2013-03-08 16:25:19 +0900 (金, 08  3月 2013) | 2 lines
- Allow the use of branch delay slots.
Review URL: https://codereview.chromium.org//12623002
mipsにdelay_slot()用のmacroを追加。
jr(RA)
delay_slot()->ori(V0, xxx
と直感的に書けるようになった

r19661 | srdjan@google.com | 2013-03-08 08:09:47 +0900 (金, 08  3月 2013) | 2 lines
The complete fix for issue 8919.
Review URL: https://codereview.chromium.org//12643004
r19657 | srdjan@google.com | 2013-03-08 06:59:02 +0900 (金, 08  3月 2013) | 2 lines
Fix crash in issue 8919. The test still fails.
Review URL: https://codereview.chromium.org//12628003
flow_graph_builder
result_is_neededでない場合も、sored valueを保存する。
と見せかけて、result_is_neededの場合も、、
LoadLocalNodeを生成する？？？


r19656 | asiva@google.com | 2013-03-08 06:50:33 +0900 (金, 08  3月 2013) | 2 lines
Implement 'dart:typeddata' directly in the VM instead of using 'dart:scalarlist'
Review URL: https://codereview.chromium.org//12544015
typeddataをvm内部に定義。変更前は、scalarlistで代替していた。

r19652 | tball@google.com | 2013-03-08 06:00:22 +0900 (金, 08  3月 2013) | 6 lines
Stop handling VM messages if the isolate has an uncaught (sticky)
exception from the previous message. The Dartium engineers requested
it because they were seeing confusing stack traces.
BUG: 7515
Review URL: https://codereview.chromium.org//12549007
sticky_error()を返す際に、一度clearしてから返す。
変更前は、stickyが立ったままだった。

r19606 | iposva@google.com | 2013-03-07 20:04:27 +0900 (木, 07  3月 2013) | 4 lines
- Add a skeleton MIPS assembler, disassembler and simulator.
- Remove unused fields and methods from ARM simulator.
- Remove unused 5th parameter from Simulator::Call.
Review URL: https://codereview.chromium.org//12541003
上述の通り
mips対応進んでます。

r19575 | regis@google.com | 2013-03-07 04:03:03 +0900 (木, 07  3月 2013) | 2 lines
Fix build.
Review URL: https://codereview.chromium.org//12433011
0初期化。

r19571 | regis@google.com | 2013-03-07 03:49:38 +0900 (木, 07  3月 2013) | 4 lines
Clean up ARM assembly code loading and storing from/to a large offset.
Make use of vldm and vstm ARM instructions.
Implement ARM stub printing stop message.
Review URL: https://codereview.chromium.org//12481007
CanHoldLoad/StoreOffset()でtrue caseとfalse caseで処理を分ける。
falseの場合、hi loに分けてoffsetを作る必要がある。
immediateを使える場合と、hi loから作るパスとを明確に分けた。

r19519 | regis@google.com | 2013-03-06 07:04:23 +0900 (水, 06  3月 2013) | 7 lines
Complete implementation of bounds checking in the vm,
by introducing a vm object BoundedType that represents a type
that could not be checked against an upper bound at compile time.
A BoundedType is verified at run time when used,
typically when it (and/or its bound) gets instantiated.
This fixes issues 7075 and 7625.
Added one test.
Review URL: https://codereview.chromium.org//12473002
class BoundedType : public AbstractType
を新規追加。snapshotにも追加。
rawには、type_, bound_, type_parameter_が定義されている。
runtime(classfinalizer)でtype parameterのboundをcheckする
ClassFinalizer::CheckTypeArgumentBounds()

TypeParameterにCheckBound()ってのが追加されて、
subtypeやsupertypeやらで何度もCheckされるのを回避するため、各TypeParameterはis_checkedを持つと。
TypeおよびTypeParameterは、Runtimeには直接作用しないけど、
ParserおよびFinalizerで、エラーは投げますよということか。

IsBounded()でこんなにHandle()使っていいのか。。ループの中で生成してますよ。
謎だけど、 HeapProfilerでBoundedTypeを参照している。。

r19511 | zra@google.com | 2013-03-06 04:53:43 +0900 (水, 06  3月 2013) | 2 lines
Adds muls, sdiv, udiv instructions to ARM simulator, assembler, disassembler
Review URL: https://codereview.chromium.org//12459005
muls, sdiv, udivを追加。
mulsはsets condition flags.

r19439 | zra@google.com | 2013-03-05 10:03:22 +0900 (火, 05  3月 2013) | 8 lines
Adds mrc instruction to arm simulator, assembler, disassembler.
This instruction will be used to query an arm processor to
determine whether it supports the sdiv and udiv instructions.

Also adds a flag --sim_has_int_div to the arm simulator,
which changes the result of the mrc instruction so we can test both ways.
Review URL: https://codereview.chromium.org//12378080
CPUFeaturesに、interger_division_supported_追加。
mrc命令でfeaturesを確認するらしい。

r19434 | regis@google.com | 2013-03-05 09:04:32 +0900 (火, 05  3月 2013) | 3 lines
Remove the barely used macro assemblers after merging their contents to the base assemblers.
Review URL: https://codereview.chromium.org//12398029
macro_assemblerから、各assemblerに処理を統合した。
assembler_macros_xxは全部削除。。macro系の重い処理を今後追加する予定ないんでしょうかね。

r19429 | hausner@google.com | 2013-03-05 07:28:55 +0900 (火, 05  3月 2013) | 8 lines
Fix for loop variable capturing
We had a bug in the capturing of for loop variables that only manifested
itself if another variable outside the loop was captured as well.
Fix for issue 8207 and 8698.
Review URL: https://codereview.chromium.org//12381089
parserの修正。
全部10になる理由がよくわからない。。
int i;
for (i=0;  //i=5
と
for (int i=0; //i=1.2.3.4.5
では結果が異なる。

r19427 | asiva@google.com | 2013-03-05 07:11:45 +0900 (火, 05  3月 2013) | 2 lines
First step towards implementing dart:typeddata library.
Review URL: https://codereview.chromium.org//12313088
TypedDataのload処理追加.bootstrap

r19422 | srdjan@google.com | 2013-03-05 06:38:35 +0900 (火, 05  3月 2013) | 2 lines
Recognize more list factories. Recognizing list factories (Array, Bytearrays, etc)
allows the type and range to be determined.
Add byte array factories to the list of recognzied factories and intrinsify them early.
If not intrinisified they may be inlined and not recognized.
Keeping the recognition at API level is more stable as internal implementation may change.
Review URL: https://codereview.chromium.org//12377082
ListFactory系がRECOGNIZED_LISTに追加。ScalarList系はほぼすべて。
一通りIntrinsiferに追加。FixedLengthArrayの判定を入れて、type propagatorの対象になる。

r19405 | regis@google.com | 2013-03-05 03:08:38 +0900 (火, 05  3月 2013) | 8 lines
Second codegen test passing on ARM (simulated).
This required support on ARM for:
- compilation of static calls
- patching of static calls
- stub to call into runtime
- redirection support for calls from simulator to host runtime
- stack frame iteration
Review URL: https://codereview.chromium.org//12381034
CallRuntimeFrameのEnter/Leaveを実装。
vtsmdやvldmdがあれば一発。
合わせてFlowGraphCompilerから上記をEmitする。

get/patchStaticCallを実装。
RuntimeEntry::Call()は、BranchLink(label)

stubには、以下を追加。
// Input parameters:
//   R4: arguments descriptor array.
GenerateCallStaticFunctionStub()
R0とR4をpush
callruntime
R0とR4をpop
ldr(R0, FieldAddress(R0, Code::instructions_offset())); //飛び先を取得。
AddImmediate(R0, R0, Instructions::HeaderSize() - kHeapObjectTag); //heapのtagをadd
bx(R0);

// Input parameters:
//   LR : return address.
//   SP : address of last argument in argument array.
//   SP + 4*R4 - 4 : address of first argument in argument array.
//   SP + 4*R4 : address of return value.
//   R5 : address of the runtime function to call.
//   R4 : number of arguments to the call. //ここは固定みたい。
GenerateCallToRuntimeStub()
R0にisolateをload
isolateのtop_exit_frame_info_offset()をSPに保存。
isolateのtop_context_offsetをctxに保存
blx R5の前に、R0-R3に、native argumentsを設定する。
blx R5

blx前後のctxの退避方法がよくわからん。
mov(CTX, ShifterOperand(R0)); //R0がExitFrameInfo
mov(CTX, ShifterOperand(R2)); //R2が復元済みExitFrameInfo


armのcpuの使い方
const RegList kAbiArgumentCpuRegs =
     (1 << R0) | (1 << R1) | (1 << R2) | (1 << R3);

const RegList kAbiPreservedCpuRegs =
     (1 << R4) | (1 << R5) | (1 << R6) | (1 << R7) | (1 << R8) | (1 << R9) | (1 << R10);


r19404 | zra@google.com | 2013-03-05 02:45:38 +0900 (火, 05  3月 2013) | 2 lines
Adds vstm, vldm to ARM simulator, assembler, disassembler
Review URL: https://codereview.chromium.org//12390039
arm命令のvldms vstms vldmd vstmdを追加。

r19390 | vegorov@google.com | 2013-03-04 23:55:33 +0900 (月, 04  3月 2013) | 9 lines
In LoadOptimizer::EmitPhis check for environment uses of phis.
Previously we checked for input uses only. This caused some phis
to be not emitted if they had only environment uses. The bug was masked
by an elimination pass done before the register allocation.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//12391060
input_use_list() != NULL --> HasUses
HasUsesには、env_use_listもカウントされるので、env_use_listの参照もチェックすることにしたと。

r19322 | vegorov@google.com | 2013-03-02 01:31:26 +0900 (土, 02  3月 2013) | 21 lines
CompileType::ToNullableCid must check whether type is implemented

This should be done in addition to checking whether type
has subclasses as subtyping relation is defined in terms of interfaces.

Otherwise type propagation infers that result of a mint
operation has a kIntegerCid because IntType has no subclasses.

It is only appropriate to not take subinterfaces into
account when inferring cid of the receiver.

No regression test included because currently it is not possible
to write one: fact that we inferred kIntegerCid for result
of mint operations is not observable and for other IR
instructions nullability prevents us from infering
anything but kDynamicCid.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//12385044
nullableの処理がよくわからないな。。
dartにはnull point exceptionが実状無くて、
nosuch methoderrorになるんだよね。。
抽象クラスとして推論すべきか？ということ？
dartのinterfaceと、vmのimplとの関係がよくわからないな。
基本的に抽象クラスとして推論するけど、
implされたクラスの確認をどうするかとうこと？

変更前は曖昧な場合、全部dynamicにしていた。
変更後はFromAbstractType(type, kNonNullable)となっている。。
FromAbstractType(type, kNullable)を設定することもあるが、、


r19297 | floitsch@google.com | 2013-03-01 21:14:45 +0900 (金, 01  3月 2013) | 3 lines
Remove deprecated IllegalJSRegExpException class.
Review URL: https://codereview.chromium.org//12317130
IllegalJSRegExceptionを削除し、
普通の例外として投げるようになった。

r19282 | fschneider@google.com | 2013-03-01 18:03:45 +0900 (金, 01  3月 2013) | 11 lines
Fix null-termination bug in Stacktrace::ToCString.
Under certain conditions Stacktrace::ToCString can return a not null-terminated string.
This is the case when ToCStringInternal is invoked with a stacktrace of length 0.
BUG=dart:8850
TEST=tests/language/stacktrace_test.dart
Review URL: https://codereview.chromium.org//12387019
\nを挿入

r19272 | asiva@google.com | 2013-03-01 12:00:52 +0900 (金, 01  3月 2013) | 19 lines
Fix stack frame index numbers for full stack traces
It used to be:
#0      getCurrentStackTrace (file:///tmp/junk.dart:3:5)
#0      func1 (file:///tmp/junk.dart:10:29)
#1      func2 (file:///tmp/junk.dart:14:8)
#2      func3 (file:///tmp/junk.dart:18:8)
#3      func4 (file:///tmp/junk.dart:22:8)
#4      main (file:///tmp/junk.dart:26:8)
(Notice the two #0 frames on top).

Now it will print this as:
#0      getCurrentStackTrace (file:///tmp/junk.dart:3:5)
#1      func1 (file:///tmp/junk.dart:10:29)
#2      func2 (file:///tmp/junk.dart:14:8)
#3      func3 (file:///tmp/junk.dart:18:8)
#4      func4 (file:///tmp/junk.dart:22:8)
#5      main (file:///tmp/junk.dart:26:8)
Review URL: https://codereview.chromium.org//12381030
frame_index + 1

r19267 | srdjan@google.com | 2013-03-01 08:31:10 +0900 (金, 01  3月 2013) | 2 lines
Do not inline List factory if a non-constant argument is passed 
in order to prevent non-optimal code being generated.
This is a temporary fix until we have found a better solution
(maybe introduce a high-performance ? operator once its definition settles).
Review URL: https://codereview.chromium.org//12377032
Listの?opがオーバーヘッドなのだろうか
ListかつNonConstantの場合、inline展開しない。
Listは冒頭で、size nが与えられているかどうかで分岐しているのだが、そこが気になるのだろう。
それがinline展開されるのが気になる？
何らかの改善はあるのだと思う。
optional parameterなconstructorクラスは多いが、ListのみVM側に実装して特別に高速化しているため、
パフォーマンス上気になるのだと思う。

r19258 | hausner@google.com | 2013-03-01 06:17:47 +0900 (金, 01  3月 2013) | 6 lines
Libraries: update VM to current spec
- Exports allowed in script files
- library name is optional
- delete meaningless test, file co19 bugs
Review URL: https://codereview.chromium.org//12382026
parserの修正。 修正箇所は3箇所なんだけど、
これがdelete meaninglessに対応した修正なのかわからん。

r19256 | srdjan@google.com | 2013-03-01 05:54:15 +0900 (金, 01  3月 2013) | 2 lines
Fix factory name to result cid mapping, run type propagation once more after constant propagation.
Review URL: https://codereview.chromium.org//12374024
type propagationが1回増えた。
FactoryRecognizerなるものを新規追加して
ListのFactoryに応じて、Array, GrowableObjectArray, WithDataの型情報を取得している。
コードの整理もあるけど、WithDataに新規対応したのかな。

r19255 | tball@google.com | 2013-03-01 05:45:37 +0900 (金, 01  3月 2013) | 4 lines
Fixed debugger stacktrace generation that failed a VM assertion.
Added LocalVarDescriptors.ToCString(),
which is just used when debugging debugger issues, and is not referenced by any public APIs.
Review URL: https://codereview.chromium.org//12380031
vm/object.c::LocalVarDescriptors::ToCString
LocalVarDescriptorは、optimizedの際には動作しない。
最適化前でないと、正しいframeのoffsetが 入手不可能なのだと思う。
この点は将来改善されるのだろうか。
JVMのdebuggerはインタプリタモードでデバッグさせるし似たようなものか。
たしかbreakするまでJITコンパイルされたコードが走るけど、breakしたらインタプリタに戻るんだっけかな。

r19232 | fschneider@google.com | 2013-02-28 23:30:37 +0900 (木, 28  2月 2013) | 4 lines
Use enum instead of bool parameter in IL instructions to indicate if a store barrier is needed.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12377017
StoreBarrierTypeとして、NoStoreBarrierとEmitStoreBarrierを追加。

r19206 | kmillikin@google.com | 2013-02-28 17:25:58 +0900 (木, 28  2月 2013) | 13 lines
Remove dead phis as soon as they are discovered.

Previously we removed dead phis late, in the register allocator.
This change removes them as soon as
they are discovered to be dead and packs the phi array to squeeze out NULLs.
This speeds iteration but doesn't save space because the phi array is zone-allocated.
The PhiIterator is used everywhere to iterate phis except a few places
that need to know the phi index
(e.g., SSA construction, phi elimination).
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12340108
MarkLivePhiではなく、RemoveDeadPhis()に変更。
phi == NULlみたいな処理は置き替えられた。

r19182 | srdjan@google.com | 2013-02-28 07:58:59 +0900 (木, 28  2月 2013) | 2 lines
Intrinsify OnebyteString's hashcode. Next step is to inline it.
Review URL: https://codereview.chromium.org//12335138
Intrinsifierに、OneByteString_getHashCode()を追加。
get:hashCode
class StringHasherの処理をasmにinlineしたのだと思う。
以下の処理をasmで書き直した。
OneByteとTwoByteなどの処理で、処理を切り分けていたが、
intrinsicsにすれば、dart_patchクラスから、Hashを呼び出すだけでOKになるはず。
OneByteStringなので、

for (intptr_t i = 0; i < len; i++) {
  hasher.Add(* OneByteString::CharAddr(str, i + begin_index));
}
return hasher.Finalize(String::kHashBits);

void Add(int32_t ch) {
  hash_ += ch;
  hash_ += hash_ << 10;
  hash_ ^= hash_ >> 6;
}
Finalize(bits) {
hash_ += hash_ << 3;
hash_ ^= hash_ >> 11;
hash_ += hash_ << 15;
hash_ = hash_ & ((static_cast<intptr_t>(1) << bits) - 1);
ASSERT(hash_ <= static_cast<uint32_t>(kMaxInt32));
return hash_ == 0 ? 1 : hash_;
}


r19179 | asiva@google.com | 2013-02-28 07:47:06 +0900 (木, 28  2月 2013) | 10 lines
Add functionality to get full stack trace when exceptions are thrown.
This should address the issue raised in 7813.

try {
 ...
  ...
} on Object catch(e, s) {
 print(s.fullStackTrace);  // This should print the full stack trace.
}
Review URL: https://codereview.chromium.org//12316116
19096の続きの修正かな。RawStackTraceの拡張。
bootstrap_nativesに、getFullStacktrace, getStacktrace, setupFullStacktraceを追加。
vm内部で、stacktraceの文字列を生成String::Newして、その結果を返すらしい。。
libにも、stacktrace.cc stacktrace_patch.dartを追加している。
dartのfullStackTrace()を、vm内部のbootstrapでサポートしたと。


r19178 | iposva@google.com | 2013-02-28 07:36:22 +0900 (木, 28  2月 2013) | 2 lines
- Do not use the ? operator in the List factory.
Review URL: https://codereview.chromium.org//12335146
_GROWABLE_ARRAY_MARKERを、lengthに埋め込んでmarkerにする。

r19170 | hausner@google.com | 2013-02-28 05:58:07 +0900 (木, 28  2月 2013) | 2 lines
Fix order of mixin application during class finalization
Review URL: https://codereview.chromium.org//12355002
ApplyMixinを、FnalizeClassの直後に行うように順番入れ替え。

r19154 | hausner@google.com | 2013-02-28 02:42:24 +0900 (木, 28  2月 2013) | 4 lines
Less confusing names for mixing application classes
Use names of super and mixin class rather than types.
Review URL: https://codereview.chromium.org//12317150
簡単なリファクタリングかな？

r19152 | regis@google.com | 2013-02-28 02:13:51 +0900 (木, 28  2月 2013) | 2 lines
Compile and simulate first dart function on arm generated from ast.
Review URL: https://codereview.chromium.org//12335102
ごくり、、でかい。。
下記の基礎部分をARM向けに実装。
ReservedFrame, EnterDartFrame, EnterStubFrameのRuntime側の処理。
上記に対応した処理のStubの生成部分。
CompileGraphのメインのみ。
Compileの指示部分(counterのチェック)
Returnの処理
Enter直後のStackOverflow

メイン関数に入ってreturnで抜けるくらいはできるのでは？


r19143 | johnmccutchan@google.com | 2013-02-28 00:21:12 +0900 (木, 28  2月 2013) | 3 lines
Force WriteByte to be inlined
Review URL: https://codereview.chromium.org//12340086
コンパイラオプションのattributeでinlineを強制する、
DART_FORCE_INLINEマクロを定義。

r19127 | sgjesse@google.com | 2013-02-27 21:51:21 +0900 (水, 27  2月 2013) | 10 lines
Increase timeout jitter
Test have been failing on Windows a couple of times, e.g
http://build.chromium.org/p/client.dart/builders/vm-win32-release/builds/12880/steps/tests/logs/stdio
R=asiva@google.com
Review URL: https://codereview.chromium.org//12330139
testを変更。
kAcceptableSleepWakeupJitter = 200

r19112 | lrn@google.com | 2013-02-27 17:45:04 +0900 (水, 27  2月 2013) | 7 lines
Change new List(n) to return fixed length list.
Deprecate List.fixedLength, add List.filled.
Make Iterable.toList and List.from take "growable" argument, defaulting to false.
Review URL: https://codereview.chromium.org//12328104
ListFixedLengthFactoryを削除。
node->arguments()->length() == 0
だと、勝手にkGrowableObjectArrayCidをタグ付け

r19102 | zra@google.com | 2013-02-27 09:35:57 +0900 (水, 27  2月 2013) | 2 lines
Implements shifted offset register addressing mode for arm.
Review URL: https://codereview.chromium.org//12321149
OffsetKindに、ImmediateとShiftedRegister
Shiftedの場合、25bit目にtype shift bitを埋め込むと？

B25 <-- 25bit目
encoding_ = B25 | xxx | yyy | zzz << shift
みたいな|のみで記述されてておもしろい。

r19101 | regis@google.com | 2013-02-27 09:32:31 +0900 (水, 27  2月 2013) | 3 lines
Fix bad optimization prematurely marking types as instantiated (issue 8710).
Add test.
Review URL: https://codereview.chromium.org//12314132
set_is_finalized_instantiated()とset_is_finalized_uninstantiated()を
SetIsFinalized()に共通化。

r19099 | srdjan@google.com | 2013-02-27 09:03:53 +0900 (水, 27  2月 2013) | 2 lines
Improve performance of Onebytestring allocation and hascode computatio.
About 10% improvement on a JSON benhchmark.
Review URL: https://codereview.chromium.org//12315117
Allocateする際のString::Handle()を除去。
hash計算において、OneByteStringの処理を特殊化

r19097 | hausner@google.com | 2013-02-27 08:39:37 +0900 (水, 27  2月 2013) | 5 lines
Progress in generic mixins
Handle generic mixin applications in class declarations, but not yet in type aliases.
Review URL: https://codereview.chromium.org//12340085
mixinクラスからtype parameterを受け継ぐ処理を追加。
mixin application(mixinee)がtype parameterを持つ場合は今のところ未サポート

基本的に修正はparserとfinalizer。
finalizerに、type parameterをmixinクラスから取り込む処理を追加かな？


r19091 | tball@google.com | 2013-02-27 07:34:08 +0900 (水, 27  2月 2013) | 2 lines
Initial prototype of vmstats support, based on Dart VM Stats draft design doc.
Review URL: https://codereview.chromium.org//12221022
statsではなく、vmStatus
statsは、apiやbinのほう、vmの中ではvmStatus扱い。
APIとして、getVMStatusを公開。
name, port, starttime, stacklimit, newspace, used, capacity, oldspace, used, capacity
を表示する。
API経由で情報を取得できるみたい。port経由で接続して取得する。
bin/mainに、--stats-root=xxxと、--stats オプションを追加
mutex(MonitorLocker)を使って取得するらしい。
socketは、普通にbindして準備する。bin/vmstats_impl.cc


r19096 | asiva@google.com | 2013-02-27 08:24:24 +0900 (水, 27  2月 2013) | 2 lines
Resubmit change 19074.
Review URL: https://codereview.chromium.org//12335111
r19084 | asiva@google.com | 2013-02-27 06:41:29 +0900 (水, 27  2月 2013) | 2 lines
Revert change 19074 until the windows build is fixed.
Review URL: https://codereview.chromium.org//12335107
r19074 | asiva@google.com | 2013-02-27 04:07:40 +0900 (水, 27  2月 2013) | 5 lines
Fix for bug 6767 - Limit stack trace collection for stack overflow exceptions.
Use pre allocated stack object for collecting strack trace in the case of OOM
and stack overflow exceptions.
Review URL: https://codereview.chromium.org//12320103
snapshot Fullの場合に作用する？
RawStackTrace()か。
StackTraceBuilder()を作って、あらかじめ領域確保、いつ起こってもいいよと。。
修正量が多いな。。

r19044 | fschneider@google.com | 2013-02-26 23:38:03 +0900 (火, 26  2月 2013) | 12 lines
Support instruction-level perf event profiling to Dart VM using V8's ll_prof.py.
Usage:
1) perf record -g out/ReleaseIA32/dart --ll-prof example.dart
2) third_party/v8/tools/ll_prof.py --disasm-top=3
This will produce a  per-function and a per-instruction profile with 
disassembly for the top 3 function in the profile.
Currently only available on Linux.
Review URL: https://codereview.chromium.org//12342012
オプション ll_prof
LowLevelProfileCodeObserver()の追加。
ちょっと試してみるか。

r19036 | kmillikin@google.com | 2013-02-26 20:50:28 +0900 (火, 26  2月 2013) | 9 lines
Add functions for setting an environment and rebinding a use.
Add functions for setting or clearing an instruction's environment,
which initialize the environment uses.
Add a function for changing a use's definition.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12335063
Environmentを抽象化、useの更新等を単純にした。


r19022 | tball@google.com | 2013-02-26 09:12:33 +0900 (火, 26  2月 2013) | 2 lines
Corrected test suppression from previous CL.
Review URL: https://codereview.chromium.org//12317117
テストの追加

r19020 | tball@google.com | 2013-02-26 08:36:28 +0900 (火, 26  2月 2013) | 3 lines
Disabled context variables in local variable list in the debugger,
so developers can still use it while issue 8593 is being fixed.
Review URL: https://codereview.chromium.org//12320023
debuggerのlocal variableのslot検索を一時的にoff

r19019 | iposva@google.com | 2013-02-26 08:31:57 +0900 (火, 26  2月 2013) | 2 lines
- The dart:json library is now using patches.
Review URL: https://codereview.chromium.org//12335082
INIT_LIBRARYにpatchフラグを有効にした。

r19017 | iposva@google.com | 2013-02-26 08:25:29 +0900 (火, 26  2月 2013) | 3 lines
- Properly load the core libraries as libraries and not as scripts.
This will honor their imports and library names.
Review URL: https://codereview.chromium.org//12321082
load済みのlibraryをcanonicalizeする処理の変更。
冗長な記述がマクロ化された


r19013 | srdjan@google.com | 2013-02-26 08:05:43 +0900 (火, 26  2月 2013) | 2 lines
For Doubl erounding call C-function instead of attempting to inline it. Fixes issue 8760.
Review URL: https://codereview.chromium.org//12334080
DoubleRoundの高速化のためinlineされていた実装が削除？ intrinsicsが呼ばれるのかな。

r19001 | johnmccutchan@google.com | 2013-02-26 06:12:50 +0900 (火, 26  2月 2013) | 3 lines
Simd128Float32, Simd128Mask, and Simd128Float32List additions for dart:scalarlist
Review URL: https://codereview.chromium.org//12303013
vmに、Float32x4と、Float32x4ArrayとUint32x4を追加。
vm/raw_objectとvm/objectに追加しているけれども、SSEまではまだ使用されていない。
simd系の演算をscalarlistに取り込んだだけかな。
x4型を使えば、配列添字ではないため、添字チェックは存在しない。
float32x4Array型はbytearray型なので、おそらく任意のbytearrayの特定の領域をviewで参照して、
simd演算できるようになるはず。

r18994 | regis@google.com | 2013-02-26 04:30:29 +0900 (火, 26  2月 2013) | 4 lines
Hook up simulator (if needed) when calling Dart code.
Merge identical InvokeDynamic and InvokeStatic to InvokeFunction.
Remove redundant argument from InvokeClosure.
Review URL: https://codereview.chromium.org//12315087
calleeをInvokeFunctionになったと。。
InvokeFunction()本体も修正していて、USING_SIMULATORでifdefが切ってある。
その場合は、Current()->Call()を呼び出す。
そうでない場合は、entryPoint()を呼び出す。
if !HasCode()の場合に、CompileFunction()を読んでいた処理が削除されているようだが、
どこにいったのだろうか。

stub_code側も共通化されていて、InvokeStaticとInvokeDynamicはいらない子に。
stubのTOSも1子減った。

r18991 | vegorov@google.com | 2013-02-26 03:48:49 +0900 (火, 26  2月 2013) | 8 lines
null value can be the receiver of methods on Object (e.g. hashCode).
Fix wrong assumption in the type propagator that marked the receiver as never nullable.
R=srdjan@google.com
BUG=dart:8739
Review URL: https://codereview.chromium.org//12330113
んん？ 966の内容が戻ってるんだけど。。比べてみたら修正されただけか。
PropagatorのPrintも、18966風に修正した。
is_nullableの場合のtype propagatorの修正も入っていて、index==0が目印なのか。


r18966 | vegorov@google.com | 2013-02-25 22:09:17 +0900 (月, 25  2月 2013) | 8 lines
Add machine readable markers around code and flow graph output printed for
--print-flow-graph and --disassemble-optimized.
This allows to quickly preparse large IR/code dumps
when loading then into the tools instead of parsing them line by line and figuring out
where things start and end.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12321111
PrintGraphの際に、BEGIN CFGとEND CFGに囲まれるようになった。
消されたキーワードは俺parseの目印につかってたんだけどな、、切り替えればいいか。

r18961 | kmillikin@google.com | 2013-02-25 20:24:08 +0900 (月, 25  2月 2013) | 8 lines
Set instruction/use_index when adding an input to an IL instruction.
When setting an input (including in the constructor) of an IL instruction,
automatically set the input use's instruction and use_index fields.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12316065
SetInputAt()を改良。
生の添字をいじるのではなく、SetInputAt()で操作するようにした。

r18960 | lrn@google.com | 2013-02-25 19:48:09 +0900 (月, 25  2月 2013) | 5 lines
Remove deprecated string features.
Make String.codeUnits return a List.
Review URL: https://codereview.chromium.org//12282038
CharCodeAt -> CodeUnitAt
return List<int>

r18937 | srdjan@google.com | 2013-02-23 09:58:41 +0900 (土, 23  2月 2013) | 2 lines
Making CompileType a Value object.
Review URL: https://codereview.chromium.org//12315063
CompileTypeをValueObject継承。もしかしていままでリークしていた？

r18925 | srdjan@google.com | 2013-02-23 07:43:36 +0900 (土, 23  2月 2013) | 2 lines
Improve performance of String::ToCString for OneByteStrings and parsing of doubles.
Leads to significant speedups in json parsing.
Review URL: https://codereview.chromium.org//12317076
latin-1の場合に高速化。

r18933 | sra@google.com | 2013-02-23 09:21:24 +0900 (土, 23  2月 2013) | 5 lines
Revert "Revert "Use browsers JSON.parse for parsing JSON (#3)""
Fix more IE special cases
Review URL: https://codereview.chromium.org//12320072

r18911 | sra@google.com | 2013-02-23 04:34:08 +0900 (土, 23  2月 2013) | 3 lines
Revert "Use browsers JSON.parse for parsing JSON (#3)"
Review URL: https://codereview.chromium.org//12313069

r18908 | sra@google.com | 2013-02-23 04:21:18 +0900 (土, 23  2月 2013) | 7 lines
Use browsers JSON.parse for parsing JSON (#3)
Original CL: https://codereview.chromium.org//12114021
This version modified to take advantage of dart:json being moved to VM.
Review URL: https://codereview.chromium.org//12314055

r18896 | vegorov@google.com | 2013-02-23 01:39:52 +0900 (土, 23  2月 2013) | 5 lines
Fix arm and mips build.
TBR=kmillikin@google.com
Review URL: https://codereview.chromium.org//12340028
armとmipsの修正漏れ

r18895 | vegorov@google.com | 2013-02-23 01:33:37 +0900 (土, 23  2月 2013) | 14 lines
Ensure that compile time types for comparisons are recomputed once comparison are specialized.

Turn CompileType into a value object instead of zone object.
Provide a transparent zone allocated wrapper for CompileType.
This simplifies code paths that recompute and update type
and reduces number of allocated zone objects.

Split ComputeInitialType into ComputeInitialType and ComputeType.
ComputeType returns values type as a value object.
ComputeInitialType returns a pointer and by default it delegates to ComputeType.
This split reflects differences between instructions:
majority of them have their own type,
but some can return the type of an input which should not be unwrapped and rewrapped
again because this will destroy the connection between types.

R=kmillikin@google.com
Review URL: https://codereview.chromium.org//12330072
CompileTypeをZoneAllocateではなく、ZoneCompileTypeがwrapするようにした。
Typeは1回のコンパイル内でキャッシュされ、ZoneCompileType内でcanonicalizeされる。
wrapした型を更新する場合、UpdateType()
メモリ使用削減が目的かな。

r18890 | fschneider@google.com | 2013-02-22 22:41:24 +0900 (金, 22  2月 2013) | 5 lines
Insert missing test for unboxed mint support when inlining _setIndexed, getInt32, getUint32.
Int32Array and Uint32Array can only be optimized on ia32 when SSE 4.1 is supported.
Review URL: https://codereview.chromium.org//12328055
r18818に追加。ia32の場合、32bit以下のときmintのcheckを追加。
x64ではmintはないが、ia32では必要であり、int32arrayは32bitより小さい場合に有効。


r18865 | asiva@google.com | 2013-02-22 10:24:57 +0900 (金, 22  2月 2013) | 3 lines
Move json, uri, utf and crypto libraries into the VM.
This should ensure that we would not need a patch per embedder for these libraries
in case somebody decides to patch these.
Review URL: https://codereview.chromium.org//12318031
patch対象のクラスに、上記を追加。
準備のみで、ビルド方法を変更したのみ。
LoadScriptはUnreachable

r18859 | srdjan@google.com | 2013-02-22 07:24:42 +0900 (金, 22  2月 2013) | 2 lines
Recognize pattern (a << b) & c with c being a positive Smi and allow left shift to truncate the result.
Review URL: https://codereview.chromium.org//12218181
オプション truncating_left_shift=true
OptimizeLeftShiftBitAndSmiOp()を追加
leftが0以上でなければやらない。
shift後のtempがsinle useだったら、AsSmiShiftLeftInstruction()
(a << b) & c を以下のように特殊化する。method chainingっぽく見えるのがおもしろい。
もしcがBinarySmi and_だったら、
a.<<(b).&(c) --> (Smi)(c) & (Mint)(a).<<(b)

x64の場合、
EmitSmiShiftLeft()
rightがconstant
shll valueが0以下かつtruncatingだったら、xorqで0初期化
上記のいずれかなら、deopt result is mint or exception
is_truncatingだったら、shlqのあとdeopt挿入
不要ならshlqのみ。

rightがnonconstant
leftがconstantでないと難しい。

rightもleftもconstantでない場合も、smi andするのでどうにかなる。
andするSmiに、checksmi挿入。
普通はoverflowしたらMintやBigintに一時的になるが、
無理やりshiftするだけでOK。

いあ、shll sarlしてoverflowしてたらdeoptか？

Math.randomが遅い問題も、そのうちand(mint)版が作成されて速くなるはず。
いあ、x64だと既に大分速くなっている？？？


r18848 | iposva@google.com | 2013-02-22 03:53:27 +0900 (金, 22  2月 2013) | 3 lines
- Improve the message for NoSuchMethodErrors that are determined statically at compile time.
Review URL: https://codereview.chromium.org//12328019
NoSuchMethodErrorsを実行時に投げる際に、
EncodeTypeやInvocationMirror型、例をあげると TopLevel, Static Getterのいずれかを投げる。

r18846 | asiva@google.com | 2013-02-22 03:43:44 +0900 (金, 22  2月 2013) | 2 lines
Add typed data interface to Dart API, this only changes the C++ API as dicussed in a previous email.
The dart code in the library has not been changed yet.
Review URL: https://codereview.chromium.org//12255018
ByteArrayからTypedDataへ
全部名称変更。

r18844 | zra@google.com | 2013-02-22 03:36:34 +0900 (金, 22  2月 2013) | 2 lines
Adds ARM arm assembler tests.
Review URL: https://codereview.chromium.org//12340006
ARM向けのUnittestが追加されている。
V8も見てみたけど、and_ は伝統みたい。 コメントで言及し難いからなのか。

r18830 | kmillikin@google.com | 2013-02-21 22:56:40 +0900 (木, 21  2月 2013) | 9 lines
Weaken a bogus assertion in use list verification.
It is allowed for a phi to refer to itself as input without violating properties of SSA form.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12317043
assertの追加。
use->definition()->IsPhi()

r18827 | kmillikin@google.com | 2013-02-21 21:57:43 +0900 (木, 21  2月 2013) | 10 lines
Reapply "Change the SSA construction pass to also construct def-use chains."

This reapplies svn commit 18813 with a bug fix.
In the case of an inlined call whose value is not used,
the inliner hase inserted a use of the return value's definition, which must be removed.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12334007

computeUseListの削除、verifyuselists()への置き替えがメイン。
(1) Value* input = phi->InputAt(0);
(2) phi->ReplaceUsesWith(input->definition());
(3) input->RemoveFromUseList();
(* phis)[phi_idx] = NULL;
phiが削除予定だから、inputからの依存を切りたいのか？これ全部依存切れるんじゃないのかな。。


r18826 | kmillikin@google.com | 2013-02-21 21:51:01 +0900 (木, 21  2月 2013) | 10 lines
Fix broken use lists in branch instructions.

BranchInstr::ReplaceWith is used in two different places that have different
expectations about the use lists of their argument.
Split it into two separate functions.
R=fschneider@google.com
BUG=dart:8657
Review URL: https://codereview.chromium.org//12310040

setComparison()で置換処理を行うようになっている。
BranchInstr::ReplaceWith()

r18820 | sgjesse@google.com | 2013-02-21 20:58:11 +0900 (木, 21  2月 2013) | 7 lines
Merge IO v2 branch to bleeding edge
R=ager@google.com, ajohnsen@google.com, whesse@google.com
Review URL: https://codereview.chromium.org//12316036
vm内は、 dart_api_impl.cc
ThrowAgrumentError()
主にruntime/binが多いかな。

r18818 | fschneider@google.com | 2013-02-21 20:35:19 +0900 (木, 21  2月 2013) | 2 lines
Inline ByteArray._setIndexed in the flow graph optimizer.
Review URL: https://codereview.chromium.org//12317011
setIndexed系が、TryInlineByteArraySetIndexed()
すべてIntrinsicではなく、ICDataによるinliningに置き替えられた。
素晴らしい。
Intrinsicの使い方も考え物ですね。
オーバーヘッドが削減されて、2倍くらい速くなった。

r18797 | iposva@google.com | 2013-02-21 08:40:32 +0900 (木, 21  2月 2013) | 3 lines
- Disable source_filter.gypi.
- Adjust some more OS dependent files.
Review URL: https://codereview.chromium.org//12313021
18786と同様。source_filter.gypi機能か。。

r18793 | vegorov@google.com | 2013-02-21 07:38:22 +0900 (木, 21  2月 2013) | 8 lines
Ignore definitions that do not have SSA index in FlowGraphAllocator::CollectRepresentations.
SSA building does not assign an index to definitions without uses and the rest of the allocator
can cope with this treating output produced by such an instruction as temporary value.
R=srdjan@google.com
BUG=dart:8655
Review URL: https://codereview.chromium.org//12315017
ssa_temp_indexはデフォルト-1なんだっけ？

r18786 | iposva@google.com | 2013-02-21 06:17:38 +0900 (木, 21  2月 2013) | 4 lines
Prepare for removal of source_filter.gypi:
- Guard OS-dependent source files with #if TARGET_OS_* in a similar
  fashion to the architecture dependent sources.
Review URL: https://codereview.chromium.org//12282051
if definedでTARGET_OSのガードを挿入。
こっちのほうがビルド速いのかね。

r18777 | vegorov@google.com | 2013-02-21 04:40:26 +0900 (木, 21  2月 2013) | 15 lines
Strengthen type assertions post-dominated by checks during type propagation.
If a type assertion for a value is post-dominated by a class
or smi check over the same value then raise the check over the assertion.
This allows to eliminate type assertions in the cases like:
AssertAssignable(x, int)
CheckSmi(x)
Currently post-domination is computed within a single block because post-dominators are not available.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12317013
AssertAssignable()を挿入して、single block内でCheckSmiに先行してチェックする。
Deoptする前にassertを飛ばすためかな？
CheckClassやCheckSmiの直前にAssertAssignable()を挿入する。

r18769 | regis@google.com | 2013-02-21 02:28:35 +0900 (木, 21  2月 2013) | 3 lines
Implement ARM disassembler.
Implement ARM call patcher.
Review URL: https://codereview.chromium.org//12301042
ObjectPool()をobject.hに追加。
vm/disassembler_arm.ccを追加。

r18767 | fschneider@google.com | 2013-02-21 02:11:41 +0900 (木, 21  2月 2013) | 5 lines
Remove optional CompileType parameter in the constructor of Value.
It is only needed in one place inside the Value class anyway,
so there is no reason to have it visible to the outside.
Review URL: https://codereview.chromium.org//12319017
Value()の引数 typeを隠蔽。


r18750 | kmillikin@google.com | 2013-02-20 22:01:25 +0900 (水, 20  2月 2013) | 12 lines
Remove two more places where we computed use lists and add verification.
Remove computation of use lists after type propagation which was
unnecessary, and a call per inlined function after ApplyICData which was also unnecessary.
Add verification code after all compiler passes.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//12317007
UseListのメンテを置換済みであるため、VerifyUseLists()を追加した。

r18710 | hausner@google.com | 2013-02-20 03:26:55 +0900 (水, 20  2月 2013) | 6 lines
Fix static name resolution in mixing code In mixin code,
static names need to be looked up in the mixin class.
OTOH, in patch classes, we need to resolve static names in the class into with the code is patched.
I'm all for simplicity!
Review URL: https://codereview.chromium.org//12308005
static methodはmixinされないが、mixinされた非static methodから呼び出すことはできるらしい。
謎だ。

r18692 | fschneider@google.com | 2013-02-20 00:25:47 +0900 (水, 20  2月 2013) | 5 lines
Copy propagated type info when inserting conversion.
Use propagated type info to improve smi-checking before
double operations (CheckEitherNonSmi)
Review URL: https://codereview.chromium.org//12298034
CopyWithType()を追加し、insertingでreaching_typeをコピー。
callをspecializeする際に使って型情報を伝搬する。

r18676 | kmillikin@google.com | 2013-02-19 21:09:01 +0900 (火, 19  2月 2013) | 6 lines
Convert some compiler passes to preserve valid def-use chains.
Change the ApplyICData, ApplyClassIds, Canonicalize, and
SelectRepresentations passes to preserve valid use lists.
Review URL: https://codereview.chromium.org//12212093
コンパイラ内部を大幅にリファクタリング。
ComputeUseListにより適時再計算するのを削除し、 各Passでpreserveするように修正。

基本的なメンテのパターンはこちら
use->RemoveFromUseList();
use->set_definition(converted);
converted->AddInputUse(use);

ReplaceCall()
push->ReplaceUsesWith(push->value()->definition());
push->UnuseAllInputs();
push->RemoveFromGraph();
call->ReplaceWith()

普通は、ReplaceCall()を呼んで内部でメンテ。

r18647 | fschneider@google.com | 2013-02-19 01:52:36 +0900 (火, 19  2月 2013) | 5 lines
Use compile type to improve stores to Int32List and Uint32List on ia32.
If the value stored is a smi, we just untag and store it.
There is no need to unbox it into an XMM register first.
Review URL: https://codereview.chromium.org//12295017
Int32ArrayCidとUint32ArrayCidを、これまでMint固定で扱っていたのを、
ia32でもSmiとして扱う。
なんかこれはおかしい気がする。。Mintとして扱わないと、最上位bitが立っていた場合に困るのでは？？
どうせia32もxmm使うし問題ないよねということ？

r18645 | vegorov@google.com | 2013-02-19 00:56:59 +0900 (火, 19  2月 2013) | 6 lines
Fix compilation error: enumeral and non-enumeral type in conditional expression.
R=ager@google.com
Review URL: https://codereview.chromium.org//12288030
三項演算子がコンパイルエラーらしい。。普通のif-elseに。

r18641 | vegorov@google.com | 2013-02-19 00:45:55 +0900 (火, 19  2月 2013) | 8 lines
Trust declared type of the receiver to compute its initial compile type.
Fix a bug in the ToNullableCid which was leaving cid_ uninitialized when class has subclasses.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12304009
GraphEntryInstrにParsedFunctionを持たせて、ComputeInitialType()で使用する。
dynamicか、constructorの型を返す。

r18624 | fschneider@google.com | 2013-02-18 22:18:28 +0900 (月, 18  2月 2013) | 7 lines
Optimize _getIndexed on byte arrays.
Until now we only optimize the [] operator, but don't have a
fast path for polymorphic invocations of [] on byte arrays.
I also added additional test coverage for Uint8Clamped list.
Review URL: https://codereview.chromium.org//12282029
ByteArrayの特殊化がとうとうはじまったか、、ガタッ
ByteArrayの各種GetIndexedをRecognilizerに追加

r18604 | regis@google.com | 2013-02-16 08:55:31 +0900 (土, 16  2月 2013) | 5 lines
Add support for object pool that will be used on ARM and MIPS architectures.
Modify code patching infrastructure to accept code object,
which is necessary to get to the object pool containing patchable target addresses.
Modify assembler test infrastructure to provide associated code object.
Review URL: https://codereview.chromium.org//12260026
本体のほうをARM/MIPS向けにメソッドを抽象化。
おもしろそうなのは、ARMのPP = R10を、Caches object pool pointerとして使うというところ。
code_patcherを修正し、PatchCallにおいて、object poolを参照すると。。
object poolは、ia32 x64では使用しない。
object poolを参照してのpatch callは未実装。

r18525 | srdjan@google.com | 2013-02-15 03:10:21 +0900 (金, 15  2月 2013) | 2 lines
Optimize left shift of a constant: compute max value of right that does not overflow into Mint/Bigint.
Review URL: https://codereview.chromium.org//12212175
shift leftの最適化がとうとう来たか。。
right_rangeと、leftがconstantだった場合に実行。
leftがisSmiだった場合、MintやBigintへのoverflowへのguardを作成してshllを生成。
right_rangeから、guardが不要であると分かれば、shllのみ。

r18519 | fschneider@google.com | 2013-02-15 00:59:18 +0900 (金, 15  2月 2013) | 7 lines
Fix bug in optimizing string .length loads.
We're not allowed to hoist a .length load if the corresponding
class-check is not also hoisted out of a loop.
TEST=tests/language/optimized_string_charcodeat_test.dart
Review URL: https://codereview.chromium.org//12256037
lengthのhoist抑止か。

r18517 | fschneider@google.com | 2013-02-14 21:59:51 +0900 (木, 14  2月 2013) | 4 lines
Optimize stores to ExternalUint8Array and ExternalUint8ClampedArray in the optimizer.
This CL adds support for these two array types to the StoreIndexed instruction.
Review URL: https://codereview.chromium.org//12263010
ExternalUint8Array and ExternalUint8ClampedArray
external arrayの場合、RequiresRegisterをtempに使用する。

r18515 | fschneider@google.com | 2013-02-14 20:41:08 +0900 (木, 14  2月 2013) | 6 lines
Use writable register policy to avoid explicit restoring input register after untagging.
This CL produces more compact code if the writable input
register is the last use by avoiding unnecessary re-tagging.
In that case no extra temp generated by the register allocator.
Review URL: https://codereview.chromium.org//12114008
LoadDoubleOrSmiToFpuを削除。
Re-tagの削除。可能な限りImmediateIndexに置換する。
Location::WritableRegister()とLocation::RequiresRegister()の導入。

r18495 | hausner@google.com | 2013-02-14 08:48:18 +0900 (木, 14  2月 2013) | 7 lines
Minor improvement in mixin application
Build list of functions and attach it to mixing application class on one call.
Takes care of a review comment by Siva.
TBR=asiva
Review URL: https://codereview.chromium.org//12261029
finalizerの書式が揃ってなかった点を修正。
mixinclsee.each(cls) => cloned_funcs.Add(func.Clone(cls))
mixinclsee.each(cls) => cloned_fields.Add(field.Clone(cls))

r18493 | johnmccutchan@google.com | 2013-02-14 08:05:17 +0900 (木, 14  2月 2013) | 3 lines
SSE Assembler + Linux build fixes
Review URL: https://codereview.chromium.org//12223115
大量追加！！！
xxxps系とmovupsを一式追加。

r18492 | srdjan@google.com | 2013-02-14 08:00:09 +0900 (木, 14  2月 2013) | 2 lines
The code size does not scale with architecture word size,
set code size cutoff limit to 200,000 bytes for all architectures
Review URL: https://codereview.chromium.org//12256028
r18485 | srdjan@google.com | 2013-02-14 06:52:02 +0900 (木, 14  2月 2013) | 2 lines
Add flag to block optimizations of large implicit getters. Implicit getters have a 0 size in tokens,
therefore also check the size of unoptimized code to decide if a function is optimizable.
Print more data with --trace-compiler.
Review URL: https://codereview.chromium.org//12263017
huge_method_cutoff_in_tokens=20000
huge_method_cutoff_in_code_size=200000 byte
上記を越えた場合、is_optimizable()がfalse返す。つまりFlowGraphOptimizerが走らない。

r18479 | hausner@google.com | 2013-02-14 06:08:15 +0900 (木, 14  2月 2013) | 6 lines
First stab at mixins in VM compiler
Things not yet supported:
- Type parameters for super class and mixin class
- super call limitation check
Review URL: https://codereview.chromium.org//12210127
Object.hのClassに、mixin()やset_mixin()を追加。
ポイントとなるフィールドは、clone, owner, origin

mixinのtokenは、kWITHか
mixinにより、まずparse時のconstructorを解決する。
mixinされたクラスから、Class mixin_applicationを作成し、
AddImplicitConstructor(mixin_application)として取り込む。

その後、mixinはClassFinalizerのApplyMixinにより、
mixinclsee.each(cls) => cloned_funcs.Add(func.Clone(cls))
mixinclsee.each(cls) => cloned_fields.Add(field.Clone(cls))

r18464 | srdjan@google.com | 2013-02-14 03:44:27 +0900 (木, 14  2月 2013) | 2 lines
Fix allocation of array tables (use store barrier if needed, store values directly instead of via stack).
Review URL: https://codereview.chromium.org//12212050
ArrayLiteralVarっていうSymbolが追加。
Arrayだからといって、Stackに全部つまなくなった。。
修正前は、for回して何回もpopqしていた。。
その対象になるのは、ArrayLiteralだけなのかな。

r18456 | vegorov@google.com | 2013-02-14 02:16:35 +0900 (木, 14  2月 2013) | 11 lines
Reapply r18377 it was reverted due to the unrelated bug it surfaced.
Remove SminessPropagator and FlowGraphTypePropagator and all associated infrastructure and fields.
Replace multiple fields (result_cid_, propagated_cid_, propagated_type_, reaching_cid_)
with a single field of type CompileType
which represents an element of type analysis lattice and incorporates information about:
value's nullability, concrete class id and abstract super type.
This ensures that propagated cid and type are always in sync and complement each other
Implement a new FlowGraphPropagator that propagates types over the CompileType-lattice.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12260008
修正量が多い。。optimizerの処理をファイルとクラスに切り出したはず。
コメントの通りの修正のはずだけど、量が多すぎて妥当性が判断できない。
たしかに、各クラスごとにフィールドを持てば処理できるけれども、
おそらくベンチマークとって問題ないという判断なのだろう。。

r18443 | vegorov@google.com | 2013-02-13 23:14:05 +0900 (水, 13  2月 2013) | 6 lines
When canonicalizing branch on StrictCompare don't fuse comparisons
that can deoptimize or serve as pending deoptimization target for representation changes.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12220150
return thisしてfuseしないケースを増加。
compがDeoptimizeできるときと、representationが異なる場合。

r18426 | iposva@google.com | 2013-02-13 10:13:02 +0900 (水, 13  2月 2013) | 2 lines
- Make size of the stack red zone depend on word size.
Review URL: https://codereview.chromium.org//12207142
4 -> kWordSize

r18412 | srdjan@google.com | 2013-02-13 08:34:12 +0900 (水, 13  2月 2013) | 2 lines
Reduce allocation of ArrayNode-s where a GrowableArray could be used instead.
Review URL: https://codereview.chromium.org//12207137
ArrayNodeをGlorableArray<ArrayNode*>に置き替えかな？

r18402 | asiva@google.com | 2013-02-13 06:14:05 +0900 (水, 13  2月 2013) | 4 lines
Minor cleanup
- added a field parsed_function to the parser
- remove fields expression_temp_ and saved_current_context_
Review URL: https://codereview.chromium.org//12225141
parsed_functionをフィールドに追加して、current_contextを保存するのに使っている。

r18367 | asiva@google.com | 2013-02-12 11:39:00 +0900 (火, 12  2月 2013) | 2 lines
Add snapshot size to the VM benchmarks suite.
Review URL: https://codereview.chromium.org//12226068
coreとstandalone-coreをsnapshotして、そのsizeを計測するunittestを追加。

r18330 | asiva@google.com | 2013-02-12 04:48:32 +0900 (火, 12  2月 2013) | 3 lines
Provide implementations for Dart_ScalarListAcquireData & Dart_ScalarListReleaseData
Review URL: https://codereview.chromium.org//12209075
apiのDart_ScalarListAcquireDataを実装。
ByteArrayによって既存のArrayへのViewを作るのだと思う。

r18318 | floitsch@google.com | 2013-02-12 02:59:52 +0900 (火, 12  2月 2013) | 6 lines
Allow ambiguous Expect and ExpectException imports.
This patch temporarily allows Expect to come from core and from any other library without
(I wanted to make the CL public reporting an error (or warning).
Once everyone (including co19) has migrated I will revert this CL.
Review URL: https://codereview.chromium.org//12211045
ExpectとExpectExceptionがついた場合、importしない。

r18287 | iposva@google.com | 2013-02-09 08:27:50 +0900 (土, 09  2月 2013) | 2 lines
- Remove redundant type parameters for internal data.
Review URL: https://codereview.chromium.org//12218082
不要なTypeParameterを削除しただけ。

r18256 | fschneider@google.com | 2013-02-09 00:47:09 +0900 (土, 09  2月 2013) | 2 lines
Optimize branches in polymorphic equality operations.
Review URL: https://codereview.chromium.org//12209057
equalityの処理の見直し。

r18235 | asiva@google.com | 2013-02-08 07:43:16 +0900 (金, 08  2月 2013) | 5 lines
Fix for issues 6080 -
- Read the saved context from the entry frame when straddling across C++ frames
  while iterating over a stack trace in the debugger.
  This ensures that the correct context is setup in the ActivationFrame structure in these scenarios
  (instead of the empty context).
- Read the saved context from the caller's frame when iterating over a stack trace in the debugger.
  The compiler saves the context in the caller frame before invoking closures,
  we read this saved context when iterating the stack trace.
Review URL: https://codereview.chromium.org//12179020
word * -5に、SavedContextOffsetInEntryFrameを追加した。
current contextを保存するのだと。
stack_frameを変更するのは初なのでは？

r18232 | asiva@google.com | 2013-02-08 05:55:21 +0900 (金, 08  2月 2013) | 2 lines
Add unit tests which reliabily reproduces the error condition reported in Issue 6080
without the need for a specialized and inconsistent private environment.
Review URL: https://codereview.chromium.org//12218046
test追加。

r18209 | kmillikin@google.com | 2013-02-07 18:42:36 +0900 (木, 07  2月 2013) | 4 lines
Change CSE, LICM, and range analysis to preserve use lists.
Change the common subexpression elimination, loop-invariant code motion,
and range analysis passes to maintain use lists.
UnuseAllInputs()を追加。削除前にUseをメンテするらしい。

r18200 | regis@google.com | 2013-02-07 09:55:47 +0900 (木, 07  2月 2013) | 4 lines
Generate first ARM assembler test and execute (simulate) it.
RFC: First draft showing how generated ARM code accesses GC'ed objects and
accesses patched call targets.
Review URL: https://codereview.chromium.org//12224024
CanHoldLoadOffset()でいろいろ分岐している。
CanHold()
ああ、shifterで命令を畳み込めるかの判定か。。
全部assemblerの内部に隠蔽するのか。

kBreakpointSvcCodeを埋め込むのか。これはsimulatorで動かしてbreakさせるためか。
arm simulatorが動きそう。
unittestにarm simulatorを動かすコードが入っていて、起点はSimulator::Current()->Call()か
simulatorを介して、まずはunit testにarm assemblerの自動テストを追加していくと。

r18183 | fschneider@google.com | 2013-02-07 04:00:50 +0900 (木, 07  2月 2013) | 6 lines
Add optimized loads from ExternalUint8ClampedArrays.
The generated code is exactly the same as for ExternalUint8Array.
TEST=tests/standalone/byte_array_test.dart
Review URL: https://codereview.chromium.org//12225049
ExternalUint8ClampedArrayの最適化を追加。

r18175 | fschneider@google.com | 2013-02-07 01:21:51 +0900 (木, 07  2月 2013) | 5 lines
Flip test condition when testing for fixed-length array length load.
This addresses additional comments to my previous CL:
https://codereview.chromium.org/12088108/
Review URL: https://codereview.chromium.org//12208046
ByteArrayBaseLengthもimmutableの仲間入り。

r18173 | fschneider@google.com | 2013-02-07 00:18:57 +0900 (木, 07  2月 2013) | 11 lines
Inline getters of byte array view in the optimized flow graph.
This CL provides inline IL code for the getters _getInt8, _getInt16, etc.
to speed up [] and byte array views.
The code uses the existing LoadIndexed instructions by passing a index
scale factor explicitly: For normal arrays loads, the scale factor is equal
to the element size. For byte array access, the scale factor is always 1.
I'm adding inlined setters in a separate CL.
Review URL: https://codereview.chromium.org//12218008
ByteArrayのgetIntを高速化。
BuildByteArrayViewLoad() を追加。
どう高速化されるかというと、BinarySmiOpInstrに変換される。
あまり変わらないかも、、コードを整理しただけか。。
テストコードたくさん追加。

r18172 | floitsch@google.com | 2013-02-07 00:11:47 +0900 (木, 07  2月 2013) | 6 lines
Hide collection-dev library.
Committed: https://code.google.com/p/dart/source/detail?r=18167
Reverted: https://code.google.com/p/dart/source/detail?r=18169
Review URL: https://codereview.chromium.org//11938036
ライブラリ名の先頭に_をつける。

r18162 | asiva@google.com | 2013-02-06 10:45:56 +0900 (水, 06  2月 2013) | 2 lines
Minor cleanup of activation frame creation code.
Get the code object while iterating the frames as that is way faster than doing a code lookup later.
Review URL: https://codereview.chromium.org//12225031
debugger ActivationFrameのCode::Lookupcode()を高速化か。

r18159 | iposva@google.com | 2013-02-06 09:29:48 +0900 (水, 06  2月 2013) | 4 lines
- Add handling of private dart:_ libraries.
- Make dart:collection-dev a private library by renaming it to dart:_collection-dev.
- Predefine the URIs of dart: libraries as VM symbols.
Review URL: https://codereview.chromium.org//12220027
_をつけるとprivate libraryか。
parserの修正。
library名をvm/symbols.hに定義。

r18158 | hausner@google.com | 2013-02-06 07:43:57 +0900 (水, 06  2月 2013) | 4 lines
Save 0.00001% memory
Release the functions and fields array after patching classes.
Review URL: https://codereview.chromium.org//12207028
empty_array()を設定するようにしたらしい。canonical_tableを参照するだけか。

r18157 | asiva@google.com | 2013-02-06 05:42:33 +0900 (水, 06  2月 2013) | 2 lines
Rename the accessor functions saved_context_var and set_saved_context_var
to saved_entry_context_var and set_saved_entry_context_var
so that it matches the local variable name used.
This avoids confusing this with the saved_context_var variable which is used by try statements.
Review URL: https://codereview.chromium.org//12207023
renameとリファクタリング。

r18155 | hausner@google.com | 2013-02-06 05:19:32 +0900 (水, 06  2月 2013) | 4 lines
Remember owner class of patch code
This is a step towards using PatchClass for mixins
Review URL: https://codereview.chromium.org//12213020
PatchClassの引数が、ScriptからClassへ変更。
setScriptがset_source_classになっているなぁ。

r18075 | srdjan@google.com | 2013-02-05 05:29:58 +0900 (火, 05  2月 2013) | 2 lines
Use SAR for divident by a power-of two constant divisor.
Review URL: https://codereview.chromium.org//12091100
SAR? アセンブラのSARだった。。
PowerOfTwoConstantか判定し、
BinarySmiOpInstrにおいて、TRUNCDIVの場合にsarを吐く。

r18055 | kmillikin@google.com | 2013-02-05 02:04:02 +0900 (火, 05  2月 2013) | 9 lines
Add a use list iterator that allows mutation of current.
Add Value::Iterator that supports removing the current use from the
underlying use list, including deleting it or moving it to another use list.
Use it in range analysis and representation selection.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//12178019
Valueクラスの中に、UseのIteratorを作成。
InsertConversionの引数を減らした。defをuse->definition()で代替。

r18048 | kmillikin@google.com | 2013-02-04 23:01:35 +0900 (月, 04  2月 2013) | 7 lines
Move recording of definition uses from the value to the definition.
It was weird that this method mutated an object that wasn't even mentioned in the call.
Also, change Definition::ReplaceUsesWith so that
it appends all at once instead of consing each individual use.
Review URL: https://codereview.chromium.org//12091091
ReplaceUsesWith()で、useのlinked-listを更新する。

r18033 | regis@google.com | 2013-02-04 14:51:02 +0900 (月, 04  2月 2013) | 4 lines
Resubmit reverted r17962, but, for now, only report error about unfinalized
types if flag --error_on_malformed_type is specified.
Fix one more case of unfinalized signature type.
Review URL: https://codereview.chromium.org//12183014
17962を参照。

r18018 | regis@google.com | 2013-02-02 09:18:37 +0900 (土, 02  2月 2013) | 2 lines
Resubmitting r18013.
r18013 | regis@google.com | 2013-02-02 08:43:33 +0900 (土, 02  2月 2013) | 3 lines
Cleanup api for isolate state checking.
This should avoid the breakage on Windows observed by reverted r17962.
Review URL: https://codereview.chromium.org//12082126
CheckIsolateState()をリファクタリング

r17998 | asiva@google.com | 2013-02-02 05:02:30 +0900 (土, 02  2月 2013) | 2 lines
Restore factory names in the intrinsifier list to the way they were
(is used in a special way during lookup of private corelib classes).
Review URL: https://codereview.chromium.org//12095110
corelibのlookupのfactory名を削除。マクロで展開するようにした。

r17995 | asiva@google.com | 2013-02-02 04:16:34 +0900 (土, 02  2月 2013) | 4 lines
Instead of setting up the can intrinsify state lazily setup eagerly
in Object::Init() so that the snapshot will carry it and when
running from a snapshot Intrinsifier::CanIntrinsify can be just a bit check.
Review URL: https://codereview.chromium.org//12096105
Intrinsifier::InitializeState()を追加。boostrap後に処理する。
intrinsicの名称のマッチング処理が変更。 マクロになった。。
マクロもグループごとに整理して、MATH SCALARLIST CORE

r17992 | srdjan@google.com | 2013-02-02 03:44:40 +0900 (土, 02  2月 2013) | 2 lines
Fixed simarm, simmips builds.
Review URL: https://codereview.chromium.org//12161004
下記のarm mips版空実装追加。

r17991 | srdjan@google.com | 2013-02-02 03:29:38 +0900 (土, 02  2月 2013) | 2 lines
Intrinsify external uint8 clamped array setter and getter.
Review URL: https://codereview.chromium.org//12114041
ExternalUint8ClampedArray getIndexed setIndexed 追加。

r17984 | fschneider@google.com | 2013-02-02 00:10:24 +0900 (土, 02  2月 2013) | 8 lines
Separate the array/string .length load from the bounds check.
This is done in preparation to inline more array and array view operations.
Since the length is immutable for fixed length arrays,
it allows hoisting the load out of loops.
Review URL: https://codereview.chromium.org//12088108
lengthフィールドのloadFieldを、loopの外に移動できるようにした。
immutalbe arrayの場合、固定なので。
loopの外に移動した上で、array bound checkの引数で参照する。

r17977 | antonm@google.com | 2013-02-01 21:45:42 +0900 (金, 01  2月 2013) | 5 lines
Revert changes 17962-3 which break Dartium Debug build.
TBR=ricow@google.com
Review URL: https://codereview.chromium.org//12079117
3だけ？

r17962 | regis@google.com | 2013-02-01 11:40:16 +0900 (金, 01  2月 2013) | 9 lines
Fix class patching involving type parameters: type parameters of patched classes were not finalized.
Simplify and fix function type alias finalization (remove dummy alias owner).
Make sure no unfinalized types or unresolved classes are written to a snapshot.
Verify that all pending classes are finalized before writing a snapshot.
Make snapshot_test more resilient to finalization errors.
Add missing import to snapshot_test.dart.
Fix typo in growable_array.dart.
Review URL: https://codereview.chromium.org//12123002
型パラメータを持つ関数のpatchの修正か。
runtime/libにpatchがたくさん埋まっているけど、patchは公開された機能ではないよね。。
parserのfunction signitureを作成する処理を変更。
NewSignatureFunction
PatchSignatureFunction

r17958 | asiva@google.com | 2013-02-01 08:56:48 +0900 (金, 01  2月 2013) | 11 lines
First set of changes towards cleaning up the bytearray access APIs
- Added unimplemented versions of Dart_ByteArrayAcquireData and Dart_ByteArrayReleaseData
- Added infrastructure to prevent callbacks into an API function that
  allocates a new object on the Dart heap or invokes dart code.
- Removed the old Dart_ByteArrayGet* access functions as it was felt that
  they have become redundant once we provide direct access to the internal data pointers.
- Removed DARTSCOPE_NOCHECKS as it seems to be redundant after the change
  to not create explicit stack zones on each Dart API call.
Review URL: https://codereview.chromium.org//12036098
dart_api_implを修正。
DARTSCOPE_NOCHECKSを全部削除かな。性能よりも安全重視？
CHECK_CALLBACK_STATEやDART_SCOPEを全体に挿入。
ByteArrayXXXを削除。
代わりにScalarListAcquireData(array, type, data, len)
typeは、Dart_Scalar_Typeのenumに定義。


r17939 | asiva@google.com | 2013-02-01 04:16:47 +0900 (金, 01  2月 2013) | 2 lines
Fix for issue-7157 - set the stack marker in the top API local scope just before entering dart code.
It used to be set in Dart_EnterScope and
this was causing problems as the marker could potentially end up being lower than the stack pointer
at the time of entering Dart code resulting
in an destruction of the top scope during 'state->UnwindScopes(...)'
Review URL: https://codereview.chromium.org//12118002
isolate->top_exit_frame_info()

r17937 | asiva@google.com | 2013-02-01 03:53:21 +0900 (金, 01  2月 2013) | 3 lines
- Change the layout of external typed array objects to avoid the extra indirection
  when accessing elements in the array.
- Change the Dart API which create these external arrays to account for this change
Review URL: https://codereview.chromium.org//12093071
修正量が多い。
NewExternalByteArray系のメソッドにおいて、callbackをWeakPersistentHandleFinalizerに登録するように変更。
RawExternalの内部に、peerの参照を移動した。
finalizerにも登録しており、callbackをdelete時にcallするのかな。

external系のarrayは、data_をheap外に保持していたが、 heap外に確保するのは変更されていないはず。
raw_ptr()->external_data_->data()[index];
という参照関係から、
return raw_ptr()->data_[index];
に変更された。
to avoid the extra indirectionは、上記を指す。

r17924 | kmillikin@google.com | 2013-02-01 01:10:15 +0900 (金, 01  2月 2013) | 7 lines
Make use lists into doubly-linked lists.
At the cost of a word per use, we gain constant time removal from use lists.
Review URL: https://codereview.chromium.org//12079096
useの連鎖をdouble-linked listsにした。previuis_useを追加。
prevが必要なところでprev変数で代替していたけど、valueクラスの内部に用意した。

r17879 | srdjan@google.com | 2013-01-31 07:57:20 +0900 (木, 31  1月 2013) | 2 lines
Try to have constant on the right hand side for commutative Smi instructions.
Review URL: https://codereview.chromium.org//12096067
leftに定数が来ているときに、right側にConstantを設定するためにswapする。
canonicalizeして両方のケースに対応。

r17859 | srdjan@google.com | 2013-01-31 02:40:28 +0900 (木, 31  1月 2013) | 2 lines
Enable correct optimized double modulo operation. (TODO: enable remainder optimization).
Review URL: https://codereview.chromium.org//12082063
r17806の件。DartModulo()を追加。DartModulo()は、lib/double.ccから移植。
libc_fmodの代わりに、DartModuloを呼び出すように修正。

r17843 | fschneider@google.com | 2013-01-30 23:06:26 +0900 (水, 30  1月 2013) | 11 lines
Fix a crash bug when creating a stack trace from an optimized frame.
In some cases of NoSuchMethodError creating a stack trace with optimized
code did result in an assertion failure.
We don't have deoptimization info at all potentially throwing calls
in optimized code: Namely in the prologue that copies parameters.
BUG=dart:8200
TEST=tests run with --optimization-threshold=5
Review URL: https://codereview.chromium.org//12079071
InlinedFunctionIteratorを作って、index -1を内部に隠蔽。

r17840 | vegorov@google.com | 2013-01-30 22:11:43 +0900 (水, 30  1月 2013) | 6 lines
When comparing symbols during the range analysis check
that both of them are not affected by side-effect.
R=fschneider@google.com
BUG=dart:8197
Review URL: https://codereview.chromium.org//12079074
AreEqualDefinitions()に、b->AffectedBySideEffect()を追加した。

r17810 | srdjan@google.com | 2013-01-30 06:16:44 +0900 (水, 30  1月 2013) | 3 lines
On Ia32 optimistically assume that results from int32 and uint32 array loads fit into Smi.
Only if the instruction caused deoptimization will we assume mixed Smi/Mint operations.
In absence of precise tracking of deoptimization history (location/reason) conservatively assume
that a method that was deoptimized once may have been deoptimzied because of uint32/int32 loads.
Significant improvement for MeshDecompression on ia32.
Review URL: https://codereview.chromium.org//12086045
LoadIndexedInstrをDeopt可能にし、ia32においてU/Int32ArrayCidの最適化を追加。

r17806 | srdjan@google.com | 2013-01-30 05:36:59 +0900 (水, 30  1月 2013) | 2 lines
Fix double modulo bug by temporary disabling calling to C (fix and reenabling it will follow later).
Added test.
Review URL: https://codereview.chromium.org//12077052
double modはバグっているらしいので、一時的にdisable

r17804 | fschneider@google.com | 2013-01-30 05:12:00 +0900 (水, 30  1月 2013) | 8 lines
Do not add smis to the store buffer when cloning objects.
StoreBufferObjectPointerVisitor did not check for smis.
It is used from Object::Clone.
Also assert that IsNewObject and IsOldObject is only called on heap objects.
Review URL: https://codereview.chromium.org//12089049
rename
IsNewObjectの場合、必ずHeapobjectのはず。メソッドの名称が原因かな。。

r17775 | regis@google.com | 2013-01-30 01:46:10 +0900 (水, 30  1月 2013) | 3 lines
Initial revision of ARM assembler.
Object references and calls, as well as their fixups, are still unimplemented.
Review URL: https://codereview.chromium.org//12090034
todo

r17773 | srdjan@google.com | 2013-01-30 01:30:56 +0900 (水, 30  1月 2013) | 2 lines
Fix simarm/simmips build.
Review URL: https://codereview.chromium.org//12093046
mispやarmにdeopt_idを引数に追加。

r17770 | fschneider@google.com | 2013-01-30 01:02:15 +0900 (水, 30  1月 2013) | 5 lines
Widen the type of constant values handled by constant propagation.
The constant object has to be a smi or an old space heap object: Right now,
we can only embed old space objects into code.
Review URL: https://codereview.chromium.org//12096039
条件式を拡張している。

r17755 | fschneider@google.com | 2013-01-29 21:38:27 +0900 (火, 29  1月 2013) | 10 lines
Fix source position for stack traces with optimized top function.
Fix decoding of the deoptimization info when constructing a stack trace.
Fix stack trace for checked mode exceptions from optimized code.
BUG=dart:8058
TEST=runtime/tests/vm/dart/optimized_stacktrace_test.dart,
tests/language/stack_overflow_stacktrace_test.dart
Review URL: https://codereview.chromium.org//12049039
引数にいろいろ追加して、deopt時の情報を強化したいらしい。

r17750 | ager@google.com | 2013-01-29 19:15:50 +0900 (火, 29  1月 2013) | 12 lines
Change a couple of API functions to return unhandled exception errors
instead of fatal errors on immutable array (by calling into dart code for immutable arrays).
Add regression tests.
We should look at all the API errors returned from the API and
figure out if they should actually be fatal errors or just exceptions.
R=iposva@google.com,sgjesse@google.com
Review URL: https://codereview.chromium.org//12038066
change dart api
and 条件を書き換えた。のかな。

r17741 | iposva@google.com | 2013-01-29 10:41:57 +0900 (火, 29  1月 2013) | 3 lines
Fix issue 8161:
- Ensure that old generation collections invoke the API callbacks.
Review URL: https://codereview.chromium.org//12091036
gcの引数をkInvokeCallbackに変更。

r17739 | asiva@google.com | 2013-01-29 09:53:22 +0900 (火, 29  1月 2013) | 2 lines
Make Type, TypeParameter, TypeArguments and InstantiatedTypeArguments final heap objects.
Review URL: https://codereview.chromium.org//12086031
object.hの修正、上記がFINAL_HEAP_OBJECTに変更。
何が違うのかというと、
HEAP_OBJは、=と^=の際に、initializeHandle()
FINAL_HEAPの場合、raw_にassignする。

initializeHandle()は、
raw_ptr != nullだったら、SetRaw()
==nullだったら、set_vtable(fake_object.vtable())

cpp_vtable vtable() const { return bit_copy<cpp_vtable>(*this); }
void set_vtable(cpp_vtable value) { *vtable_address() = value; }


r17730 | srdjan@google.com | 2013-01-29 05:46:16 +0900 (火, 29  1月 2013) | 2 lines
Added result cids to some natives (byte array _new).
Review URL: https://codereview.chromium.org//12090010
visitStaticCall()において、GetResultCidOfNative()を呼び出し、
scalarlistのnewの場合、各々の型を返す。それ以外はdynamicCid

r17703 | fschneider@google.com | 2013-01-28 21:02:07 +0900 (月, 28  1月 2013) | 5 lines
Address comments about safely casting handles.
The debug version exactly follows the original code.
Release mode avoid creating a temporary handle.
Review URL: https://codereview.chromium.org//11500004
type_classとunresolved_classを、DEBUG時にはClass::Handle()経由で返す。

r17679 | srdjan@google.com | 2013-01-26 09:41:55 +0900 (土, 26  1月 2013) | 2 lines
Cleanups in intrinsified typed array methods, added Uint16_setIndexed.
Review URL: https://codereview.chromium.org//12050006
主にコメント追加とrename
Uint16Array_setIndexed()を新規追加。[]=

r17677 | srdjan@google.com | 2013-01-26 09:33:20 +0900 (土, 26  1月 2013) | 2 lines
Fix simarm and simmips builds.
Review URL: https://codereview.chromium.org//12094002
下記のintrinsicsを、simarmとsimmipsに追加。

r17645 | srdjan@google.com | 2013-01-26 03:04:34 +0900 (土, 26  1月 2013) | 2 lines
Intrinsify typed array _new natives, thus speeding up allocation of typed arrays.
Review URL: https://codereview.chromium.org//12033090
TYPED_ARRAY_ALLOCATIONマクロを新規追加。
int or float 8 16 32 64
intrinsifierにそれぞれ追加し、Allocationを上記マクロで全部代替。
マクロは、type_nameとscale_factorを引数にとり、
type_nameを使ってClassIdTagや、StoreIntoObjectNoBarrierのindexを指定したり、sizeofに使用される。
type_nameのsizeを、scale_factorで調整する。
ArrayのSizeは、実行時にStackでもらうため、Emit時にはあまり関係ない。

r17626 | regis@google.com | 2013-01-25 10:26:00 +0900 (金, 25  1月 2013) | 2 lines
Fix Windows build by removing bad include.
Review URL: https://codereview.chromium.org//12039081
include pthread.h

r17623 | regis@google.com | 2013-01-25 10:16:35 +0900 (金, 25  1月 2013) | 2 lines
Initial revision of ARM simulator and (empty) MIPS simulator.
Review URL: https://codereview.chromium.org//12041056
vm/simulator_arm.h|ccを追加。2kくらい。
vm/simulator_mips.h|ccも空を追加。
まずはarm Simulatorを作成したと。
simulatorとsiulatorDebuggerが定義されている。
registerやinstrが定義されており、
set/get_pc set/get_register call supervisorcall decodeが定義されている。
cpu state, n z c vか。
debugggerは、gdbみたいなcmdをひたすらwhileで回す制御が入っている。。

r17618 | asiva@google.com | 2013-01-25 08:47:02 +0900 (金, 25  1月 2013) | 2 lines
Adapt operator= and operator^= of Smi to be similar to other internal VM classes.
Review URL: https://codereview.chromium.org//12035087
Smiの場合、BASE_OBJECT_IMPLEMENTATION

r17592 | regis@google.com | 2013-01-25 04:14:55 +0900 (金, 25  1月 2013) | 2 lines
Fix argument test for the captured parameter of an outer function (issue 8007).
Review URL: https://codereview.chromium.org//12036088
context-level < 1の場合のみ

r17579 | regis@google.com | 2013-01-25 01:42:33 +0900 (金, 25  1月 2013) | 2 lines
Cleanup for arm and mips.
Review URL: https://codereview.chromium.org//12016026
vm/elfgen.hに、kEM_MIPSを追加し、EM_MIPS向けにifdef切り直した。

r17569 | kmillikin@google.com | 2013-01-24 23:13:02 +0900 (木, 24  1月 2013) | 9 lines
Move code around in preparation for better inlining.
To inlining calls in a test context, the code to plug the inlined
function graph into the caller graph should be dispatched on the type of the inlining context.
This change moves code around without otherwise changing it.
Review URL: https://codereview.chromium.org//11953076
PrepareGraphs() bbを走査して、environmentを解決する。
ReplaceCall()で、calleeのentryとexitをがちゃんこする。元はflow_graphのinline_callかな。
その際に、phiやUsesの解決も行う。
ReplaceAsPredecessorWith() 元はflow_graphのReplacePredecessor()かな。

r17549 | floitsch@google.com | 2013-01-24 21:16:37 +0900 (木, 24  1月 2013) | 5 lines
Rename Date to DateTime.
BUG=http://dartbug.com/1424
Review URL: https://codereview.chromium.org//11770004
libの名称変更。

r17514 | srdjan@google.com | 2013-01-24 09:06:16 +0900 (木, 24  1月 2013) | 2 lines
Use builtin fmod for double modulo operation.
Review URL: https://codereview.chromium.org//12049056
DoubleModをintrinsicとMethodRecognizerに追加。
libc_fmodを呼び出す。

r17510 | asiva@google.com | 2013-01-24 07:50:25 +0900 (木, 24  1月 2013) | 2 lines
Use Double::NewCanonical instead of creating a double object and then canonicalizing it.
Review URL: https://codereview.chromium.org//12038051
parserにおいて、NewをNewCannicalに変更。

r17504 | asiva@google.com | 2013-01-24 07:16:17 +0900 (木, 24  1月 2013) | 2 lines
Fix ARM and MIPs builds (there is no |= operator anymore).
Review URL: https://codereview.chromium.org//12036062
|=から^=への置換。

r17497 | srdjan@google.com | 2013-01-24 06:25:39 +0900 (木, 24  1月 2013) | 2 lines
Rename xxxArray_newTransferable natives to xxxList_newTransferable.
Review URL: https://codereview.chromium.org//12039047
bootstrap_nativesの名称変更

r17491 | asiva@google.com | 2013-01-24 05:01:31 +0900 (木, 24  1月 2013) | 6 lines
Added macros OBJECT_IMPLEMENTATION and FINAL_OBJECT_IMPLEMENTATION
which have different implementations of 'operator=' and 'operator^='.
In the case of FINAL_OBJECT_IMPLEMENTATION we do not do the vtable setting
in these methods (Note the |= operator functionality is now subsumed into
the new implementation of "operator^=")
Review URL: https://codereview.chromium.org//12052033
マクロの機能を詳細化。色々改良。
BASE_OBJECT_IMPLEMENTATION
OBJECT_IMPLEMENTATION
FINAL_OBJECT_IMPLEMENTATION
HEAP_OBJECT_IMPLEMENTATION
FINAL_HEAP_OBJECT_IMPLEMENTATION
|=operatorを削除し、大部分^=に戻している。
void operator^=(RawObject* value) {                                          \
  initializeHandle(this, value);                                             \
  ASSERT(IsNull() || Is##object());                                          \
}
libやbinも全部戻っている。


r17489 | srdjan@google.com | 2013-01-24 04:52:26 +0900 (木, 24  1月 2013) | 2 lines
Hide private corelib's method from stack trace in exceptions.
Review URL: https://codereview.chromium.org//12025038
objectのタグに、isVisitbleを追加。
オプション verbose-stacktrace=false
stacktraceに出力しない、internal objectのリストを定義している。
Object List AssertionErrorImplem... などなど。INVISIBLE_LIST


r17478 | srdjan@google.com | 2013-01-24 02:43:58 +0900 (木, 24  1月 2013) | 2 lines
Fix native lookup. Fix external byte arrays.
Review URL: https://codereview.chromium.org//12033036
countの比較が先のように思うが。
SCALED_UNALIGNED_GETTER

r17438 | asiva@google.com | 2013-01-23 15:13:18 +0900 (水, 23  1月 2013) | 4 lines
Move verification of builtin_vtables into Dart::InitializeIsolate.
This ensures that we don't ASSERT on every handle assignment
(not an issue with release builds but should help the debug builds some).
Review URL: https://codereview.chromium.org//11867015
EqualsIgnoringPrivateKey()をtemplateにして適用範囲を拡大。

r17437 | asiva@google.com | 2013-01-23 14:57:29 +0900 (水, 23  1月 2013) | 3 lines
Allow externalization of canonical strings also.
Only restrict canonical strings in the VM isolate heap.
Review URL: https://codereview.chromium.org//11969029

r17411 | regis@google.com | 2013-01-23 02:07:35 +0900 (水, 23  1月 2013) | 2 lines
Fix simmips build.
Review URL: https://codereview.chromium.org//11953027
mips向けのUNIMPLを追加。

r17410 | hausner@google.com | 2013-01-23 01:48:00 +0900 (水, 23  1月 2013) | 5 lines
Stop supporting map literals with 1 type argument
To be checked in next week Tue (Jan 22)
Review URL: https://codereview.chromium.org//12021022
parserの修正。lebacy map literalを廃止。

r17408 | srdjan@google.com | 2013-01-23 01:15:54 +0900 (水, 23  1月 2013) | 5 lines
Removed loop depth info tracking at graph build time.
60% compilation speed improvement on pathological case. Improvements for dart2js
The loop depth signal was made unnecessary by the call frequency signal.
Review URL: https://codereview.chromium.org//11975061
loop_depthの除去。inline展開をloop_depthで抑止していたのが開放された。

r17393 | vegorov@google.com | 2013-01-22 21:18:31 +0900 (火, 22  1月 2013) | 21 lines
Reland r17365.
Introduce InvokeMathCFunction that can be used to directly invoke mathematical
function provided by runtime.
Use it to unconditionally inline _Double.pow.
Use it to inline floor, ceil, round, truncate, round when SSE4.1 is not available.
Perform representation selection phase after constant propagation to minimize boxing.
Add support for enter instruction in the x64 disassembler.
Add test for optimized pow and fix compilation on windows.
R=fschneider@google.com
BUG=dart:8002
Review URL: https://codereview.chromium.org//12038013
IRにInvokeMathCFunctionInstrを追加
CompileType()はDoubleらしい。
kindは、Truncate Round Floor Ceil Pow

optimizerにおいて、RecognizerのInstanceCallをInvokeMathCFunctionInstrに置換する。
TargetをCallRuntimeで呼び出す命令をEmitする。


r17383 | kmillikin@google.com | 2013-01-22 19:08:57 +0900 (火, 22  1月 2013) | 5 lines
Allow cascades in initializer lists.
Review URL: https://codereview.chromium.org//12036005
parserを修正。kCASCADE時にinit

r17379 | podivilov@google.com | 2013-01-22 18:32:38 +0900 (火, 22  1月 2013) | 5 lines
Fix use after free bug in PprofCodeObserver.
TBR=asiva@google.com
Review URL: https://codereview.chromium.org//12026036
delete debug_region;の位置を変更。
関数ポインタで再帰していたの？

r17378 | podivilov@google.com | 2013-01-22 18:30:41 +0900 (火, 22  1月 2013) | 7 lines
Replace "enter" instruction with "push(ebp); mov(ebp, esp);" sequence.
"enter" instruction is rare and is not supported by valgrind.
R=srdjan@google.com,vegorov@google.com
Review URL: https://codereview.chromium.org//12028002
enter(Immediate(0)) -> EnterFrame(0)

r17362 | fschneider@google.com | 2013-01-22 01:19:42 +0900 (火, 22  1月 2013) | 2 lines
Optimize loads and stores to Int32Array and Uint32Array.
Review URL: https://codereview.chromium.org//12041005
Int32ArrayとUint32Arrayの最適化を追加
LoadIndexedの前後やStoreIndexedの前後で、Smiとして振る舞う。

LoadIndexedとStoreIndexedの実装を、ia32/x64/arm/mipsのそれぞれに振り分けた。
ARMやMipsのことを考えると、Mintのサポートを毎回オプションで確認する必要があるのか。

r17360 | fschneider@google.com | 2013-01-22 00:00:43 +0900 (火, 22  1月 2013) | 5 lines
Improve smi code for truncating division(~/) by using two fewer temp registers.
One temp was not used at all, the other can be replaced by a using a writable input register.
Review URL: https://codereview.chromium.org//12043014
TRUNCDIVのMakeLocationSummary()を修正し、inputが3->1へ。
Emitterも変更し、冗長だったのを修正し、レジスタの使用数が1に。

r17333 | podivilov@google.com | 2013-01-19 23:51:35 +0900 (土, 19  1月 2013) | 7 lines
Use free() to free memory allocated with realloc().
This is to make valgrind happy as it traces new->delete alloc->free correspondence.
R=meh@google.com,asiva@google.com
Review URL: https://codereview.chromium.org//11958037
delete[] -> free

r17332 | hausner@google.com | 2013-01-19 09:03:30 +0900 (土, 19  1月 2013) | 6 lines
Add function for one-time stop at function entry
Adds function Dart_OneTimeBreakAtEntry()
Used by debugger clients to stop at the beginning of the program
without setting a user-visible breakpoint.
Review URL: https://codereview.chromium.org//11926026
dart_apiに、OneTimeBreakAtEntryですか。

r17330 | regis@google.com | 2013-01-19 08:46:48 +0900 (土, 19  1月 2013) | 2 lines
Add test skeletons for arm and mips.
Review URL: https://codereview.chromium.org//11929037
testコードのみ追加。

r17321 | regis@google.com | 2013-01-19 06:46:58 +0900 (土, 19  1月 2013) | 2 lines
Mofify vm code base so that it can be built for --arch=simmips.
Review URL: https://codereview.chromium.org//12018023
r17320 | regis@google.com | 2013-01-19 06:44:58 +0900 (土, 19  1月 2013) | 2 lines
Add mips skeleton sources.
Review URL: https://codereview.chromium.org//11926022
armと同様に、mipsも完了。

r17310 | srdjan@google.com | 2013-01-19 05:43:33 +0900 (土, 19  1月 2013) | 2 lines
Some more ^= to |= 
Review URL: https://codereview.chromium.org//12017020
r17309 | srdjan@google.com | 2013-01-19 04:53:17 +0900 (土, 19  1月 2013) | 2 lines
Transition ^= to |= 
Review URL: https://codereview.chromium.org//11867022
r17308 | srdjan@google.com | 2013-01-19 04:43:19 +0900 (土, 19  1月 2013) | 2 lines
More ^=  to |= 
Review URL: https://codereview.chromium.org//11941021
r17302 | asiva@google.com | 2013-01-19 03:47:03 +0900 (土, 19  1月 2013) | 2 lines
Use new |= operator instead of ^= where it is possible to do so.
Review URL: https://codereview.chromium.org//11941005
r17301 | srdjan@google.com | 2013-01-19 03:37:06 +0900 (土, 19  1月 2013) | 2 lines
Use new |= operator in object.cc .
Review URL: https://codereview.chromium.org//11938023
testコードも全体的に置換。
全体的に置換。vm内は完了。
runtime/libのコードも置換。

r17288 | fschneider@google.com | 2013-01-19 01:29:02 +0900 (土, 19  1月 2013) | 6 lines
Fix bug in optimization in the presence of externalized strings.
The class-id of string objects can be changed via the Dart API. The optimizer
has to disable hoisting class-id checks across calls.
For now, loop-invariant code motion is disabled for checks of string class-ids.
Review URL: https://codereview.chromium.org//11867020
ic_data.HasReceiverClassId()を追加し、OneByteStringとTwoByteStringのside effectチェックを強化。

r17278 | vegorov@google.com | 2013-01-18 23:28:25 +0900 (金, 18  1月 2013) | 6 lines
Optimize double.floor and double.ceil down to roundsd when SSE4.1 is available.
R=fschneider@google.com
BUG=dart:7971
Review URL: https://codereview.chromium.org//11929021
DoubleFloorとDoubleCeilをCPUFeaturesを参照するように修正。

r17276 | floitsch@google.com | 2013-01-18 23:08:41 +0900 (金, 18  1月 2013) | 3 lines
Move many iterable classes to collection_dev.
Review URL: https://codereview.chromium.org//11931042
initの順番変更。

r17274 | fschneider@google.com | 2013-01-18 23:03:40 +0900 (金, 18  1月 2013) | 2 lines
Remove StringCharCodeAtInstr and handle it as part of LoadIndexed.
Review URL: https://codereview.chromium.org//11970038
IRからStringFromCharCode()を削除。
StringFromCharCodeがあるので。。

r17269 | floitsch@google.com | 2013-01-18 22:07:27 +0900 (金, 18  1月 2013) | 6 lines
Add dart:collection_dev library.
Committed: https://code.google.com/p/dart/source/detail?r=17263
Reverted: https://code.google.com/p/dart/source/detail?r=17265
Review URL: https://codereview.chromium.org//11959012
dart:collection_dev libraryですって？

r17261 | vegorov@google.com | 2013-01-18 20:54:45 +0900 (金, 18  1月 2013) | 7 lines
When requested to extract a method M from class C inject a method extractor
(consisting of a single AST node CreateClosure) as a getter get:M into C.
This allows to cache and optimize method extraction requests as normal method invocations
and at hot method extraction sites that significantly decreases overhead of method extraction
which previously required two trips into runtime system and was not cached at all.
Review URL: https://codereview.chromium.org//11642003
MethodExtractorってのが追加。 getter/setterと同じレベルで存在する。
代わりにResolveImplicitClosure()を削除と。
visitInstanceCallにおいては、one_targetかつmethod_extractorである場合、
polymorphicInstanceCallに変換。
parserにも手が入っているので、言語仕様を拡張したのか。
V(Closurizer, "Closurizer")
V(MethodExtractor, "[MethodExtractor]")

r17246 | regis@google.com | 2013-01-18 09:34:20 +0900 (金, 18  1月 2013) | 2 lines
Fix vm code base so that it can be built for --arch=simarm (no snapshot yet).
Review URL: https://codereview.chromium.org//11956004
とんでも修正。修正が多すぎる。。
arm対応いままで手を抜いてきたこと全体を見直し。method名を抽象的なものに置き替えたり、
copyrightの年月日修正。
抽象的になったのは、
xmm registerという名前とか、truncの有無、immidiateの処理
deoptimizeはia32/x64のみ.
armの実装は全部unimplだけど、code baseは全部ia32/x64に綺麗に揃えた。
flow_graph_compilerがia32/x64に処理が混在していたのを、綺麗にarchごとに整理した。
assemblerの記述が必要なところと、flow_graph_compilerの機種依存の処理以外は実装完了。

r17245 | hausner@google.com | 2013-01-18 09:24:19 +0900 (金, 18  1月 2013) | 6 lines
Remove support for old style function literals
Fix issue 6709.
strict_function_literalsオプションを廃止し、old stryleのサポートを停止。
parserから処理を削除。
全部オプションで切り分けられているので削除も簡単のようで。

r17244 | asiva@google.com | 2013-01-18 09:24:06 +0900 (金, 18  1月 2013) | 12 lines
Add a new operator |= which does a simple assignment of the raw pointer into
a handle without any vtable settings.
In debug mode there are the usual checks to ensure that the vtable
in the handle matches the expected vtable value based on the dynamic type of the object.

It is useful in loopy code as follows:
  const Array& funcs = class.functions();
  Function func = Function::Handle();
  for (int i = 0; i < 100000000; i++) {
    func |= funcs.At(i);
  }
Review URL: https://codereview.chromium.org//11979003
VM内のC++ ObjectのRawPointerを効率よく扱うために、operator|=をobjectにマクロで追加した。
|=の裏ではdebug modeにCheckHandle()が呼ばれる。handle_vtable_のASSERTを行う。
SmiTagの場合、Smi::handle_vtable_かどうかチェック。
Heapの場合、isolate->heap()に含まれるかチェック。
class_table()のhandle_vtable_のチェック。

r17243 | hausner@google.com | 2013-01-18 09:01:14 +0900 (金, 18  1月 2013) | 4 lines
Remove support for legacy abstract declarations
Make keyword 'abstract' illegal in front of class member declarations.
Review URL: https://codereview.chromium.org//12016005
legacy abstractのサポート終了。parserから削除。

r17235 | tball@google.com | 2013-01-18 06:06:59 +0900 (金, 18  1月 2013) | 2 lines
Added heap capacity and used space status methods, for use by status tools.
Review URL: https://codereview.chromium.org//11973035
heapにUsed Capacityのprintを追加。-verboseで表示するはず。

r17232 | srdjan@google.com | 2013-01-18 04:27:00 +0900 (金, 18  1月 2013) | 2 lines
Improve function lookup speed by working with raw objects only.
Review URL: https://codereview.chromium.org//11970043
function lookupをrawに展開してaddress比較に変更。NoGCScopeにした。

r17208 | fschneider@google.com | 2013-01-17 23:08:04 +0900 (木, 17  1月 2013) | 10 lines
Fix a bug with store-to-load forwarding for typed arrays.
Stores to typed arrays implicitly convert the value stored.
This CL disables store-to-load forwarding for these array stores.
Normal arrays and float64 arrays can be still optimized as before (no
conversion occurs on store)
TEST=tests/language/int_array_load_elimination_test.dart
Review URL: https://codereview.chromium.org//11962036
StoreIndexedの場合、Dartのdefinition()が存在するため、
genの集合にdefを追加し、冗長なloadとforward storeの畳み込みを促進する。
今回の修正では、ArrayCid Float64ArrayCidの場合に限定し、convertが挿入されないようにする。
ArrayCidとFloat64の場合は、converが挿入されないため。

r17205 | podivilov@google.com | 2013-01-17 22:43:44 +0900 (木, 17  1月 2013) | 8 lines
Fix use of uninitialized memory in debug assert.
deopt_id() -> ASSERT(CanDeoptimize()) -> operands_class_id_ which is not initialized at this point.
R=fschneider@google.com,vegorov@google.com
Review URL: https://codereview.chromium.org//11961041
GetICDataForDeoptId()の初期化タイミングの調整。

r17190 | fschneider@google.com | 2013-01-17 19:43:46 +0900 (木, 17  1月 2013) | 8 lines
Optimized loads/stores for scalar list: Uint8Clamped, Int8, Int16, Uint16.
This CL adds optimized stores for Uint8ClampedList, and
loads+stores for Int8List, Int16List and Uint16List.
TEST=tests/standalone/byte_array_test.dart, tests/standalone/int_array_test.dart
Review URL: https://codereview.chromium.org//11967012
ExternalElementAddressForIndex()
ExternalElementAddressForRegIndex()
基本的には、switch caseを拡張したのみ。
javaはpremitive型を用意したけど、Dartはpremitive型のListであるscalarlistで代替していると。

r17179 | hausner@google.com | 2013-01-17 10:10:42 +0900 (木, 17  1月 2013) | 5 lines
Simplify exception handler table Sort entries and drop the try_index field.
This simplifies lookup of exception handlers when walking the traces on exceptions.
Review URL: https://codereview.chromium.org//11970024
ExceptionHandlerlistがシンプルになった
fieldを整理してリファクタリング。

r17178 | srdjan@google.com | 2013-01-17 09:42:03 +0900 (木, 17  1月 2013) | 2 lines
Lookup functions by name that contains the private key,
except for dart_api which allows ignoring the private key.
Review URL: https://codereview.chromium.org//11968022
core libのlookupにおいて、privateなsymbolを探すことができるメソッドと、探せないメソッドに分割。
dart_apiは、publicなものだけ探せる。
LookupDynamicFunctionAllowPrivate
LookupStaticFunctionAllowPrivate
LoopupFunctionAllowPrivate

r17167 | hausner@google.com | 2013-01-17 07:16:09 +0900 (木, 17  1月 2013) | 4 lines
Check whether exceptions are caught
The debugger can now determine whether an exemption will be caught or not.
Review URL: https://codereview.chromium.org//11946020
OuterTryIndex()をObjectに追加。outerで外側へ順番にたどれるようにchainする。
debugger stacktraceにおいて、GetHandlerFrame()によってcurrent frameのTryIndexが取得できなかった場合に、
OuterTryIndexを遡る。

r17165 | asiva@google.com | 2013-01-17 06:45:49 +0900 (木, 17  1月 2013) | 5 lines
Fix for 7941
- mark unused space in an object whose type has been transformed as
  Int8Array instead of Array. This ensure that GC does not traverse
  the contents of the unused space.
Review URL: https://codereview.chromium.org//11968020
MarkUnusedSpaceTraversable()において、unused spaceは、Int8Arrayとしてmarkされる。
unused spaceを持つのは、external arrayなど。
修正前はRawArrayだったのを、Int8Arrayに置き替えた。
Int8Arrayであるため、 修正前は存在したifを削除でき、Unused space分を埋めることができる。

r17135 | fschneider@google.com | 2013-01-16 21:12:21 +0900 (水, 16  1月 2013) | 12 lines
Fix bug in the x64 assembler's  movw instruction.
The order of prefixes was wrong.
The operand size prefix (0x66) must occur before the REX prefix.
From the instruction set reference:
[...]the REX prefix byte must immediately precede the opcode byte or
the escape opcode byte (0FH). [...]
Also, make movw(reg, addr) unavailable, consistent with ia32.
TEST=runtime/vm/assembler_x64_test.cc
Review URL: https://codereview.chromium.org//11961013
movw(reg, addr)を使用不可に。
movw(addr, reg)は可。

r17100 | hausner@google.com | 2013-01-16 07:43:00 +0900 (水, 16  1月 2013) | 7 lines
Collect debugging info for catch clauses Collect info about try-statement nesting,
and a list of handled types in each catch clause.
This will be used by the debugger to determine whether an exception is handled
by any handler on the stack.
Review URL: https://codereview.chromium.org//11883023
多いな、、

r17085 | srdjan@google.com | 2013-01-16 04:08:55 +0900 (水, 16  1月 2013) | 2 lines
Improve compilation speed on a pathological case > 2x (7 sec -> 2.7 sec) by improving local lookups.
Review URL: https://codereview.chromium.org//11893002
LocalScope::LocalLookupVariable()
Equals -> raw() == raw()

r17084 | fschneider@google.com | 2013-01-16 02:11:11 +0900 (水, 16  1月 2013) | 2 lines
Fix crash bug when deoptimizing from an optimized sqrt operation.
Review URL: https://codereview.chromium.org//11880048
StaticCallInstrのEmiterを修正、not optimizingの場合、Descriptor更新

r17079 | vegorov@google.com | 2013-01-16 00:51:24 +0900 (水, 16  1月 2013) | 12 lines
Set statically known ResultCid for AllocateObject.
Specialize PolymorphicInstanceCall in ApplyClassIds if receiver cid
was infered: filter out all but one target for attached ICData and drop checks.
Canonicalize away CheckClass if reciever cid matches at least one in the list of checked.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11886044
SpecializeICData()
SpecializePolymorphicInstanceCall()
1個しか候補がないpolymorphicInstanceCallはSpecializeIC
そうでない場合、可能であればreceiver classに最適化する。

r17040 | srdjan@google.com | 2013-01-15 10:14:17 +0900 (火, 15  1月 2013) | 2 lines
Add Dart class for _ExternalUint8ClampedArray and API to allocate it.
Review URL: https://codereview.chromium.org//11881031
dart_api.hに、Dart_NewExternalClampledByteArrayを追加。つか一式追加。
bootstrapに、ExternalUint8ClampedArray getIndexed, setIndexed
lib/byte_array.dartも拡張。
vm内部にIRは追加していない。Uint8ClampedArrayはある。ExternalもそのうちIRに追加するのだと思う。

r17036 | iposva@google.com | 2013-01-15 08:38:00 +0900 (火, 15  1月 2013) | 2 lines
- Dump Smi objects into the heap profile.
Review URL: https://codereview.chromium.org//11881010
HeapProfilerにwriteSmiInstanceDumpを追加。
heapを使用するわけじゃないけど、setで管理して統計取るのかな。

r17019 | fschneider@google.com | 2013-01-15 02:00:34 +0900 (火, 15  1月 2013) | 8 lines
Immediate index operand for string [] and streamline code for generating array ops.
Replace sizeof(RawArray) with Array::data_offset where it is used to compute the start
of the array data.
Refactor helpers for generating array addressing mode and use them for string []
operations as well.
Review URL: https://codereview.chromium.org//11880022
sizeof(RawArray)という表現を全部置換した。uint8やuint32等を差異を吸収するコードで置換。
また、StringCharCodeでindexを指定する際に、canBeImmediateでチェックして、
可能であれば、immediate indexでアクセスするように修正した。
それ以前は、indexはregisterのみ指定可能だった。

r17018 | vegorov@google.com | 2013-01-15 01:05:31 +0900 (火, 15  1月 2013) | 8 lines
When printing constants in the flow graph truncate them at the first new line character.
This makes IR more machine readable.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11876019
PrintOperandsTo()拡張。 new line char

r17016 | vegorov@google.com | 2013-01-14 21:15:11 +0900 (月, 14  1月 2013) | 5 lines
Canonicalize away redundant checks that appear after store-to-load forwarding.
BUG=dart:7513
Review URL: https://codereview.chromium.org//11885017
RegisterAllocatorの前に、Canonicalize()を実行する。CSEの後にも1回かけとくかと。
あとはInferRangeの後っていう理由もありそう。

r17014 | fschneider@google.com | 2013-01-14 19:27:28 +0900 (月, 14  1月 2013) | 2 lines
Optimize stores to Uint8List.
Review URL: https://codereview.chromium.org//11855007
optimizerでパタンマッチして、StoreIndexedInstrのemitterを改造。
MakeLocationにおいて、switchでlocsを各scalarlistの型ごとにチューニング。
Emitterもlocsに併せて修正。

r17013 | fschneider@google.com | 2013-01-14 18:51:48 +0900 (月, 14  1月 2013) | 12 lines
Cleanup uses of X::CheckedHandle where X::Cast or X::Handle is sufficient.
The only places where CheckedHandle is appropiate is with arguments to
runtime functions and values from Dart API functions.
For other places in the VM either normal Handle and ^=, or Cast is sufficient.
T::Cast is used when the value is guaranteed to be of type T (and never Object::null()).
Otherwise, the operator^= is used for casting.
Also fix a style issue where a Raw* should be used as return type.
Review URL: https://codereview.chromium.org//11826024
Handleの最適化

r17005 | cshapiro@google.com | 2013-01-12 11:43:57 +0900 (土, 12  1月 2013) | 3 lines
Emit fake classes to please the third party HPROF tool infrastructure.
Review URL: https://codereview.chromium.org//11879008
なんぞこれ、、WriteFaceLoadClassにおいて、Javaのクラスが多数登録されているけど。。
HeapProfilerのJavaのFakeClassってなんだろうか
Javaのhprofを無理やり使っているのか。。

r17003 | cshapiro@google.com | 2013-01-12 09:44:46 +0900 (土, 12  1月 2013) | 3 lines
Use a named constant for the object id size when writing out the header.
Review URL: https://codereview.chromium.org//11823002
8 -> kObjectIdSize

r17002 | srdjan@google.com | 2013-01-12 09:44:16 +0900 (土, 12  1月 2013) | 2 lines
Fix printing of deoptimized function.
Review URL: https://codereview.chromium.org//11886008
code_generatorのPrintCallerを削除。
deoptimize時のtrace message出力を強化

r17001 | asiva@google.com | 2013-01-12 09:33:16 +0900 (土, 12  1月 2013) | 3 lines
Added code to trace zone and handles creation/deletion under flags
--trace-zone and trace-handles
Review URL: https://codereview.chromium.org//11879005
オプション追加
ZoneHandle, VMHandlesのデストラクタでtraceを出力する。
大量のログがでそう。

r17000 | asiva@google.com | 2013-01-12 09:24:28 +0900 (土, 12  1月 2013) | 6 lines
Fix for issue 7757
- Iterate and collect all the inlined functions in an optimized dart frame
  into the stack frame when throwing an exception.
- Added a OptimizedDartFrameIterator class which iterates over all the inlined
  functions of a single optimized dart frame.
Review URL: https://codereview.chromium.org//11833025
StackFrameに、InlinedFuntionsInDartFrameIteratorクラス追加
FindExceptionHandler()で呼び出す。
deopt周りもいろいろと修正が入っていて、
GetDeoptInfoAtPc()をobject.hに移動、Code::に追加。

r16999 | srdjan@google.com | 2013-01-12 08:39:00 +0900 (土, 12  1月 2013) | 3 lines
Fix performance of array literals (e.g. "[1, 2]"). Improves speed of DeltaBlue.
Simplify code to allocate groable object array from an object array.
Review URL: https://codereview.chromium.org//11882005
withDataというintrinsiferを追加。
lib/arrayで、literal指定された場合に、withDataを呼び出す。

r16997 | srdjan@google.com | 2013-01-12 08:15:51 +0900 (土, 12  1月 2013) | 2 lines
Fix printing of the function that cannot be optimized.
Review URL: https://codereview.chromium.org//11878006
主要なPrintを、OS::PrintからOS::PrintErrに変更。

r16996 | iposva@google.com | 2013-01-12 08:05:57 +0900 (土, 12  1月 2013) | 4 lines
- Start adding meta data for fields of VM internal classes.
- Correctly report instance size in bytes.
- At least report field sizes for variable sized objects.
Review URL: https://codereview.chromium.org//11880004
heap_profilerで、raw_classが内包するinstance_size_in_wordsを返す。
Dart::InitOnce()の初期化時に、CreateInternalMetaData()

cls = context_class_;
fields = Array::New(1);
name = Symbols::New("@parent_");
fld = Field::New(name, false, false, false, cls, 0);

r16983 | srdjan@google.com | 2013-01-12 05:42:47 +0900 (土, 12  1月 2013) | 2 lines
Inline Doubles truncate and round.
Review URL: https://codereview.chromium.org//11573044
IRに、DoubleToDoubleを追加。
MethodRecognizerにDoubleRoundとDoubleTruncateを追加
optimizerで、DoubleRoundとDoubleTruncateは、DoubleToDouble IRにパターンマッチ。
内部にRoundingModeを持ち、Emitする際に切り替える。

x64にandpd pxorなどが追加されたのは何かの前触れか。
x64の場合、DoubleAbsは、andpdを使用する。

Assembler::DoubleRound()を新規追加。
AssemblerにRoundingModeを追加

r16982 | tball@google.com | 2013-01-12 04:17:28 +0900 (土, 12  1月 2013) | 2 lines
Fixed warnings reported by clang compiler.
Review URL: https://codereview.chromium.org//11823067
class -> struct

r16965 | kmillikin@google.com | 2013-01-11 20:43:48 +0900 (金, 11  1月 2013) | 9 lines
Change the inlining context from an enum to a class.
To support inlining in test contexts, the inlining context needs to have its
dispatched behavior and state.  This change introduces a context class
representing calls inlined for their value or solely for their effects.
The intermediate array of exits is moved from the graph to the inlining context.
The implementation behavior is otherwise the same as before.
Review URL: https://codereview.chromium.org//11856010
InlineCallの大改造
InliningContextクラスを追加 InliningContext Enumをクラスに変更した。
inliningの処理のテンプレートクラスみたいなもん。
inlinigはネストする可能性があるため、そのcontextを保持しながら、inliningのテンプレート処理を定義。

r16945 | srdjan@google.com | 2013-01-11 09:43:56 +0900 (金, 11  1月 2013) | 2 lines
Increase deoptimization counter threshold to 16, cleanups.
Review URL: https://codereview.chromium.org//11823070
オプション deoptimization-counter-threshold=16

r16934 | hausner@google.com | 2013-01-11 06:47:09 +0900 (金, 11  1月 2013) | 9 lines
Support for embedded Dart scripts
Add a line and column offset to scripts so that errors and exceptions
in embedded Dart scripts are reported at the proper location.
New API call Dart_LoadEmbeddedScript() that allows to specify
line and column offsets.
Stumbled on and fixed a bug. Script::kind field was not externalized to snapshot.
Review URL: https://codereview.chromium.org//11824067
DartApiに、LoadEmbeddedScript()を追加
lineとcolumnを指定できること以外は、LoadScriptと変わらないAPI。
Objectも改造して、line_offsetとcol_offsetフィールドを持ち、SetLocationOffsetを上記に併せて追加。
組み込み時の相対lineとcolを指定するのか。lineとcolをgetした際には、相対lineとcolが足されて返ってくる。

r16919 | fschneider@google.com | 2013-01-10 22:18:31 +0900 (木, 10  1月 2013) | 19 lines
Add canonicalize optimization for branches.
Comparisons where the result is only used in a branch on true
can be folded into the branch instruction.
Patterns like this can occur after inlining and constant propagation.
In normal code, we merge branches and comparisons already at graph building time.
v3 <- (v1 == v2)
Branch if (v3 === true)

is optimized to
Branch if (v1 == v2)
Also: Remove outdated TODOs and rename the canonicalization pass to a better name.
Review URL: https://codereview.chromium.org//11819031
BranchInstr::canonicalize()追加


r16897 | srdjan@google.com | 2013-01-10 09:28:57 +0900 (木, 10  1月 2013) | 6 lines
Optimize function at its entry instead of at exit.
The code can be patched if it should not be executed any longer.
The code can be now patched at other location than at entry,
the requirement is still that patching code does not overwrite an inlined object.
Intrinsic methods that do not have a fall through cannot be patched.
Review URL: https://codereview.chromium.org//11783066
OptimizeInvokedFunctionにおいて、arguments.SetReturn()でpatch元のcurrentCodeを保存しておく。
code_patcher.ccを追加。リファクタリングのコード移動のみ。
ia32/x64に、EmitFrameEntry()やEntryPatchを追加。以前はReturnでのPatchだった。

最適化可能な場合は、いかのようなFrameを生成する。Returnではなく、FrameEntryで行うと。
LoadObject reg, function
AddCurrentDescriptor()
incl reg, usage_counter_offset()
cmpl reg, offset, threshold(3000)
j ge, optimize_function_label

代わりに、GenerateOptimizeFunctionStubや、RetrunInstrのEmitでPatchを仕込む処理を削除。

r16847 | vegorov@google.com | 2013-01-09 21:27:46 +0900 (水, 09  1月 2013) | 8 lines
Constant propagator should revisit phis when it visits predecessor block.
Phi's value depends both on its inputs and reachability of join's predecessors.
Thus it is essential to revisit phi when predecessor becomes reachable.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11824024
JoinEntryではなく、GotoでPhiのpredecessorをAcceptするらしい。

r16846 | floitsch@google.com | 2013-01-09 20:23:54 +0900 (水, 09  1月 2013) | 3 lines
Enable "part of" for the async library.
Review URL: https://codereview.chromium.org//11820024
gypiにasync_dartを追加。

r16815 | hausner@google.com | 2013-01-09 03:57:19 +0900 (水, 09  1月 2013) | 6 lines
Allow optimized code when debugger is active
The debugger allows the VM to optimize code unless there is a breakpoint inside the function.
Whenever a new breakpoint is set (explicitly or implicitly by stepping)
all optimized code is discarded.
Review URL: https://codereview.chromium.org//11780005
Debugger::IsActive()を削除。
HasBreakpintの場合、OptimizeFunctionしないらしい。

DeoptimizeWorld()ってのが追加か。DeoptimizeAllを呼び出す。
InstrumentForStepping()から呼び出す。

JVMの場合はインタプリタに戻ったけど、Dart VMやV8は最初のコンパイル結果に戻ると。
breakpoint持ちは基本的にはoptimizeしないけど、new breakpointの設定も考慮して元に戻す処理もある。

r16806 | fschneider@google.com | 2013-01-09 01:51:57 +0900 (水, 09  1月 2013) | 5 lines
Support immediate and memory operands for PushArgumentInstr in optimized code.
If a value is a constant or stored on the stack this change avoids loading it into a
new register before pushing it.
Review URL: https://codereview.chromium.org//11791051
AnyOrConstant() ToStackSlotAddress()をLocationsについか、
IRからPushArgumentInstrのEmitorを削除して、ia32とx64にそれぞれ独自実装を追加。
optimizingの際の無駄なemitコードを削減し、IsRegisterな値は、pushl
IsConstantの場合は、PushObject
上記以外は、pushl。

r16799 | vegorov@google.com | 2013-01-08 23:27:09 +0900 (火, 08  1月 2013) | 10 lines
Delay canonicalization of 1.0 * N until after representation selection.
This allows to avoid Unbox(Box(N)) pair if N is an unboxed double phi:
var N = 0.0;
while (X) N += 1.0 * N;
Review URL: https://codereview.chromium.org//11791047
下記修正のunbolxdoubleを挿入する処理を削除。

r16795 | vegorov@google.com | 2013-01-08 22:32:23 +0900 (火, 08  1月 2013) | 6 lines
Canonicalize away simple arithmetic equivalences.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11773040
BinarySmiOpInstrとBinaryMintOpInstrとBinaryDoubleOpInstrのCanonicalizeにおいて、
CommutativeArighmetic最適化。

ToIntegerにおいて、Doubleだった場合、doule型生成、Smiの場合、Smi型生成
commutativeArighmeticを追加か、
left.(*)(right)において、
left=double, right!=double, unboxdoubleを挿入。
left=0, right!=doubleの場合、return right。 doubleを除外するのは、Nanと0.0が異なるため。
left.(+)(right)において、
left=0, right!=doubleの場合、(doubleを除外するのは、0.0と-0.0は異なるため)
return right
でもどうなのよこれ、、Canonicalizeを1回試して、nullでなければ、もう1回Canonicalizeを試すと。。


r16782 | cshapiro@google.com | 2013-01-08 11:53:14 +0900 (火, 08  1月 2013) | 6 lines
Fix confusion over on-disk object id sizes during instance serialization.
To avoid confusion in the future the WritePointer methods have been
renamed to the more descriptive WriteObjectId.
Review URL: https://codereview.chromium.org//11778028
メソッド名のリファクタリングぽい。

r16774 | srdjan@google.com | 2013-01-08 09:58:58 +0900 (火, 08  1月 2013) | 2 lines
Bug fix and improvements to clamped arrays.
Review URL: https://codereview.chromium.org//11794038
UintClampled8Array_getIndexedがバグっていた？ Uint8Arrayで代替していたのを、ちゃんと実装した。
SmiUntagした後に、TIMES_1でshiftしてる。。？

r16764 | cshapiro@google.com | 2013-01-08 08:16:44 +0900 (火, 08  1月 2013) | 3 lines
Restore the bytes promoted counter.
Review URL: https://codereview.chromium.org//11783015
byte_promotedっていうカウンタで、promoteしたsizeの統計をとるらしい。

r16757 | regis@google.com | 2013-01-08 07:24:11 +0900 (火, 08  1月 2013) | 2 lines
Fix context chaining to prevent memory leak (issue 7681).
Review URL: https://codereview.chromium.org//11806003
handleをつかわずにnewしたいたため、メモリリークしていたらしい。

r16756 | srdjan@google.com | 2013-01-08 07:13:47 +0900 (火, 08  1月 2013) | 2 lines
Cleanups.
Review URL: https://codereview.chromium.org//11801023
comment cleanup

r16734 | iposva@google.com | 2013-01-08 03:36:39 +0900 (火, 08  1月 2013) | 2 lines
- Preallocate non-named ArgumentsDescriptors with a small amount of parameters. 
Review URL: https://codereview.chromium.org//11773008
ArgumentDescriptorをキャッシュする配列を作成。
普通にNewするとCached. default 32

r16731 | vegorov@google.com | 2013-01-08 02:06:50 +0900 (火, 08  1月 2013) | 8 lines
Do ComputeUseLists after ApplyClassIds.
Applying class ids invalidates use lists.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11791024
ApplyClassIdsの後に、ComputeUseLists()を追加。何か修正したっけ？

r16717 | vegorov@google.com | 2013-01-08 00:44:23 +0900 (火, 08  1月 2013) | 6 lines
Recognize List.fixedLength factory constructor.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11788018
Recognizeに追加。List.fixedLength
lib v2で新規追加されたList型のコンストラクタ

r16716 | fschneider@google.com | 2013-01-08 00:43:35 +0900 (火, 08  1月 2013) | 8 lines
Support scalar lists in array bounds check elimination.
This allows to eliminate bounds checks for scalar lists in loops like:
for (var i=0; i < a.length; i++) {
  a[i]
}
Review URL: https://codereview.chromium.org//11665005
きたこれ！！！わすれられているのかと。。
kByteArrayBaseLength()と、kStringBaseLength()は、Range情報を計算する。
IsFixedLengthArrayType()を追加。ArrayCid, ImmutableARrayCid, ByteArrayから派生したやつら。
CheckArrayBoundInstr::IsRedundant()において、
ByteArrayから派生したArrayCidの場合、ByteAarray::length_offset()を参照して、Range情報に記録する。
IsRedundant()において、なんでswitchなのかとおもったら、最後にExternalUint8ArrayCidが混じっている。。

r16711 | vegorov@google.com | 2013-01-08 00:33:36 +0900 (火, 08  1月 2013) | 6 lines
Ensure that LowerBound and UpperBound return overflow marker when overflow occurs.
R=fschneider@google.com
BUG=dart:7617
Review URL: https://codereview.chromium.org//11779017
OverflowedMinSmi()とClamp()に置換。

r16701 | vegorov@google.com | 2013-01-07 23:51:24 +0900 (月, 07  1月 2013) | 5 lines
Fix Intrinsifier and MethodRecognizer to correctly match private getters and setters.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11779018
MethodRecognizerのCompareNamesの修正
get:_ set:_からはじまるsymbolかチェックする処理を追加。

r16687 | floitsch@google.com | 2013-01-07 20:23:16 +0900 (月, 07  1月 2013) | 3 lines
Big merge from experimental to bleeding edge.
Review URL: https://codereview.chromium.org//11783009
dart:asyncっていうライブラリに、async系とfutureが移動して、streamが新規追加。lib v2らしい。
http://news.dartlang.org/2013/01/dart-lands-first-set-of-library-v2.html
libにASyncってのが追加されていて、vmがloadscriptする。bootstrap周りはそれ系の修正
iteratorも修正がはいり、intrinsifierでは、next getHasNextを削除
get:currentとmoveNextに置換されたが、そのうちIntrinsiferにImplする予定。

r16684 | kmillikin@google.com | 2013-01-07 19:03:17 +0900 (月, 07  1月 2013) | 8 lines
Fix incorrect desugaring of cascades.
Make use of the attractive and powerful way that the LoadLocal expression is
really a pair of an arbitrary statement and a local variable load.
BUG=dart:7494
Review URL: https://codereview.chromium.org//11745028
cascadesの修正
ASTのみ、SequenceNodeってのに、addして繋げるらしい。

r16683 | asiva@google.com | 2013-01-07 14:44:20 +0900 (月, 07  1月 2013) | 6 lines
Cleanup handles more efficiently, ensures we don't have to iterate over them
while visiting objects during GC.
- Add handle scopes during class finialization
- Add handle scopes to different stages of the compiler
- Ensure that we iterate only to the top of scoped handles while visiting objects
Review URL: https://codereview.chromium.org//11778013
handleの最適化。
ClassFinalierのZoneHandleから、Handleに修正。
CompileFunctionHelperのParserを、isolate handlescopeで領域確保するように修正

r16666 | srdjan@google.com | 2013-01-05 10:07:32 +0900 (土, 05  1月 2013) | 2 lines
Intrinsify Uint8ClampedArray's store and load indexed, inline load indexed.
Review URL: https://codereview.chromium.org//11783006
intrinsiferに、Uint8ClampedArrayを追加。
getIndexed []
setIndexed []=
Uint8ArrayCidと同じく扱われるように、case文や||で条件分岐を追加した。

r16665 | hausner@google.com | 2013-01-05 09:46:23 +0900 (土, 05  1月 2013) | 5 lines
Handle optimized code blocks in debugger stack trace
Removed an old restriction that debugger activation frames
are expected to be non-optimized code. Fixes bug 5944.
Review URL: https://codereview.chromium.org//11776007
vm/debugger.hに、DartCode()を作って、毎回Handleしているのを最適化した。

r16664 | regis@google.com | 2013-01-05 09:45:52 +0900 (土, 05  1月 2013) | 2 lines
Support Null type in Class::TypeTest and simplify Instance::IsInstanceOf.
Review URL: https://codereview.chromium.org//11785006
IsNullClass()の返値を修正。
IsNullClass()で判定している処理において、cls.IsNullClass==trueはありえないので、分岐先の処理を削除。
16648も合わせて修正。

r16648 | srdjan@google.com | 2013-01-05 06:29:05 +0900 (土, 05  1月 2013) | 2 lines
Optimize instanceof: if all results are true and tests can be done using class only
replace instanceof with a Boolean constant.
Review URL: https://codereview.chromium.org//11746024
Optimizerに、InstanceOfAsBool()追加
いみわからん構造ですね。。
InstanceOfAsBool()でnull以外がうまく返ってくれば、BoolのConstantで置換する。

r16645 | asiva@google.com | 2013-01-05 03:38:00 +0900 (土, 05  1月 2013) | 2 lines
Do not emit pointer information for embedded singleton VM Isolate objects while generating code.
These embedded objects do not need to be visited during GC.
Review URL: https://codereview.chromium.org//11722026
objectに、IsVMHeapObject()っていう処理を追加。
今まではnullくらいだったけど、最近多数追加されたembedded singleton VM Isoalte objectsを、
IsVMHeapObjectという対象にした？
rawの場合、IsMarked()がIsVMHeapObject()に該当するらしいけど。

r16624 | iposva@google.com | 2013-01-04 11:15:36 +0900 (金, 04  1月 2013) | 2 lines
- Consolidate verbose-gc output to be a single line which can be imported easily into spreadsheets.
Review URL: https://codereview.chromium.org//11734028
オプションverbose-gc-hdr=40を追加。
GCのverbose出力時のヘッダを、hdr=40回ごとに出力する。
verbose-gcの出力を変更。
PrintStats()の出力を、ヘッダを|区切り、データを,区切りに変更。
また、細かいフェーズごとにtimeを取ってstatsで出力する。

r16623 | asiva@google.com | 2013-01-04 10:52:05 +0900 (金, 04  1月 2013) | 3 lines
- Make Boolean 'true' and 'false' singleton VM isolate objects.
- Change all uses of it
Review URL: https://codereview.chromium.org//11745022
Bool::True()やBool::False()をisolateに用意して、singoleton objectに置換した。
Nullみたいな扱いになった。以前修正されたsentinelみたいな扱い。
結果的に、object_storeから削除し、objectとraw_objectにsingletonの定義を追加。

r16593 | meh@google.com | 2013-01-03 11:11:03 +0900 (木, 03  1月 2013) | 5 lines
Fix pprof VM flag description
Review URL: https://codereview.chromium.org//11695007
generate-pprof-symbolsのオプションの説明を修正。

r16589 | srdjan@google.com | 2013-01-03 07:22:39 +0900 (木, 03  1月 2013) | 2 lines
In unoptimized code use call for instanceof instead of inlined checks.
This allows us to collect type feedback and to reduce the code size of unoptimized code.
Next will be work on type tests as well.
Review URL: https://codereview.chromium.org//11694003
大きな修正かも。
オプション、inline-cache=trueを削除。
bootstrapに、Object_instanceOfを追加
修正前は、builderにおいて、TypeCheckArgumentsに対してInstanceOfInstr命令を生成していた。
修正後は、InstanceCallを挿入し、TypeFeedbackを受ける。
また、Optimizerにおいて、TypeTestOperatorをInstanceOfInstrに置換する。

r16588 | iposva@google.com | 2013-01-03 07:09:28 +0900 (木, 03  1月 2013) | 2 lines
オプション、huge_method_cutoff=20000を追加。
is_optimizable()において、上限を設定している。

r16584 | asiva@google.com | 2013-01-03 04:31:59 +0900 (木, 03  1月 2013) | 4 lines
Convert all symbol accessors to return read only handles
so that it is not necessary to create a new handle in the code that uses it.
Added a few more strings to the symbols list.
Review URL: https://codereview.chromium.org//11667012
Handleのリファクタリング。大体はHandleはずし。
String::HandleでSymbols::Empty()を参照していたのを、Symbols::Empty()のみに置換。
といった変換がメイン。
あとは、""で囲んだ文字列を、Symbolsに予め定義しておくとか。

r16583 | regis@google.com | 2013-01-03 03:52:28 +0900 (木, 03  1月 2013) | 3 lines
Remove NoSuchMethodErrorImplementation class and use NoSuchMethodError from core lib instead.
Review URL: https://codereview.chromium.org//11712002
flowgraphbuilderにBuildThrowNoSuchMethodErrorを新規追加
parserに、ThrowNoSuchMethodError()を追加
bootstrapより、NoSuchMethodError_throwNewを削除


r16550 | hausner@google.com | 2012-12-29 03:51:58 +0900 (土, 29 12月 2012) | 2 lines
Improve line info accuracy in debugging
Review URL: https://codereview.chromium.org//11696005
line numberから、funcを探せるようになった。
それに伴い、vm/object.ccを修正し、intrinsifierのfinterprintを修正している。
fingerprintって、何かビルド時のオプションで計算できるんだっけ？
object.ccを修正する度に埋め込み直すのか？

r16541 | srdjan@google.com | 2012-12-29 01:16:49 +0900 (土, 29 12月 2012) | 2 lines
Fix instance of test for classes that implement call.
Review URL: https://codereview.chromium.org//11698002
冗長なjmpを削除

r16538 | antonm@google.com | 2012-12-28 19:00:26 +0900 (金, 28 12月 2012) | 7 lines
Fix a warning.
Most probably description needs some love too.
TBR=meh@google.com
Review URL: https://codereview.chromium.org//11692009
option generate_pprof_symbols=NULL

r16530 | tball@google.com | 2012-12-28 08:45:40 +0900 (金, 28 12月 2012) | 2 lines
Implemented class literals in the VM.
Review URL: https://codereview.chromium.org//11633054
parserでTypeNodeを生成している。またTypeNodeがbuilderで何かされている。

r16528 | iposva@google.com | 2012-12-28 08:25:43 +0900 (金, 28 12月 2012) | 2 lines
- Fix comments and formatting.
Review URL: https://codereview.chromium.org//11646006
formatting

r16519 | srdjan@google.com | 2012-12-28 04:23:09 +0900 (金, 28 12月 2012) | 2 lines
Small code cleanup in instanceof test.
Review URL: https://codereview.chromium.org//11674011
IsSubType()の前に、SmiTagのチェックする分岐を削除した。

r16517 | srdjan@google.com | 2012-12-28 03:24:03 +0900 (金, 28 12月 2012) | 2 lines
Sort checks by counts before emitting test-and-call polymorphic instance calls.
Review URL: https://codereview.chromium.org//11602014
SortICDataByCount()
CidTarget構造体で、call countを管理する。
tuple<cid, target, count>を、EmitTestAndCall()でソートした順番にGenerateする。
呼び出された回数が多い順番に、test-and-callを生成する。

r16464 | hausner@google.com | 2012-12-22 10:09:44 +0900 (土, 22 12月 2012) | 5 lines
Fix bug 5944
Ensure both closureized and regular function are deoptimized when setting a breakpoint.
Review URL: https://codereview.chromium.org//11669017
closure.HasCode() EnsureFunctionIsDeoptimized(closure)

r16463 | regis@google.com | 2012-12-22 09:40:46 +0900 (土, 22 12月 2012) | 5 lines
Turn compile time errors related to missing getters and setters into invocation
of noSuchMethod or into throwing of NoSuchMethodError according to spec.
Return result of InvocationMirror.invokeOn to caller.
Fix various tests.
Review URL: https://codereview.chromium.org//11669015
noSuchMethodって、compile時にinterfaceをresolveできなかった場合か。
noSuchMethodを埋め込んで、 Runtime時に解決できるようにしている。
そのため、mirrorなどのreflectionと関係があると。。
noSuchMethodを埋め込んでおいて、Runtimeでも解決できなければ、エラーになると。

superの場合、noSuchMethodCallを埋め込んで、Runtime時に解決する
superでない場合、noSuchMethodErrorの呼び出しを埋め込んでエラーにすると。
上記を全部builder(compile時)にやっている。

r16462 | meh@google.com | 2012-12-22 09:23:25 +0900 (土, 22 12月 2012) | 12 lines
Clean up CodeObservers
Move CodeObserver registration to the OS abstraction.
Move Pprof logic to the OS abstraction.
Remove pprof from VM tests because now pprof logic is in the VM itself.
Add DISALLOW and AllStatic to Code Observers where appropriate.
Previous review: https://codereview.chromium.org/11572032/
BUG=7321
Review URL: https://codereview.chromium.org//11660011
debuginfo_macos.ccを削除
debuginfo_win.ccを削除
dart_api_impl.ccから、Dart_xx Pprof系を削除
os_win.ccに、VTuneCodeObserver追加
上記を抽象化して、osの各実装に書くようにした。
os_linux.ccにCodeObserverの実装を移動。全部揃ってるのはlinuxのみ。
os_androidも、linuxと同様。ただしandroidはまだperfが未サポート。

r16461 | meh@google.com | 2012-12-22 09:12:35 +0900 (土, 22 12月 2012) | 8 lines
Implement a native identical function in the VM.
Returns true if objects are the same instance.
Adds an identical closure test
(disabled for dart2js pending https://chromiumcodereview.appspot.com/11612022/).
BUG=7378
Review URL: https://codereview.chromium.org//11613003
Identical_comparison,2 をBootstrapNativesに追加

r16458 | hausner@google.com | 2012-12-22 08:37:26 +0900 (土, 22 12月 2012) | 9 lines
Ignore nested breakpoints
Fixes issue 5945.
When stepping into core library code, it is possible to hit a breakpoint
recursively when the debugger executes dart code to evaluate values.
This change ignores nested breakpoint and exception events.
Review URL: https://codereview.chromium.org//11644085
stack_grace_ != NULLの場合もreturn

r16439 | fschneider@google.com | 2012-12-21 20:56:11 +0900 (金, 21 12月 2012) | 2 lines
Cleanup: Don't allocate a frame iterator in the IC miss handler when it's not needed.
Review URL: https://codereview.chromium.org//11607018
iteratorを毎回確保していたのを、 flag trace_icの場合のみ確保するように修正。

r16420 | kmillikin@google.com | 2012-12-21 17:58:32 +0900 (金, 21 12月 2012) | 6 lines
Simplify basic block discovery -- handle all blcoks uniformly.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11571057
いろんなサブクラスが継承してvirtualを実装していたのをやめた。
BlockEntryInstrのみがdiscoveryを実装する構造になってる。

r16417 | asiva@google.com | 2012-12-21 12:07:10 +0900 (金, 21 12月 2012) | 3 lines
Fix latin1 character predefinition in the symbol table. The code
was doing two calls to FindIndex for every character.
Review URL: https://codereview.chromium.org//11644038
latin1のpredefinitionテーブル対応を完了。

r16416 | asiva@google.com | 2012-12-21 11:33:05 +0900 (金, 21 12月 2012) | 4 lines
Create read only handles for empty_array and sentinel objects
(trying out a basic framework and will extend it to others once this works).
Review URL: https://codereview.chromium.org//11648006
Handleの二重参照をやめて、Object::empty_array()っていうsingletonの空のreadonlyな奴に置き替え
似たようなのに、Object::transition_sentinel()を追加
Object::sentinel()を追加

上記のsingletonの場合、objectとraw()がsingletonらしい。
snapshotの際には、objectクラスではなく、rawに着目する。

一応上記も最初はRAW_NULLに初期化されているらしい。
Instanceは、AllocateReadOnlyHandle()

r16390 | srdjan@google.com | 2012-12-21 04:29:52 +0900 (金, 21 12月 2012) | 1 line
Mark final fields as immutable.
field.is_final()なんて処理あったんですね。。

r16394 | ager@google.com | 2012-12-21 05:03:07 +0900 (金, 21 12月 2012) | 5 lines
Reapply "Optimize the message queue for many active ports with few messages."
Review URL: https://codereview.chromium.org//11647038
r16392 | ager@google.com | 2012-12-21 04:40:29 +0900 (金, 21 12月 2012) | 8 lines
Revert "Optimize the message queue for many active ports with few messages."
No failures locally. I'll investigate tomorrow.
R=iposva@google.com
Review URL: https://codereview.chromium.org//11642048
r16388 | ager@google.com | 2012-12-21 04:20:44 +0900 (金, 21 12月 2012) | 15 lines
Optimize the message queue for many active ports with few messages.
The current message queue implementation is very inefficient if you are using
many active ports with few messages.
This happens when you use 'call' a lot on ports which is currently done in dart:io.
This patch does not remove messages from the queue when closing a port.
Instead it drops messages for closed ports when it processes them.
This dramatically speeds up dart:io benchmarks that enqueue tons of writes on a file output stream.
R=iposva@google.com
BUG=http://dartbug.com/6911
Review URL: https://codereview.chromium.org//11440035
LookupReceivePort
HandleMessage
2件の修正。
isolate.cc::IsolateMessageHandler::HandleMessage()
if !IsOOB
receive_portがcloseしていたら(初期化済みの値Null),以降の処理(message deserialize)スキップ
delete message

r16360 | fschneider@google.com | 2012-12-20 21:42:11 +0900 (木, 20 12月 2012) | 2 lines
Cache resolution of two static functions frequently used in I/O.
Review URL: https://codereview.chromium.org//11636017
HandleMessage()で、_ReceivePortImpl()と_handleMessage()を、最初の1回だけ生成して、cacheするように変更。

r16352 | vegorov@google.com | 2012-12-20 09:16:42 +0900 (木, 20 12月 2012) | 6 lines
When replacing one value with another ensure that replacement has SSA index assigned.
R=srdjan@google.com
BUG=dart:7513
Review URL: https://codereview.chromium.org//11638030
replaceCurrentInstructionにおいて、ssaのメンテをすると？

r16343 | regis@google.com | 2012-12-20 06:26:29 +0900 (木, 20 12月 2012) | 2 lines
Simplify method invocation runtime entries.
Review URL: https://codereview.chromium.org//11636025
DartEntryは、RuntimeEntryから呼ばれることが多いのかな。
RuntimeEntry乃宣言をcode_generatorに固めて、そこから呼ばれる処理は、DartEntryにかためたと。
リファクタリングか。

r16339 | srdjan@google.com | 2012-12-20 04:47:13 +0900 (木, 20 12月 2012) | 2 lines
Fix test failure issue 7471: Signature classes have different type checking rules,
i.e., they have no subclasses but other signature classes may be subtypes (must check signature).
Review URL: https://codereview.chromium.org//11640025
type_class.IsSignatureclas() return false;

r16331 | vegorov@google.com | 2012-12-20 02:47:01 +0900 (木, 20 12月 2012) | 12 lines
Set kArrayCid as ResultCid for CreateArray instruction.
Propagate the length of the array returned by CreateArray in constant propagation.
Fold constant RelationalOp instructions.
Together this allows to kill considerable amount of unrechable code emitted from array literal allocation.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11635017
CompareIntegers()を新規追加。
kObjectArrayLengthだった場合、SmiのConstantを作って設定すると。

r16314 | fschneider@google.com | 2012-12-19 20:48:30 +0900 (水, 19 12月 2012) | 2 lines
Make getter for capacity in _GrowableObjectArray private.
Review URL: https://codereview.chromium.org//11606023
rename get:capacity -> get:_capacity

r16311 | fschneider@google.com | 2012-12-19 19:43:13 +0900 (水, 19 12月 2012) | 2 lines
Inline ByteArrayBase.length in the flow graph optimizer.
Review URL: https://codereview.chromium.org//11628011
IsRecongnizedLibrary()追加。CoreとMathとScalarlistはintrinsicsに置換する。
ByteArrayBase, get:lengthを、TryInlineInstanceGetter()において、
InlineArrayLengthGetter()を試行する。

r16296 | srdjan@google.com | 2012-12-19 08:48:03 +0900 (水, 19 12月 2012) | 2 lines
UnboxDouble: convert smi constants to doubles at compile time instead of at runtime.
Review URL: https://codereview.chromium.org//11645006
Smi ConstansからUnboxDoubleされる場合、optimizerで定数変換する。

r16295 | asiva@google.com | 2012-12-19 08:47:35 +0900 (水, 19 12月 2012) | 3 lines
Cleanup the exceptions create code to use Arrays instead GrowableArrays so
that it is consistent with the DartEntry invoke code that it calls finally.
Review URL: https://codereview.chromium.org//11639007
r16288 | asiva@google.com | 2012-12-19 06:36:01 +0900 (水, 19 12月 2012) | 4 lines
Changed the API in DartEntry for invoking dart code from C++ to make it more compatible with the requirements of the runtime.
Deleted all the code duplication that was added to circumvent the old DartEntry API requirements.
Review URL: https://codereview.chromium.org//11613009
DartEntryってなんだっけ
code_generatorのメソッドをDartEntryに移動したのかな。
GrowableArray<>を使っていたところが、置き換えか。Array::Handle(Array::New(1))になったいる？

r16274 | srdjan@google.com | 2012-12-19 03:57:05 +0900 (水, 19 12月 2012) | 2 lines
Fix build.
Review URL: https://codereview.chromium.org//11607021
miss fix

r16272 | srdjan@google.com | 2012-12-19 03:43:29 +0900 (水, 19 12月 2012) | 2 lines
Add DoubleToSmi optimistically, preventing boxing/unboxing of doubles and propagate smi-nessof the result.
Review URL: https://codereview.chromium.org//11568044
DoubleToSmi中間表現を新規追加
ic_dataがkDoubleToIntegerだった場合、DoubleToSmiのIRを作って置換
Locationでは、kNumInput=1 xmmが入力。
// result = Register, value = Xmm
cvttsd2si(result, value)
cmpl result, SmiMax+1
j negative, deopt
SmiTag result
合計4命令。

r16269 | srdjan@google.com | 2012-12-19 03:15:41 +0900 (水, 19 12月 2012) | 2 lines
Use call counts to prevent cold calls from being inlined.
Review URL: https://codereview.chromium.org//11541002
ObjectにggregateCount()追加
inline-hotness=10オプションを追加
InstanceCallInfoクラスを作成し、Ratioを管理。
aggregate_countを適度にカウントアップしながら、CallSiteのRatioでinline展開をコントロール
InlineInstanceCalls()において、hotness以下の場合、何もしない。
hotness以上の場合、TryInlining


r16267 | iposva@google.com | 2012-12-19 02:45:55 +0900 (水, 19 12月 2012) | 2 lines
- Consider the growth policy even when allocating large pages.
Review URL: https://codereview.chromium.org//11434056
enough_free_spaceフラグを参照しなくなった。
問答無用でgrowth

r16237 | regis@google.com | 2012-12-18 09:13:33 +0900 (火, 18 12月 2012) | 5 lines
Include super type in interface list for cycle detection (issue 4318).
Report an error if a type appears in both extends clause and implements clause.
Add language test.
Close old pending issue 4905685.
Review URL: https://codereview.chromium.org//11613007
ResolveSuperTypeAndInterfaces()を追加して解決。
visitしたAraryを持って再起しながら、cycleを見つけたらReportError

r16220 | regis@google.com | 2012-12-18 04:35:16 +0900 (火, 18 12月 2012) | 4 lines
Invoke noSuchMethod instead of immediately throwing NoSuchMethodError when
invoking a non-closure as a closure (reopened issue 3326).
Address comments of last cl.
Review URL: https://codereview.chromium.org//11612002
リファクタリングかな。
InvokeNoSuchMethod

r16212 | vegorov@google.com | 2012-12-18 00:22:16 +0900 (火, 18 12月 2012) | 7 lines
Store optimized flow graph statistics on the function itself.
This gives a good estimate for an early bailout from the inlining attempt.
Review URL: https://codereview.chromium.org//11567012
raw_objectにinstrunction_count()とcallsite_count()を追加。フィールド追加で、ちゃんとsnapshotされる。
inliningの際にカウントして格納する。
TRACE_INLININGの際に、statsとして出力する。何かinliningの指標になるわけではない。

r16199 | cshapiro@google.com | 2012-12-16 04:58:45 +0900 (日, 16 12月 2012) | 3 lines
Merge the Merlin heap tracing to top-of-trunk.
Review URL: https://codereview.chromium.org//11428067
Allocate時のTraceAllocation()ってのが追加されている。
HeapTrace::is_enabled()の際に、様々なTrace処理を呼び出す。
http://cs.anu.edu.au/~./Steve.Blackburn/pubs/papers/merlin-toplas-2006.pdf
これ参照か？

ScavengerやM&Sに以下を追加してTrace可能に。Trace対象はaddrとsize。TraceはHeapが管理する。
TraceCopy()
TracePromotion()
TraceAllocate()
TraceDeathRange()
TraceSweep()
TraceDeleteZone()
StubのStoreBuffer系の処理において、TraceStoreIntoObject() -> HeapTraceStore()
code_generatorで、HeapTraceStoreを生成する。
StoreBufferでないStoreIntoObjectNoBarrierからもTraceされる。

以下を新規追加
オプション heap_trace=false
vm/heap_trace.cc
vm/heap_trace.h

Traceするaddrは、すべてAllocationRecordに記録していく。
最終的にファイルへ出力。
詳細は論文か、PPTのサマリを参照すべきか。

Trace系の処理やオブジェクトも、GC対象に含まれており、修正量が多い。
GC対象のオブジェクトを追加する際の参考になるかも。
Handleの追加も行っている。

r16187 | regis@google.com | 2012-12-15 09:28:41 +0900 (土, 15 12月 2012) | 2 lines
Implement InvocationMirror.invokeOn method in the vm (issue 7227).
Review URL: https://codereview.chromium.org//11570042
bootstrap_nativesに、InvocationMirror_invokeを追加
外部に公開したので、ZoneHandleを取りやめ、Handleへ置換。

r16186 | tball@google.com | 2012-12-15 09:20:07 +0900 (土, 15 12月 2012) | 7 lines
Second version of support for specifying an unhandled exception callback in Dart.
Isolate.spawnFunction optionally takes a callback parameter,
which is not resolved until an unhandled exception occurs.
If a callback wasn't specified, the VM will then call an "_unhandledExceptionCallback"
function if it is defined in the isolate's source file.
If no callback is provided, the error is logged as the isolate is closed.
Review URL: https://codereview.chromium.org//11558034
bootstrap_nativesのisolate_spawnFunctionが、1->2へ。
kIsolateUnhandledExceptionを追加。ObjectStoreにセット。

IsolateMessageHandlerに、ResolveCallbackFunction()と、UnhandledExceptionCallbackHandler()を追加
resolveは、MessageHandlerからunhandledExceptionCallbackをlookupしてfuncの実体をかえすだけ？

ProcessUnhandledException(const Object& message, const Object& result)
UnhandledExceptionCallBackをcallする。


r16175 | regis@google.com | 2012-12-15 04:04:01 +0900 (土, 15 12月 2012) | 3 lines
Implement Function.apply in vm (issue 5670).
Fix a closure parameter count check bug (unveiled by an apply test).
Review URL: https://codereview.chromium.org//11564029
bootstrap_nativesにFunction_apply追加。
! closure_obj.IsCallable()
Instance::IsCallable()追加。lookupしてfunctionとcontextを探して返すと。
Throwに使うんですけどね。。

r16152 | asiva@google.com | 2012-12-14 16:17:27 +0900 (金, 14 12月 2012) | 2 lines
Fix windows build.
Review URL: https://codereview.chromium.org//11566025
Dart_IsStringLatin1(str) -> str_obj.IdOneByteString()

r16150 | asiva@google.com | 2012-12-14 15:59:26 +0900 (金, 14 12月 2012) | 2 lines
Fix build break.
Review URL: https://codereview.chromium.org//11565028
sizeof(uint16_t) -> str_obj.CharSize()

r16149 | asiva@google.com | 2012-12-14 15:44:26 +0900 (金, 14 12月 2012) | 7 lines
Changes per discussion with Anton
- Add a new API call Dart_StringTolatin1 so that the contents of a
  string object that satisfies Dart_IsStringLatin1 can be gotten
- Tweak Dart_MakeExternalString to copy out the contents of the string
  for valid string objects that can not be externalized by the VM
(e.g strings in the VM isolate)
Review URL: https://codereview.chromium.org//11580003
DartAPIに、Dart_StringToLatin1追加
external向けの処理ははいっていないけど、TESTCASEに追加された。

r16127 | srdjan@google.com | 2012-12-14 01:27:09 +0900 (金, 14 12月 2012) | 2 lines
Increase optimziation counter threshold to 3000, improves dart2js preformance.
Review URL: https://codereview.chromium.org//11442059
え、、3000に変わった。

r16119 | vegorov@google.com | 2012-12-14 00:31:29 +0900 (金, 14 12月 2012) | 10 lines
Implement store to load forwarding.
Implementation is done on top of load to load forwarding.
In addition to killing loads stores now generate values for corresponding load ids.
To find load expression id corresponding to a store
we change KeyValueTrait of the map used for load numbering.
New trait allows to lookup a load by store.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11568011
LoadKeyValueTraitを作成し、loadとstore系をhashcode管理してgvnっぽくload/storeのみ辞書管理する。
冗長なloadの除去において、load store loadしていた場合、2回目のloadをskipしてstoreした値を使う。

r16117 | fschneider@google.com | 2012-12-14 00:24:32 +0900 (金, 14 12月 2012) | 5 lines
Store canonical type argments in a hash table instead of linear list.
The code closely follows the symbol table implementation,
but adjusted for use with TypeArguments objects.
Review URL: https://codereview.chromium.org//11474056
canonical type argumentってのができた。glowするarrayに情報を格納するらしい。
type argumentsの場合にhashcodeをどう扱うのかが悩みらしい。

r16114 | vegorov@google.com | 2012-12-13 23:48:30 +0900 (木, 13 12月 2012) | 6 lines
Never try to add 0 bytes to free list.
R=iposva@google.com
BUG=dart:7288
Review URL: https://codereview.chromium.org//11564015
pagesの修正。

r16109 | vegorov@google.com | 2012-12-13 23:10:38 +0900 (木, 13 12月 2012) | 12 lines
Improve redundant load elimination.
Previously it incorrectly computed OUT sets during the fix point iteration:
did not propagate changed from IN to OUT.
However just computing bitset representation of IN set was actually not enough
because different values might be coming in from different predecessors.
This algorithm inserts phis at merge points.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11505002
オプション、print_flow_graph_optimized=falseを追加。
LoadOptimizerクラスを新規作成。その前は、computeAvailableLoadメソッドだった。
LLVMのcorrespedvaluepropagationに似たアルゴリズムでloadのin/out集合を、bbを越えて伝搬して計算する。
ポイントは、branchで分岐する際に、true/falseそれぞれに伝搬することと、
合流ポイントで集合をmergeする。


r16084 | meh@google.com | 2012-12-13 09:42:19 +0900 (木, 13 12月 2012) | 12 lines
Move generate_perf_events_symbols flag to VM (new issue with @google address)
Changes reviewed and approved here:
https://chromiumcodereview.appspot.com/11490026
Created a new issue using meh@google.com instead of meh@chromium.org so I can commit to trunk.
Committed: https://code.google.com/p/dart/source/detail?r=16016
Review URL: https://codereview.chromium.org//11549011
DartApi.hから、Dart_InitPerfEventsSupport()を削除
genereate_perf_events_symbolsオプションを、main.ccからDart VMのオプションに変更。
Linuxに限り、/tmp/perf-%ld.mapを定義しているけど、、元からそうだしいいか。

r16083 | iposva@google.com | 2012-12-13 09:39:12 +0900 (木, 13 12月 2012) | 2 lines
- Remove duplicate declaration of flag.
Review URL: https://codereview.chromium.org//11548048
オプションの冗長な定義を削除。DEFINEとDECLAREが同じファイルに重なっていた。

r16075 | cshapiro@google.com | 2012-12-13 08:05:51 +0900 (木, 13 12月 2012) | 3 lines
Fix format type specifier discrepancies on 64-bit targets.
Review URL: https://codereview.chromium.org//11555032
%3d -> %3"pd"

r16074 | cshapiro@google.com | 2012-12-13 07:58:24 +0900 (木, 13 12月 2012) | 11 lines
Improve the reporting of scavenger and free list reports.
The scavenger now reports survival and promotion statistics.
The statistics for the large free list are now reported.  Previously,
only information about the small free list was printed.  Each report
indicates whether the data is from before or after a garbage collection,
each row of a report is preceded by the free list type (small or large),
and cumulative bytes are reported for the free list type.
Review URL: https://codereview.chromium.org//11416384
vervose_gcオプションを指定時、survivalレシオとpromotedレシオを計算して表示する。
FreeListのPrint機能も強化

r16069 | regis@google.com | 2012-12-13 07:33:15 +0900 (木, 13 12月 2012) | 2 lines
Fix type test for callable objects (issue 7338).
Review URL: https://codereview.chromium.org//11549027
TypeTest()において、FunctionのTypeTest()を再帰的に行う。

r16057 | kmillikin@google.com | 2012-12-13 04:52:47 +0900 (木, 13 12月 2012) | 11 lines
Refactor the InstanceFunctionLookupStub.
The stub is used in the case that an IC miss handler cannot find a cacheable target.
It handles implicit closures, calls to instance fields, and no such method.
Refactor the stub to make a single call into the runtime.
Review URL: https://codereview.chromium.org//11316353
GenerateInstanceFunctionLookupStubにおいて、
kResolveImplicitClosureFunctionRuntimeEntry や、
kInvokeImplicitClosureFunctionRuntimeEntry を呼び出していたのを、
InstanceFunctionLookupRuntimeEntryのみ呼び出すように修正。

code_generatorのほうも大幅に書き換え。
LookupDynamicFunctionを削除。

r16044 | fschneider@google.com | 2012-12-13 00:13:21 +0900 (木, 13 12月 2012) | 5 lines
Narrow result cid and type of BinarySmiOp to be always smi.
After smi-SHL was changed to deoptimize in case of overflow,
the result type can be narrowed to smi only.
Review URL: https://codereview.chromium.org//11557012
kSHLの場合も、SmiCidをResultCidに返すように修正。

r16040 | kmillikin@google.com | 2012-12-12 23:20:42 +0900 (水, 12 12月 2012) | 5 lines
Remove inadvertently duplicated code.
Review URL: https://codereview.chromium.org//11555016
冗長なコードを削除。

r16037 | fschneider@google.com | 2012-12-12 22:40:14 +0900 (水, 12 12月 2012) | 9 lines
Extend sminess propagator to process branch instructions.
When doing comparisons like (x == null) and the comparison
is dominated by a smi-check, we can fold the comparison away.
One example where this occurs is the List constructor where the length
parameter is checked for null. If not null, the length of the list
is fixed and known and can be used to eliminate bounds checks.
Review URL: https://codereview.chromium.org//11442053
SminessPropagatorにおいて、Branch命令だった場合に、SmiCidをBranchのinput側に伝搬する。

r16015 | asiva@google.com | 2012-12-12 11:52:14 +0900 (水, 12 12月 2012) | 5 lines
Dynamically Allocate the predefined handles structure in Symbols
so that an "exit" will not result in static destructors being run
and zapping the handles area while some other isolates are still running.
Review URL: https://codereview.chromium.org//11549010
VMHandlesから、ReadOnlyHandlesクラスに置換。predefined_handles_

r16009 | regis@google.com | 2012-12-12 09:48:58 +0900 (水, 12 12月 2012) | 2 lines
Support call operator in the vm.
Review URL: https://codereview.chromium.org//11316343
RUNTIME_ENTRYに、InvokeNonClosureを追加
普通のInvoke処理に見える。

StubCallClosureFunctionを呼び出した際に、
kReportObjectNotClosureRuntimeEntryを呼んでstopしていたのを、
InvokeNonClosureの呼び出しに置換。

r16008 | asiva@google.com | 2012-12-12 09:35:48 +0900 (水, 12 12月 2012) | 3 lines
Add dump_symbol_stats to dump symbol table stats at the end of a test run
when --trace-isolates --dump_symbol_stats is used.
Review URL: https://codereview.chromium.org//11416356
dump_symbol_statsオプションを追加し、DumpStats()を追加
あとはBucketsのCollision_countをdumpする。


r15942 | asiva@google.com | 2012-12-11 10:20:02 +0900 (火, 11 12月 2012) | 7 lines
Add read only handles for the following predefined symbols
"=="
"[]"
"[]="
"this"
and use them in the code.
Review URL: https://codereview.chromium.org//11519006
いろいろと専用のHandleが追加されている。最近Dotが追加されたけど、
EqualOperator
IndexToken
AssignIndexToken
This

r15941 | asiva@google.com | 2012-12-11 10:06:44 +0900 (火, 11 12月 2012) | 4 lines
Start a fresh zone and handle scope for each function being compiled in CompileAll
(currently handles and memory is not being released until all the functions are compiled).
Review URL: https://codereview.chromium.org//11280315
よくわからんけど、isolateをStackZoneでHanleしておる。

r15940 | cshapiro@google.com | 2012-12-11 09:50:31 +0900 (火, 11 12月 2012) | 3 lines
Provide a mechanism for dumping of heap profiles on predefined events.
Heap::ProfileToFIle()追加
class name string IDをひたすら書き込むらしい。
オプションは、heap-profile-initialize ???

r15939 | regis@google.com | 2012-12-11 09:31:53 +0900 (火, 11 12月 2012) | 2 lines
Pass the proper invocation mirror argument to noSuchMethod.
Review URL: https://codereview.chromium.org//11523002
ArgumentsDescriptorとnoSuchMethod関連
ポイントはArguments Array lengtに、oroginal receiverを含むところかな。

r15926 | asiva@google.com | 2012-12-11 04:28:14 +0900 (火, 11 12月 2012) | 2 lines
Restructure Add and SetAt to not create a Handle.
Review URL: https://codereview.chromium.org//11443024
GC向けのStorebufferの更新が、RawGrowableObjectArrayのSetAt()に追加。
value->IsNew() and data->IsOld()の場合に、StoreBufferにAddPointer()

r15920 | asiva@google.com | 2012-12-11 03:24:34 +0900 (火, 11 12月 2012) | 6 lines
- Create frame work for adding read only handles for symbols in the VM isolate
- Make the symbol corresponding to "." use this frame work and change code
  which was creating a handle to use the read only handle instead.
  (Once we agree on this frame work we could create similar read only handles
  for the frequently used symbols)
Review URL: https://codereview.chromium.org//11469036
Symbols::DotHandle()?
parser向けのHandle()、Symbols::Dot()をDotHandle()へ

r15919 | regis@google.com | 2012-12-11 02:59:40 +0900 (火, 11 12月 2012) | 4 lines
Rename GET_NATIVE_ARGUMENT macro to GET_NON_NULL_NATIVE_ARGUMENT.
Introduce new GET_NATIVE_ARGUMENT macro accepting null.  Add test.
Review URL: https://codereview.chromium.org//11468016
Rename GET_NATIVE_ARGUMENT macro to GET_NON_NULL_NATIVE_ARGUMENT.
GET_NATIVE_ARGUMENTは、IsNull()が含まれる。

r15890 | kmillikin@google.com | 2012-12-10 19:03:35 +0900 (月, 10 12月 2012) | 9 lines
Fix compilation on Windows.
Visual Studio reports that only static integral constants are allowed to be initialized in the class.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//11478047
kLoadFactorの追加

r15889 | kmillikin@google.com | 2012-12-10 18:48:52 +0900 (月, 10 12月 2012) | 7 lines
Cache lookups at megamorphic call sites in optimized code.
The function name and argument descriptor are mapped to a lookup cache
at compile time.  The cache maps class id to target function.  It is resizable.
Review URL: https://codereview.chromium.org//11299298
code_generatorに、MegamorphicCacheMissHandlerを追加。RuntimeEntry
他のMissHandlerと同じで、ResolveDynamicForReceiverClass()を呼びだし、CompileFunctionしたCodeを返す。

Objectに、MegamorphicCacheクラスを追加。
InitialCapacity=16, LoadFactor=0.75らしい。
set/getをみると、普通のArrayに見える。
set/getのindexは、calleeごとにdescriptor管理だと思われ。

vm/megamorphic_cache_tableを新規追加
LookUpでは、<name, descriptor, cache>なtupleをシーケンシャルサーチしている。
InitMissHandler()は面白い。StubCode::Generate()っていうの、他にあったっけ？ とおもったらMACROで生成していたのか。。
GC向けVisitObjectPointerでは、tupleの管理する全要素<name, descriptor, cache>をvisitする。
megamorphic_cache_table()の初期化、InitMissHandler()は、isolateの初期化時に行う。stubと一緒。

EmitMegamorphicInstanceCall
cachetableを取得し、LookUpしたCacheを取得。
loopで回りながら、tableからtarget_functionを探して呼び出す。

r15868 | srdjan@google.com | 2012-12-08 06:45:37 +0900 (土, 08 12月 2012) | 2 lines
Add code comments to slow paths.
Review URL: https://codereview.chromium.org//11475042
EmitにComments追加
Slow path(CheckStackOverflowSlowPath, BoxDoubleSlowPath, BoxIntegerSlowPath)コメント追加

r15850 | srdjan@google.com | 2012-12-08 02:59:53 +0900 (土, 08 12月 2012) | 2 lines
Cleanups based on Kevin's and Florian's suggestions.
Review URL: https://codereview.chromium.org//11481002
リファクタリング
ArgumentsDescriptor::NameAt(index)をMatchesNameAt(index, other)に変更

r15847 | iposva@google.com | 2012-12-08 02:18:22 +0900 (土, 08 12月 2012) | 2 lines
- Do not read past the end of the utf32_array.
Review URL: https://codereview.chromium.org//11447009
String::Equals()
has_moreフラグ追加して、共に終端に到達していたらequal

r15845 | kmillikin@google.com | 2012-12-07 22:00:38 +0900 (金, 07 12月 2012) | 8 lines
Reapply "Do not call ResolveCompileInstanceFunction from the lookup stub."
With a fix for a crash bug on x64.  The near jump encoding could fail on
some platforms due to platform-specific code.
Review URL: https://codereview.chromium.org//11476021
Argument Descriptor Array絡みの修正。
RUNTIME_ENTRYのResolveCompileInstanceFunctionを削除。
stubのアセンブラを修正。
GenerateInstanceFunctionLookupStubから、
kResolveCompileInstanceFunctionRuntimeEntryの呼び出しと、その結果raw_nullだった場合に走るパスを削除。
raw_nullだったレジスタを置換。

r15833 | asiva@google.com | 2012-12-07 10:41:53 +0900 (金, 07 12月 2012) | 4 lines
Return an unhandled exception error on an OOM or other errors while reading a message.
This ensures that we never call FindExceptionHelper with no dart invocation frames.
Review URL: https://codereview.chromium.org//11475012
snapshotのReadObjectでsetjmpでエラーを捕捉した場合、errorオブジェクトを返す。
ReadObjectのcallee側も、Errorのチェックを行い、UnhandledExceptionだった場合、
UnhandledExceptionCallbackを呼び出す。

r15821 | srdjan@google.com | 2012-12-07 08:27:01 +0900 (金, 07 12月 2012) | 2 lines
Fix failures in byte array tests, reenabled test.
Review URL: https://codereview.chromium.org//11471014
byte array testsのfix. getIndexedとsetIndexedのシンボルをbootstrap_nativesに追加。

r15814 | srdjan@google.com | 2012-12-07 07:30:08 +0900 (金, 07 12月 2012) | 5 lines
Windows complains:
'dart::RawUint8Array' : base classes cannot contain zero-sized arrays
Uint8ClampedArrayの継承クラスを、Uint8ArrayからByteArrayに変更。

r15807 | cshapiro@google.com | 2012-12-07 06:56:31 +0900 (金, 07 12月 2012) | 3 lines
Unify specification of file open, close, and write callbacks.
Review URL: https://codereview.chromium.org//11442024
FileOpenCallback, FileWriteCallback, FileCloseCallbackをIsolateのInitOnceに追加。
上記callbackは、Isolateごとに参照を保持する。
isolateからFileの操作は、perfと連携する際や、heap_profilerと連携する際に発生する。
関数アドレスやサイズ、シンボルをファイル出力しており、その際のcallbackになる。

r15806 | srdjan@google.com | 2012-12-07 06:53:51 +0900 (金, 07 12月 2012) | 2 lines
Added Uint8ClampedList. COmpielr optimziations to follow in next CL.
Review URL: https://codereview.chromium.org//11437028
kUInt8ClampedArrayCidを追加
kExternalUInt8ClampedArrayCidを追加
ごっそり追加。基本的にはUInt8系と同じ。

r15775 | fschneider@google.com | 2012-12-06 18:32:49 +0900 (木, 06 12月 2012) | 4 lines
Save a handle allocation in two accessor functions of class Type.
The ASSERT already makes sure, that we have the correct type at hand.
Review URL: https://codereview.chromium.org//11444008
不要なHandleを削除。

r15766 | vsm@google.com | 2012-12-06 09:27:04 +0900 (木, 06 12月 2012) | 8 lines
Refactored Android samples / embedder.
- Started moving generic embedder code from sample into runtime/embedders/android.
  I'd like to move more in a later CL.
- Removed dependence on vm/bin in sample.
Ivan or Siva: can one of you review the changes under runtime?
Review URL: https://codereview.chromium.org//11416343
android対応
OS::Print()が、__android_log_vprint()を使用してメッセージ出力。

r15764 | hausner@google.com | 2012-12-06 09:09:36 +0900 (木, 06 12月 2012) | 9 lines
Set BP in closurized function if necessary
If a function has been closurized, and both the regular function as well as
the closurized function are already compiled when the user sets a breakpoint,
then two code breakpoints have to be installed.
Fixed issue 2318.
Review URL: https://codereview.chromium.org//11446020
HasImplicitClosureFunction()を追加。
debuggerから、すでにcompileされたclosureが存在する場合、Breakpointを設定できる。
範囲指定は、target_functionと、first_token_pos ～ last_token_posか。

r15763 | asiva@google.com | 2012-12-06 08:37:37 +0900 (木, 06 12月 2012) | 7 lines
Issue - 7123
Rename
String::New(const uint8_t latin1_array......) to String::FromLatin1
String::New(const uint16_t utf16_array......) to String::FromUTF16
String::New(const int32_t utf32_array.......) to String::FromUTF32
Review URL: https://codereview.chromium.org//11443005
NewからFromXXにrename。
Symbols::NewSymbolメソッドを追加。

r15748 | srdjan@google.com | 2012-12-06 04:50:50 +0900 (木, 06 12月 2012) | 2 lines
Pass handles not raw objects into methods.
Review URL: https://codereview.chromium.org//11441021
ArgumentDescriptorのHandleや参照のもちかたを修正。
Handle()の修正、classがRawObjectの参照を持たないように置換
この辺の、raw dataとhandleと操作を分離した構造がまだよく理解できていない。。

r15737 | kmillikin@google.com | 2012-12-06 00:35:18 +0900 (木, 06 12月 2012) | 10 lines
Pass IC data and arguments descriptor to IC miss runtime functions.
Before, we obtained them by pattern matching backwards on the machine instructions at the call site.
This previous approach becomes unwieldy when we need to use to use multiple instance call patterns.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//11438017
この修正は、
vm/stubsのGenerateInstanceFunctionLookupStub()において、
ResolveCompileInstanceFunctionRuntimeEntryの引数に、ICDataとArgumentsDescriptorを追加。
CacheMissHandlerを呼び出す際にも、ICDataとArgumentsDescriptorを引数に追加
上記のcallerは、vm/code_generatorを修正。
ただし、この呼び出しのResolveCompileInstanceFunctionRuntimeEntryの呼び出しは、15845にて削除される。

vm/code_generator
ResolveCompileInstanceCallTargetを修正15845で削除される。
CacheMissHandler系の修正、引数にICDataとArgumentsDescriptorを取るように修正し、
InlineCacheMissHandlerに双方を引数で渡す。
最終的に、ResolveDynamicに渡して、miss後に呼び出しメソッドを探すのに使う。

vm/code_patcherにおいて、
GetInstanceCallIcDataAt()を削除し、GetInstanceCallAt()で代替

上記の修正をまとめると、IcDataとArgsDescをICMissHandlerに渡していなかったため、
resolveで解決できないケースがあったと？ これはArgsDescの修正が起因なのか、元々の仕様の修正なのか。

r15733 | vegorov@google.com | 2012-12-05 23:29:41 +0900 (水, 05 12月 2012) | 6 lines
Remove unused field AstNode::ic_data.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11438018
ast.hから、ICDataの参照を削除。

r15732 | fschneider@google.com | 2012-12-05 22:59:41 +0900 (水, 05 12月 2012) | 2 lines
Avoid unneccary handle allocation in OptimizeTypeArguments.
Review URL: https://codereview.chromium.org//11453008
ループの中で毎回Handle呼んでいたのをループの外に出した。

r15731 | vegorov@google.com | 2012-12-05 22:46:58 +0900 (水, 05 12月 2012) | 6 lines
Kill unused CodeGenInfo field in AstNode.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11447012
ast.hからCodeGenInfoクラスへの参照を削除。

r15727 | kmillikin@google.com | 2012-12-05 21:05:57 +0900 (水, 05 12月 2012) | 5 lines
Introduce a class encapsulating arguments descriptor arrays.
Review URL: https://codereview.chromium.org//11442010
修正量は多いが、処理が変わったわけではない。
ArgumentsDescriptor()メソッドでArrayを生成していたのを、
ArgumentDescriptorArrayクラスに置き換えた。

vm/dart_entryに、ArgumentsDescriptorクラスを追加
Array故の煩雑な操作を、メソッドに置き換えている。

Emitする際にも、ArrayからArgumentsDescriptorクラスのoffsetを参照するようになったため、
ia32 x64のemitメソッドに修正が入っている。

r15724 | kustermann@google.com | 2012-12-05 18:04:55 +0900 (水, 05 12月 2012) | 5 lines
Part of fix for http://dartbug.com/6528
Committed: https://code.google.com/p/dart/source/detail?r=15690
Review URL: https://codereview.chromium.org//11434106
Symbols::FromXXX()を追加。RawStringクラスにも、FromXXX()を追加。
XXXは、UTF8, Latin1, UTF16, UTF32,などなど。

r15711 | asiva@google.com | 2012-12-05 07:18:12 +0900 (水, 05 12月 2012) | 3 lines
Fix for issue 7089 (Symbols::New was not quite working correctly
when there are non ASCII Latin-1 characters in the string).
Review URL: https://codereview.chromium.org//11411341
NewからFromXXXへの置換がメイン。

r15710 | srdjan@google.com | 2012-12-05 06:52:02 +0900 (水, 05 12月 2012) | 2 lines
Improve C++ code for string splittig (Dromaeo benchmark).
Review URL: https://codereview.chromium.org//11308337
SubtringUnchecked()を追加。高性能な版のsubstring for one-byte stringらしい。
srcからdestにmemmoveする。

r15695 | fschneider@google.com | 2012-12-05 02:07:50 +0900 (水, 05 12月 2012) | 12 lines
Improve and fix constant propagation for type arguments.
Corretly match the constant propagator's analysis code for
InstantiateTypeArguments with the code generator template for it and handle
the case of NULL-type arguments.  This improves code like
new List()
in checked mode. The old code would only improve code with type arguments like
new List<type>();
Review URL: https://codereview.chromium.org//11416340
InstantiateTypeArgumentInstrにおいて、TypeArgumentに指定した型を元に、定数伝搬するように修正。

r15690 | kustermann@google.com | 2012-12-05 00:24:16 +0900 (水, 05 12月 2012) | 3 lines
Part of fix for http://dartbug.com/6528
Review URL: https://codereview.chromium.org//11434106
vm/libdart_dependency_helper.ccを追加。
空のmainが定義されている。

r15689 | fschneider@google.com | 2012-12-04 23:51:43 +0900 (火, 04 12月 2012) | 8 lines
Instantiate uninstantiated types with known constant type-arguments.
The enables eliminating more type-checks.
For type-checks that have a uninstantiated target type and a constant
instantiator type arguments as input, we can instantiate the type at compile-time.
Review URL: https://codereview.chromium.org//11280230
AssertAssignableInstrに、set_dst_type()を追加
uninstanceなAssign処理において、定数がtype-argumentの場合、null_contantでnull初期化

r15636 | johnmccutchan@google.com | 2012-12-04 00:25:07 +0900 (火, 04 12月 2012) | 3 lines
s/transferrable/transferable
Review URL: https://codereview.chromium.org//11434077
symbolをnewTransferrableからnewTransferableに変更

r15618 | asiva@google.com | 2012-12-01 09:34:19 +0900 (土, 01 12月 2012) | 3 lines
Partial cleanup towards fixing Issue 6726
(try to add all constants strings in the VM to the symbols list).
Review URL: https://codereview.chromium.org//11419261
.ccにでてくる文字列を、定義済みsymbolに置き換えて綺麗にしましたと。

r15615 | srdjan@google.com | 2012-12-01 09:22:18 +0900 (土, 01 12月 2012) | 2 lines
Added native to split OneByteString with a char code as pattern.
Review URL: https://codereview.chromium.org//11414273
シンボルOneByteString_splitWithCharCodeをbootstrap_nativesに追加。
15548の件か。

r15614 | srdjan@google.com | 2012-12-01 09:03:04 +0900 (土, 01 12月 2012) | 2 lines
Add result cid to StringFromCharCode.
Review URL: https://codereview.chromium.org//11412284
StringFromCharCodeInstrのResultCidを追加。kOneByteStringCid

r15612 | hausner@google.com | 2012-12-01 08:20:01 +0900 (土, 01 12月 2012) | 4 lines
Eliminate old style import from language tests
Also implement multi-part library names.
Review URL: https://codereview.chromium.org//11316283
libraryとimport文の,testでの全面的な置換。#は不要になった。
libnameに.があると、 malformed library name ???

r15604 | asiva@google.com | 2012-12-01 06:53:58 +0900 (土, 01 12月 2012) | 3 lines
Fix bug in Utf8::CodePointCount which was causing some strings with latin1
characters to be stored as TwoByteStrings.
Review URL: https://codereview.chromium.org//11419259
CodePointCount()をCodeUnitCount()に名称変更と、効率化。

r15603 | johnmccutchan@google.com | 2012-12-01 06:39:09 +0900 (土, 01 12月 2012) | 4 lines
Fix win32 build breakage
Change signature of OS::AlignedAllocate from using intptr_t to size_t
Review URL: https://codereview.chromium.org//11416291
r15598の修正。
macosの場合、mallocに置換。TODOでposix_memalignに戻す。

r15598 | johnmccutchan@google.com | 2012-12-01 05:35:22 +0900 (土, 01 12月 2012) | 3 lines
Expose transferable constructor to Int8List
Review URL: https://codereview.chromium.org//11414211
osの抽象IFに、AllocateAlignedArray(),AlignedAllocate(),AlignedFree()を追加。
winでは、_aligned_malloc() _aligned_free()を呼ぶと。
linuxでは、memalign()とfree()を呼ぶ。
androidでは、linuxと一緒。
macosでは、posix_memalign()とfree()

scalarlistのnative interfaceに、xxxArray_newTransferrable()を追加。
bytearrayにはtransferrable(int)が追加されている。
dart:scalarlistには何も追加されていないみたい。

r15589 | srdjan@google.com | 2012-12-01 02:19:42 +0900 (土, 01 12月 2012) | 2 lines
Add more spcific ranges for String length and charCode methods.
Review URL: https://codereview.chromium.org//11280248
StringBaseLengthからLoadFieldする際、RangeBoundary計算の追加。
StringCharCodeAtInstrにInferRange()を追加。

r15586 | kmillikin@google.com | 2012-11-30 22:29:42 +0900 (金, 30 11月 2012) | 6 lines
Increment CompilerStats::code_allocated when allocating in executable pages.
R=iposva@google.com
Review URL: https://codereview.chromium.org//11299247
compiler-statsオプション指定時、HeapPageにExecutableなコードを配置する際に、
code_allocated += size

r15585 | sgjesse@google.com | 2012-11-30 22:06:44 +0900 (金, 30 11月 2012) | 15 lines
Add support for surrogates when serializing and deserializing for native ports
As Dart allows creating string with UTF-16 surrogate code units which
are not always in lead/trail pairs,
we need to support this in the communication with native ports.
This change allows surrogate code units in messages to/from native
ports and supports them in the UTF-8 encoding used on the Dart_CObject
structure string representation.
R=ager@google.com, erikcorry@google.com, asiva@google.com
Review URL: https://codereview.chromium.org//11280150
twoByteStringを含んだMessageをReadする際に、 surrogateを考慮して、utf8のlenを計算する。
もしsurrogateを含んでいた場合、unsupport例外を投げる。

r15576 | kmillikin@google.com | 2012-11-30 20:53:44 +0900 (金, 30 11月 2012) | 6 lines
Enable building with VTune support on Windows.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//11419230
winでもVTuneをサポート。
gypiにOS==winを追加。

r15568 | cshapiro@google.com | 2012-11-30 12:33:37 +0900 (金, 30 11月 2012) | 3 lines
Move various top-level Unicode definitions into classes and methods.
Review URL: https://codereview.chromium.org//11414249
unicode周りの修正。主にリファクタリングでクラス構造を整理。
よく使う操作をAllStaticクラスのmethodに定義。

r15565 | cshapiro@google.com | 2012-11-30 11:36:19 +0900 (金, 30 11月 2012) | 3 lines
Use the code point iterator when computing 16-bit string hash codes.
Review URL: https://codereview.chromium.org//11412258
String::Hash(String&)の場合、CodePointInteratorを使用。
String::Hash(const uint16_t*)の場合、普通にindex iでループ

r15562 | regis@google.com | 2012-11-30 10:26:31 +0900 (金, 30 11月 2012) | 5 lines
Remove support for interfaces.
For now, disable tests using obsolete syntax.
Tests disabled in this cl and in previous ones removing default factory classes
will either be deleted or updated in a later cl.
Review URL: https://codereview.chromium.org//11411271
r15480に引き続き、Interface関連の削除。
interface()をabstract()に置き換えつつある。
もしくは、is_interface()から分岐するすべての処理を削除。特にparserの修正が多い。
intrinsicsのfootprint値が軒並み変更されてますね。。
最後に、tokenからinterfaceを削除と。

r15554 | asiva@google.com | 2012-11-30 08:43:47 +0900 (金, 30 11月 2012) | 6 lines
Fix StringBase_createFromCodePoints to correctly accept Latin-1 characters as one_byte_string.
Rename Dart_NewExternalUTF8String to Dart_NewExternalLatin1String,
this reflects the functionality correctly.
Review URL: https://codereview.chromium.org//11280241
Rename Dart_NewExternalUTF8String to Dart_NewExternalLatin1String,
にともない、テストデータのupperを0x7Fから0xFFに変更か？

r15553 | asiva@google.com | 2012-11-30 08:19:17 +0900 (金, 30 11月 2012) | 4 lines
When externalizing a string ensure that the basic tag bits are preserved.
Also make sure we do not try to externalize read only strings that are in
the VM isolate.
Review URL: https://codereview.chromium.org//11411204
Mark_ExternalStringでだめだったらエラーを投げると。

r15548 | srdjan@google.com | 2012-11-30 07:55:09 +0900 (金, 30 11月 2012) | 2 lines
Implement faster splitting with empty string as pattern.
Add special native for computing substring of OneByteString (preparation for instrinsic).
Review URL: https://codereview.chromium.org//11416270
intrinsics OneByteString_substringUnchecked
otherstringのsubstringだった場合、memmoveしてreturn

r15538 | asiva@google.com | 2012-11-30 04:28:22 +0900 (金, 30 11月 2012) | 8 lines
Fix for issue 6359 - Make snapshots platform independent.
The issue previously was that an instance size was stored a size in bytes,
similarly field offsets were stored as an offset in bytes.
This caused issues when generating the snapshot on one platform and reading it on another platform.
The VM has been changed to store the instance size as a size in words and the field offset as an offset in words.
Review URL: https://codereview.chromium.org//11421117
wordsサイズを意識して、プラットフォーム非依存に動作するように修正
x64buildのsmiは-(2^62) to (2^62)-1か。shift bitだから62ね。。

r15532 | hausner@google.com | 2012-11-30 03:33:45 +0900 (金, 30 11月 2012) | 4 lines
Eliminate support for old getter syntax
warn-legacy-gettersオプションを削除し、旧get構文が使えなくなった。

r15518 | vegorov@google.com | 2012-11-29 23:47:06 +0900 (木, 29 11月 2012) | 12 lines
Implement better side effect tracking for load-to-load forwarding.
Any field store can interfere only with stores to the same offset.
Indexed store can only interfere with indexed load.
This tracking is not yet used by LICM.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11280232
LoadField/StoreFieldのoffsetを取得し、GVNで、Load/Storeの副作用をoffsetを使って詳細に判定する。
load storeでkillされるloadを取得し、DataflowAnalysisにおけるlive variableが詳細に判定できる。

r15517 | vegorov@google.com | 2012-11-29 22:54:06 +0900 (木, 29 11月 2012) | 6 lines
Support VTune's JIT interface.
R=iposva@google.com
Review URL: https://codereview.chromium.org//11412106
新規追加ファイル
vm/code_observers.h
vm/code_observers.cc
vm/vtune.h
vm/vtune.cc

vm.gypi
OS=='linux'
-DDART_VTUNE_SUPPORT
-I<(dart_vtune_root)>/include

VuneCodeObserver::Notify()
  iJIT_Method_Load jmethod;
  jmethod.metho_id = iJIT_GetNewMethodID()
  jmethod.method_name = ...
  jmethod.method_load_address = ..
  jmethod.method_size = ..
  iJIT_NotifyEvent(iJVM_EVENT_TYPE_METHOD_LOAD_FINISHED, &jmethod);

code_observerに、VTUNE向けの処理と、perf向けの処理と、Pprof向けの処理と、GDB向けの処理が統合されてる。
perfとgdbは、text形式でファイルに直接出力
pprofは、elfgen経由でファイル出力

VTUNEのAPIは ここが詳しい。
http://software.intel.com/sites/products/documentation/hpc/amplifierxe/en-us/2011Update/lin/ug_docs/GUID-17D7238B-DD19-45DB-B5E0-D9B344D1BE96.htm

r15515 | fschneider@google.com | 2012-11-29 22:43:20 +0900 (木, 29 11月 2012) | 4 lines
Cleanup: Remove unused return value in OptimizeTypeArguments.
Instead use it to replace the bool*  output-parameter.
Review URL: https://codereview.chromium.org//11428079
上述のとおりリファクタリング

r15486 | srdjan@google.com | 2012-11-29 09:49:42 +0900 (木, 29 11月 2012) | 3 lines
Attempt to do direct class comparison for type checks using CHA.
Next step is to convert instanceof nodes to an integer comparison node,
which would then be automatically merged with branch.
Review URL: https://codereview.chromium.org//11348289
flow_graph_compilerに、TypeCheckClassEquality()を追加
r15472 is_implemented() return false
GenerateInlineInstanceof()において、
TypeCheckAsClassEquality()がtrueの場合、
type_cidを使用し高速なinstance of を生成する。

r15480 | regis@google.com | 2012-11-29 08:39:27 +0900 (木, 29 11月 2012) | 4 lines
Remove support for default factory classes.
For now, disable tests using obsolete syntax.
More will get disabled as support for interfaces is completely removed.
We may then permanently remove some tests,
while updating and reenabling others whose purpose is not related to interfaces.
object parser class_finalizerから、
default factoryとinterfaceの向けの処理をごっそり削除。
いろいろ言語仕様が変更されるんだっけ？mix-inのため？

r15477 | srdjan@google.com | 2012-11-29 07:57:26 +0900 (木, 29 11月 2012) | 2 lines
Add flag 'implements' to class, it is set anytime someone implements this class.
This is a way to recognize implicit interfaces in order to improve class checks.
Review URL: https://codereview.chromium.org//11348283
Objectに、ImplementedBitを追加
class load時(class_finalizer)で、set_is_implemented()を呼び出す。
is_implemented()を参照する処理は入っていない。

r15472 | regis@google.com | 2012-11-29 06:14:43 +0900 (木, 29 11月 2012) | 3 lines
Remove ClosureArgumentMismatch runtime entry in vm and
replace with call to noSuchMethod.
Review URL: https://codereview.chromium.org//11421134
RUNTIME_ENTRY ClosureArgumentsMismatchを削除
CopyParameter()において、ClosureArgumentsMismatch()を
CallNoSuchMethodFunctionLabel()に置き換え
CAMの中でExceptions::ThrowByType(Exceptions::kNoSuchMethod ...)していたのを、
CallNoSuchMethodFunctionLabel()に置き換え

r15447 | fschneider@google.com | 2012-11-28 20:22:23 +0900 (水, 28 11月 2012) | 5 lines
Improve constant propagation to handle InstantiateTypeArguments.
If the input to an InstantiateTypeArguments instruction is a constant
it can be eliminated and replaced with the constant.
Review URL: https://codereview.chromium.org//11299204
ConstantPropagationを拡張し、TypeArgumentsも対象に追加。
Constantかチェックして、伝搬する。

r15431 | asiva@google.com | 2012-11-28 10:36:04 +0900 (水, 28 11月 2012) | 4 lines
Rename the field type_arguments_instance_field_offset_ to
type_arguments_field_offset_ in preparation for calling it
type_arguments_field_offset_in_words_
Review URL: https://codereview.chromium.org//11316203
リファクタリングのみ。

r15428 | regis@google.com | 2012-11-28 10:11:29 +0900 (水, 28 11月 2012) | 6 lines
Enforce rule in vm that factory name must match enclosing class name.
This is a step towards removing support for obsolete default factory classes.
For now, disable tests using obsolete syntax.
More will get disabled as support is completely removed.
We may then permanently remove some tests,
while updating and reenabling others whose purpose is not related to default factory classes.
Review URL: https://codereview.chromium.org//11419191
MapImplementationから、Mapに変換。parserがシンプルになった。

r15427 | asiva@google.com | 2012-11-28 09:23:28 +0900 (水, 28 11月 2012) | 2 lines
Canonicalize all integer constants that we create by parsing a string.
Review URL: https://codereview.chromium.org//11348259
stringをparseして生成したIntegerおよびBigintを、old gen spaceに生成する。
NewCanonical()で、Newの際にHeap::kOldをつけてAllocate

r15404 | hausner@google.com | 2012-11-28 02:33:17 +0900 (水, 28 11月 2012) | 7 lines
Eliminate support of legacy type Dyamic
With this change, Dynamic is no longer implicitly converted to dynamic.
This change breaks code that still uses Dynamic.
Review URL: https://codereview.chromium.org//11419176
旧構文のDynamicのparserを削除。dynamicのみ。
warn-legacy-dynamic=falseオプションを削除

r15368 | iposva@google.com | 2012-11-27 14:41:14 +0900 (火, 27 11月 2012) | 2 lines
- Remove unneeded library tags when concatenating libraries.
Review URL: https://codereview.chromium.org//11411176
gypiの修正

r15359 | tball@google.com | 2012-11-27 09:33:21 +0900 (火, 27 11月 2012) | 2 lines
Commented out child isolate test until it's fixed with monitor.
Review URL: https://codereview.chromium.org//11419172
下記の修正。。

r15356 | tball@google.com | 2012-11-27 09:11:07 +0900 (火, 27 11月 2012) | 2 lines
Fixed race-condition in isolate test.
Review URL: https://codereview.chromium.org//11411186
isolateのtestにSleep追加

r15352 | tball@google.com | 2012-11-27 08:31:47 +0900 (火, 27 11月 2012) | 5 lines
Added support for isolate unhandled exceptions.
isolateのInitOnceに、Dart_IsolateUnhandledExceptionCallbackの初期化を追加
setter/getter 呼び出し処理も追加
isolateにcallbackが追加できるようになりました。

r15332 | srdjan@google.com | 2012-11-27 03:35:45 +0900 (火, 27 11月 2012) | 8 lines
Fix for issue 6678: Result of identical(a, b) with a and b doubles not consistent.
Implement proposed new identity spec (flag --new_identity_spec).
It will be enabled/committed once the new spec been confirmed.
The new spec says that identity of numbers is computed
on their values instead of on the object reference.
This provides deterministic behavior without having to disable optimizations in the VM.
In some cases 'identical' is now slower than 'equality' as more checks need to be done.
The VM compiler can optimize 'identical' in the future.
My benchmarks do not show any slow down.
Review URL: https://codereview.chromium.org//11414136

StrictCompareInstrの修正。
ia32/x64に、EmitEqualityRegRegCompareと、EmitEqualityRegConstCompareを追加
オプションnew_identify_spec=trueでデフォルト有効になる。
比較の一方が"not" boxable number(Mint, Double, Bigint)だった場合、number_checksは不要。
例をあげると、smi, unboxedDouble, unboxedMintくらいかな？
number_checksが必要な場合、call(StubCode::IdenticalWithNumberCheck呼び出しなので、若干遅い。
50asmくらいか。 型ごとの分岐が多いので悩ましい処理。
後で型ごとに特殊化したメソッドを用意するのだと思う。

右辺左辺のどちらかがsmiの場合、ただcmplして終了。10asm
双方が異なる型だった場合、比較終了。10-20asmくらい。
双方Doubleの場合、this比較、double値比較して、20asm
双方Mintの場合も似たような処理。 25asm
Bigintが混ざっていたら、call kBigintCompareRuntimeEntry


r15330 | iposva@google.com | 2012-11-27 03:08:08 +0900 (火, 27 11月 2012) | 2 lines
- Do not visit length and hash of string objects. They are guaranteed to be Smi.
Review URL: https://codereview.chromium.org//11299170
RawXXByteStringが、HeapにいたらASSERT？
!isHeapObject()が正しいのか。。
何かすごい勘違いをしている？ Peerにいく？

r15316 | srdjan@google.com | 2012-11-27 02:00:51 +0900 (火, 27 11月 2012) | 2 lines
Throw OutOfMemory instead of crashing when bigint multiply overflows.
Review URL: https://codereview.chromium.org//11299173
bigintのmultiplyにおいて、 kMaxDigitsより大きかったら、out_of_memoryの例外を投げる。

r15310 | srdjan@google.com | 2012-11-27 01:09:50 +0900 (火, 27 11月 2012) | 3 lines
Cleanups and added more checks for valid Integer allocation
(must be Smi, Mint or Bigint for their corresponding range).
Integer boxing in compielr seems to check correctly fro smi/mint.
Can you think of any other places where we could create incorrect Mints or Bigints?
Review URL: https://codereview.chromium.org//11421064
Bigint::Newにおいて、入力のstrがMintの範囲内の値だったらASSERT
Bigint::New(int64_t を削除。MintからBigintは生成させない。

r15305 | fschneider@google.com | 2012-11-26 20:50:07 +0900 (月, 26 11月 2012) | 12 lines
Support loads from Uint8Array and ExternalUint8Array in the optimizing compiler.
This is done by extending LoadIndexed to handle Uint8Array and ExternalUint8Array.

Small cleanups:
- Share code for computing the element addresses for indexed loads.
- Remove kGrowableArrayCid where it cannot occur.
  We only ever emit LoadIndexedInstr for fixed-size arrays.
  Loads from growable arrays are split into loading the backing store first
  and then an indexed load from the backing store.
Review URL: https://codereview.chromium.org//11411142
Uint8Array, kExternalUint8ArrayCidのLoadIndexedInstrをサポート
CompileTypeはIntType
ResultCidはkSmiCid
representationは、kTagged
inferRange()は、0-255を返す。
配列のlengthは、length_offset()に格納されている。
ia32/x64向けに、Emitを追加
external系は初追加

kExternalUint8ArrayCidのLoadIndexedInstr
SmiUntag index
movl resultReg, FieldAddress(array, external_data_offset())
movl resultReg, Address(result, data_offset()) <-- 2回間接参照なんだっけ、、1回だと思っていた。
movzxb resultReg, resultReg, index, TIMES_1
SmiTag resultReg  //smi tagging
SmiTag index   //indexがレジスタに乗っていたら戻す。

kUint8ArrayCidのLoadIndexedInstr
SmiUntag index
movzxb resultReg, array, index
SmiTag resultReg  //smi tagging
SmiTag index   //indexがレジスタに乗っていたら戻す。

kGrowableObjectArrayCidを削除
いらない子に。


r15291 | vegorov@google.com | 2012-11-24 01:04:34 +0900 (土, 24 11月 2012) | 10 lines
Heuristically predict interference on the back edge
and use it to minimize number of register reshuffling which is especially expensive
when cycles of XMM registers arise.
When allocating free register check if hint can potentially interfere on the back edge
try ignoring hint and search for a better candidate.
Additionally fix handling of constants in the liveness analysis
to accommodate constants used as immediates.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11418135
ReachingDefsクラスを追加して、
PhiInstrのinputを上側に辿って、到達定義のindexをbitvector管理
inputにさらにphiがいたら、phiの集合をマージする。
PhiInstr命令にBitVector* reaching_defsを追加して、PhiInstrにフィードバックする。

AllocateFreeRegister()
loop_headerにおいて、backedgeからのvregがある場合、
ループのphiの到達定義に、liverangeが含まれない場合、レジスタ割り当て候補とする。
ループのバックエッジからの候補は、ループヘッダでの新規割り当ての優先度を下げる。

r15261 | ager@google.com | 2012-11-23 00:00:24 +0900 (金, 23 11月 2012) | 9 lines
Port intrisification of setIndexed on Uint8 and Int8 arrays from ia32 to x64.
This is a direct port of the ia32 intrinsifier.
We noticed this was missing when looking at HTTP benchmark profiles.
R=fschneider@google.com,srdjan@google.com
Review URL: https://codereview.chromium.org//11415116
ia32からx64へポーティング、intrinsifierを修正
Int8Array_setIndexed()
Uint8Array_setIndexed()
ia32では、EBXとEDIにarray indexを保持していたけど、
x64だと余分なレジスタがあるので、R12でindexを保持して、spillが1命令少ない。

r15254 | erikcorry@google.com | 2012-11-22 21:51:14 +0900 (木, 22 11月 2012) | 6 lines
Fix Unicode issues in dart2js and dart2dart.
R=floitsch@google.com
Review URL: https://codereview.chromium.org//11418115
テストコードのみ修正。

r15253 | fschneider@google.com | 2012-11-22 21:46:57 +0900 (木, 22 11月 2012) | 4 lines
Only require SSE2 at minimum hardware requirement.
BUG=dart:6010
Review URL: https://codereview.chromium.org//11416136
x64は、least SSE2
sse3 supportオプションは廃止し、ia32もsse2を前提条件
つかsse3のコードそのままでいいんすかね。。

r15246 | fschneider@google.com | 2012-11-22 21:06:52 +0900 (木, 22 11月 2012) | 10 lines
Inline [] operator on one-byte strings.
str[i] is translated into
temp = str.charCodeAt(i)
result = StringFromCharCode(temp);
The existing code for charCodeAt is reused and contains
the necessary range class id and range check.
Review URL: https://codereview.chromium.org//11416129
RECOGNIZEにStringBaseCharAt追加。optimizerでStringFromCharCodeInstr命令に変換。
Emitの様子. キャッシュは15088参照。
movl result, immediate(Symbols::PredefinedAddresses()) <-- テーブルに全部キャッシュ済み
movl result, Address(result, char_code, xxxx);

r15242 | iposva@google.com | 2012-11-22 16:54:21 +0900 (木, 22 11月 2012) | 4 lines
Fix bug 6467:
- Do not attempt to Dart_ExitScope if no scope exists.
- Print more informative message if Dart_Initialization fails.
Review URL: https://codereview.chromium.org//11308166
InitOnce()の返値が、boolからエラーメッセージのconst char* に変更

r15241 | iposva@google.com | 2012-11-22 16:54:00 +0900 (木, 22 11月 2012) | 2 lines
- Make RawObject::tags_ private.
Review URL: https://codereview.chromium.org//11411139
tags_がprivateになった。

r15240 | ajohnsen@google.com | 2012-11-22 16:40:52 +0900 (木, 22 11月 2012) | 7 lines
Make List an abstract class.
This was the last interface in dart:core.
Review URL: https://codereview.chromium.org//11417051
ListImplementationを削除。Listで置き換え。

r15233 | regis@google.com | 2012-11-22 09:14:08 +0900 (木, 22 11月 2012) | 3 lines
Ambiguous type references require a compile time error in some special cases (fix issue 6741).
Review URL: https://codereview.chromium.org//11348188
parserのエラーチェック条件を変更
finalizerでの、malformed type argumentsの引数チェックを削除。

r15230 | srdjan@google.com | 2012-11-22 07:46:38 +0900 (木, 22 11月 2012) | 2 lines
Reenable function source fingerprint checks.
Added checks to MethodRecognizer.
Review URL: https://codereview.chromium.org//11412137
RECOGNIZED_LISTもfingerprint対象に。MACRO定義時に値埋め込み。
fingerprintのチェックを有効にした。

r15218 | srdjan@google.com | 2012-11-22 04:27:44 +0900 (木, 22 11月 2012) | 2 lines
Fix build on Linux. Disable fingerprint checking as the finger prints changed.
Review URL: https://codereview.chromium.org//11308146
CheckFingerprint()の内部処理をコメントアウト...!?

r15217 | srdjan@google.com | 2012-11-22 04:15:54 +0900 (木, 22 11月 2012) | 3 lines
Use fingerprint to detect changes in methods that are intrinsified.
Make sure that the fingerprints are portable across 32 and 64 bit platforms.
Review URL: https://codereview.chromium.org//11421024
INTRINSIC_LISTに、予めfingerprintの値を埋め込んでいる。
Intrinsifer::Intrinsify()で呼び出しの際に、ASSERTでチェックする。

r15210 | hausner@google.com | 2012-11-22 02:23:35 +0900 (木, 22 11月 2012) | 5 lines
Remove abstract from class members in dart libraries
Add VM flag to produce compile error for explicitly
defined abstract class members.
Review URL: https://codereview.chromium.org//11299121
parserの修正
fail_legacy_abstract=falseオプションを追加
trueの場合、旧構文を使用時ErrorMessage("illegal use of abstract")

r15200 | ager@google.com | 2012-11-22 00:35:15 +0900 (木, 22 11月 2012) | 12 lines
Intrinsify ExternalUint8Array.[].
This helps the HTTP parser quite a bit. I was playing around with
it and thought I might as well upload it for review.
Feel free to take over the changelist if I'm doing this wrong.
In that case you should see this as a request for intrinsification of
ExternalUint8Arrays. :-)
R=fschneider@google.com,srdjan@google.com
Review URL: https://codereview.chromium.org//11280121
intrinsifierに、ExternalUint8 getIndexed追加
movzxすると。
配列添字、EBXをuntagしたままでよいのでしょうかね。。
もしかして俺の勘違いで、untagをtagしなおすルールでなく、使いっぱなしなんだっけ？
それともLocationの定義次第か。

r15189 | cshapiro@google.com | 2012-11-21 10:05:52 +0900 (水, 21 11月 2012) | 5 lines
Resolve C++11 narrowing conversion errors when compiling with GCC 4.7.
BUG=4495
Review URL: https://codereview.chromium.org//11418107
char* = 0xedから、const char* = \xED
みたいな記述に変更。

r15188 | cshapiro@google.com | 2012-11-21 09:30:27 +0900 (水, 21 11月 2012) | 3 lines
Use a signed 32-bit integer for representing code points.
Review URL: https://codereview.chromium.org//11419086
uint32_t*からint32_t*に全置換

r15185 | cshapiro@google.com | 2012-11-21 08:46:05 +0900 (水, 21 11月 2012) | 3 lines
Use the code point iterator in equality comparisons to C strings.
Review URL: https://codereview.chromium.org//11418095
CodePointIterator に置換。

r15182 | srdjan@google.com | 2012-11-21 08:00:32 +0900 (水, 21 11月 2012) | 2 lines
Add source fingerprint computation to function.
Will be used to detect unexpected changes of functions in internal library
(e.g, the ones used for intrinsification)
Review URL: https://codereview.chromium.org//11416120
SourceFingerPrint() const を追加
Scriptをtoken単位でiterateして、hash計算。^は使わず、*31と加算のみ。

r15178 | regis@google.com | 2012-11-21 04:55:05 +0900 (水, 21 11月 2012) | 2 lines
Address review comments of https://codereview.chromium.org/11299020/
Review URL: https://codereview.chromium.org//11418098
from 14997
Isolate::Current()->object_store()->list_class()を
IsListClass()メソッドに抽出してリファクタリング

r15166 | cshapiro@google.com | 2012-11-21 03:08:17 +0900 (水, 21 11月 2012) | 3 lines
Use the Equals method for C strings when comparing against C strings.
Review URL: https://codereview.chromium.org//11416094
parserをちょこっと修正

r15162 | johnmccutchan@google.com | 2012-11-21 02:37:07 +0900 (水, 21 11月 2012) | 3 lines
Add support for XMM8..XMM15
Review URL: https://codereview.chromium.org//11358262
assembler_x64に、xmm8..xmm15をサポート

r15136 | lrn@google.com | 2012-11-20 18:21:52 +0900 (火, 20 11月 2012) | 9 lines
Remove NullPointerException.
Accessing non-existing members on null now throws NoSuchMethodError.
Throwing a null value fails by throwing a NullThrownError.
Methods checking for null now generally throw new ArgumentError(null).
Committed: https://code.google.com/p/dart/source/detail?r=15061
Review URL: https://codereview.chromium.org//11415028
kNullPointerと、kArgumentErrorを削除、kNullThrownを追加。
kNullPointer->kNullThrownに置換

r15128 | cshapiro@google.com | 2012-11-20 11:37:21 +0900 (火, 20 11月 2012) | 7 lines
Correct a misnomer regarding supplementary code points.
The supplementary multilingual plane (SMP) code points were assumed to
be equivalent supplementary code points.
In fact, smp code points are a small subset of all supplementary code points.
Review URL: https://codereview.chromium.org//11299084
IsSmpSequenceStartがIsSupplementarySequenceStart()に置き換え？

r15126 | srdjan@google.com | 2012-11-20 09:04:08 +0900 (火, 20 11月 2012) | 2 lines
Remove loading of function object in static calls.
Review URL: https://codereview.chromium.org//11419073
PatchStaticCallから、PatchStaticCallAt()の呼び出しに置き換えている。15101の修正が元。
StaticCallクラスの拡張。target()とset_target()を追加。

GenerateCallXXXStaticFunctionStub()や、いくつかシンプルになった。
XXXStaticCallの呼び出しを生成する際に、Frameの一部にresult用の領域を予めpushしておく。
RuntimeEntryのXXXStaticCallのにおいて、setReturn(target)で設定する。


r15122 | hausner@google.com | 2012-11-20 08:46:23 +0900 (火, 20 11月 2012) | 4 lines
Proper reporting of illegal characters in source code
Fixes bug 6778.
Review URL: https://codereview.chromium.org//11417074
utf8でerrormessageを返すように修正

r15113 | hausner@google.com | 2012-11-20 06:34:53 +0900 (火, 20 11月 2012) | 5 lines
Fix bug 6713
Ensure that we find the correct closure type class when re-parsing
a nested function or closure.
Review URL: https://codereview.chromium.org//11420066
LookUpLocalClass()の追加し、function parse時に検索する。

r15109 | cshapiro@google.com | 2012-11-20 05:57:14 +0900 (火, 20 11月 2012) | 3 lines
Provide a code point iterator to the String class to simplify iteration.
Review URL: https://codereview.chromium.org//11416054
CodePointIterator追加
for (xxx; i<str.Length()を、iteratorで置き換え。
Utf16クラスを追加。
OneByteString::EscapeSpecialCharacters()で使っている。

r15101 | srdjan@google.com | 2012-11-20 04:17:02 +0900 (火, 20 11月 2012) | 2 lines
Simplify CodePatcher::GetStaticCallAt.
Review URL: https://codereview.chromium.org//11411072
GetStaticCallTargetAt()になって、コードがシンプルに。必要なaddressのみ取得するようになった。
PatchStaticCallは1回まで。

r15091 | srdjan@google.com | 2012-11-20 01:39:07 +0900 (火, 20 11月 2012) | 2 lines
First part of static call cleanup:
store static call targets into code object, referenced by code-offset.
Review URL: https://codereview.chromium.org//11418046
UpdateResolvedStaticCall()を削除。
Codeオブジェクトのrawがstatic_callsを保持することは変わらないが、
名称がstatic_calls_target_table_に変更。code_generatorから、raw_object側にコードを移した。
PatchStaticCallやFixCallerTargetの他にも、
EmitStaticCall()の中で、 Add(const Function& func)をRuntimeに呼び出すコードを埋め込む。

r15088 | fschneider@google.com | 2012-11-20 01:06:19 +0900 (火, 20 11月 2012) | 7 lines
Add one-char string table for faster String.charAt to the VM.
This is used for a fast lookup when executing String.charAt.
Currently it is only used in the C-runtime,
but the plan is to generate optimized code for the table lookup for speeding up String.charAt.
Review URL: https://codereview.chromium.org//11369259
predefined_というキャッシュを作って、配列のindexで参照してかえす。

r15086 | sgjesse@google.com | 2012-11-19 23:58:26 +0900 (月, 19 11月 2012) | 9 lines
Always zero-initialize array used for mapping VM symbols to Dart_CObject
NULL pointer checks are used to check for valid entries.
TBR=ager@google.com
Review URL: https://codereview.chromium.org//11280059
下記のvm_symbol_referencesを、DEBUG時に0初期化する。

r15082 | sgjesse@google.com | 2012-11-19 23:02:25 +0900 (月, 19 11月 2012) | 10 lines
Deserialize same symbol as same Dart_CObject
When symbols are deserialized as part of a Dart_CObject the same
symbols are now turned into the same Dart_CObject objects.
R=ager@google.com
Review URL: https://codereview.chromium.org//11415048
ApiMessageReaderにおいて、VMSymbolをvm_symbol_references_にキャッシュするように修正


r15058 | iposva@google.com | 2012-11-19 15:12:32 +0900 (月, 19 11月 2012) | 2 lines
- Remove obsolete random number generator from the VM code.
Review URL: https://codereview.chromium.org//11417049
vmのintrinsicとして用意されていた、random系を削除。
runtime/libをつかえと。

r15048 | asiva@google.com | 2012-11-17 10:48:45 +0900 (土, 17 11月 2012) | 3 lines
Change the library directive syntax in the VM unit tests, to the new format.
Review URL: https://codereview.chromium.org//11412048
importの構文が、#import ('dart:xx'); -> import 'dart:xx';
旧構文でも動くけど、旧構文だとEditorでコンパイルエラーになる。
testのscriptを書き換え。

r15032 | iposva@google.com | 2012-11-17 04:42:02 +0900 (土, 17 11月 2012) | 3 lines
- Move MathNatives from dart:core to dart:math.
- Split out double and integer parsing from MathNatives.
  Review URL: https://codereview.chromium.org//11316031
dart:coreとdart:mathの、dartのAPIとccのAPIを整理しているのか。
Integer/Double parse系の処理、IsValidLiteral()をnativeに追加。
Math系のbootstrap nativeのシンボル、MathNatives_xxがMath_xxに置換。

r14997 | regis@google.com | 2012-11-16 10:31:15 +0900 (金, 16 11月 2012) | 4 lines
Make creation of list literal more resilient to changes in the underlying
dart implementation of List in the core library.
Do the same for map literal creation.
Review URL: https://codereview.chromium.org//11299020
ListInterfaceから、ArrayTypeに変わった。
基本的にはvm内部でlistではなく、arrayとして扱うためのリファクタリング。listはcore library側。
vmはlistをimplしているわけではないので。
parser周りのfactoryの修正も多い。

r14993 | hausner@google.com | 2012-11-16 09:57:09 +0900 (金, 16 11月 2012) | 7 lines
Disallow const native factories
We removed the only user of const native factory methods, so remove the hack in the VM.
Issue 6662.
Review URL: https://codereview.chromium.org//11414019
parserの修正
const factoryがruntime error
constructor or factoryに制御を分けていたのを、
FactoryOrConstructorという一括りにして、整理

r14989 | asiva@google.com | 2012-11-16 09:13:18 +0900 (金, 16 11月 2012) | 3 lines
Revert OneByteString back to ISO Latin-1 instead of ASCII
as webkit supports ISO Latin-1 and UTF-16 encodings for strings.
Review URL: https://codereview.chromium.org//11365243
Ascii -> Latine1 に伴い、<= 0x7F -> <= FF
decodeが大きく変わった。 DecodeToLatin1()
MessageのOneByteStringやStringも、Latine1に置き換えられた。

r14978 | asiva@google.com | 2012-11-16 06:37:26 +0900 (金, 16 11月 2012) | 3 lines
- Add functionality to morph a string into an external string
- Add Dart API call Dart_MakeExternalString
Review URL: https://codereview.chromium.org//11360114
dart_api_implに追加
Dart_StringStorageSize()
Dart_MakeExternalString()
ExternalOneByteString::Newの、UnusedSpaceに関する処理をリファクタリング。
併せてMakeExternalString()を作成し、UnusedSpaceの処理を挿入。

MakeUnusedSpaceTraversable()というのを使うと、
GC中にTraverse可能なunused spaceを生成。これはArrayかInstanceとして作成可能。
original_size - used_sizeが、unusedSpaceになる。
unusedSpaceのサイズによって、ArrayかInstanceとして作成するか決まる。

MakeUnusedSpaceTraversable()は、MakeExternalStringか、ExternalOneByteString::Newから呼ばれる。
ExternalStringのunusedspaceは、GC中にtraverseできると？何かに活用するんだっけ？

MakeExternal()は、used_sizeはInstanceSize(), original_sizeは、str_lengthになる。
その差分をすべてunusedspaceとする。
普通のStringはstrlenのサイズだけメモリが必要だったが、
ExternlStringの場合、InstanceSize()のtopだけのメモリのみ確保し。
Stringのbody部分は、memmoveで、void*arrayにコピーしてしまう。
top以外の残った領域をunusedSpaceとする。
kOneByteStringCidとkTwoByteStringCidでのみ使用可能。

Externalな領域は、AddFinalizer()で、FinalizablePersistentHandle* weak_refから参照される。
externalな領域は、GCのpeerで管理する。
peerはGCで特別に管理する集合だった気がする。

r14951 | ager@google.com | 2012-11-15 20:03:02 +0900 (木, 15 11月 2012) | 10 lines
Don't copy Int8Arrays when passing them in as lists of bytes and don't
call from C to Dart to get the values either.
Just copying the values over as is will behave the same as it does
now and will be a lot faster.
R=sgjesse@google.com
Review URL: https://codereview.chromium.org//11418004
Int8ArrayとExternalInt8Arrayは、Uint8と同様にRangeCheckしてcopyする。

r14948 | iposva@google.com | 2012-11-15 18:15:14 +0900 (木, 15 11月 2012) | 2 lines
- Make sure to add predefined symbols into the current symbol table after growth.
Review URL: https://codereview.chromium.org//11308032
副作用を考慮してループの中にいれましたということ？

r14943 | sgjesse@google.com | 2012-11-15 17:16:27 +0900 (木, 15 11月 2012) | 7 lines
Address comments to r14887
TBR=iposva@google.com
Review URL: https://codereview.chromium.org//11308031
リファクタリングかな。

r14939 | asiva@google.com | 2012-11-15 10:51:50 +0900 (木, 15 11月 2012) | 2 lines
Fix build failure on linux.
Review URL: https://codereview.chromium.org//11366257
r14937 NativeArgAt()のミス。

r14938 | srdjan@google.com | 2012-11-15 10:36:04 +0900 (木, 15 11月 2012) | 2 lines
Address Florian's comments: use restricted lazy deoptimization, fix typo.
Review URL: https://codereview.chromium.org//11364245
r14934のDeoptimizeIfOwner()を使いましょう。

r14937 | hausner@google.com | 2012-11-15 10:14:01 +0900 (木, 15 11月 2012) | 7 lines
Fix native argument handling
Native functions need to fetch arguments differently if they are called through a closure.
fixes issue 6696.
Review URL: https://codereview.chromium.org//11293290
closure内からのnative argumentに対する扱い
14698からみかな？
closureの場合、native argに普通の方法ではアクセスできない。
おまけにhidden args=1が存在するらしい。
native argsは、 closure functionではなく、contextが管理しているらしい。

r14936 | asiva@google.com | 2012-11-15 10:14:07 +0900 (木, 15 11月 2012) | 3 lines
Do not try to write ContextScope into a snapshot.
(partially addresses issue 6358).
Review URL: https://codereview.chromium.org//11275336
ContextScopeのSnapshot Read/Writeがなくなった。

r14935 | cshapiro@google.com | 2012-11-15 10:05:48 +0900 (木, 15 11月 2012) | 3 lines
Fail new space promotions only when old space is truly exhausted.
Review URL: https://codereview.chromium.org//11363226
TryAllocate()に、PageSpace::GrowthPolicy growth_policy = PageSpace::kControlGrowth
を追加。
new space promotionに失敗した場合、PageSpace::kForceGrowthをつけて、再度チャレンジ

r14934 | srdjan@google.com | 2012-11-15 09:41:53 +0900 (木, 15 11月 2012) | 2 lines
Upon script loading deoptimize only functions whose owener has been subclassed,
as that is the only CHA optimizations being applied to the code at the moment.
Review URL: https://codereview.chromium.org//11365273
DeoptimizeIfOwner()を追加
リファクタリングして、DeoptimizeAt()を追加

scriptのowenerはどういう条件下だろうか。
loadされたscriptおよびそのsubclass群を呼び出しているfunctionのことかな。
全部ではなく、対象を絞ってdeoptimizeすると。

ownerは、classloadingの直後であるclass_finalizerで収集する。

r14926 | asiva@google.com | 2012-11-15 08:14:41 +0900 (木, 15 11月 2012) | 5 lines
Throw illegal argument exception when
- objects which extend NativeWrapper are passed in isolate messages
- closure objects are passed in isolate messages
  (issues 6108, 6312)
Review URL: https://codereview.chromium.org//11293163
SnapshotWriterで失敗するケースを追加
Writerの引数が、IsSignatureClass()か、IsNativeArgumentの場合、
ArgumentExceptionを投げる。投げるといっても、setjump,longjumpだが。

r14916 | regis@google.com | 2012-11-15 04:56:39 +0900 (木, 15 11月 2012) | 2 lines
Fix result type checking of redirecting factory in checked mode (issue 6596).
Review URL: https://codereview.chromium.org//11404004
tests/language/factory_redirection_test.dartを参照するとわかりやすいかも。
parserの修正。
redirect_functionだった場合、かつSubTypeをもつ場合、エラーらしい。

r14905 | regis@google.com | 2012-11-15 02:33:50 +0900 (木, 15 11月 2012) | 2 lines
Never compile a redirecting factory (issue 6697).
Review URL: https://codereview.chromium.org//11377164
IsRedirectingFactory()はCompileFunction()しないらしい。どういうこった。

r14887 | sgjesse@google.com | 2012-11-14 22:01:57 +0900 (水, 14 11月 2012) | 15 lines
Add support for non ASCII strings when communicating with native ports.
The string representation in a Dart_CObject strructure is now UTF8.
All strings read are now converted to UTF8 from either ASCII or UTF16 serialization.
All strings posted should be valid UTF8 and are
serialized as either ASCII or UTF16 depending on the content.
Proper andling of surrogate pairs is missing, but will be added when
https://codereview.chromium.org/11368138/ lands.
R=ager@google.com, erikcorry@google.com, asiva@google.com
Review URL: https://codereview.chromium.org//11410032
PostCObject()でApiMessageWriterでSerializationに失敗した場合、return false
kTwoByteStringCidの場合、
CObjectのreaderでUtf8::Encode, CObjectのWriterでDecodeToUTF16

r14873 | regis@google.com | 2012-11-14 13:28:02 +0900 (水, 14 11月 2012) | 3 lines
Remove private class helping the parser to construct literal lists and maps.
Patch List and Map (implementation) classes with literal factories.
Review URL: https://codereview.chromium.org//11369234
List._fromLiteral, _HashMapImpl, Map._fromLiteral
がprivateになって、Recognizerで再定義された。

r14872 | fschneider@google.com | 2012-11-14 08:45:23 +0900 (水, 14 11月 2012) | 6 lines
Enable inlining of functions containing instance-of.
The corresponding issues have been fixed and all tests pass now.
BUG=dart:5216,dart:5217
Review URL: https://codereview.chromium.org//11369230
どういうことかわからないけど、inliningのbailoutが1個外れた。
他でissueの原因が解決したからなのか。

r14871 | srdjan@google.com | 2012-11-14 08:31:07 +0900 (水, 14 11月 2012) | 2 lines
Move lazy deoptimization of all optimized code from top level parsing to end of class finalization
(after installing new classes, and --use_cha, we need to invalidate some optimzied code)
Review URL: https://codereview.chromium.org//11370008
RemoveOptimizedCode()が、parserからclass_finalizerに移動した。
FinalizePendingClasses()の中で、use_cha=trueの場合、RemoveOptimizedCode()が走る。
タイミングが変わっただけかな。

r14870 | vegorov@google.com | 2012-11-14 08:21:02 +0900 (水, 14 11月 2012) | 6 lines
Count per check hits in ICData.
R=srdjan@google.com
Review URL: https://codereview.chromium.org//11275290
Objectクラスに、Get/SetCountAtっていうメンバを追加した。
emit時にcount_offsetをインクリメントする処理を追加して、
ICDataのcheckの回数をカウント。
最適化で使うわけではないけど、il_printerがデバッグ情報として回数を出力してくれる。
この後どうなっていくんでしょうかね。 楽しみです。

r14866 | regis@google.com | 2012-11-14 06:05:55 +0900 (水, 14 11月 2012) | 2 lines
Create symbols for string constants.
Review URL: https://codereview.chromium.org//11360231
FunctionResult, FactoryResultをSymbolに追加

r14864 | fschneider@google.com | 2012-11-14 05:00:47 +0900 (水, 14 11月 2012) | 6 lines
Improve SHR by using range information for the shift count.
Avoid emitting unnecessary range checks for the shift count
if the value is known to be positive and/or less than the max shift count.
Review URL: https://codereview.chromium.org//11364222
CanDeoptimize() kSHRの場合、Rangeが0～kPlusInfinityの間に収まるなら、Deoptimize不要。
EmitBinarySmiInstrでは、
leftがRegister値の際に、CanDeoptimize()をチェックし、
rightが0以下の場合、deoptimizeするコードを生成
rightがcountlimitに収まるかもチェックする。
countlimitに収まらない場合、rightにcountlimitをsetしているけど、deoptimizeでなく？

r14862 | regis@google.com | 2012-11-14 04:02:08 +0900 (水, 14 11月 2012) | 2 lines
Check result type of redirecting factory in checked mode.
Review URL: https://codereview.chromium.org//11369219
parserでは、RedirectingFactoryに対して、
check_result_typeオプションが有効な場合、 AssignableNodeを生成。
flow_graph_builderで、AssignableNodeをCanSkipTypeCheck()で確認

RedirectingFactoryがMalformedだった場合、parserでのエラーチェック
Constructorの場合はRuntimeのエラーチェックを挿入する。

r14860 | srdjan@google.com | 2012-11-14 03:34:05 +0900 (水, 14 11月 2012) | 4 lines
In optimized code use IC calls for instance calls that have no IC data instead of deoptimizing.
The optimized IC call increments usage counter and reoptimizes optimized function
if the threshold is met.
Recognize closure calls and mark them in ICData.
Closure calls do not populate ICData,
i.e., number of checks is always 0 (unless mixed closure calls with regular instance calls).
Therefore closure IC calls do not count for reoptimization.
Review URL: https://codereview.chromium.org//11361225
オプション trace_optimized_ic_calls=false
オプション reoptimization_counter_threshold=2000


r14838 | ajohnsen@google.com | 2012-11-13 19:41:37 +0900 (火, 13 11月 2012) | 8 lines
Move JSSyntaxRegExp to core as a private member.
This removes the last refrences to dart:coreimpl.
After this cleanup, RegExp no longer have a const constructor. Use 'new
RegExp(...)' from now on.
Review URL: https://codereview.chromium.org//11365196
_JSSyntaxRegExpがPrivateのsyntaxになって、CoreImplからruntime/libに移動。
coreimplはすべてprivateになったので、LoadCoreImplScriptや、corelib_impl_source/patchなどの、
Library::CoreImplLibrary()をVM側からScriptとして呼び出す処理も、併せて削除。
Bootstrapや、VM側が上記の参照をHandleしておく変数等も削除。

r14828 | hausner@google.com | 2012-11-13 10:06:48 +0900 (火, 13 11月 2012) | 2 lines
Enforce proper library/import syntax
Review URL: https://codereview.chromium.org//11312197
parserの修正
いろいろとエラー制御が増えた。

r14827 | vegorov@google.com | 2012-11-13 09:50:57 +0900 (火, 13 11月 2012) | 8 lines
Eradicate CallSiteInliner::next_ssa_temp_index_.
It should always be equal to the max SSA temp index stored on the caller graph itself.
Thus it is redundant and dangerous to store it in two places.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11312200
next_ssa_temp_index_から、max_virtual_register_number()で逐一再計算するように変更
使いまわすのはよくない。

r14825 | srdjan@google.com | 2012-11-13 09:43:17 +0900 (火, 13 11月 2012) | 2 lines
Do not add InstantiatedTypeArgument entries into cache as they cannot be canonicalized.
Limit the maximum subtype cache size,
so that it does not become brobdingnagian and thus slows the GC.
Review URL: https://codereview.chromium.org//11369204
オプション max_subtype_cache_entries=100
でcacheの上限を設けた。

r14823 | hausner@google.com | 2012-11-13 08:51:51 +0900 (火, 13 11月 2012) | 2 lines
Fix debugger test
Review URL: https://codereview.chromium.org//11369203
testコードのsymbolを変更

r14822 | iposva@google.com | 2012-11-13 08:26:38 +0900 (火, 13 11月 2012) | 2 lines
- Fix x64 build.
Review URL: https://codereview.chromium.org//11362214
friend追加

r14821 | iposva@google.com | 2012-11-13 08:21:04 +0900 (火, 13 11月 2012) | 5 lines
- Do not mix scalar values and object fields in RawInstance to simplify the traversal for GC.
  Classes with native fields have a hidden reference to a typed array containing the native fields.
Review URL: https://codereview.chromium.org//11312183
cls.native_fieldを参照しなくなり、native_fieldの初期かが
GenerateAllocationStubForClass()からなくなった。
代わりに、object.h::setNativeField()の初回に領域確保を行う。

objectがnative_fieldへの参照をもつ。
普通は、raw_objectに実データを持たせるものだが、、


r14816 | hausner@google.com | 2012-11-13 07:57:39 +0900 (火, 13 11月 2012) | 2 lines
More function literal changes in tests.
Review URL: https://codereview.chromium.org//11363206
昔は空のfunctionが、function() {}
今は、() {}

r14814 | fschneider@google.com | 2012-11-13 07:44:34 +0900 (火, 13 11月 2012) | 12 lines
Restrict immediate operands to smi where only smis are supported.
Re-enable redundant phi elimination.
Add x64 codegen templates and assembler instructions for immediate operands.
Fix x64 assembler for imull when using r8-r15.
Add x64 instruction for imulq(reg, imm).
Fix x64 disassembler printing of immediates.
Review URL: https://codereview.chromium.org//11362210
remove_redundant_phis=trueにオプション変更
特定の条件下で、RegisterOrConstantからRegisterOrSmiConstantに置き換え
RelationalOpやBinarySmiInstrにおいて、参照のみされるOperand(1)は、
Instrの副作用の影響を受けないので、OrSmiConstantのままであると。

r14805 | hausner@google.com | 2012-11-13 04:55:11 +0900 (火, 13 11月 2012) | 8 lines
Remove named function literals from library and tests
Start eliminating old-style function literals, i.e. remove
return type and function names.
Enforcing new style function literal syntax can be turned
on with the vm flag --strict_function_literals.
Review URL: https://codereview.chromium.org//11377102
オプション strict_function_literals=false
parserの修正
関数の下記リテラルが使用不可になるらしい。
IDENT + LPARENTのパターン。_(var x)
VOID + literalのパターン。 void xx(var x)

r14802 | asiva@google.com | 2012-11-13 04:02:44 +0900 (火, 13 11月 2012) | 2 lines
Fix for issue 6623 - Canonicalize implicit static closure objects.
Review URL: https://codereview.chromium.org//11359151
IsImplicitStaticClosureFunction()だった場合、
ReturnDefinition(new ConstantInstr(closure));
union構造に置き換え、closure_を追加
union {
  RawInstance* closure_;  // Closure object for static implicit closures.
  RawCode* closure_allocation_stub_;  // Stub code for allocation of closures.
};


r14794 | floitsch@google.com | 2012-11-13 02:19:58 +0900 (火, 13 11月 2012) | 7 lines
a === b -> identical(a, b)
Replace === null with == null.
BUG=http://dartbug.com/6380
Review URL: https://codereview.chromium.org//11361190
testコードのみ書き換え。
=== -> ==
=== -> identical()

r14779 | lrn@google.com | 2012-11-12 17:16:59 +0900 (月, 12 11月 2012) | 5 lines
Convert String to a class.
Remove the StringImplementation class.
Review URL: https://codereview.chromium.org//11085003
StringInterfaceからStringTypeに置き換えただけ

r14769 | regis@google.com | 2012-11-10 08:51:06 +0900 (土, 10 11月 2012) | 6 lines
Fix result type checking of factory constructors of generic classes in VM.
Add a language test.
Fix some language tests.
Fix runtime library.
Note: This does not yet fix result checking of redirecting factories.
Review URL: https://codereview.chromium.org//11369168
Factoryである場合の処理を、class_finalizerに追加
Factoryのresult_typeを取得する。

r14756 | srdjan@google.com | 2012-11-10 05:55:31 +0900 (土, 10 11月 2012) | 3 lines
Remove unused/not working function tracing flag and functionality.
Other small fixes, use stub to call optimization of a function (in preparation for reoptimization).
Review URL: https://codereview.chromium.org//11364184
trace_functionsオプションを削除
ReturnInstr::EmitNativeCode
の中の、kOptimizeInvokedFunctionRuntimeEntryの呼び出しを、
StubCode::OptimizeFunctionLabelとして関数化

r14755 | fschneider@google.com | 2012-11-10 04:54:55 +0900 (土, 10 11月 2012) | 6 lines
Reland: Improve smi shift operations and avoid repeated deoptimizations.
This CL includes a bug fix where a NULL check of the pc was missing.
Also change the dart2js test status of arithmetic_test from Skip to Fail.
Review URL: https://codereview.chromium.org//11369158
deopt_reason set/getできるようになった。 last_deoptのみ履歴として残す。
deoptの履歴を参照して、最適化するかしないか決める。
実コードでは、DeoptBinarySmiOp(overflowした)の場合、kMintCid、そうでなければkSmiCid

Shift値が定数だった場合、BinarySmiにSHLの特殊化を追加
kSHL(left, rigth)
mov temp, left
shll left
sarl left
cmpl left, tmp   <-- 元にもどして等しくないならアウト
noeqならoverflowとしてdeopt
shll left

そうでない場合、BinarySmiのSHL特殊化を修正
shift数をuntagした後は、上記と共通。

deopt_reasonを大幅に整理、不要だったものを削除。
このdeoptの履歴はlastだけでなく、bitにして集合を管理したほうがいいような。

r14752 | kmillikin@google.com | 2012-11-10 04:42:01 +0900 (土, 10 11月 2012) | 8 lines
Fix Code::ToCString.
It was printing the entry address in decimal and only the low 32 bits on x64.
R=vegorov@google.com
Review URL: https://codereview.chromium.org//11365179
0x%d --> %p出力に変更

r14718 | srdjan@google.com | 2012-11-09 09:58:21 +0900 (金, 09 11月 2012) | 2 lines
Make sure that ParsedFunction holds onto zone handles.
Review URL: https://codereview.chromium.org//11364166
HandleからZoneHandleへの切り替え
ParsedFunctionが、function.raw()をZoneHandleで管理する。

r14716 | hausner@google.com | 2012-11-09 09:19:43 +0900 (金, 09 11月 2012) | 2 lines
Implement const expressions for local variables
Review URL: https://codereview.chromium.org//11265047
astにEvalConstExpr()が追加 NULL or compile-time const value.
LocalVariable関連のファイルを修正し、VariableにConstのフラグ設定を行う。
RawBool* is_const;                               <-- add
union {
  RawAbstractType* type;
  RawInstance* value;  // iff is_const is true   <-- add
};
コンパイル時にEvalするような処理は入ってないけど、どこかでやっているのだろうか。
Constフラグの設定は行っているが、フラグを参照してどうこうする処理ははいっていない。

r14705 | vegorov@google.com | 2012-11-09 04:13:57 +0900 (金, 09 11月 2012) | 8 lines
Use structural loop info computed by register allocator to mark loop phis.
Currently it disagrees with loop information computed
in other parts of optimization pipeline that do not require loops to be properly nested.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11404003
flow_graph_allocator::ConnectIncomingPhiMovesのリファクタリング
loop_headerのみつけかたを若干書き換えたくらいかな。

r14701 | gram@google.com | 2012-11-09 03:41:58 +0900 (金, 09 11月 2012) | 2 lines
Fix library syntax
Review URL: https://codereview.chromium.org//11368124
importの構文は、以下も使えるように最近対応された
import 'dart:isolate';

r14698 | regis@google.com | 2012-11-09 03:28:07 +0900 (金, 09 11月 2012) | 4 lines
Pass closure object as first implicit argument to closure functions.
Remove code passing captured receiver to native instance closures; instead,
access captured receiver in context, as non-native functions do.
Review URL: https://codereview.chromium.org//11360116
修正量がでかいように見えて、そうでもない。 コード量が減る方向にリファクタリング。
native_argumentsに若干の変更があるかな。
native_closure関係の修正。native_closureを特別扱いせず、普通のclosureと同様に扱うコードに置き換え。
is_native_instance_closure()を削除し、native_instanceだからarg+1するような処理を削除。

ia32ではいか。
old
Input parameters:                                       
   ESP : points to return address.                       
   ESP + 4 : address of return value.                    
   EAX : address of first argument in argument array.    
   EAX - 4*EDX + 4 : address of last argument in argument array.
   ECX : address of the native function to call.         
   EDX : number of arguments to the call.                
void StubCode::GenerateCallNativeCFunctionStub(Assembler* assembler)

new
Input parameters:                                         
  ESP : points to return address.                           
  ESP + 4 : address of return value.                       
  EAX : address of first argument in argument array.        

  ECX : address of the native function to call.             
  argc_tag including number of arguments and function kind. 

r14695 | iposva@google.com | 2012-11-09 03:07:54 +0900 (金, 09 11月 2012) | 5 lines
Fix bug 6586:
- Attempt to run the Monitor thread_test multiple times before failing
  due to its potential to failure due to timing.
- Use named constants when converting millis to seconds and nanos.
  Review URL: https://codereview.chromium.org//11361157
thread.test.ccの修正

r14673 | vegorov@google.com | 2012-11-08 11:23:41 +0900 (木, 08 11月 2012) | 10 lines
Try allocating loop phi into a register even if phi has only unconstrained uses
but there are cheap eviction candidates:
values that come into the loop and have only unconstrained uses in it.
When spilling a value inside the loop
that has only unconstrained uses in this loop move spilling point outside of the loop.
This tweaks allow to minimize amount of memory moves on loop back edges.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11361161
ループ中で使わない変数を、ループの外にspillする処理を追加。


r14668 | srdjan@google.com | 2012-11-08 09:19:53 +0900 (木, 08 11月 2012) | 1 line
Add flag --remove-redundant-phis, default to false until incorrect code generation is fixed.
This CL makes all test pass with --optimization-counter-threshold=5 .
remove_redundant_phis=falseオプションを追加

r14611 | srdjan@google.com | 2012-11-07 10:34:50 +0900 (水, 07 11月 2012) | 2 lines
Fixed disabling inlining of static calls that were not executed.
Review URL: https://codereview.chromium.org//11275180
r14605 | srdjan@google.com | 2012-11-07 08:47:19 +0900 (水, 07 11月 2012) | 2 lines
Do not inline static calls that have not been executed in unoptimized code:
the inlined function does not have type feedback
that takes that call's arguments into account.
As a side effect, it fixes a crash in smi-equality.
Review URL: https://codereview.chromium.org//11312105
14611で修正が入っているので、両方合わせて
ExtractUncalledStaticCallDeoptIds()で、PcDescriptorsからStaticFunctionを収集し、
uncalled_static_static_call_deopt_ids_のArrayに設定。FlowGraphInliner生成のたびに収集する。
Inliningの候補を走査し、VisitStaticCallした際に、上記Arrayに含まれていたら、Inliningしない。

r14600 | hausner@google.com | 2012-11-07 07:51:01 +0900 (水, 07 11月 2012) | 2 lines
Make sure setter does not conflict with method
Review URL: https://codereview.chromium.org//11312109
parser kSetterFunctionか確認する条件を追加

r14589 | asiva@google.com | 2012-11-07 04:11:07 +0900 (水, 07 11月 2012) | 2 lines
Avoid duplicate null checks when calling SetRaw from InitializeHandle
Review URL: https://codereview.chromium.org//11369028
obj->SetRaw()をinitializeHandle(obj, raw_ptr)に置き換え

r14588 | asiva@google.com | 2012-11-07 04:07:43 +0900 (水, 07 11月 2012) | 2 lines
Fix length computation in Dart_StringToUTF8.
Review URL: https://codereview.chromium.org//11275107
エラー追加

r14583 | hausner@google.com | 2012-11-07 02:54:27 +0900 (水, 07 11月 2012) | 8 lines
Fix various inheritance bugs
Fields can be overridden by subclasses
A setter does not conflict with a method
Eliminate outdated tests
Fixes issue 6482
Review URL: https://codereview.chromium.org//11312095
parser周り全然読んでないから、この機会にでも。。
LoopupFunctionとか、LookupFieldとか
func ^= functions_.At(i)
test_name = func.name() とか不明すぎる。

r14553 | asiva@google.com | 2012-11-06 11:58:00 +0900 (火, 06 11月 2012) | 2 lines
Fix some warnings generated when -Wconversion-null is used.
Review URL: https://codereview.chromium.org//11312096
spawn_data_(NULL) -> spawn_data_(0)

r14549 | asiva@google.com | 2012-11-06 09:56:53 +0900 (火, 06 11月 2012) | 2 lines
Added a unit test case for issue 6448
Review URL: https://codereview.chromium.org//11359064
6448???, maybe 6358

r14548 | asiva@google.com | 2012-11-06 09:56:41 +0900 (火, 06 11月 2012) | 2 lines
Fix compiler warning.
Review URL: https://codereview.chromium.org//11364084

r14547 | tball@google.com | 2012-11-06 08:51:40 +0900 (火, 06 11月 2012) | 5 lines
Made string sub-classes friends of Object, to give them access to Object::Allocate
when compiling with clang.
Review URL: https://codereview.chromium.org//11362101
Objectクラスのfriendに下記の4クラスを追加。のみ。clangのコンパイル対策？

r14545 | tball@google.com | 2012-11-06 07:22:19 +0900 (火, 06 11月 2012) | 10 lines
Merged String subclasses into String.
Merged String subclasses (OneByteString, etc.) into String,
keeping their raw types.
This allows String handles to continue to point
to a String after its raw type is changed, such as to make its data external.
Review URL: https://codereview.chromium.org//11367044
OneByteString, TwoByteString, ExternalOneByteString, ExternalTwoByteStringが、
Stringの継承ではなく、AllStaticの継承に変更。 Stringのfriendに。
Stringから継承していたメソッドやI/Fは別途実装。
内部のデータの持ち方は変更なし。
NewStringClass()というファクトリを作って、全部String型でHandleするように変更。

r14544 | regis@google.com | 2012-11-06 06:00:12 +0900 (火, 06 11月 2012) | 4 lines
Do not copy type parameter bound from declaration to reference, since we are
not able to properly finalize it.
Revisit later. This fixes issue 6488. Siva will add a test.
Review URL: https://codereview.chromium.org//11366093
TypeParameterのboundを再解析する。

r14540 | srdjan@google.com | 2012-11-06 02:07:06 +0900 (火, 06 11月 2012) | 2 lines
Remove special meaning when usage counter reaches the threshold.
Review URL: https://codereview.chromium.org//11366076
optimization_counter_threshold周りでemitされるコードを修正
冗長なコードを整理したらしい。

r14500 | hausner@google.com | 2012-11-03 05:30:08 +0900 (土, 03 11月 2012) | 4 lines
Make library, import, export, part pseudo-keywords
Resubmit cl 14446 after Ivan's keyword table fix.
Review URL: https://codereview.chromium.org//11367069
KEYWORD_LISTを修正。
library, import, export, partのtoken化
taken.hには、operatorの優先順位が定義されている。

r14499 | srdjan@google.com | 2012-11-03 05:21:33 +0900 (土, 03 11月 2012) | 2 lines
For megamorphic calls (IC calls in optimized code),
use a stub without attempting to count usage of function.
Review URL: https://codereview.chromium.org//11359046
最適化時にICを生成する際に、MegamorphicCallEntryPoint()を使う処理を追加
GenerateUsageCounterIncrement()を作成、既存処理から関数を抽出。
ICにはusage_counter_offset()がフィールドとして埋まっていて、
ICが呼ばれる度に、そのカウンターをインクリメントする。
この関数はカウンターをインクリメントするのみ。他の処理は行わない。

r14486 | srdjan@google.com | 2012-11-03 01:35:05 +0900 (土, 03 11月 2012) | 2 lines
Various little cleanups to avoid excessive allocation of handles.
Review URL: https://codereview.chromium.org//11358052
forの終値をループの外に移動。
Handleの畳み込み

r14463 | zerny@google.com | 2012-11-02 21:26:07 +0900 (金, 02 11月 2012) | 8 lines
More inlining flags and tuned heuristics.
The heuristics should be examined further,
but these maintain about the same runtime for the benchmarks
while decreasing compile time for dart2js.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11269040
builderの関数にloop_depth()を引数に追加
JoinEntryとBlockEntryInstrとTargetEntryInstrにloop_depthを設定する

inlining向けにオプションを追加
以下の5オプションは、ShouldWeInline()で参照。
DEFINE_FLAG(int, inlining_size_threshold, 20,
  "Always inline functions that have threshold or fewer instructions");
DEFINE_FLAG(int, inlining_in_loop_size_threshold, 80,
  "Inline functions in loops that have threshold or fewer instructions");
DEFINE_FLAG(int, inlining_callee_call_sites_threshold, 1,
  "Always inline functions containing threshold or fewer calls.");
DEFINE_FLAG(int, inlining_constant_arguments_count, 1,
  "Inline function calls with sufficient constant arguments "
  "and up to the increased threshold on instructions");
DEFINE_FLAG(int, inlining_constant_arguments_size_threshold, 60,
  "Inline function calls with sufficient constant arguments "
  "and up to the increased threshold on instructions");

Inlining heuristics based on Cooper et al. 2008.
もしかして、これ？
http://dl.acm.org/citation.cfm?id=1788381
An adaptive strategy for inline substitution
http://www.cs.rice.edu/~keith/512/Lectures/10WholeProgram-1up.pdf
引数にConstantがある場合、Constant Propagationに期待出きるので、
積極的にinliningすると。
loop_depthは、loop_depth > 0かつinlining_in_loop_size_thresholdがtrueでないと、
ShouldWeInlineがtrueにならない。
loop bufferの範囲内で、inliningしたいってところか。


r14453 | iposva@google.com | 2012-11-02 16:29:12 +0900 (金, 02 11月 2012) | 3 lines
- Prepopulate the keyword symbol table otherwise we can end up
  with empty spots when reading from a snapshot.
Review URL: https://codereview.chromium.org//11366058
scanner/parserの変更

r14444 | srdjan@google.com | 2012-11-02 08:25:26 +0900 (金, 02 11月 2012) | 2 lines
Add is_intrinsic and is_not_intrinsic bits to prevent repeated tests on the same function
(inlining, recompilations). The bist are set lazily, initially both are false.
Review URL: https://codereview.chromium.org//11358047
IntrinsicKindを追加。kUnknownIntrinsic, kIsIntrinsic, kIsNotIntrinsic
主にリファクタリング

r14441 | fschneider@google.com | 2012-11-02 07:47:41 +0900 (金, 02 11月 2012) | 12 lines
Inline native String.charCodeAt in optimized code and fix a bounds-check bug.
Introduce a new IL instruction that does charCodeAt from
1- and 2-byte character strings. The existing CheckArrayBound
instructions is extended to be used for string bounds checking.

Also fix a bug with a missing compile-time bounds-check on constant arrays.

TEST=tests/language/optimized_string_charcodeat.dart,
tests/language/optimized_constant_array_string_access.dart
Review URL: https://codereview.chromium.org//11360033
charCodeAtのintrinsicsを追加
StringCharCodeAtInstrクラス
flow_graph_optimizerに特殊化処理追加
条件をみて、CheckArrayBoundInstrも畳み込むらしい
ia32のEmitterは、
kOneByteStringCidの場合、
SmiUntag(index), movzxb, SmiTag(index), SmiTag(result)
kTwoByteStringCidの場合、SmiUntag(index)/Tag(index)が畳み込めるので、movzxb, SmiTag(result)

r14434 | srdjan@google.com | 2012-11-02 06:06:36 +0900 (金, 02 11月 2012) | 2 lines
Do not recompute unary_checks repeatedly.
Add special (and quicker) way to check for method overrides using CHA.
Review URL: https://codereview.chromium.org//11275110
cha.cc HasOverride()を追加 呼び出し元をリファクタリング
direct_subclass.LookupDynamicFunction()で探す。もしあればtrue
const ICData& unary_ic_dataを引数で渡すようにして再計算しないように。
最近この手の修正が多いですね。


r14426 | vegorov@google.com | 2012-11-02 03:56:39 +0900 (金, 02 11月 2012) | 8 lines
Improve RangeBoundary::LowerBound/UpperBound.
They should not just return MinSmi/MaxSmi when symbol's range is not available.
Instead they should take offset into account.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11275098
ただMaxSmi()やMinSmi()を返さず、(Symbol +- offset) をかえす。

r14422 | srdjan@google.com | 2012-11-02 03:10:30 +0900 (金, 02 11月 2012) | 2 lines
Fix issue 6288, move DeoptimizeAll to top level parsing.
Allow optimizing compiler to optimize even when ooptimzied code is active.
Review URL: https://codereview.chromium.org//11293038
LoadScriptの際に、use_cha==trueでRemoveOptimizedCode()しなくなった。
OptimizeとDeoptimizeの制御が複雑になってきた。。

r14420 | asiva@google.com | 2012-11-02 02:58:58 +0900 (金, 02 11月 2012) | 2 lines
Remove some unnecessary class handle creations.
Review URL: https://codereview.chromium.org//11293031
const Class&のHandleから、intptr_t class_idにいくつか変更
実行時の一時的なメモリ増加がほんの少し減少するのかな？

r14405 | lrn@google.com | 2012-11-01 22:46:30 +0900 (木, 01 11月 2012) | 5 lines
Renaming IndexOutOfRangeException to RangeError.
It now extends ArgumentError.
Review URL: https://codereview.chromium.org//11275042
Exceptionの名称が変更されたのみ。

r14381 | sgjesse@google.com | 2012-11-01 17:09:30 +0900 (木, 01 11月 2012) | 7 lines
Fix broken VM build caused by 14380
TBR=csaphiro@google.com
Review URL: https://codereview.chromium.org//11361028
GetData()とGetPeer()を
ExternalInt8Arrayクラスに追加

r14380 | sgjesse@google.com | 2012-11-01 16:53:33 +0900 (木, 01 11月 2012) | 15 lines
New APIs for external byte arrays
The following APIs have been added:
Dart_IsExternalByteArray: Check whether an object is an external byte array.
Dart_ExternalByteArrayGetData: Return the pointer to the external data
hosted by the external byte array.
R=cshapiro@google.com
Review URL: https://codereview.chromium.org//11362009
StringAPI周りの追加修正。

r14377 | srdjan@google.com | 2012-11-01 08:17:20 +0900 (木, 01 11月 2012) | 2 lines
Any instance call with too many checks is left to be megamorphic.
This helps with, e.g., LoadField instructions with large number of checks and frequent deoptimization.
Deoptimization improves on dart2js/swarm:
total number of deoptimization 956 -> 753; number of methods becoming unoptimizable 101 -> 52.
Review URL: https://codereview.chromium.org//11367022
Megamorphicの際には、制御を変更してcheckが生成されないようにした。
deoptの個数は減るらしい。

r14367 | srdjan@google.com | 2012-11-01 05:07:31 +0900 (木, 01 11月 2012) | 2 lines
Add flag --always_cleared_ic_data,
which forces a cleared ICData to be emitted with each IC call
(instead of propagating the ICData from unoptimized to optimized code).
This addresses Kevin's concern that propagating the ICData may hurt performance
when inlining methods as the IC calls of inlined methods may not need all classes as the unoptimized code.
Currently running with cleared ICData slows dart2js by > 2%,
probably because the ICData has to be repopulated by optimized code through calls to runtime.
Adding the flag for experimenting as we work on inlining strategies and megamorphic calls.
Review URL: https://codereview.chromium.org//11347049
オプション追加--propagate-ic-data=true
非常に興味深い修正 inlining strategies
修正前は、unoptimizeのときだけ生成。
オプションがtrueの場合、ICをEmitするたびにクリア。
オプションをfalseにすると、修正前と挙動は同じ。

r14366 | hausner@google.com | 2012-11-01 04:43:44 +0900 (木, 01 11月 2012) | 4 lines
Prevent mutation of final variables
Fixes issue 4328
Review URL: https://codereview.chromium.org//11363012
finalのコンパイル時エラー対応

r14362 | regis@google.com | 2012-11-01 03:13:12 +0900 (木, 01 11月 2012) | 4 lines
Remove references to ObjectNotClosureException and ClosureArgumentMismatchException
from the VM (issue 6124).
These are replaced with NoSuchMethodError for now (work in progress).
Review URL: https://codereview.chromium.org//11312019
code_generatorを修正して、Runtimeのエラーを作成している。
作る際の参考になるかも。
最終的には、ThrowByType()で投げる。
exceptions.ccから、上記2つのsymbolを削除
symbolsにCall, "call"を追加

r14357 | asiva@google.com | 2012-11-01 02:56:46 +0900 (木, 01 11月 2012) | 23 lines
- Represent strings internally in UTF-16 format, this makes it
  compatible with webkit and will allow for easy externalization of
  strings. One byte strings are retained for pure ASCII strings.
  (The language specification was changed recently to reflect this as
  follows "A string is a sequence of UTF-16 code units").
- Remove four byte string class and all references to it.
- Rename some of the string functions in Dart API to make them
  consistent and better describe the underlying functionality
  Dart_NewString => Dart_NewStringFromCString
  Dart_NewString8 => Dart_NewStringFromUTF8
  Dart_NewString16 => Dart_NewStringFromUTF16
  Dart_NewString32 => Dart_NewStringFromUTF32
  Dart_NewExternalString8 => Dart_NewExternalUTF8String
  Dart_NewExternalString16 => Dart_NewExternalUTF16String
  Dart_NewExternalString32 => Dart_NewExternalUTF32String
  Dart_StringGet8 => Dart_StringToUTF8
  Dart_StringGet16 => Dart_StringToUTF16
  Dart_StringToCString => Dart_StringToCString
  Dart_IsString8 => Removed
  Dart_IsString16 -> Removed
  Dart_StringToBytes -> Removed
  Dart_StringGet32 -> Removed
  Review URL: https://codereview.chromium.org//11318018
修正量が多いので、ポイントだけ確認したけど、大体コメントのとおり

r14350 | srdjan@google.com | 2012-11-01 01:35:30 +0900 (木, 01 11月 2012) | 2 lines
Use unary class checks when emitting instance calls in optimized mode.
Review URL: https://codereview.chromium.org//11339033
EmitEqualityAsInstanceCall()の中で、
UnaryClassChecks()を高速なasm生成で置き換えた？
あまり自信ない。


r14343 | fschneider@google.com | 2012-10-31 23:53:15 +0900 (水, 31 10月 2012) | 2 lines
Relational comparisons for unboxed mints.
Review URL: https://codereview.chromium.org//11344011
kMintCidでは、Deoptimizeなしと、SideEffectなしを追加。
上記は、SmiとMintとDoubleが該当する。
Mintは、kDoubleと同様にboxingされているが、ia32とx64で実装が異なる。
NumberOfChecks() == 1の条件が緩和されて、
!= 1 かつ HasTwoMintOrSmi()でもkMintCidに特殊化
ia32において、
RelationalOpInstr::MakeLocationSummary()を拡張
Mintがxmmに乗ってる前提で比較を行う。
EmitUnboxedMintComparisonOp()を追加
これはRelationalOpのうち、LT GT LTE GTEのみ扱う。
xmmに格納された値を、pextrdでhiを取得してcmpl
pextrdでlowを取得してcmpl
上記結果を踏まえてどっかに飛ぶ
x64向けに修正はない。

r14324 | lrn@google.com | 2012-10-31 19:32:54 +0900 (水, 31 10月 2012) | 9 lines
Change signature of noSuchMethod to take an InvocationMirror.
Requires VM and dart2js/dart2dart changes to work.
Committed: https://code.google.com/p/dart/source/detail?r=14198
Committed: https://code.google.com/p/dart/source/detail?r=14254
Review URL: https://codereview.chromium.org//11231074
InvocationMirrorとAllocateInvocationMirrorに対応
parserがAllocateInvocationMirror()
codegenがInvokeNoSuchMethodFunction()
flowgraphbuilderがBuildStaticNoSuchMethodCal()
Symbols::AllocateInvocationMirror()を生成して呼び出すのと、
NoSuchMethodを呼び出しているけど、
どういうことかよくわからん。。

r14309 | srdjan@google.com | 2012-10-31 05:59:22 +0900 (水, 31 10月 2012) | 2 lines
Fix equality instruction to switch from checked (polymorphic) to megamorphic state.
This helps dart2js as it eliminates excessive deoptimizations
(probeForAdding runs now in optimized mode) -> 5% improvement.
Review URL: https://codereview.chromium.org//11343046
IsPolymorphic()ってみやすい
オプション max-polymorphic-checks=4を追加

r14304 | srdjan@google.com | 2012-10-31 04:59:58 +0900 (水, 31 10月 2012) | 2 lines
Add range to kBIT_AND with positive constants. Use that range to eliminate compares in left shifts.
Review URL: https://codereview.chromium.org//11175013
RangeAnalysis向けの修正
kBIT_ANDを走査した際に、RangeBoundaryを狭める処理を追加
BinarySmiOpInstrのkSHLをemitする際、
Range情報を使ってshift幅がRangeの範囲内に収まっていれば、cmpl命令生成を畳み込む。

r14296 | hausner@google.com | 2012-10-31 02:45:36 +0900 (水, 31 10月 2012) | 4 lines
Disallow 'dynamic' as type parameter name
Fixes issue 2492
Review URL: https://codereview.chromium.org//11343044
parserの修正

r14295 | srdjan@google.com | 2012-10-31 02:27:58 +0900 (水, 31 10月 2012) | 2 lines
Fix issue 6403: do not crash if super indexed load does not exist
(return 'no-such-method call' instrcution as result.
Review URL: https://codereview.chromium.org//11273117
ReturnDefinition()が抜けていたのを追加。

r14293 | vegorov@google.com | 2012-10-31 01:26:46 +0900 (水, 31 10月 2012) | 11 lines
Allow bound check elimination to eliminate checks 
when both array length and index boundaries are expressed through the same symbol.
For example:
var list = new List(n);
for (var i = 0; i < n; i++) list[i];
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11273111
IsRedundant()の引数にRangeBoundaryのlengthを追加。
削除対象のCheckArrayBoundInstrのlengthを取得して、IsRedundant()にかけて冗長か判定する。
SameSymbolでoffsetが範囲に収まれば冗長と判断

Trait用のArrayLengthDataクラスを作成
合わせて、Trait用にhashmapを拡張。
ArrayのAllocation箇所を辿ってlengthを探すが、arrayとlengthのペアをキャッシュするために必要。

CheckArrayBoundInstrからlengthを探す、LoadArrayLength()を作成
BuilderでConstractorCallを辿った際に、kArrayCidとkGrowableConstructorだった場合は、
Constructor型を記録しておく。
LoadArrayLength()では、Allocationの箇所を辿れる場合、
constructorからlengthを取得し、キャッシュする。
辿れない場合、lengthを取得するLoadFiledInstrを生成し、キャッシュする。
キャッシュしたlengthは、最終的にIsRedundant()で参照される。


r14281 | ajohnsen@google.com | 2012-10-30 23:19:57 +0900 (火, 30 10月 2012) | 5 lines
Move StringImplementation from coreimpl to core as _StringImpl.
Review URL: https://codereview.chromium.org//11348035
classはcore_impl_libからcore_libへ置換

r14274 | ajohnsen@google.com | 2012-10-30 22:25:04 +0900 (火, 30 10月 2012) | 5 lines
Move ListImplementation from coreimpl to core, as a private member.
Review URL: https://codereview.chromium.org//11189141
symbolsがListImplementationが_ListImplに置換
classはcore_impl_libからcore_libへ置換

r14258 | vegorov@google.com | 2012-10-30 19:27:51 +0900 (火, 30 10月 2012) | 14 lines
1.Fold away x === null comparisons when propagated cid of x is not kDynamicCid.
2.Eliminate single operand phis that appear in the graph after constant propagation.
3.Recognize constructors for _ObjectArray and _GrowableObjectArray.
4.Fix bug in result cid recognition for List.
constructor call. A call with an argument does not guarantee
that fixed size array (kArrayCid) is returned.
These changes together allow us to produce better code after inlining of List constructor,
otherwise we lose information due to non-specialized control-flow
that chooses between _GrowableObjectArray and _ObjectArray.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11342014
小さい修正を4点。
VisitStrictCompare()中で、冗長なphiを削除

r14252 | kmillikin@google.com | 2012-10-30 18:50:35 +0900 (火, 30 10月 2012) | 9 lines
Compress deoptimization information by sharing common suffixes.
For all the deoptimization entries in a function, build a suffix trie.
Add a new deoptimization instruction that indicates the rest of the translation
is a fixed-length suffix of another entry.
Review URL: https://codereview.chromium.org//11040058
CreateDeoptInfo()の引数にDeoptInfoBuilder builderを追加
parsed_function()から新たに生成せず、引数のbuilderを使いまわす。
builderの中に、object_tableをもって、生成時のコスト削減してるのだと思う。
DeoptInfoBuilderが、DeoptInstrをSuffix Trieで共通化して、Findを高速化？


r14249 | kmillikin@google.com | 2012-10-30 18:37:35 +0900 (火, 30 10月 2012) | 10 lines
Simplify the implementation and generated code for the IC stubs.
The implementation now uses the same code for 1 and >1 argument cases.
For the 1 argument case the generated code is essentially the same code as before.
For the >1 argument case the generated code is slightly improved.
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11272028
リファクタリング
じゃっかん無駄なアセンブラ減ったかも。

r14237 | iposva@google.com | 2012-10-30 09:52:21 +0900 (火, 30 10月 2012) | 3 lines
- GrowableArray::RemoveLast returns the value being removed
  to avoid having to call Last() followed by RemoveLast().
  Review URL: https://codereview.chromium.org//11348026
void RemoveLast -> T& RemoveLast()
に伴い、全体をリファクタリング

r14236 | srdjan@google.com | 2012-10-30 09:48:11 +0900 (火, 30 10月 2012) | 2 lines
Propagate ICData from unoptimized code to instance calls in optimized code.
Review URL: https://codereview.chromium.org//11341025
GenerateInstanceCallの引数を整理してconst ICDataを追加、他削除。リファクタリングかな？
じゃっかんsnapshotに影響あるかも？

r14234 | regis@google.com | 2012-10-30 09:06:24 +0900 (火, 30 10月 2012) | 3 lines
Fix wrong canonicalization of signature class due to name collision (issue 6353).
Add test.
Review URL: https://codereview.chromium.org//11342028
IsDynamicType()からIsObjectType()に変わっているけどよくわからん。

r14233 | hausner@google.com | 2012-10-30 09:02:22 +0900 (火, 30 10月 2012) | 4 lines
Handle super call to unary operators
Fix issue 1288.
Review URL: https://codereview.chromium.org//11342027
vm/symbols.hにSuperを追加
parserを大きく修正し、IsPrimaryNode()かつIsSuper()向けの処理を追加。
BuildUnarySuperOperator() kNEGATEとkBIT_NOTが対象。
syntaxに変更あったんだっけ？

r14224 | asiva@google.com | 2012-10-30 06:17:54 +0900 (火, 30 10月 2012) | 2 lines
Fix for issue 6311 (serialize the right type).
Review URL: https://codereview.chromium.org//11344018
snapshot時に、reinterpret_cast<>しないように修正

r14221 | iposva@google.com | 2012-10-30 05:26:14 +0900 (火, 30 10月 2012) | 4 lines
- Avoid recursion in the scavenger by remembering weak properties
  with reachable keys in a stack.
- Added assertion to trigger when scavenger is called recursively.
Review URL: https://codereview.chromium.org//11338017
scavengerの修正.
DelayedWeakStackっってのが追加
delayed_weak_stackに、WeakPropertyを記録しておいて、
ProcessToSpace()の最後にvisitする。

r14215 | regis@google.com | 2012-10-30 03:31:24 +0900 (火, 30 10月 2012) | 2 lines
Remove --reject_named_argument_as_positional flag from the VM.
Review URL: https://codereview.chromium.org//11341014
オプションと処理を削除

r14173 | ajohnsen@google.com | 2012-10-29 17:38:15 +0900 (月, 29 10月 2012) | 5 lines
Move Arrays, Collections and Maps into a new library, dart:collections.
Review URL: https://codereview.chromium.org//11274043
bootstrapの対象に追加
bootstrapでは、LoadScriptを呼ぶらしい。
vm.gypiの中身は興味深い。
dartのlibraryをsnapshotしてバイナリにした後で、
generate_collection_ccみたいなのにバイナリを埋め込む。
const char []にして.ccのソースコードを生成して、
コンパイルしてオブジェクトに取り込んでいるという理解でいいのかな。

r14157 | hausner@google.com | 2012-10-27 07:31:49 +0900 (土, 27 10月 2012) | 8 lines
More fixes for super[]
Extend the LoadIndexedNode to also handle super[] and super[]=
Make sure super []= returns the value.
Handle side effects in index expression correctly.
Defer operator function resolution to the flow graph build phase.
Review URL: https://codereview.chromium.org//11267027
LoadIndexedNodeに、Class super_classを引数に追加
REsolveDynamicでsuper_functionが存在する場合、
StaticCallInstrを生成する。そうでない場合、修正前と同じくInstanceCallInstr
StoreIndexedの場合も同様。
NoSuchMethodCallっていう命令があると。
上記はFlowGraphBuilderで処理することになり、
parserで行っていた処理が置き換えられた。
性能の変化はないかも。


r14141 | vegorov@google.com | 2012-10-27 01:04:55 +0900 (土, 27 10月 2012) | 10 lines
Simple array bounds check elimination on top of range analysis framework.
Currenly eliminates only bounds checks
when there is an implicit constraint bounding index's range with array length.
Does not eliminate redundancy in expressions like a[i + 1], a[i].
R=fschneider@google.com
Review URL: https://codereview.chromium.org//11262033
LoadFieldInstrがArrayLength系だった場合、0～Array::kMaxElementsのRangeを生成する。

BinarySmiInstrを走査した際に、SymbolとConstantとの計算だった場合、
SymbolのoffsetとしてRangeBoundaryを計算する。
SymbolicAdd()
SymbolicSub()
Symbol(変数)と定数とのAdd/Subを対象にRangeBoundaryを計算する。
Add(Symbol a, Constant b) --> RangeBoundary(a, a.offset() + b.value())
Sub(Symbol a, Constant b) --> RangeBoundary(a, a.offset() - b.value())

RangeAnalysis::InferRangesRecursive()から呼ぶ,
CheckArrayBoundInstr::IsRedundant() {
で冗長かどうか判定する。


r14131 | fschneider@google.com | 2012-10-26 21:28:11 +0900 (金, 26 10月 2012) | 4 lines
Small performance fix for mint equality operation.
Mint compares don't have side effects and can't deoptimize.
Review URL: https://codereview.chromium.org//11313005
kMintCidを条件判定に追加

r14122 | lrn@google.com | 2012-10-26 17:28:33 +0900 (金, 26 10月 2012) | 3 lines
Convert NoMoreElementsException and EmptyQueueException to StateError.
Review URL: https://codereview.chromium.org//11269045
libのほうはたくさん修正されているけど、vmの中身はコメントの修正のみ。

r14121 | ager@google.com | 2012-10-26 17:00:05 +0900 (金, 26 10月 2012) | 8 lines
Introduce VM API for the patching mechanism.
This will be used to use patching for the dart:io library.
R=iposva@google.com
Review URL: https://codereview.chromium.org//11264032
Dart_LoadPatch(library, source, patch)を追加
externalシンボル付きのsourceに対して、patchシンボル付きの実装をLoadするらしい。

r14118 | cshapiro@google.com | 2012-10-26 10:26:56 +0900 (金, 26 10月 2012) | 3 lines
Avoid integer overflow when computing the size of new space in bytes.
Review URL: https://codereview.chromium.org//11276022
intからintptr_tに変更

r14113 | iposva@google.com | 2012-10-26 08:46:01 +0900 (金, 26 10月 2012) | 4 lines
- Consolidate code into the old generation.
- Record pointers between code objects.
- Collect unreferenced code objects.
Review URL: https://codereview.chromium.org//11265026
GC向けの修正
heapからcode_spaceがなくなった。。
codeは、heapのold_spaceのHeapPage::kExecutableに格納されるらしい。
また、OldSpaceと同様の処理で、MakSweep()の対象になっている。
UpdateResolvedStaticCall()追加 PatchStaticCall()とFixCallerTarget()から呼ばれる。
resolved_static_calls領域は、Heap::kOldに作成して管理
Heapには、DataかExecutableのフラグを用意し、
VirtualMemory::Protectionを設定する際に、Executeを与えたり、
Read|Writeを設定している。

if (is_executable) {
  memset(reinterpret_cast<void*>(current), 0xcc, obj_size);
}
デバッガで追う際のメモリリーク検出用？


r14112 | tball@google.com | 2012-10-26 08:38:45 +0900 (金, 26 10月 2012) | 5 lines
Updated GetTimeZoneName() to return "" if localtime_r fails or has a NULL for its tm_zone value,
like V8 does.
Also updated GetTimeZoneOffsetInSeconds() to return 0 on localtime_r failure, like V8.
BUG=5943
Review URL: https://codereview.chromium.org//11267051
os_*.ccの修正
localtime_rが失敗した際に、""を返す。

r14098 | srdjan@google.com | 2012-10-26 05:18:54 +0900 (金, 26 10月 2012) | 4 lines
Check class instruction supports Smi check. This fixes missed inlining of isOdd/isEven
Fixed a nasty bug in equality optimization.
Make sure that we emit CheckSmiInstr instead of CheckClassInstr if we are only checking for smi.
Review URL: https://codereview.chromium.org//11262025
CheckClassInstrを生成する際、もしSmiのCheckClassだった場合、
CheckSmiInstrを生成するように変更。

r14079 | fschneider@google.com | 2012-10-25 23:31:44 +0900 (木, 25 10月 2012) | 10 lines
Small IL cleanup.
1. Remove manual inlining and intrinsification of Double.toDouble
   and Integer.toInt. The flow graph inliner can handle these since
   they are not native library functions.

2. Remove unused member instance_call_ from UnarySmiOp.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11267043
DoubleToDoubleと、IntegerToIntegerを削除
code_generatorからも削除
optimizerのspecializeする処理も削除

r14068 | vegorov@google.com | 2012-10-25 20:38:31 +0900 (木, 25 10月 2012) | 10 lines
Simplify range analysis algorithm.
Replace generic fix point range analysis algorithm 
based on widening and narrowing operators with an ad hoc single dominator tree pass.
To improve precision discover initial value and direction of the growth for simple induction variables.
R=fschneider@google.com
BUG=
Review URL: https://codereview.chromium.org//11283002
RangeBoundaryとは別に、
Direction、kUnknown, kPositive, kNegative, kBothを用意した。
WidenMin/Max NarrowMin/Maxするのは止めたらしい。
代わりに、InferInductionVariableRange()を実装。
IVは、LoopHeaderのPHIを起点から探し、
SmiのPHI->BinarySmiInstrを辿っってDirectionを更新する。
Directionだけでなく、LLVMのScalarEvolutionぽいかんじに、
BasicRecurrenceのみ生成するようにして
IVの終値を記録するようにすれば、何か効果があるだろうか？

r14065 | ager@google.com | 2012-10-25 18:57:06 +0900 (木, 25 10月 2012) | 7 lines
Revert change that was based on a local change that was not
part of the test script change.
R=sgjesse@google.com
BUG=
Review URL: https://codereview.chromium.org//11274042
14064をrevert

r14064 | ager@google.com | 2012-10-25 18:38:51 +0900 (木, 25 10月 2012) | 6 lines
Fix CCTestSuite in test.dart.
R=sgjesse@google.com
BUG=
Review URL: https://codereview.chromium.org//11270032
testのメッセージを変更

r14053 | srdjan@google.com | 2012-10-25 09:33:11 +0900 (木, 25 10月 2012) | 2 lines
Hopefully fix warnings of uninitialized variables.
Review URL: https://codereview.chromium.org//11264024
???

r14051 | srdjan@google.com | 2012-10-25 09:24:17 +0900 (木, 25 10月 2012) | 2 lines
Intrinsify Mint/Smi combined comparisons by extending a Smi
to a 64 bit integer and doing a 64-bit integer compare (ia32 only).
Review URL: https://codereview.chromium.org//11262019
Push64SmiOrMint()ってemitterができた。
ia32の場合、 Smiをuntagしてpushl*2するコードか、Mintをpushl*2するコードを生成する。
ia32において、SmiとMintが混在するケースで、CompareIntegersを高速化する。
それまでCompareIntegersは、BothSmiしか出力できなかった。


r14046 | iposva@google.com | 2012-10-25 07:29:34 +0900 (木, 25 10月 2012) | 3 lines
Do not pre-resolve static calls.
This makes it easier to record the out-going edges to other generated code.
Review URL: https://codereview.chromium.org//11266022
function.HasCode()のパスを削除。

r14036 | srdjan@google.com | 2012-10-25 05:38:53 +0900 (木, 25 10月 2012) | 2 lines
Trace when disabling optimized code (--trace-disabling-optimized-code)
Review URL: https://codereview.chromium.org//11282003
オプション追加
codeの出力は、ToFullyQualifiedCString() %sでPrintしてるだけ。面白い。
il_printerに統合されるかもね。

r14033 | fschneider@google.com | 2012-10-25 03:18:11 +0900 (木, 25 10月 2012) | 8 lines
Fix deoptimzation bug in hoisting smi operation out of loops.
The hoisted operations used an incorrect deoptimization target
so that the program continued with an incorrect environment
after deoptimization.
TEST=tests/language/deopt_smi_op.dart
Review URL: https://codereview.chromium.org//11270013
bugfix AddDeoptStub()の引数にdeopt_id()を与えるように修正

r14022 | floitsch@google.com | 2012-10-25 00:04:32 +0900 (木, 25 10月 2012) | 3 lines
Make isEmpty a getter.
Review URL: https://codereview.chromium.org//11238035
MethodRecognizerのisEmptyからget:isEmptyに変更

r14015 | floitsch@google.com | 2012-10-24 22:05:11 +0900 (水, 24 10月 2012) | 3 lines
Make hasNext a getter instead of a method.
Review URL: https://codereview.chromium.org//11230011
MethodRecognizerのhasNextからget:hasNextに変更

r14006 | fschneider@google.com | 2012-10-24 19:44:00 +0900 (水, 24 10月 2012) | 20 lines
Enable merging of comparisons into branches in checked mode.
Instead of inserting an explicit type check at branches, the
branch instruction checks the input for boolean itself:

"if (a < b)" will be translated by the flowgraph builder
like this:

  CheckedBranch(a < b)

before it would look like this:

  t1 <- (a < b)
  t2 <- AssertBool(t1)
  Branch(t2 === true)

Also in this change:
flow_graph_optimizer.cc contains a small fix of an assert triggered when running
with --trace-optimization.
Review URL: https://codereview.chromium.org//11232063
ComparisonInstrに、is_checked()を持たせ、Emitで参照しAssertBool()を出し分ける。

r14001 | zerny@google.com | 2012-10-24 18:46:24 +0900 (水, 24 10月 2012) | 8 lines
Set previous pointer to graph entry for initial definitions.
This should be replace with direct pointers to the containing block on all
instructions.
R=kmillikin@google.com
Review URL: https://codereview.chromium.org//11265005
FlowGraphにAddInitialDefinitions()を追加
リファクタリング



-------------------------------------------------------------------------------
r13999
Inlining of calls with optional parameters.
Review URL: https://codereview.chromium.org//11028140
ComputeSSA()の引数に、<Definition*>のinlining_parameters引数追加
引数に指定されていれば、graph_entryにinitial_definitions()に追加する。
inliningされる関数の引数は、ConstantInstrである場合の畳み込みが実装されている。
(linliningの結果、ssa_temp_indexを不要に増やさない工夫のはず. ReplaceUsesWith()するだけ)
AdjustForOptionalParameters()がでかい。
OptionalParameterのargumentsとdefaultvalueをstubに突っ込む
inline展開の前に、optional parameterを解決する。

r13974
isEven, isOdd, isNegative, isMaxValue, isMinValue, isInfinite, isPositive, isSingleValue.
リネームのみ。

r13973
Convert 'identical' to strict equal.
Review URL: https://codereview.chromium.org//11234047
identicalがTopLevelで定義されている場合
identicalをVisitStaticCallNode()でStrictCompareInstrに変換

r13969
Propagate class-id through checked mode type checks.
Review URL: https://codereview.chromium.org//11230053
AssertAssignableInstrに、propagated_cid()追加

r13927
Restructure code generation timers and add sub-timers for inlining phases.
Review URL: https://codereview.chromium.org//11236063
timer関連の修正. inliningの際に、Timerをネストして使用。
オプション compiler_stats
timerでinliningの以下を細かく測定
1.ParseFunction()
2.BuildGraph()
3.ComputeSSA() && ComputeUseLists()
4.ApplyICData() && ComputeUseLists()
5.InlineCall() && parameter ReplaceUsesWith


r13922
Avoid rediscovering blocks on each call to FlowGraph::InlineCall.
Review URL: https://codereview.chromium.org//11092102
inliningのあとの、caller側のirとcallee側のirを再解析するのではなくて、
RepairGraphAfterInlining()によって、DominatorTreeを
ReplacePredecessorでメンテ
DiscoverBlocksの回数を減らした。


r13907
EqualOperator ==
Fix super ==: Test first for null before call inf super ==.
Review URL: https://codereview.chromium.org//11230034
// Implement equality spec: if any of the arguments is null do identity check.
// Fallthrough calls super equality.
EmitSuperEqualityCallPrologue()ってなんぞや
ESP+0がnullだったら,check_identity
ESP+wordがnullでなければ,fall
check_identity:
cmpl result, ESP+0
NOT_EQUAL goto is_false
LoadObject result, bool_true()
goto skip_call
is_false:
LoadObject result, bool_false()
goto skip_call
fall::

何に使うのかよくわからん。。
StaticCallInstrが、equality(==)だった場合に呼び出す。
nullであるケースをprologueでskipして、equality演算がpolymorphicInstanceCallになることを
防いでいるのか？

A.==(B)と仮定すると、
ESP+0がA
ESP+wordとresultがB
A(null) == B -> cmp A, result -> resultがnullでtrue, skip
A == B(null) -> cmp A, result -> resultがnullでtrue, skip
A == B -> fall


r13893
Inline load and store index on Float32Arrays.
Review URL: https://codereview.chromium.org//11198072
Float32ArrayCidが、intrinsicsになった。
Float64ArrayCidと比較すると、
loadIndexedの場合は、movss, cvtss2sdしないといけない。
storeIndexedの場合は、逆にcvtsd2ss, movss
メモリ使用量では少ない。

r13882
Cache parsed functions when inlining.
Review URL: https://codereview.chromium.org//11228022
ParsedFunctionからParsedFunction* に変更
inliningされた関数は、flow_graph_inlinerにキャッシュされるようになった。
inliningの度に、関数を再生成しなくてすむので、コンパイル時間にやさしい。

r13871
Avoid creating unnecessary environments during SSA renaming.
Only instructions that can deoptimize and Goto-instructions
ever need an environment.
Review URL: https://codereview.chromium.org//11225028
CanDeoptimize()とGotoのときだけ、set_env()するらしい。

r13866
Make hashCode a getter and not a method.
Review URL: https://codereview.chromium.org//11191078
String_hashCodeからString_getHashCode()にリネーム。
中身はintrinsicsで、
String::hash_offset()の値をmovlで取得し、0か比較した後に返す。


r13859
Enable redundancy elimination for array loads.
This CL also adds a second round of CSE if necessary to make use
of secondary effects for more optimization opportunities.
Review URL: https://codereview.chromium.org//11234002
CSEでLoadIndexedInstrを削除できるようにした。
基本的には、lookupの対象にして、
LoadIndexedInstrに、AttributesEquals()とAffectedBySideEffect()メソッドを追加しただけ。
boolを返すようにし、成功すればDominatorBasedCSEが2回め走る

------------------------------------------------------------------------
rev13843

リビジョンログを読んで興味深かったもの抜粋

r13840
Tuned inlining parameters:
inlining_size_threshold: 250 -> 50
inlining_depth_threshold: 1 -> 3
All measurements on my Linux box:
dart2js: 2% slower, 9% increased code size.
The following benchmarks got approx. 20% faster: DeltaBlueClosures, Richards, BinaryTrees, Sum, Towers, RayTrace.
Review URL: https://codereview.chromium.org//11231014
thresholdの初期値を調整したのみ。
50と3になった。

r13823
Fix bigint modulo operation. Fixes bug 6056
Review URL: https://codereview.chromium.org//11192074
moduleがNegativeか非Negativeか参照し、補正を行う。

r13798
Apply optimization after class-id propagation:
instance calls without ICData are optimized by using input argument class-ids to create fake ICData.
This reduces the number of deoptimizations.
Review URL: https://codereview.chromium.org//11187046
OptimizerにApplyClassIds()を追加
PropagateSminess()の実行後に、ICDataがないICを、引数の型から推定する。
その結果、deoptimizeの挿入を減らす。
BBとinstをたどって、ICだったら、TryCreateICData() VisitInstanceCall()
ICData(ProfileしたType)がない場合、Argの型を見て,icdataを生成して設定する。
現在、Argの型は1つのみ対応。
Resolver::ResolveDynamicForReceiverClass()を使って対象の関数を取得。


r13794
Inline indexed store ([]=) array operations in checked mode.
Review URL: https://codereview.chromium.org//11186047
enable_type_checksの際にも、TryReplaceWithStoreIndexedでされるように処理追加
AssertAssignableInstrを追加する

r13792
Do not bump allocate in old-space pages. Always use
the freelist in preparation for chunked allocation.
Review URL: https://codereview.chromium.org//11186013
gc_sweeperとpagesを修正
BumpAllocateを廃止
代わりにfreelistをFree

r13762
Fix optimization of %: replace IC call even if not optimizable.
Review URL: https://codereview.chromium.org//11190036
fix bug

r13712
In optimized code always deoptimize if we encounter an instance call without type feedback (ICData has no checks).
Fix a bug in inliner: do not inline methods that have no compiled code as we can not deoptimize into them. This is the simplest fix, more complex fixes can be implemented if we see a need for them.
This improves the speed of Meteor by 15% and NavierStokes by 40% (Mac OS X). 
Review URL: https://codereview.chromium.org//11186007
InstanceCallをFlowGraphCompilerでEmitする際に、
もしICでプロファイル済みだった場合、これまでと同様。
もしICでプロファイルしていない(未通過のパス)だった場合、
DeoptInstanceCallNoICDataというタグ付きでDeoptするコードを生成する。
最適化後に、最適化前に未通過のICを呼び出した場合、Deoptする。

r13704
Add value tests to intrinisics GrowableArray _setData and setLength.
Thos are private native methods that could be invoked via mirrors with incorrect values.
Review URL: https://codereview.chromium.org//11195007
_setData
setLength
所々にSmiTagのチェック処理を追加

r13703
Intrinsify writing to Uint8 and Int8 arrays on IA32.
Review URL: https://codereview.chromium.org//11074016
以下のintrinsicsを追加
Uint8Array setIndexed
Int8Array setIndexed
mov EBX, Address(ESP, 1 * word)
SmiUntag(EBX)
addl EBX, 128
cmpl EBX, 0xFF
j ABOVE, fall_through
sub EBX, 128
movb Address(EAX, EDI, TIMES_1), BL  //EAX=base, EDI=index, Store BL
ret


r13696
Intrinsify natural world typed array getters
Review URL: https://codereview.chromium.org//11139004
Int32ArrayとUInt32ArrayのgetIndexedをassemblerで実装
setIndexはまだです。。
値を取り出してsmiに収まらなければreturn false

r13685
Fix receiver's type for constructors.
Review URL: https://codereview.chromium.org//11187003
リファクタリング

r13683
Optimize type checks for boolean expressions using class-id information.
This CL adds a canonicalization pass for AssertBoolean instructions.
If the input class id is guaranteed to be bool, the check can be eliminated.
Review URL: https://codereview.chromium.org//11191002
AssertBooleanInstrはcanonicalizationのvisitorが走った際に、
bool型の場合はdefinitionを返してbool型を伝搬し、冗長なCheckClassを削除

r13682
Inline indexed load and store of typed array float64.
NavierStokes time improves from 34,775us to 12,000us (v8 runs NavierStokes in 16000 us).
Review URL: https://codereview.chromium.org//11092090
今後こういう修正が増えていくのかも。
LoadIndexInstrとStoreIndexInstr周りを大幅改良
kFloat64ArrayCid用の特殊化を随所に埋め込み
TryReplaceWithArrayOpをリファクタリングして、
PrepareIndexedOpとTryReplaceWithStoreIndexedとLoadIndexedに変更
LoadIndexとStoreIndexのEmitNativeCodeも修正
Float64ArrayCidの場合,StoreIntoObjectを使用しない。movsdのみ。
StoreIntoObjectNoBarrierの場合もmovlのみ発行.
Float64ArrayCidの場合は、レジスタ割付で無駄な命令が発行されなくなる？
LoadIndexは特の実装と比較して速いわけではないが、
unboxdouble向けにlocation情報を提供して、doubleのままxmmにloadできるようになった。

r13664
Fix crashes in intrinsified float32/float64 array setters when attempting to store a Smi. Added tests.
Review URL: https://codereview.chromium.org//11144021
intrinsicsのsetIndexed()において、EAX(Base)のsmiチェックを追加


実際のソースコード比較
diff 3k

------------------------------------------------------------------------




rev13637

リビジョンログを読んで興味深かったもの抜粋

r13581
Get rid of RawClosure class and use RawInstance for closures.
Simplify SetRaw to not require an access to the Current Isolate.
Review URL: https://codereview.chromium.org//11087070
Closureクラスが、InstanceからAllStaticになった。
Instanceをコンストラクタでもらう.返り値はInstance
ClosureのInstanceから直接Isolateへアクセスすることを除去
snapshotも簡略化

r13576 | srdjan@google.com | 2012-10-12 04:44:47 +0900 (金, 12 10月 2012) | 2 lines
Apply John's change (Issue 11077007: Intrinsify Float64 array access on ia32 and x64.).
Review URL: https://codereview.chromium.org//11087087
Float64Array_のintrinsicsが実装。ia32とx64にて。
scalarlistのFloat64が高速になったはず。
getIndexed()では、
TestByteArrayIndex()の後、 EAX(base address) + EBX(smi tagged index) << TIMES_4(ScaleFactor 2)
からxmmに値を取り出したのち、TryAllocate()を呼び出してdoubleでboxingした値を返す。
setIndexed()では、
doubleのインスタンスからunboxingして、xmmに格納。
TestByteArraySetIndex()の後、EAX(base address) + EBX(smi tagged index) << TIMES_4(ScaleFactor 2)
に値を格納。
doubleなのにScaleFactor2なのは、smiが既にshift 1されているから。

r13547
Mark optimized functions with a * in the perf event symbol output.
This allows to distinguish time spent in optimized code vs unoptimized code
in our profile information.
Review URL: https://codereview.chromium.org//11028143
perfで性能測定する際のsymbolを、最適化前の関数と最適化後の関数に分けて区別できるようにした。
最適化後の関数は、頭に*がつく。

r13471
Recursive inlining.
Due to large performance regressions on dart2js the default depth is set to 1,
i.e., we only inline the first level of calls by default.
The depth can be changed with the inlining_depth_threshold flag.
深さ優先でcallgraphをたどって、inline展開する。
inlining_depth_threshold=1が初期値で、1回inline展開を試行する。
2だと、1回inline展開をして、さらにその中の関数をinline展開する。

r13443
Implement SmiToInt and DoubleToInt. All necessary tests are in tests/language/arithmetic_test.dart
Review URL: https://codereview.chromium.org//11098009
toIntメソッドを特殊化し、DoubleToInteger命令追加
recognized_kingに追加
doubleをunboxして、Smitag
もしMintだった場合は、GenerateStaticCall

r13408
Faster 64-bit left-shift for ia32.
This CL adds a fast left-shift that operates on unboxed mints.
(64-bit integers) to the ia32 optimizing compiler.
Review URL: https://codereview.chromium.org//11085004
ShiftMintOpInstr::EmitNativeCodeにSHL実装
lowとhighをそれぞれshlした後に、
highをsarlして、overflowを判定、だめな場合はdeopt

r13372
Fix bug with missing unboxed mint-to-double conversion.
In case of a mixed integer/double operation that has a mint
input, the corresponding conversion from unboxed mint to unboxed
double was missing.

This CL converts a unboxed mint to a double by first boxing,
and then unboxing. Currently, we deoptimize in case the result
does not fit into a smi because we can only optimize mixed
smi/double operations and not yet mint/double operations.
Review URL: https://codereview.chromium.org//11017017
from == kTagged && to == kUnboxedMint
from == kUnboxedMint && to == kTagged
from == kUnboxedMint && to == kUnboxedDouble
from == kUnboxedDouble && to == kTagged
from == kTagged && to = kUnboxedDouble
// TODO(fschneider): Implement direct unboxed mint-to-double conversion.

r13352
Hide internal details of VM string implementation.
Review URL: https://codereview.chromium.org//11035057
StringBaseクラスがVM内部に隠蔽
get:length
charCodeAt
hashCode
isEmpty


実際のソースコード比較
diff 5k

version情報を管理するクラスを追加。今はv0.1.x

Dynamicがdynamicにリファクタリング。コメントこみこみ。

Zoneクラスリネーム
Zone->StackZone
BaseZone->Zone

debugger_apiにisolate_idを追加

FlowGraphVisualizerが削除

Leaf系が全部削除。
isLeaf()や、EnterDartLeafFrame()がなくなった。

namespaceのexportが追加。新しい構文？




-------------------------------------------------------------------------------
top 13295

リビジョンログを読んで興味深かったもの抜粋

r13295
Faster 64-bit right-shift for the ia32 compiler.
Review URL: https://codereview.chromium.org//11027060
ShiftMintOpInstr中間表現追加
codegenにも、ShiftMintOpを追加
optimizerで、kMintCidかつkSHRの場合、ShiftMintOpInstrを生成
kSHLは未実装。

r13254
Support for mixed null/smi equality: do not deoptimize,
emit same optimized code as if that was smi-equality only.
Moved assert for duplicate class checks into ICData.
Allow CheckClassInstr to check for Smi as well.
Review URL: https://codereview.chromium.org//11048032
RUNTIME_ENTRY UpdateICDataTwoArgs() 追加
EqualityWithNullArg をstubに実装。 ia32とx64に各々。
Smi型のEquality比較だとしても、
初期化していない場合に、nullが設定されている可能性がある。
その場合、smi, nullの2型になり得るので、
vm内部では、smi型のみの特殊化として扱う。
将来は、DoubleとMintにも拡張する予定。

r13237
Renaming Unboxed* IL instructions to shorter names.
Since we don't have boxed mint and double operations anymore,
we can use shorter names.
Review URL: https://codereview.chromium.org//11027026
Unboxedっていうキーワードがなくなった。地味にうれしい。

r13221
Add fast 64-bit bitwise negation to the IA32 optimizing compiler.
Review URL: https://codereview.chromium.org//11043020
UnboxedMintUnaryOp中間表現を追加
ia32のAssemblerにpxorを追加
kBIT_NOTのを特殊可を追加

r13211
Add fast 64-bit integer ADD and SUB to the optimizing compiler.
They operate on unboxed 64-bit integers stored in xmm registers.
I also fixed an issue with some SSE 4 specific assembler
tests where we hit an assert with an empty assembler buffer
when running with --no-use-sse41.
Review URL: https://codereview.chromium.org//11016028
ia32のMintの計算を特殊化。x64は不要。
ia32のdecoderにsimd追加
sqrtss addss mulss subss divss cvtdq2pd

TryReplaceWithBinaryOpに特殊化パス追加
HasOnlyTwoSmi
HasTwoMintOrSmi
ShouldSpecializeForDouble

UnboxedMintBinaryOpInstrのEmitNativeCodeを拡張
kAddとkSubが追加された。以前はAnd OR XORのみだった。
基本的に、kAddの場合は、addl adcl, kSubの場合は、subl sbbl


r13170
Run canonicalization again after constant propagation.
This eliminates smi checks of constant-valued instructions.  Also fix
printing of block numbers in code comments.
optimizer.OptimizeComputations()を追加


r13112
Support for unboxed 64-bit integer bitwise operations and equality on ia32.
This CL adds AND, OR, XOR and == operations on unboxed 64-bit integers
(aka. mints).
Unboxed mints are stored in xmm registers. Each xmm register location
has an additional bit to keep track of its value representation.
Unboxed mints are materialized on the heap on deoptmization in the same way as
unboxed doubles.
The SSE instructions used are available on all CPUs that support SSE 4.1.
IA32の場合、Representation最適化にDoubleの他にMintを追加
X64環境は関係ない。Mintは64bit integerなので。

IRに、UnboxInteger BoxInterger UnboxedMintBinaryOpが追加
Allocatorにも手が入っていて、MintはDoubleと同様、XmmRegisterにMaterializeされる。
LiveRangeも、DoubleとMintはどうように計算される。

r13081
Revert r13022 (revert inlining of methods with control flow), 
Review URL: https://codereview.chromium.org//10979078;
disable inlining of methods with control-flow so that we do not run out of heap space.
InlineBailoutが削除、control flow系(case, do-while, jump backを含んだもの)がinline展開可能に。
REorderPhisを追加して、番号振り直し
PolymorphicInstanceCallもinline展開可能に。Call数の制限はないけど、グラフの大きさで制限。
オプション多数追加
--inlining-size-threshold=250
--inline-control-flow=false
--inlining-growth-factor=3


実際のソースコード比較
diff 8k

オプション追加
--trap-on-deoptimization=false
--unbox-mints=true
--trace_deoptimization=false
--trace_deoptimization_verbose=false
verboseを指定すると、DeferredMints()を表示する


XMM Registers は、kDoubleとkMintで同様に使う

scavenger
row_obj->isWatched()
the delayed WeakProperty用のscavenge処理
DelayWeakPropertyは、IsHeapObject() && IsOldObject() && !row_key->IsMarked()

SLOW_ASSERT(cond)追加 slow_asserts=falseオプション追加

以下を追加
RawICData* AsUnaryClassChecksForArgNr()
RawICData* AsUnaryClassChecks()

edgeで、ThrowNoSucMethodErrorの制御が変わっていたけど、
parse周りが変更された影響かも
ErrorMsgで埋め込まれていたのが、ThrowNoSuchMethodError()呼び出しになっている。


Isolateに、RawMintとRawIntegerが追加
Isolate用に、Debuggerのportや,signalhandlerの処理を追加している。

deopt周りがかなり改善されててわからん


vm/ast
MakeAssignmentNodeを追加
getterがない場合,'throw NoSuchMethodError'
ほかはとりあえずreturn null
もうちょっと固めにチェックしてほしいけどね。

EmitUnboxedMintEqualityOp
movaps xmm0, left
pcmpeqq xmm0, right
movd temp, xmm0
compl temp, -1
xmm0は、レジスタ割付で割り付けられたxmmの仮番号0なので、xmm0固定という意味ではない。




-------------------------------------------------------------------------------
rev13046(edge)


リビジョンログを読んで興味深かったもの抜粋

r13040
Convert MOD to AND for power-of-two positive constants.
MODがConstantかつSmiである場合、BinarySmiOpInstrのBIT_ANDに変換

r13032
Inline String isEmpty, refactor inlining of intrinsics.
RECOGNIZED_LISTの処理をリファクタリング
isEmptyを追加

r12989
Don't inline recursive calls.
しないらしい。そもそも今までしていたんだっけ？


実際のソースコード比較
diff 4k

リファクタリングが多い

RECOGNIZED_LIST の変更
_ObjectArray,
_ImmutableArray,
_GrowableObjectArray, get:length
_GrowableObjectArray, get:capacity
StringBase, isEmpty

Float32Arrayってのが、ia32とx64に実装されたけど、何に使うのか。。

FlowGraphCompiler::EmitEqualityRegConstCompare()
Register型だった場合、Smi::Castのあとtestqで判定
Operandの片側がconstだった場合に呼び出す。


-------------------------------------------------------------------------------

rev12897(edge)

リビジョンログを読んで興味深かったもの抜粋

r12897
Add code for CPU feature detection and use it to detect SSE3 and SSE 4.1.
The Dart VM now requires at least SSE3 to build and run.
sse4_1とsse3っていうフラグ制御を追加しただけで、emitされるわけではない。

r12849
Fix error in r12771 disabling licm.
これはないなと。。

r12842
Add is_inlinable field to functions.
Repeated attempts at inlining functions that cannot be inlined leads to
noticeable performance regression when compiling with dart2js.
inline展開されましたフラグを保持するように変更
どのへんの制御に使われるフラグなのかは不明。


r12778
Support constant folding of instructions with constant smi values.
In sparse conditional constant propagation,
replace instructions with constant smi values with their constant value.
Extend the analysis to understant shift and bitwise binary operations.
Smi同士の、SHL SHR BIT_AND BIT_OR BIT_XOR に適用範囲を拡大した。
補助関数として、Integer::BitOp() Smi::ShiftOp()が追加


r12772
Fix convergence issues in range analysis.
Split it into three phases: initialization, widening and narrowing.
During widening and narrowing phi-ranges change according to
classical widening and narrowing operators defined as:
Widening:
  [_|_, _|_] v [a, b] = [a, b]
  [a, b] v [c, d] = [c < a ? -inf : a, d > b ? +inf : b]

Narrowing:
  [a, b] ^ [c, d] = [(a == -inf) ? c : min(a, c), (b == +inf) ? d : max(b, d)]

infer()の引数に、init, widen, narrowの3種を渡して、
収束しやすくした。みたい。
phiでループするようなケースにおいて、widenのフェーズでrangeは広がる方向に収束し、
narrowで狭まる。

r12771
Disable loop invariant code motion on deoptimized functions.
deoptimization_counter()を参照して、
一度deoptされた関数の場合LICMを抑止する。
LICMの際にDeoptでメンテナンスを行っていたが、特定条件下においてメンテしきれないのだと思う。

r12756
Reapply "A simpler scheme for garbage collection of ureachable phi inputs."
Fix two issues:
* Unreachable code elimination did not correctly identify all unreachable blocks.
* Loop detection in the register allocator relied on the block IDs.


r12733
Implement range analysis for smi values.
And use it to eliminate overflow checks on + and - operations.
TargetEntryInstrに、RangeAnalysis関連のフィールドとメソッド追加
Constraint命令追加

range_analysisオプションで制御できる。

RangeAnalysis for smi Values.
remove overflow checks from binary smi

if (FLAG_range_analysis) {
  // We have to perform range analysis after LICM because it
  // optimistically moves CheckSmi through phis into loop preheaders
  // making some phis smi.
  flow_graph->ComputeUseLists();
  optimizer.InferSmiRanges();
  {
    range_analysis()
    Analyze()
    {
      CollectSmiValues()   // smiのdefとphi、checksmiを収集する。
      InsertConstraints()  // 各々defにconstraintを設定して初期化する
                           // branchで分かれる場合、true_constraintとfalse_constraintそれぞれに、
                           // それぞれのbranchに分岐した際のRelationを更新してあげる。
      InferRanges()        // worklist方式で推論する。rangeは、min_smiとmax_smiの間で推論する。
                           // rangeに変更があった場合、def->useをworklistに突っ込んで収束するまで繰り返す
      RemoveConstraints()  // 不要になったConstrantを削除
    }
  }
}

恐らく、将来的にはBinarySmiOpがEmitする際の、
add, j(overflow) <-- このjumpを削除するのだと思う。


実際のソースコード比較
diff 6k

全体として、RedirectingFactory関連の修正が多い。

object.h

redirection_data_class
namespace_class
snapshotもあわせて拡張


CPUFuatures
sse3_supported()
sse4_1_supported()

StrictCompareInstr::EmitNativeCode
両方のoperandがconstantだったら畳み込む。




rev12649(edge)

リビジョンログを読んで興味深かったもの抜粋

r12645
Disable inlining by default.
Inlining deoptimizable code currently causes errors.
残念。 有効にする場合は、use_inlining=true

r12630
Improve SminessPropagator to propagate sminess across cycles of phis.
若干phiのたどり方が変わった

r12621
A simpler scheme for garbage collection of ureachable phi inputs.
Simplify the garbage collection of unreachable phi inputs.  Assign immutable
block ids to basic blocks and ensure that both predecessor blocks and phi
inputs are kept sorted by block id.
revertされているけど、
EliminateUnreachablePhiInputs()とClearPredecessors()の置き換え ???

r12616
Introduce a VM-only dart:scalarlist library for byte arrays.
Include it in the SDK so users can use it. Create a dummy
implementation and patch file for the library for dart2js so it can be
documented. Johnni, can you think of a nicer way of making
documentation generation work for a VM only library? Also, it seems that
patching kills the documentation comments and they do not show up in
the generated docs.
DartVMの現在のListはあまり高速でなく、
Javaの配列アクセスを多用するプログラムを移植してくると遅くなってしまう。
byte array用の高速なAPIを作って、VM内部で高速な実装を用意する準備なのだと思う。

r12561
Reapply "Initial implementation of sparse conditional constant propagation."
With a fix for compilation on Mac.  GrowableArray is DISALLOW_COPY_AND_ASSIGN,
so we can't create a temporary one to be ignored and have to pass one in to be
ignored.
class ConstantPropagator追加. FOR_EACH_INSTRUCTIONマクロは便利ですね。。
オプションは、cp
ここでEliminateUnreachablePhiが追加されたのね。。 
到達BlockをSCCPが全部解析して、不要になったブロックは上記で削除するみたい。
SetValueで、Definitionクラスにフィールド追加されたconstant_value_に値更新、lattice管理
latticeを更新すると、use_liseをworklistに追加して伝搬していく。
visitでworklistのinstrを走査しながら、BinarySmiOpの両辺Constantは畳み込む。
TODO support equality for doubles, mints, etc.

ObjectクラスにRawIntergerが沢山追加されている。CPで流用するため。
定数の管理やUtilityを用意。


r12511
Lazy peer API.
This change provides getters and setters for a lazily allocated field
associated with every heap allocated object.  It is a generalization
of the peer field of external string instances, external byte array
instances, and the smrck field of closure instances.
すごく興味深い機能だけど、今後APIに色々追加するんですかね？
これはDartVM専用の機能になるのかな。

r12502
Fix bad optimization of instance-of with uninstantiated types (issue 5216).
Fix bad assert when type check elimination is disabled (issue 5217).
Cleanup of type elimination code in optimizing compiler.
eliminate_type_checksが改善
CanComputeIsNullと、CanComputeIsInstanceOfのケースも削除対象


r12499
Reapply "Deoptimization support in inlined code."
inlining bailoutがかなり減った。
PolymorphicInstanceCallが候補１つだけの場合、積極的にinliningするようになった。
これのおかげで、aobenchのボトルネックはsphere_intersectになった。はず。


実際のソースコード比較
diff 6k

Peerは、std::map<RawObject*, void*>みたいなデータ構造と理解
RawObjectは、GCの管理対象として、スペースごとに管理されており、
各スペースごとにPeerも管理することになった。

Peerは、通常のheap管理とは別のmapで管理する。
Heap::SetPeer(RawObject*, void*) Heap::GetPeer(RawObject*)

IsNewObjectとIsOldObjectってなんでしょうね。
// Alignment offsets are used to determine object age.
kNewObjectAlignmentOffset = kWordSize,
kOldObjectAlignmentOffset = 0,

raw_objがold_spaceかnew_spaceかによって、void* peerの処遇も変わるようで。
PageSpaceクラスに、GetPeer() SetPeer()メソッドを追加し、
PeerTable map管理されており、Get/Setできるみたい。

Scavengeの際にPRocessPeerReferents()が呼ばれ、PeerTableを捜査し、
IsForwardingだったら、SetPeerでspaceのテーブルの参照を更新する。

GCMarkerにおいて、Peer向けの処理が追加
Markから漏れてRawObjectがSurvivedでない場合、Peer_tableから削除。


FlowGraphAllocatorも大きく更新されている。
valueがConstantだった場合の、rangeやlivein/outの解析が改良されている。
ProcessEnvironmentUses()のConstant周りの処理が一新。
代わりに、最後に行っていた Process global constantsが削除

generateInlinedMathSqrt()が削除されている。
NumberNegateInstrが削除。



rev12443(edge)


リビジョンログを読んで興味深かったもの抜粋

r12443
Avoid using a temp register when unboxing a known smi.
Instead of saving into a temp, restore the input by re-tagging
it after the conversion.
UnboxDoubleInstr::Emitにおいて、smiの場合に、高速なunbox命令群をEmitする。
具体的には、untaggingSmi -> xmm conv -> taggingSmi

r12437
Simple redundant load elimination.
This analysis uses bit vectors to track side effects. Currently, there is
only one type of side effect which affects all mutable load-field instructions.
The elimination pass is a dominator tree preorder traversal like the existing
CSE pass. Instead of a hash-map it keeps an array with the current dominating
occurrence for each load expression.
LLVMのGVNっぽく、冗長なLoad命令除去を追加
HasSideEffect()を追加、BitVectorをエンハンス
AvailLoadをBitVectorで管理し、HasSideEffectがあればdrop
Availであるかぎり、冗長なLoadの使用点を、AvailLoadの使用点で置き換えていく。
支配順にたどり、子の支配ブロックへAvailLoadを伝搬していく。
AvailLoadは、このパスを実行する前に、1回だけ解析する。
Avail out/gen/killの集合をbitvectorを使って効率よく計算していく。
とはいえ、最後はAvail in/out/kill/genが収束するまで計算する。


r12430
Enable CSE for binary smi ops and constants.
中間表現のAttributeEqualをエンハンスして、CSEでEqualする際の対象にした。


r12427
Mangle private names in the method recognizer otherwise they are not recognized.
mangle部分を除去して比較するメソッドの追加

r12378
Enable redundancy elimination for initialized static final fields.
Once initialized, static final fields are immutable and can participate
in common subexpression elimination and code motion without  being affected by side effects.


r12332
Add unboxed double negation and reenable optimized smi negation.
Fix the optimizer to recognize unary minus operations and
implement double negation as (x * -1) using the unboxed double multiplication.
unary-向けに特殊化
negate向けにUnboxedDoubleBinaryOpeで特殊化


r12322
Optimize code for bound checks if array is constant.
Skip unnecessary Smi checks if they still survived to code emission.
定数の配列のBoundCheckが冗長なので生成抑止。
Emit時に検出したらAssert


r12273
Mark phi as producing a smi value if it is dominated by SmiChecks over its operands.
SminessPropagator追加 worklistをたどる形式
PropagateSminessRecursive()は、BBを支配順にたどりながら、BB中のCheckSmiInstrを収集して、smiを確定させていく。
phiがSmiでないけど、phiのinputがSmiと確定していたら、最終的にProcessPhis()で判定。
ProcessPhis()では、worklistを順にたどりながら、
phiがSmiと確定したら、phiのinput_use_list()をたどって、phiだったらworklitに追加
ネストしたループのphiを、内側からsmiに確定させていく処理なのだと推測。

r12257
Use ICData to collect type feedback on instance setter value.
If value is always Smi, insert a smi check and eliminate the store barrier.
TODO: Implement it for indexed store (collecting three arguments).
emit_store_barrierフラグを新規追加、有効な場合StoreIntoObject()でEmitする。
有効でない場合(ArgIsAlwaysSmi(* instr->ic_data(), 1)で確認し、CheckSmiInstrを挿入済み。)
StoreIntoObjectNoBarrier()でEmitする。



実際のソースコード比較
diff 6k

vm/dart_api_implの変更が多い。
r12342の以下が対象らしい。
- Added supporting functions to the dart embedding api:
- Dart_ClassIsTypedef
- Dart_ClassGetTypedefReferent
- Dart_ClassIsFunctionClass
- Dart_ClassGetFunctionClassSignature
- Dart_FunctionReturnType
- Dart_FunctionParameterType
- Dart_VariableType
- Dart_GetTypeVariableNames
- Dart_LookupTypeVariable
- Dart_IsTypeVariable
- Dart_TypeVariableOwner
- Dart_TypeVariableUpperBound

//Handles inline cache misses by updating the IC data array of the call
InlineCacheMissHandlerThreeArgs
ThreeArgsCheckInlineCache

LoadVMFieldInstrからLoadFieldInstrへ置換？

remove
LoadInstanceField
LoadVMField
CheckBound

snapshot ClosureData::ReadFrom ClosureData::WriteTo




Rev12254

リビジョンログを読んで興味深かったもの抜粋

r12254
Whenever possible use length passed to the List constructor for bounds checks
instead of loading it from the array object itself.

既存のCheckArrayBoundInstr
が、新規追加されたCheckBoundInstrに特殊化される。

BoundCheckInstr命令、cmpしてBoundを越えればdeoptimize

r12249
Flush instruction cache when patching for lazy deopt.

2命令追加されただけだけど、効果がよくわからん。

r12245
Split array loads/stores for growable arrays into two IL instructions.
This simplifies the code generation function for indexed loads/stores
a lot and help eliminating the load of the backing store in the future.
Enable CSE for loads of immutable fields like string length or fixed array
length.

StoreIndexedInstr & LoadIndexedInstr
両者のEmitNativeCodeが簡略化


r12244
Inline monomorphic calls.
Also add inlining support for more instructions that can not deoptimize.

沢山InlineBailoutが追加された。。
inliningの対象がStaticCallからDefinitionに拡張
ClosureCallもPolymorphicInstanceCallもinlineを試行する
けどまだ大量のBailoutにひっかかって効果はなさそう。


r12226
Shrink the size of deoptimization_counter_ and kind_tag_ fields. This
compensates for the new num_optional_named_parameters_ field.

deoptimization_counterがintptr_t->int16_t
代わりにuint16_t kind_tag_を追加


r12109
Use CHA to eliminate checks for calls on receiver of caller: check that there can be only one target.

DynamicFunctionのreceiverを、CHAを使用して解析、
可能であればcall_of_checkを除去してPolymorphicInstanceCallInstrに置換


実際のソースコード比較
diff 5k

kWritableRegister ???

trace_ic_miss_in_optimizedフラグ追加

FactoryConstructorがListFactoryだった場合の特殊化が追加
kGlowableOpbjectArrayCidとkArrayCid

IRに以下が追加
GlowableObjectArray get::capacity
MathSqrtInstr
CheckBoundInstr

bool InstanceCallNeedsClassCheck()


visitStaticCallでMathSqrtInstrへの特殊化を行っている




rev12079

実際のソースコード比較
diff 4k

optional parameter関連が多いかも

LICM追加
TryHoistCheckSmiThroughPhi
  phiがSmiなら、CheckSmiは不要なので除去
  phiがDynamicCidだけど、opがsmiとnon-smiの場合、
  phiをSmiに格上げして、non-smiをcheck付きでhoistする。


Intrinsifier Double_toInt追加

assemblerにcvttsd2siq追加。CVTTSD2SI r64, xmm1/m64

metadata
skipMetadataのみ。parseできますよ程度。


FlipCondition
EvaluateCondition
静的に評価可能なConditionを評価する。
しかもEmit直前に行う。。

リビジョンログを読んで興味深かったもの抜粋

r12078

VM can parse and ignore metadata

Support parsing of metadata in all legal locations except library
and import directives. The metadata is simply ignored. It is not
evaluated or validated for correctness.


r12014
Repair flow graph printing after graph refactoring.

r12006
Revert "Finalize reachable weak persistent handles at isolate shutdown."

r11947
Allow smi comparisons to have constant operands.
Remove unnecessary temps reserved for them.
Load constants directly in phi moves.
Generate xor(reg, reg) for loading of 0 instead of mov.

branchの片方のオペランドが定数だったら、 xorl
ComparisonをEmitするタイミングで両オペランドのConstantを静的評価している。
のちのちConstant Propagationによって置き換えられるらしい。

r11946
Implement loop invariant code motion for check instructions.
This CL adds a new optimization pass that hoist loop invariant
instructions upwards out of loops.

LICM追加 Inst単位にHasSideEffectを持つのは面白い。
ループ検出はDominator任せ。
今はCheck系やBoxUnbox系のInstしか引き上げできなさそう。
Deoptの詳細把握してないのでよくわからんけどLICMでDeoptメンテしてますね。


rev11976(trunk)



rev11932


実際のソースコード比較
diff 11k

大部分がリファクタリング

ComputationとBindInstrが廃止！！！

TestGraphVisitor ???

FlowGraphTypePropagator::VisitBlockが追加

若干遅くなったなと思ったけど、EmitInstructionEpilogueが原因？




リビジョンログを読んで興味深かったもの抜粋

Allow test context to have multiple true and false branch slots.

Implement special handling for && and || in the test context to eliminate materialization of intermediate boolean values.

Fix build break on Win32 and MacOS related to printf format string checks.

Reapply "Remove classes Computation and BindInstr."

rev11869

実際のソースコード比較
diff 6k

deoptimization関連

CompilerDeoptInfo
CompilerDeoptInfoWithStub
DeoptRetAddrAfterInstr
DeoptRetAddrBeforeInstr


リファクタリング関連

Valueクラス
  definition()
  next_use()
  instruction()
  PrintTo()

enum Representation
  kTagged, kUnboxedDouble

EmbeddedArrayクラス

Instructionクラス
  PrintTo()

BinaryDoubleOpCompが削除

parseが結構改造されてる


optimizer関連

ShouldSpecializeForDouble()

HandleRelationalOpのHasOnlyTwoSmiの特殊化
HandleEqualityCompareのHasOnlyTwoSmiの特殊化
  not impl mixed mode

BinarySmiOpにおいて、opの片方がConstantだった場合のコード生成を改造


リビジョンログを読んで興味深かったもの抜粋

Remove classes Computation and BindInstr. だけどRevertされた

CheckNonSmiの追加、だけどRevertされた

Specialize binary operations with mixed Smi-Double feedback as Double ones.

Only store IC data with instructions that collect type feedback.
Currently only three instructions,
InstanceCall EqualityOp RelationalOp


rev11673(edge)

実際のソースコード比較
7k
a flow_graph_inliner

option
  --deoptimize_alot
  --trace_inlining

deoptimize関連

xmmレジスタのコピーや退避処理が追加

flow_graph関連

Inlining向けの制御が追加

Inliningの処理が、FlowGraphのbuilderで新規解析を行った、自分にくっ付けるだけって面白いな。。

Inliningは、今のところ、static callのみ。また早期に実施する。

intermediate_language関連

ArgumentDefinitionTestが追加

parseに、formal parameterのチェック機能追加。ArgumentDefinitionTestを生成するみたい

stack_frameにStackMapのコメントが追加

StackMap内では、レジスタは全てbitmap管理らしい

EliminateDeadPhis()

SelectRepresentations()
  BoxDouble/UnboxDouble処理
  名前がV8っぽい

GenerateDartCall()追加

EmitClassChecksNoSmi()削除

Deoptimization Infrastructureって読ばれているけど、まだちゃんと理解できてない。


全体的に、double向けの処理と、xmmレジスタの使用に関して、手が入ってきた。

smi向けのVMの最適化は一通り終わって、今はdouble向けにいろいろ実装を進めているのかもしれない。


リビジョンログを読んで興味深かったもの抜粋

option --deoptimize-alot

The continuation for lazy deoptimization

Rematerialize constants instead of spilling

Add explicit class checks: LoadVMField class

Inlining of static calls

Eliminate Boxing/Unboxing pairs.


rev11635(trunk)

rev11547

diff 6k ほとんどリファクタリング

vm/heap

  GCReasonってのが追加されて、gcのcodespaceは以下のいずれからしい。

  new space, promotion failure, old space, code space, full, debugging, test case

  snapshotの際に、message型の場合はnewに割り付け、それ以外の場合はoldに割り付け

FlowGraphAllocator

  global constans対応

IntermediageLanguage

  Materializeが削除、、

  StrictCompareAndBranchが削除, StrictCompareになったかも

CodeGeneratorのDEOPT_REASONSが興味深い

EmitBranch()を追加

  EqualityCompare, RelationalOp,

benchmark_testに、DartStringAccessってのが追加

rev11433
diff 3k

AttributeEqualの新規追加

CheckArrayBoundCompの新規追加

Optimizerにおいて、
insertBefore, insertAfterメソッドを使用して、
積極的にguardを挿入するようになってきた。

smiだった場合にCheckArrayBound

UseListのValidator riset

snapshotの修正が増えてきた。Conputationが増えたのが原因だろうか。

intermediate_languageから
deopt系のStub追加処理が削除


rev11373

*** Locations & FlowGraphAllocator

locationsのkindに、kXmmRegisterと、kDoubleStackSlotが追加
併せてFlowGraphAllocatorを大改造

レジスタに関連する処理全体にxmmレジスタ対応で修正入っている。


*** FlowGraphBuilder

StrictCompareAndBranchへの置換処理


*** intermediate_language

特殊化されたComputationが増えてきた。
CheckSmi
CheckEitherNonSmi
UnboxedDoubleBinaryOp
UnboxDouble
BoxDouble
StrictCompareAndBranch

*** FlowGraphOptimizer

--use_unboxed_doubles

inst = Computation(DoubleCid, left, right)

t0 = CheckEitherNonSmi(left, right);
t1 = UnboxDouble(left);
t2 = UnboxDouble(right);
t3 = UnboxedDoubleBinaryOp(t1, t2);


LocalCSEが首に。
DominatorBasedCSE()

Block全体みたいん

 --trace_optimizationで参照可能

最適化パス群が出来上がってきたかも
BuildGraph
ComputeSSA
  LocalLoad/LocalStoreは変換の際に除去するらしい
ApplyICData
PropagateTypes
OptimizeComputations
DominatorBasedCSE


ComputeUseListとは何ぞや
Handlerでメンテしないので、明示的に再解析？



Locationでレジスタとスタックの推移を管理して、
PeepholeOptみたいなことをするつもりなのかな？

Computation単位でEmitする仕組みであるため、
Computation単位でin/out/tempのレジスタを管理し、
MacroAssemblerの引数にLocationで管理しているレジスタを指定する。



rev11197
diff 5k

A cha  ClassHierarchyAnalysis
  オプション --use_cha

dart_api_impl 修正量多い
RemoveOptimizedCode()実装。
  JVMみたいにクラスロード時???にDeoptimize
  将来的にはCHA参照みたい。
AddDirectSubclass追加

Computationに以下を追加
  BinarySmiOp
  BinaryMintOp
  BinaryDoubleOp
  Materialize

is_ssaからis_optimizingに変更。grepする際はこのキーワードで

AllocateRegistersLocally greedy local register allocation

FlowGraphOptimizer
  AddCheckClassを新規追加
  smiどうしやdoubleどうしは特殊化しつつある





rev10999
diff 7k

A flow_graph flow_graph_builderからのリファクタリング
A hash_map  ValueNumbering用

WeakPropertyクラスを新規追加
  GC関連？
  ProcessWeakProperty
  Snapshptもされるみたい。何のために追加されたんだk？

support for GC watched bit.

Equalityのnull対応されてる。。

lookupのscopeが狭まってきた。

Optimizer大幅修正
LocalCSE
  Block内のInstだけでValueNumbering風にCSEする。

kNumArgsChecked = 2; // type-feedback

aobench 9.5sec



dartvm rev 10783
diff 8k

vm/gdbjit_android new
vm/debuginfo_android new
vm/elfgen  new refactoring
vm/virtual_memory_android new
vm/os_android new

ここまで 1k

FlowGraphAllocator
  Safepoint関連の修正


bootstrapやloadscriptまわりもおもしろそう。
すでにstring型のソースコードをたべれるみたいだし。

is_ssaフラグが全体にちらばってきた。

FlowGraphOptimizer
  Type関連の最適化

  irにis_eliminateフラグを持たせて、
  macro asmのフェーズでフラグ参照してtype guard除去っすか、、

そういえばどこでinline展開してるのか調べてなかったな。。
TypePropagatorの後で入れるのかもしれない。



dartvm rev10609
diff 7k

disassembler大改造 2kstep
恐らく--disassemble-optimizedオプションのため
--disassembleオプションと同時指定は動かないかも


codegen
  deopt
  lookupCodeとか変わってるのが気になる。
  たぶん、stubのMegamorphicLookup()が廃止になったのが原因かも。

FlowGraphAllocator
  processUsesEnvが追加されたので、bailoutが減ったかも？

FlowGraphBuilder
  BuildConstructorTypeArguments


intermediate_language

  virtual Definiation* tryReplace()
  propagateType
  PropagetedType

  UseList
  addUses removeUses

  ReplaceUsesWithメソッド

  CompileTypeの導入

FlowGraphOptimizer
  OptimizeComputation

  TypePropagator に修正

FlowGraphCompiler
  BuildConstructorTypeArguments

  compiler->isLeafってなんだろうな

DeoptimizeInstruction
  DeoptimizationContextクラス追加


メモ
+  enum KindTagBits {
+    kStaticBit = 1,
+    kConstBit,
+    kOptimizableBit,
+    kHasFinallyBit,
+    kNativeBit,
+    kAbstractBit,
+    kExternalBit,
+    kKindTagBit,
+    kKindTagSize = 4,
+  };



dartvm rev10436
diff 15k

新規作成
vm/snapshot_ids
vm/deopt_instructions 多い

修正量が多い
FlowGraphAllocatorの修正
FlowGraphBuilderの修正
parser
snapshot
flow_graph_compiler_xx
object

RUNTIME_ENTRYの、第0引数が変更された。
arg0の項目がなくった。


id()が変更 Cidが末尾に付くようになった。それに関連するリファクタリング
CodeGenにdeopt_idがくっついてるけど、

class_id
kDoubleCid

速度低下は、Objectクラスのlookupの変更が影響しているのだろうか。


dartvm rev9979 vm/symbolが新規作成、全体的にvm/symbol向けにリファクタリング
FlowGraphAllocatorの修正が多い
SpillとLiveRangeのSplitも実装されたし、
SSA LinerScanとしての機能は一通り揃った感じ
リファクタリングや機能追加の過程を見るのは結構勉強になりますね。。

dartvm rev10119
flowgraphallocatorとdeoptimize周りに修正
--use_ssaがちゃんと動く

deoptimizationのbailoutケースが減ってる
registers_copy frame_copy などのサポートが入った？

PushArguments()のリファクタリング

CanDeoptimize()がtrueなのは、
PolymorphicInstanceCall
EqualityCompare
RelationalOp
LoadInstanceField
StoreInstanceField
LoadIndexed
StoreIndexed
InstanceSetter
LoadVMField
BinaryOp
NumberNegate
toDouble

###############################################################################
2013/04
ARM対応とMIPS対応の修正が多い。ARM版はクロスコンパイルできるようになった。
ARMのほうが対応が進んでるけど、MIPS対応はARMの1week遅れくらい。
ARMはIRの実装に進んでいる。MIPSもIRの実装に進んでいる。
どちらもStubsとRuntimeの実装。どちらもhello worldまでいけたっぽ。
armの場合、deoptimizeの実装に着手？

最近は文字列処理を高速化している最中。
copyの高速化を試してみたい、文字列処理を組込み関数にしてみたり。
latin-1用の高速なパスを追加してみたり。

float/int32x4型は着々と実装が進んでいるみたい。
intel向けには、 レジスタ割付、box/unboxの実装は完了している。
add/mul/sub/div/まで実装された。今後max/minなどの各メソッドを実装するはず。

最近はbugfixやdeprecatedの整理が多、M4がリリースされた。

2013/05
stacktraceやsavedcallee系の修正が4月末から多い印象。
editorと連携したdebug関連に手が入っているのだと思う。
特にclosureと連携したcaptureとstackframeとの絡みかな。

object headerが修正されて、freeがなくなって、代わりにrememberedsetが入った。
gcも一緒に修正されて、storebufferがシンプルになった。bufferの重複チェックはrememberedsetを参照する。
gcの際には、objectごとにrememberedsetという状態を持つし、
objectのscan中にはold_object_pointerって状態も管理しているので、
コードはシンプルだけどよくわからん。

あとはType Argumentsの修正が多いかも。
おそらく継承したクラス間でType Argumentsを共通化して重複して格納することを排除している。

HandleがPersistanteHandleとWeakPersistentHandleを追加。
大幅にHandleを使う内部処理をリファクタリングしている。
また、Profileをとって無駄なHandleを削除したり、上記への置き換えが進んでいる。

ARM向けは5月末に大量に修正されている。
ARMではOptimizerが有効になっており、そこそこ動くはず。
intrinsicsの修正は完了。
順調に最適化されたIRが実装されている。
Android Emuで試すか?

前までMIPS向けはARMの1週間遅れだったけど、途中から更新されていないかも。。
MIPS向けをメインでやっていたzra-sanがARM向けも手伝っていそう。


2013/06
MIPS向けの機能追加が多かった。またはMIPS固有の機能追加。
ARM向けはx86と同等のspecでテスト通っているが、IRが追加されていないためまだまだ遅いはず。
MIPS系はあといくつかのテストをpassする必要がある。runtime/vm/vm.status参照。
ia32のunimplが32個あるのに対して、ARM, MIPSは残り75個。40個くらいunimplを埋めると、実装が追いつく。

VMの大きな変更としては、
On-Stack Replacementの追加
throw_on_javascript_int_overflowの追加。53bitを越えて整数演算した場合に例外を投げる。
print object histgram。isolateのshutdown時にlive objectの統計を出力する。
NoSuchMethodInvocationの高速化
Try-Catchを最適化

また各種統計を強化して、adaptiveな最適化を強化したいらしい。
StaticCallをICっぽい処理にして、countをとっている。

runtime/includeのヘッダを分割されたため、
組み込みやnative系はinclude headerを修正する必要がある。

2013/07
bugやissueの修正が多い。
NoSuchMethodInvocationの高速化 NoSuchMethodのOptionalParameterにも対応

ARMとMIPSは、OSRの実装まで完了。NEONの実装を開始。
ARM NEONを実装
ARMの実装はおそらく8月中に終わる

大量にmirror向けにbootstrap_nativesを追加。
lib/mirrorの修正が多い。

VMはほぼほぼStableになった。
