Deoptimization
###############################################################################

OptimizedIR ::

  After Optimizations:
  ==== file:///home/elise/language/dart/work/adven/deopt.dart_::_fibo
    0: B0[graph] {
        v0 <- Constant:29(#null)
        v1 <- Parameter:30(0) {PT: dynamic} {PCid: dynamic}
  }
    2: B1[target] ParallelMove eax <- S-1
    4:     CheckStackOverflow:2()
    6:     v2 <- Constant:4(#2) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [2, 2]
    8:     CheckSmi:5(v1) env={ v1 [eax], v1 [eax], v2 [C] }
   10:     Branch if RelationalOp:5(<, v1, v2 IC[1: _Smi@0x36924d72, _Smi@0x36924d72 #873]) goto (2, 3)
   12: B2[target]
   13:     ParallelMove eax <- eax
   14:     Return:8(v1)
   16: B3[target]
   18:     v3 <- Constant:11(#1) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [1, 1]
   20:     ParallelMove ecx <- eax
   20:     v4 <- BinarySmiOp:13(-, v1, v3) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [1, 1073741822] -o
   22:     PushArgument:14(v4) {PCid: dynamic}
   24:     v5 <- StaticCall:15(fibo v4) {PT: dynamic} {PCid: dynamic} env={ v1 [S-1], a0 }
   25:     ParallelMove eax <- eax
   26:     ParallelMove ecx <- S-1, S+0 <- eax
   26:     v7 <- BinarySmiOp:21(-, v1, v2) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [0, 1073741821] -o
   28:     PushArgument:22(v7) {PCid: dynamic}
   30:     v8 <- StaticCall:23(fibo v7) {PT: dynamic} {PCid: dynamic} env={ v1 [S-1], v5 [S+0], a0 }
   31:     ParallelMove ecx <- eax, eax <- S+0
   32:     CheckSmi:25(v5) env={ v1 [S-1], v5 [eax], v8 [ecx] }
   34:     CheckSmi:25(v8) env={ v1 [S-1], v5 [eax], v8 [ecx] }
   36:     ParallelMove edx <- eax
   36:     v9 <- BinarySmiOp:25(+, v5, v8) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [-inf, +inf] +o env={ v1 [S-1], v5 [eax], v8 [ecx] }
   37:     ParallelMove eax <- edx
   38:     Return:26(v9)

OptimizedCode ::
  
  Code for optimized function 'file:///home/elise/language/dart/work/adven/deopt.dart_::_fibo' {
          ;; Enter frame
  0xb2f08468    55                     push ebp
  0xb2f08469    89e5                   mov ebp,esp
  0xb2f0846b    e800000000             call 0xb2f08470
  0xb2f08470    83ec04                 sub esp,0x4
          ;; B0
          ;; B1
  0xb2f08473    8b4508                 mov eax,[ebp+0x8]
          ;; CheckStackOverflow:2()
  0xb2f08476    3b25743e630a           cmp esp,[0xa633e74]
  0xb2f0847c    0f8668000000           jna 0xb2f084ea
          ;; v2 <- Constant:4(#2) {PT: _Smi@0x36924d72} {PCid: _Smi@0x36924d72} [2, 2]
          ;; CheckSmi:5(v1)
  0xb2f08482    a801                   test al,0x1
  0xb2f08484    0f8573000000           jnz 0xb2f084fd    // goto deoptimize
          ;; Branch if RelationalOp:5(<, v1, v2 IC[1: _Smi@0x36924d72, _Smi@0x36924d72 #873]) goto (2, 3)

checksmiの、test al,0x1, jnzでdeoptimizeにとぶはず。

runtime flame ::

          ;; CheckStackOverflowSlowPath
  0xb2f084ea    50                     push eax
  0xb2f084eb    b940bc0a08             mov ecx,0x80abc40
  0xb2f084f0    ba00000000             mov edx,0
  0xb2f084f5    e82e7b3f02             call 0xb5300028  [stub: CallToRuntime]
  0xb2f084fa    58                     pop eax
  0xb2f084fb    eb85                   jmp 0xb2f08482
          ;; Deopt stub for id 5
  0xb2f084fd    e8767f3f02             call 0xb5300478  [stub: Deoptimize]
          ;; Deopt stub for id 25
  0xb2f08502    e8717f3f02             call 0xb5300478  [stub: Deoptimize]
          ;; Deopt stub for id 25
  0xb2f08507    e86c7f3f02             call 0xb5300478  [stub: Deoptimize]
          ;; Deopt stub for id 25
  0xb2f0850c    e8677f3f02             call 0xb5300478  [stub: Deoptimize]
  0xb2f08511    e9227f3f02             jmp 0xb5300438  [stub: FixCallersTarget]
  0xb2f08516    e9fd7f3f02             jmp 0xb5300518  [stub: DeoptimizeLazy]
  }

deopt id 5経由でdeoptimiに飛ぶと。

trace ::

  Deoptimizing (reason 17 'CheckSmi') at pc 0xb2f08502 'file:///home/elise/language/dart/work/adven/deopt.dart_::_fibo' (count 0)
  *0. [0xbffd8adc] 0x0000b2f0836a [ret bef oti:0(5)]
  *1. [0xbffd8ae0] 0x000000000004 [const oti:1]
  *2. [0xbffd8ae4] 0x0000b2fa0869 [eax]
  *3. [0xbffd8ae8] 0x0000b2f08350 [pcmark oti:0]
  *4. [0xbffd8aec] 0x0000bffd8afc [callerfp]
  *5. [0xbffd8af0] 0x0000b2f082ef [callerpc]
  *6. [0xbffd8af4] 0x0000b2fa0869 [eax]
    Function: file:///home/elise/language/dart/work/adven/deopt.dart_::_fibo
    Line 2: '  if (n < 2) {'

GenerateDeoptimizationStub
===============================================================================

deoptimizationには、eagerとlazyが存在する。

lazyの場合、EAXレジスタを保護する。

runtime/vm/stub_code_ia32.cc ::

  // TOS: return address + call-instruction-size (5 bytes).
  // EAX: result, must be preserved
  void StubCode::GenerateDeoptimizeLazyStub(Assembler* assembler) {
    // Correct return address to point just after the call that is being
    // deoptimized.
    __ popl(EBX);
    __ subl(EBX, Immediate(CallPattern::InstructionLength()));
    __ pushl(EBX);
    GenerateDeoptimizationSequence(assembler, true);  // Preserve EAX.
  }

  void StubCode::GenerateDeoptimizeStub(Assembler* assembler) {
    GenerateDeoptimizationSequence(assembler, false);  // Don't preserve EAX.
  }

eaxがpreservedされているのかどうかを、最初に判定している。

lazyなほうが、保存するEAXが少なくてすむ。退避レジスタ数からInstructionLength()分引いている。


stub deoptimize
===============================================================================

Stubは、optimized frameからunoptimized frameへ変換する。
optimized frameは、registerとstackに値を含んでいる。
unoptimized frameは、全ての値をstackに含んでいる。

deoptimizeは、以下のステップで行う。
1. レジスタの値を全てpushする。
2. 全てのstackとレジスタをtemporary bufferにコピーする
3. 呼び出し側のcallerrのフレームを、unoptimized frameのサイズに調整する。
4. unoptimized frameで埋める
5. Materialize Object(xmmの値を、Double型もしくはMint型にUnboxingして格納しなおす)

image ::

  // GC can occur only after frame is fully rewritten.
  // Stack:
  //   +------------------+
  //   | Saved FP         | <- TOS
  //   +------------------+
  //   | return-address   |  (deoptimization point)
  //   +------------------+
  //   | optimized frame  |
  //   |  ...             |


static void GenerateDeoptimizationSequence(Assembler* assembler, bool preserve_eax) ::

    __ EnterFrame(0);
    // The code in this frame may not cause GC. kDeoptimizeCopyFrameRuntimeEntry
    // and kDeoptimizeFillFrameRuntimeEntry are leaf runtime calls.
    const intptr_t saved_eax_offset_from_ebp = -(kNumberOfCpuRegisters - EAX);
    // Result in EAX is preserved as part of pushing all registers below.

    // Push registers in their enumeration order: lowest register number at
    // lowest address.
    for (intptr_t i = kNumberOfCpuRegisters - 1; i >= 0; i--) {   //1. レジスタをstackに退避
      __ pushl(static_cast<Register>(i));
    }
    __ subl(ESP, Immediate(kNumberOfXmmRegisters * kDoubleSize)); //1. xmmレジスタの退避領域計算
    intptr_t offset = 0;
    for (intptr_t reg_idx = 0; reg_idx < kNumberOfXmmRegisters; ++reg_idx) {
      XmmRegister xmm_reg = static_cast<XmmRegister>(reg_idx);    //1. xmmレジスタをstackに退避
      __ movsd(Address(ESP, offset), xmm_reg);
      offset += kDoubleSize;
    }

    __ movl(ECX, ESP);  // Saved saved registers block.
    __ ReserveAlignedFrameSpace(1 * kWordSize);
    __ SmiUntag(EAX);
    __ movl(Address(ESP, 0), ECX);  // Start of register block.
    __ CallRuntime(kDeoptimizeCopyFrameRuntimeEntry);             //2. FrameのCopy
    // Result (EAX) is stack-size (FP - SP) in bytes, incl. the return address.
  
    if (preserve_eax) {
      // Restore result into EBX temporarily.
      __ movl(EBX, Address(EBP, saved_eax_offset_from_ebp * kWordSize));
    }
  
    __ LeaveFrame();
    __ popl(EDX);  // Preserve return address.                  //3. resize frame
    __ movl(ESP, EBP);
    __ subl(ESP, EAX);                                          //return address - unopt stack size
    __ movl(Address(ESP, 0), EDX);

    __ EnterFrame(0);
    __ movl(ECX, ESP);  // Get last FP address.
    if (preserve_eax) {
      __ pushl(EBX);  // Preserve result.
    }
    __ ReserveAlignedFrameSpace(1 * kWordSize);
    __ movl(Address(ESP, 0), ECX);
    __ CallRuntime(kDeoptimizeFillFrameRuntimeEntry);   //4. fill frame and deopt execute
    // Result (EAX) is our FP.                          //   and deopt buff finalize
    if (preserve_eax) {
      // Restore result into EBX.
      __ movl(EBX, Address(EBP, -1 * kWordSize));
    }
    // Code above cannot cause GC.
    __ LeaveFrame();
    __ movl(EBP, EAX);
  
    // Frame is fully rewritten at this point and it is safe to perform a GC.
    // Materialize any objects that were deferred by FillFrame because they
    // require allocation.
    AssemblerMacros::EnterStubFrame(assembler);
    if (preserve_eax) {
      __ pushl(EBX);  // Preserve result, it will be GC-d here.
    }
    __ CallRuntime(kDeoptimizeMaterializeDoublesRuntimeEntry); //5. materialize xmm reg to double or mint
    if (preserve_eax) {                                        //deopt executeで確定したregをmaterialize
      __ popl(EAX);  // Restore result.
    }
    __ LeaveFrame();
    __ ret();
  }


if (preserved_eax)って沢山はいってますね。

最後のMaterializeが完了するまでは、安全にGCできない。

xmmに格納された値をframeに退避するだけでは不十分で、Double型もしくはMint型にしてMaterialize(Stackに配置)する必要がある。

Materializeは、レジスタ割付の用語かな？




===============================================================================
===============================================================================


LazyStubの場合は、preserve EAX.

===============================================================================

まとめ
===============================================================================
