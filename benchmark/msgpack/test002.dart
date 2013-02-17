import "msgpack.dart";
import "dart:async";
import "dart:json";
import "dart:scalarlist";
import "dart:io";
//mapのkeyの再帰的な比較は未実装。
//Issue 2217
test(var a) {
  var w = MessagePack.packbSync(a);
  var ret = MessagePack.unpackbSync(w);
}

testOK() {
  var jsonPremitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": +0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };
  for (int i=0; i<10; i++) test(jsonPremitive);

  //fixnum
  for (int i=-33; i<=128; i++) test(i);
  //bool
  test(true);
  test(false);
  //null
  test(null);
  //unsigned
  test(1<<4);
  test(1<<8);
  test(1<<16);
  test(1<<24);
  test(1<<30);
  test((1<<30)+1);
  test((1<<31)-1);
  test((1<<31));
  test((1<<32));
  test((1<<40));
  test((1<<48));
  test((1<<56));

  //signed
  test(-48);
  test(-100);
  test(-128);
  test(-1<<2);
  test((-1<<4)-1);
  test(-1<<4);
  test((-1<<4)+1);
  test((-1<<8)+1);
  test((-1<<8));
  test((-1<<8)-1);
  test((-1<<16)+1);
  test((-1<<16));
  test((-1<<16)-1);
  test((-1<<24)+1);
  test((-1<<24));
  test((-1<<24)-1);
  test((-1<<31)+1);
  test((-1<<31));
  test((-1<<31)-1);
  test((-1<<32));
  test((-1<<40));
  test((-1<<48));
  test((-1<<56));
  test(-(1<<56));


  //double
  for (int i=-33; i<=128; i++) test(i.toDouble());
  test(0.0);
  test(+0.0);
  test(-0.0);
  test(0.1);
  test(-0.1);
  test(0.5);
  test(-0.5);
  //String
  String buff = "test";
  for (int i=0; i<128; i++) {
    buff.concat("hello $i");
    test(buff);
  }
  test("hello");
  test("01234567890123456789001234567890123456789");
  test("こんにちは");
  test("utf8でencode/decode");
  test("");
  test("0");

  //List
  List intlist = new List(10);
  for (int i=0; i<10; i++) intlist[i] = i;
  test(intlist);

  List doubleList = new List(1000);
  for (int i=0; i<1000; i++) doubleList[i] = i.toDouble();
  test(doubleList);

  Float64List f64 = new Float64List(2000);
  for (int i=0; i<2000; i++) f64[i] = i.toDouble();


  //Map
  Map intmap = new Map();
  for (int i=0; i<10; i++) intmap.putIfAbsent(i.toString(), () => "test${i}");
  Map intmap2 = new Map();
  for (int i=0; i<1000; i++) intmap2.putIfAbsent(i.toDouble(), () => "test${i}");
  test(intmap);
  test(intmap2);

  //json
  var json001 = [{"key0":11, "key1":[], "key2":[0,1,2], "key3":0.1},
                 {}, 100, 0.1, true, false, null];
  test(json001);

  var json002 = {"key0":100, "key1":"ヴぁぅえ"};
  test(json002);
}

initMap(int n) {
  Map ret = new Map();
  for (int i=0; i<n; i++) {
    String key = "key_${i}";
    ret[key] = "${i}0123456789012345678901234567890123456789abcdefghijklmpopqrstuvqwxyz0123456789012345678901234567890123456789abcdefghijklmpopqrstuvqwxyz$i";
  }
  return ret;
}

mainTest2() {
  var map = initMap(50000);
  printTime("msgpack time = ${time(() {
    var ret = MessagePack.packbSync(map);
  })} ms");
  printTime("msgpack time, use uint8 = ${time(() {
    var ret = MessagePack.packbSync(map, uint8:true);
  })} ms");

  printTime("json time = ${time(() {
    var ret = stringify(map);
  })} ms");
}

mainTest1() {
  var mt = time(() {
    for (int i=0; i<1000;i++) {
      print("iteration $i");
      testOK();
    }
  });
  printTime("time = $mt msec");
}

main() {
  fopen();
  mainTest1();
  mainTest2();
  fclose();
}
OutputStream fout;
fopen() {
  String src = new Options().script;
  fout = new File("${src}").openOutputStream(FileMode.APPEND);
}
fclose() {
  fout.close();
}
printTime(var t) {
  if (fout != null) fout.writeString("//ver ${MessagePack.version}. $t\n");
}

//return milliseconds
time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}

//ver 0.1. time = 9178 msec
//ver 0.1. msgpack time = 414 ms
//ver 0.1. msgpack time, use uint8 = 762 ms
//ver 0.1. json time = 401 ms
//ver 0.1. time = 9315 msec
//ver 0.1. msgpack time = 411 ms
//ver 0.1. msgpack time, use uint8 = 752 ms
//ver 0.1. json time = 401 ms
//ver 0.1. time = 9288 msec
//ver 0.1. msgpack time = 414 ms
//ver 0.1. msgpack time, use uint8 = 768 ms
//ver 0.1. json time = 403 ms
//ver 0.2. time = 8730 msec
//ver 0.2. msgpack time = 389 ms
//ver 0.2. msgpack time, use uint8 = 763 ms
//ver 0.2. json time = 394 ms
//ver 0.3. time = 9011 msec
//ver 0.3. msgpack time = 388 ms
//ver 0.3. msgpack time, use uint8 = 377 ms
//ver 0.3. json time = 395 ms
//ver 0.3. time = 9054 msec
//ver 0.3. msgpack time = 406 ms
//ver 0.3. msgpack time, use uint8 = 373 ms
//ver 0.3. json time = 398 ms
//ver 0.3. time = 8159 msec
//ver 0.3. msgpack time = 378 ms
//ver 0.3. msgpack time, use uint8 = 368 ms
//ver 0.3. json time = 387 ms
