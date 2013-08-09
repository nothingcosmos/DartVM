import 'package:unittest/unittest.dart';
import "package:message_pack/message_pack.dart";

import "dart:typed_data";
import "dart:async";
import "dart:io";
import "dart:isolate";

message_pack(var a, bool uint8) {
  var w = Packer.pack(a, uint8:uint8);
  var ret =  Unpacker.unpack(w);
  return ret;
}

message_pack_stream(List a) {
  int i = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.transform(new UnpackTransformer()).listen((obj) {
    if (a[i] != obj) {
      print("not equal:${a[i]} != $obj");
    }
//    else if (i % 100 == 0) {
//      print("equal:${a[i]} == $obj");
//    }
    i++;
  });

  Stream inputStream = new Stream.fromIterable(a);
  inputStream.transform(new PackTransformer()).listen((e) {
    decorder.add(e);
  });
}

message_pack_stream2(List a) {
  int i = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.transform(new UnpackTransformer()).listen((obj) {
    if (a[i] != obj) {
      print("not equal:${a[i]} != $obj");
    }
    i++;
  });

  Stream inputStream = new Stream.fromIterable(a);
  inputStream.transform(new PackTransformer()).pipe(decorder);
}

testArgumentError(var val) {
  test('catch exception', () {
    expect(() => message_pack(val, false),
    //throwsArgumentError
    throwsA(new isInstanceOf<ArgumentError>())
    );
  });
}

testMessagePack(var val) {
  test('case ${val}', () => expect(message_pack(val, false), equals(val)));
  test('case ${val}', () => expect(message_pack(val, true), equals(val)));
}

testMessagePackNodump(String name, var val) {
  test('case $name', () => expect(message_pack(val, false), equals(val)));
  test('case $name', () => expect(message_pack(val, true), equals(val)));
}

testPremitive() {
  group("test premitive:", () {
    List testData = new List();
  //fixnum
  for (int i=-33; i<=128; i++) {
    testData.add(i);
  }
  //bool
  testData.addAll([true, false]);
  //null
  testData.add(null);
  //unsigned
  testData.addAll([
  1<<4, 1<<8, 1<<16, 1<<24, 1<<30,
  (1<<4),
  (1<<8),
  (1<<16),
  (1<<24),
  (1<<30),
  ((1<<30)+1),
  ((1<<31)-1),
  ((1<<31)),
  ((1<<32)),
  ((1<<40)),
  ((1<<48)),
  ((1<<56)),
  ((1<<63)-1),
  ((1<<63)),
  ((1<<63)+1),
  ((1<<64)-1),
  ]);
  //signed
  testData.addAll([
  (-100),
  (-128),
  (-1<<2),
  (-1<<4),
  ((-1<<8)+1),
  ((-1<<8)),
  ((-1<<8)-1),
  ((-1<<16)+1),
  ((-1<<16)),
  ((-1<<16)-1),
  ((-1<<24)+1),
  ((-1<<24)),
  ((-1<<24)-1),
  ((-1<<31)+1),
  ((-1<<31)),
  ((-1<<31)-1),
  ((-1<<32)),
  ((-1<<40)),
  ((-1<<48)),
  ((-1<<56)),
  (-(1<<56)),
  ((-1<<63)+1),
  ]);

  //double
  testData.addAll([
  (0.0),
  (0.0),
  (-0.0),
  (0.1),
  (-0.1),
  (0.5),
  (-0.5),
  (3.1415),
  (2000.2000),
  (-2010.212200),
  (0.00000000001),
  ]);
  //String
  testData.addAll([
  ("0123456789012345678901234567890"),
  ("01234567890123456789012345678901"),
  ("こんにちは"),
  ("utf8でencode/decode"),
  (""),
  ("0"),
  ]);

  testData.forEach((e) {
    testMessagePack(e);
  });
  message_pack_stream(testData);
  message_pack_stream2(testData);
  });
}

