import 'package:unittest/unittest.dart';
import "msgpack.dart";
import "dart:async";
import "dart:io";

testStreamWrite() {
  OutputStream fout = new File("file.out").openOutputStream();
  //json
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
  var bin = MessagePack.packb(jsonPremitive);

  fout.close();
}

testStreamRead(String name) {
  File f = new File(name);
  f.readAsBytes();
}

testFileWrite(String name, var d) {
  OutputStream fout = new File(name).openOutputStream();

  List bin = MessagePack.packbSync(d);
  fout.write(bin);
  fout.close();
}

testFileRead(String name) {
  InputStream fin = new File(name).openInputStream();
  var ret = fin.read(1024);
  fin.close();
  return MessagePack.unpackbSync(ret);
}

testFile() {
  //json
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
  testFileWrite("file.out", jsonPremitive);
  List<int> rdata = testFileRead("file.out");

  test('case File Write&Read', () => expect(jsonPremitive, equals(rdata)));
}

main() {
  //testFile();
}