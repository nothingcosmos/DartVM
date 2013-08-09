import 'dart:isolate';
import 'dart:async';
import 'dart:io';

int fibo(int n) {
  if (n < 2) {
    return n;
  } else {
    return fibo(n-1) + fibo(n-2);
  }
}

bindIsolate1(ReceivePort port, ReceivePort rp) {
  port.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error");
      return;
    }
    replyPort.send(num*2, rp);
    print("server${replyPort}: first state finished = $num");
    return;
  });
}

bindIsolate2(ReceivePort port, ReceivePort rp) {
  port.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error in second");
      return;
    }
    fibo(40);
    replyPort.send(fibo(num), rp);
    print("server${replyPort}: second state finished = $num");
    return;
  });
}

bindIsolate3(ReceivePort port, ReceivePort rp) {
  port.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error in third");
      return;
    }
    replyPort.send("result = $num");
    print("server${replyPort}: third state result = $num");
  });
}

childIsolate() {
  ReceivePort firstPort = new ReceivePort();
  ReceivePort secondPort = new ReceivePort();
  ReceivePort thirdPort = new ReceivePort();
  spawnFunction((){
    bindIsolate1(port, firstPort);
  });

  spawnFunction(() {
    bindIsolate2(firstPort, secondPort);
  });

  spawnFunction(() {
    bindIsolate3(secondPort, thirdPort);
  });
}

SendPort load(String filename, [int num]) {
  print("${new DateTime.now()}:callee run(${num})");
  var subport = spawnUri(filename);
  return subport;
}

ReceivePort firstState(int i, SendPort port) {
  ReceivePort rp = new ReceivePort();
  port.send(i, rp.toSendPort());
  return rp;
}

ReceivePort secondState(ReceivePort backport) {
  ReceivePort rp = new ReceivePort();
  backport.receive((msg, sendport) {
    sendport.send(msg, rp);
  });
  return rp;
}

ReceivePort thirdState(ReceivePort backport) {
  ReceivePort rp = new ReceivePort();
  backport.receive((msg, sendport) {
    sendport.send(msg, rp);
  });
  return rp;
}

main() {
  var args = new Options().arguments;

  SendPort sp = spawnFunction(childIsolate);
  //clientがステートを持つってことでいいのか。
  //client側はblockingするパターンか
  //もしくは一部futureにするのがいいのか。
  for (int i=0; i<20; i++) {
    print("start client $i");
    ReceivePort firstResult = firstState(i, sp);
    ReceivePort secondResult = secondState(firstResult);
    ReceivePort thirdResult = thirdState(secondResult);
    thirdResult.receive((msg, p) {
      print("client msg = $msg");
    });
  }
}