testJSON() {
  group("test json:", () {
    List testData = new List();
  //json
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": 0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
  testData.add(jsonPremitive);

  var json001 = [{"key0":11, "key1":[0.1, 0.0, -0.1], "key2":[0,1,2,[100,200,300]],},
                 {}, [], [[],[[]]], 100, 0.1,
                 {"map001":{"key001":"value001", "key002": 100}, "map002":{"map002":"map002", "rec":jsonPremitive}},
                 [true, false, null]
                 ];
  testData.add(json001);
  testData.forEach((e) {
    testMessagePack(e);
  });
  });
}

createMapIntInt(Map data, String tag, int num) {
  Map test = new Map();
  for (int i=0; i<num; i++) test.putIfAbsent(i, () => i);
  data[tag] = test;
}

createMapStringString(Map data, String tag, int num) {
  Map test = new Map();
  for (int i=0; i<num; i++) test.putIfAbsent(i.toString(), () => "value$i");
  data[tag] = test;
}

createMapDoubleDouble(Map data, String tag, int num) {
  Map test = new Map();
  for (int i=0; i<num; i++) test.putIfAbsent(i.toDouble(), () => i.toDouble());
  data[tag] = test;
}

testMap() {
  group("test Map:", () {
    Map testData = new Map();
    createMapIntInt(testData, "map3 int:int", 3);
    createMapIntInt(testData, "map15 int:int", 15);
    createMapIntInt(testData, "map16 int:int", 16);
    createMapIntInt(testData, "map20000 int:int", 20000);
    createMapIntInt(testData, "map65535 int:int", 65535);
    createMapIntInt(testData, "map65536 int:int", 65536);
    createMapStringString(testData, "map15 String:String", 15);
    createMapStringString(testData, "map16 String:String", 16);
    createMapStringString(testData, "map1<<16-1 String:String", (1<<16)-1);
    createMapStringString(testData, "map1<<16 String:String", (1<<16));
    createMapStringString(testData, "map1<<17 String:String", (1<<17));
    createMapDoubleDouble(testData, "map15 double:double", 15);
    createMapDoubleDouble(testData, "map10000 double:double", 10000);
    createMapDoubleDouble(testData, "map100000 double:double", 100000);

    testData.forEach((k,v) {
      testMessagePackNodump(k, v);
    });
  });
}

createList(Map data, String tag, int num, f(int e)) {
  List test = new List.generate(num, f);
  data[tag] = test;
}

createTypedData(Map data, String tag, var constructor, int num, f(var e)) {
  List init = new List.generate(num, f);
  data[tag] = constructor(init);
}

testList() {
  group("test List:", () {
    Map testData = new Map();
    createList(testData, "array15 List<int>", 15, (e) => e.toString());
    createList(testData, "array16 List<int>", 16, (e) => (e-10).toString());
    createList(testData, "array100 List<double>", 100, (e) => (e).toDouble());
    createTypedData(testData, "array200 Float32List", (e) { return new Float32List.fromList(e);}, 200, (e) => e.toDouble());
    createTypedData(testData, "array400 Float64List", (e) { return new Float64List.fromList(e);}, 400, (e) => e.toDouble());
    createTypedData(testData, "array1000 Uint64List", (e) { return new Uint64List.fromList(e);}, 1000, (e) => e);
    createTypedData(testData, "array1<<18 Uint64List", (e) { return new Uint64List.fromList(e);}, 1<<18, (e) => e~/128);

    testData.forEach((k,v) {
      testMessagePackNodump(k, v);
      message_pack_stream(v);
    });
  });
}
testErrorCase() {
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
//todo 以下のエラーが出るコードがどれだったか忘れた。。
//setInt64 runtime/vm/object.cc:10403: error: unreachable code
}
main() {
  for (int i=0; i<1; i++) {
    testPremitive();
  }
  testMap();
  testList();
  testJSON();
  testErrorCase();

  testToDO();
}
