
stubcodeをいつ生成するのか。
===============================================================================

  // Generate all the stubs.
  Code& code = Code::Handle();
  STUB_CODE_LIST(STUB_CODE_GENERATE);

STUBも実行時のようです。

incrementとreturninstrの数値は異なるのは？

以下でもカウンタ更新
void StubCode::GenerateOptimizedUsageCounterIncrement(Assembler* assembler)
void StubCode::GenerateUsageCounterIncrement(Assembler* assembler, Register temp_reg)

上記は、ICを生成する際に使うみたい。


FLAG_optimization_counter_threshold
ちゃんご動くことを確認。3000だと最適化されなかった。

Function::usage_counter_offset()

ReturnInstrでカウンタアップして、チェックしている。


type feedbackの仕組み。
===============================================================================


gc handle
===============================================================================
RawObject

from
to
その間のポインタを解析する。連続するポインタ領域として解析する。
===============================================================================

なんでkeyword_symbolsが途中をさしているのか。
===============================================================================

  RawInstance* out_of_memory_;
  RawArray* keyword_symbols_;
  RawFunction* receive_port_create_function_;
  RawFunction* lookup_receive_port_function_;
  RawFunction* handle_message_function_;
  RawObject** to() { return reinterpret_cast<RawObject**>(&keyword_symbols_); }



