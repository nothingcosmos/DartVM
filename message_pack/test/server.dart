import "package:message_pack/message_pack.dart";

import 'dart:json';
import 'dart:io';
import 'dart:async';

final IP = '127.0.0.1';
//final IP = "localhost";
final PORT = 8080;

main () {
  ServerSocket.bind(IP, PORT).then((s) {
    s.listen((Socket client) {
      int i=0;
      client.forEach((e) {
        print("recv:$i, size = ${e.length}");
        i++;
        var getdata = Unpacker.unpack(e);
        print("recv $getdata");
        var data = Packer.pack(getdata);
        client.add(data);
      });
    });
  });
}
