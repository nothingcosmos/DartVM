import 'dart:isolate';
import 'dart:async';
import 'dart:io';

init_node(String exec) {
  var _dispatcher = (cmd, SendPort replyTo) {
    switch(cmd) {
      case "print":
        ReceivePort rp = new ReceivePort();
        rp.receive((msg, replyTo) {
          print(msg);
          //rp.close();
        });
        replyTo.send(rp.toSendPort());
        break;
      case "shutdown":
        print("shutdown");
        port.close();
        break;
      default:
        if (cmd is Stopwatch) {
          cmd.stop();
          print("msg recv:${cmd.elapsedMicroseconds} micros");
        } else if (cmd is String ) {
          print("${new DateTime.now()}:recv ${exec}");
          print(cmd);
        }
    }
  };
  port.receive(_dispatcher);
}

main() {
  Options opts = new Options();
  print("${new DateTime.now()}:${opts.script} ${port} start");
  init_node("3");
  print("${new DateTime.now()}:${opts.script} ${port} end");
}
