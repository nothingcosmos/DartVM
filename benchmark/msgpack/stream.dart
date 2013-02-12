import "msgpack.dart";
import "dart:async";
import "dart:json";
import "dart:scalarlist";
import "dart:io";

testStream(String reader, String writer) {
  File fin = new File(reader);
  File fout = new File(writer);

  var c = new StreamController();
  var sink = c.sink;

  fout.open(FileMode.APPEND).asStream().pipeInto(
      sink);

  fin.open().asStream().listen(
      (var d) {
        print("listen $d");
        sink.add(d);
      }
  );
}

testFile() {
  //json
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
}

main() {
  print("start");
  testStream("input.stream", "output.stream");
  print("finish");
}