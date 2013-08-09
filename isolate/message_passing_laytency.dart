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

printRecvTime() {
  port.receive((msg, reply) {
    if (msg is Stopwatch) {
      msg.stop();
      print("msg recv:${msg.elapsedMicroseconds} micros");
    } else if (msg is String ) {
      print("${new DateTime.now()}:recv msg");
      print(msg);
      if (msg == "shutdown") {
        port.close();
      }
    }
  });
}

sendStopwatch(SendPort p) {
  for (int i=0; i<10000; i++) {
    if (i%100 == 0) {
      fibo(41);
      print("###");
    }
    p.send(new Stopwatch()..start());
  }
}

main() {
  SendPort p = spawnFunction(printRecvTime);
  p.send("${new DateTime.now()}:send msg");
  sendStopwatch(p);
  for (int i=0; i<10; i++) {
    p.send("${new DateTime.now()}:send msg ${i}");
  }
  p.send("shutdown");
}


