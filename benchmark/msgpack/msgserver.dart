import "msgpack.dart";
import 'dart:json';
import 'dart:io';

final IP = '127.0.0.1';
//final IP = "localhost";
final PORT = 8080;

connect(Socket s) {
  s.onData = () {
    List recvdata = s.read(1024);
    recvdata.forEach((e) => print("recv=${e},${e.toRadixString(16)}"));
    var getdata = MessagePack.unpackb(recvdata);
    print("recv $getdata");
    var data = MessagePack.packb(getdata);
    s.writeList(data, 0, data.length);
  };
}

main () {
  ServerSocket server = new ServerSocket(IP, PORT, 5);
  server.onConnection = connect;
}
