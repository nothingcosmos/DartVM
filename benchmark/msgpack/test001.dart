import "msgpack.dart";

testList(var a, var b) {
  if (a.length != b.length) return false;
  for (int i=0; i<a.length; i++) {
    if (!testVar(a[i], a[i])) return false;
  }
  return true;
}

//mapのkeyの再帰的な比較は未実装。
//Issue 2217
testMap(var a, var b) {
  if(a.length != b.length) return false;
  return a.keys.every((key) => b.containsKey(key) && testVar(a[key], b[key]));
}

testVar(var a, var b) {
  //implクラスが異なる場合あり。
  //if (a.runtimeType != b.runtimeType) return false;
  if (a == null && b == null) return true;
  if (a is List && b is List) return testList(a,b);
  if (a is Map && b is Map) return testMap(a,b);
  return a == b;
}

test(var a) {
  var w = MessagePack.packb(a, uint8:true);
  var ret = MessagePack.unpackb(w);
  if (testVar(a, ret)) return true;
  print("NG $a != $ret");
  error++;
  return false;
}
int error = 0;
testOK() {
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
  test((1<<63)-1);
  //test((1<<63));
  //signed
  test(-100);
  test(-128);
  test(-1<<2);
  test(-1<<4);
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
  test((-1<<63)+1);
  test((-1<<63));
  //test((-1<<63)-1);
  //double
  test(0.0);
  test(+0.0);
  test(-0.0);
  test(0.1);
  test(-0.1);
  test(0.5);
  test(-0.5);
  //String
  test("hello");
  test("01234567890123456789001234567890123456789");

  //List
  List intlist = new List(10);
  for (int i=0; i<10; i++) intlist[i] = i;
  test(intlist);
  List doubleList = new List(1000);
  for (int i=0; i<1000; i++) doubleList[i] = i.toDouble();
  test(doubleList);

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
  //test(json001);
  
  var json002 = {"key0":100, "key1":"value1"};
  test(json002);
}

main() {
  var mt = time(() {
    for (int i=0; i<1;i++) {
      testOK();
    }
  });
  //test("こんにちは");//error
  print("error = $error");
  print("time = $mt msec");
}

//return milliseconds
time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}




