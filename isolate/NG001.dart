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

receiver() {
  port.receive((msg, replyTo) {
    ReceivePort rp;
      print("${new DateTime.now()}:recv cmd");
      print("cmd:${msg}");
      if (msg == "print") {
        rp = new ReceivePort();
        rp.receive((msg, replyTo) {
          print("recv:${msg}");
        });
        replyTo.send(rp.toSendPort());
      } else if (msg == "shutdown") {
        if (rp != null) rp.close();
        port.close();
      }
  });
}

main() {
  SendPort sp = spawnFunction(receiver);
  ReceivePort rp = new ReceivePort();

  //先にsendが同期処理で実行される。
  sp.send("print", rp.toSendPort());
  fibo(41);

  //sendしたメッセージのrecvは受信し、自分のmessage boxに溜まっている。
  //その後receiveを設定する。
  rp.receive((msg, dummy) {
    msg.send("hello");
    msg.send("world");
  });
  //mainを出ないとmessage boxを処理しない。
  fibo(41);//この裏でreceiveが走ってると嬉しい。awaitかcontext切り替えたい。

  sp.send("print", rp.toSendPort());
  rp.receive((msg, dummy) {
    msg.send("hello2");
    msg.send("world2");
  });
  sp.send("print", rp.toSendPort());
  fibo(41);

  sp.send("shutdown"); //shutdownを送信するとport.close()する
}


