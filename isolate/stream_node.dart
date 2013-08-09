import 'dart:isolate';
import 'dart:async';
import 'dart:io';

init_node([Map<String, dynamic> callback_table = null]) {
  List<MessageBox> boxlist = new List();
  var _dispatcher = (cmd, SendPort replyTo) {
    switch(cmd) {
      case "print":
        MessageBox replyBox = new MessageBox();
        boxlist.add(replyBox);
        replyBox.stream.forEach((e) => print(e));
        replyTo.send(replyBox);
        break;
      case "shutdown":
        print("shutdown");
        port.close();
        boxlist.forEach((box) {
           box.stream.close();
        });
        break;
      default:
        if (cmd is Stopwatch) {
          cmd.stop();
          print("msg recv:${cmd.elapsedMicroseconds} micros");
        } else if (cmd is String ) {
          print("${new DateTime.now()}:recv msg");
          print(cmd);
        }
//        try {
//          callback_table[cmd]();
//        } catch (NoSuchMethodError) {
//          print(NoSuchMethodError);
//        };
    }
  };
  port.receive(_dispatcher);
}

main() {
  print("${new DateTime.now()}:start");
  init_node();
}