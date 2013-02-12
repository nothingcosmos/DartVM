import 'package:unittest/unittest.dart';
import "msgpack.dart";
import "dart:scalarlist";
import "dart:async";

pack(var a, bool uint8) {
  var w = MessagePack.packbSync(a, uint8:uint8);
  var ret =  MessagePack.unpackbSync(w);
  return ret;
}

testArgumentError(var val) {
  test('catch exception', () {
    expect(() => pack(val, false),
    //throwsArgumentError
    throwsA(new isInstanceOf<ArgumentError>())
    );
  });
}

testSerializeDeserialize(var val) {
  test('case ${val}', () => expect(pack(val, false), equals(val)));
  test('case ${val}', () => expect(pack(val, true), equals(val)));
}

testNoDump(String name, var val) {
  test('case $name', () => expect(pack(val, false), equals(val)));
  test('case $name', () => expect(pack(val, true), equals(val)));
}

testPremitive() {
  group("test premitive:", () {
  //fixnum
  for (int i=-33; i<=128; i++)
    testSerializeDeserialize(i);
  //bool
  testSerializeDeserialize(true);
  testSerializeDeserialize(false);
  //null
  testSerializeDeserialize(null);
  //unsigned
  testSerializeDeserialize(1<<4);
  testSerializeDeserialize(1<<8);
  testSerializeDeserialize(1<<16);
  testSerializeDeserialize(1<<24);
  testSerializeDeserialize(1<<30);
  testSerializeDeserialize((1<<30)+1);
  testSerializeDeserialize((1<<31)-1);
  testSerializeDeserialize((1<<31));
  testSerializeDeserialize((1<<32));
  testSerializeDeserialize((1<<40));
  testSerializeDeserialize((1<<48));
  testSerializeDeserialize((1<<56));
  testSerializeDeserialize((1<<63)-1);
  testSerializeDeserialize((1<<63));
  testSerializeDeserialize((1<<63)+1);
  testSerializeDeserialize((1<<64)-1);
  //signed
  testSerializeDeserialize(-100);
  testSerializeDeserialize(-128);
  testSerializeDeserialize(-1<<2);
  testSerializeDeserialize(-1<<4);
  testSerializeDeserialize((-1<<8)+1);
  testSerializeDeserialize((-1<<8));
  testSerializeDeserialize((-1<<8)-1);
  testSerializeDeserialize((-1<<16)+1);
  testSerializeDeserialize((-1<<16));
  testSerializeDeserialize((-1<<16)-1);
  testSerializeDeserialize((-1<<24)+1);
  testSerializeDeserialize((-1<<24));
  testSerializeDeserialize((-1<<24)-1);
  testSerializeDeserialize((-1<<31)+1);
  testSerializeDeserialize((-1<<31));
  testSerializeDeserialize((-1<<31)-1);
  testSerializeDeserialize((-1<<32));
  testSerializeDeserialize((-1<<40));
  testSerializeDeserialize((-1<<48));
  testSerializeDeserialize((-1<<56));
  testSerializeDeserialize(-(1<<56));
  testSerializeDeserialize((-1<<63)+1);
  testSerializeDeserialize((-1<<63));

  //double
  testSerializeDeserialize(0.0);
  testSerializeDeserialize(+0.0);
  testSerializeDeserialize(-0.0);
  testSerializeDeserialize(0.1);
  testSerializeDeserialize(-0.1);
  testSerializeDeserialize(0.5);
  testSerializeDeserialize(-0.5);
  testSerializeDeserialize(+0.00000000001);
  //String
  testSerializeDeserialize("hello");
  testSerializeDeserialize("01234567890123456789001234567890123456789");
  testSerializeDeserialize("こんにちは");
  testSerializeDeserialize("utf8でencode/decode");
  testSerializeDeserialize("");
  testSerializeDeserialize("0");

  });
}

testJSON() {
  group("test json:", () {
  //json
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
  testSerializeDeserialize(jsonPremitive);

  var json001 = [{"key0":11, "key1":[0.1, 0.0, -0.1], "key2":[0,1,2,[100,200,300]],},
                 {}, [], [[],[[]]], 100, 0.1,
                 {"map001":{"key001":"value001", "key002": 100}, "map002":{"map002":"map002", "rec":jsonPremitive}},
                 [true, false, null]
                 ];
  testSerializeDeserialize(json001);
  });
}

testMap() {
  group("test Map:", () {
    Map intMap = new Map();
    for (int i=0; i<3; i++) intMap.putIfAbsent(i, () => i);
    Map int32Map = new Map();
    for (int i=0; i<(1<<17); i++) int32Map.putIfAbsent(i.toString(), () => "value$i");
    Map doubleMap = new Map();
    for (int i=0; i<100; i++) doubleMap.putIfAbsent(i.toDouble(), () => i.toDouble());
    testNoDump("map  3 int:int", intMap);
    testNoDump("map 100, double:double", doubleMap);
    testNoDump("map ${1<<17}", int32Map);
  });
}
testList() {
  group("test List:", () {
    List intlist = new List(10);
    for (int i=0; i<10; i++) intlist[i] = i;

    List doubleList = new List(100);
    for (int i=0; i<100; i++) doubleList[i] = i.toDouble();

    Float32List float32list = new Float32List(200);
    for (int i=0; i<(200); i++) float32list[i] = i.toDouble();

    Float64List float64list = new Float64List(200);
    for (int i=0; i<(200); i++) float64list[i] = i.toDouble();

    Uint64List uint64list = new Uint64List(300);
    for (int i=0; i<(300); i++) uint64list[i] = i;

    Uint8List uint8list = new Uint8List(1<<18);
    for (int i=0; i<(1<<18); i++) uint8list[i] = i~/(128);

    testSerializeDeserialize(intlist);
    testNoDump("array 100 List<double>", doubleList);
    testNoDump("array 200 Float32List", float32list);
    testNoDump("array 200 Float64List", float64list);
    testNoDump("array 300 Uint64List", uint64list);
    testNoDump("uint8 1<<18 Uint8List", uint8list);
  });
}
testError() {
  group("test error:", () {
    testArgumentError(() => print("hello"));
    testArgumentError((1<<64));
    testArgumentError(1<<100);
    testArgumentError((-1<<64)-1);
    testArgumentError((-1<<64)+2);
    testArgumentError((-1<<64)+1);
    testArgumentError((-1<<64));
    testArgumentError((-1<<63)-3);
    testArgumentError((-1<<63)-2);
    testArgumentError((-1<<63)-1);
  });
}
testToDO() {
}
main() {
  for (int i=0; i<1; i++) {
    testPremitive();
  }
  testJSON();
  testMap();
  testList();
  testError();

  testToDO();
}

//todo 以下のエラーが出るコードがどれだったか忘れた。。
//setInt64 runtime/vm/object.cc:10403: error: unreachable code