isolateの以下の基本的なメッセージパッシング処理
send()
receive()

SendPortImpl_sendInternal_()
===============================================================================
runtime/lib/isoalte.cc
MessageWriter に、送付するobjを書き込む。

PortMap::PostMessage(new Message(send_id.Value(), re
data, writer.BytesWritten(), <-- 最終的にはBytesWritten()してから送付

送受信の型は、Message

MessageHnadler::PostMessage()
MonitorLocker ml()
oob_queue Enqueue(message)
queue  Enqueue(message)

oobはout-of-band
緊急時のメッセージ
erlangやtcp/ipで使われる。

ThreadPoolを使って
task_ = new MessageHAndlerTask(this)
pool_->Run(task_)

Runは、Message:Handler::Run(ThreadPool*, Startcallback, EndCallback, CallbackData)

HandleMessageクラスが、PortMapを管理するらしい。


receive
===============================================================================
runtime/lib/isolate_patch.dart

receive(void onMessage(var message, SendPort replyTo)) {
  _onMessage = onMessage;
}

receiveで登録された、callback関数messageを _handleMessage経由で呼び出す。
static void _handleMessage(int id, int replyId, var mesasge) {
  (port._onMessage)(message, replyTo);
}

_handleMessageは、DartVM側から呼び出される。
DartLibraryCalls::HandleMessage()が該当
const Instance& mesage
最後にInvokeStaticで呼び出す。


メッセージの受け渡しは、message_handlerに記述されてそう。

handler
===============================================================================
HandleMessages()
Message* message = DequeueMessage()
HandleMessage(message); <-- isolate.cc HnadleMesage(Message*)

isolate.cc::HnadleMesage(Message*)
snapshot reader(Snapshot::kMessage)

readerで、Instance型にデシリアライズ

HandleMirrorsMessage() <-- unimple
DartLibraryCalls::HandleMessage() <-- これでlibcall

Message
===============================================================================





実装
===============================================================================
isolate自体は、
VMが1プロセスで、isolateはthreadなのかな。

Completer
Future
isolate.spawnFunction(childIsolate);
nativeらしい。

native isolate_spawnFunction(Instance, closure, Arguments->At(0)
native isolate_spawnUri
  Function& func = closure
  return Spawn(arguments, new SpawnState(func));

Spawn
  CreateIsolate(state, &error)

CreateIsolate()
  Dart_IsolateCreateCallback callback = Isolate::CreateCallback();
  void* init_data = parent_isolate->init_callback_data();
  bool retval = (callback)(state->scrip_url(), state->function_name(), init_data, error);

callbackは、

Dart_InitOnce(create, inturrupt, shutdown)
PS::InitOnce();
VirtualMemory::
Isolate::
PortMap::
FreeListElement::
Api::
thread_pool = new ThreadPool()
{
  mv_isolate_ = Isolate::Init("vm-isolate");
}

isolate間のswitchはどうやって行うんだ？






isolate switch



thread.h
lock
MutexLocker
MonitorLocker




ためしに、isolateを10個並列に行って
CPUの使用率を見てみるか？

基本はthreadだけど。




newgen=32
oldgen=512
83個目でsegvした。

newgen=3   <--
newgen=32  <-- 83 segv
newgen=128 <-- 21 segv
newgen=512 <--  3 segv

timer
===============================================================================

TimerFactoryClosure




EventTime
===============================================================================

if (is_runnable()) {
  ScheduleInterrupts(Isolate::kVmStatusInterrupt);
  {
    ...
  }
  SetVmStatsCallback(NULL);
}


===============================================================================
===============================================================================
===============================================================================
