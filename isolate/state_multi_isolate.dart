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

childIsolate1() {
    port.receive((num, replyPort) {
      if (! (num is int)) {
        if (num == "shutdown") {
          print("isolate1 shutdown");
          port.close();
          return;
        }
        replyPort.send("error");
        return;
      }
      fibo(41);
      replyPort.send(num*2);
      print("server${replyPort}: first state finished = $num");
      return;
    });
}

childIsolate2() {
    port.receive((num, replyPort) {
      if (! (num is int)) {
        if (num == "shutdown") {
          print("isolate2 shutdown");
          port.close();
          return;
        }
        replyPort.send("error in second");
        return;
      }
      fibo(41);
      replyPort.send(fibo(num));
      print("server${replyPort}: second state finished = $num");
      return;
    });
}

childIsolate3() {
    port.receive((num, replyPort) {
      if (! (num is int)) {
        if (num == "shutdown") {
          print("isolate3 shutdown");
          port.close();
          return;
        }
        replyPort.send("error in third");
        return;
      }
      fibo(41);
      replyPort.send("result = $num");
      print("server${replyPort}: third state result = $num");
    });
}

childIsolate() {
  ReceivePort firstPort = new ReceivePort();
  ReceivePort secondPort = new ReceivePort();
  ReceivePort thirdPort = new ReceivePort();
  SendPort sp1 = spawnFunction(childIsolate1);
  SendPort sp2 = spawnFunction(childIsolate2);
  SendPort sp3 = spawnFunction(childIsolate3);
  port.receive((msg, reply) {
    if (msg == "shutdown") {
//      sp1.send("shutdown");
//      sp2.send("shutdown");
//      sp3.send("shutdown");
      port.close();
    } else {
      sp1.send(msg, firstPort.toSendPort());
    }
  });
  firstPort.receive((msg, reply) {
    sp2.send(msg, secondPort.toSendPort());
  });
  secondPort.receive((msg, reply) {
    sp3.send(msg, thirdPort.toSendPort());
  });
  thirdPort.receive((msg, reply) {
    print(msg);
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
  sp.send("shutdown");
}


