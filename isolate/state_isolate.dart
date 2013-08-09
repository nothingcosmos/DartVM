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

childIsolate() {
  ReceivePort firstPort = port;
  ReceivePort secondPort = new ReceivePort();
  ReceivePort thirdPort = new ReceivePort();
  ReceivePort fourthPort = new ReceivePort();
  List ports = [port, secondPort, thirdPort, fourthPort];

  firstPort.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error");
      return;
    }
    replyPort.send(num*2, secondPort);
    print("server${replyPort}: first state finished = $num");
    return;
  });

  secondPort.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error in second");
      return;
    }
    fibo(40);
    replyPort.send(fibo(num), thirdPort);
    print("server${replyPort}: second state finished = $num");
    return;
  });

  thirdPort.receive((num, replyPort) {
    if (! num is int) {
      replyPort.send("error in third");
      return;
    }
    replyPort.send("result = $num");
    print("server${replyPort}: third state result = $num");
  });


  fourthPort.receive((msg, replyPort) {
    print("server${replyPort}: fourthPort state result = $msg");
    if (msg == "shutdown") {
      ports.forEach((p) {
        p.close();
      });
    }
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

      if (msg == 39088169) {
        p.send("shutdown");
      }
    });
  }
}


