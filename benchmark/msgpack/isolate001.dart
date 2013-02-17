import 'msgpack.dart';
import 'dart:async';
import 'dart:isolate';

testPackUnpack() {
  port.receive((msg, replyTo) {
    var bin = MessagePack.packbSync(msg);
    var ret = MessagePack.unpackbSync(bin);
    replyTo.send(ret);
  });
}

SendPort _msgPort;

Future pack(var message) {
  return _msgPort.call(message);
}

packSync(var message) {
  var bin = MessagePack.packbSync(message);
  var ret = MessagePack.unpackbSync(bin);
  return ret;
}

main() {
  _msgPort = spawnFunction(testPackUnpack);
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };

  var t2 = time(() {
    List<Future> lf = new List();
    for (int i=0; i<10000; i++) {
      lf.add(pack(jsonPremitive));
    }
    Future.wait(lf).then((list) => print("finish, ${new DateTime.now()}"));
  });
//  for (int i=0; i<10000; i++) {
//    packSync(jsonPremitive);
//  }

  var t = time(() {
  for (int i=0; i<10000; i++) {
    packSync(jsonPremitive);
  }
  });
  print("sync time = $t ms, date = ${new DateTime.now()}");
}


//return milliseconds
time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}

