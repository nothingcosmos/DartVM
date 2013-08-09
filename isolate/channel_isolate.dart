import 'dart:isolate';

int fibo(int n) {
  if (n < 2) {
    return n;
  } else {
    return fibo(n-1) + fibo(n-2);
  }
}

childIsolateSink() {
  var isFirst = true;
  IsolateSink sink;
  ReceivePort rp = new ReceivePort();
  stream.listen((msg) {
    if (isFirst && msg is IsolateSink) {
      isFirst = false;
      sink = msg;
      return;
    }
    if (msg is int) {
      sink.add(fibo(msg));
      return;
    }
    if (msg is String) {
      sink.add("thank you. $String");
      return;
    }

    sink.add(new controlToken("shutdown"));
  });
}

class controlToken {
  final String state;
  const controlToken(this.state);
}

class channelIsolate {
  IsolateSink sender;
  MessageBox _receiveBox;
  channelIsolate(void topLevelFunction(),
  [bool unhandledExceptionCallback(IsolateUnhandledException e)]) {
    sender = streamSpawnFunction(topLevelFunction, unhandledExceptionCallback);
    _receiveBox = new MessageBox();
    sender.add(_receiveBox.sink);
  }
  IsolateStream get stream => _receiveBox.stream;
  shutdown() {
    sender.close();
    _receiveBox.stream.close();
  }
}

main() {
  channelIsolate channel = new channelIsolate(childIsolateSink);
  channel.stream.listen((msg) {
    print(msg);
    if (msg is controlToken) {
      channel.shutdown();
    }
  });

  for (int i=0; i<41; i++) {
    print("start client $i");
    channel.sender.add("hello");
    channel.sender.add(i);
    channel.sender.add("world");
  }
  channel.sender.add(0.1);
}


