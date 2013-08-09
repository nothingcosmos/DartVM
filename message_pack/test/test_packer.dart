import 'package:unittest/unittest.dart';
import "package:message_pack/message_pack.dart";

import "dart:typed_data";
import "dart:async";
import 'dart:io';

pack(var a, bool uint8) {
  var w = Packer.pack(a, uint8:uint8);
  var ret =  Unpacker.unpack(w);
  return ret;
}
testSerializeDeserialize(var val) {
  var ret = pack(val, true);
  print("ret = ${ret}");
}

void createPrimitiveBinary(String fname) {
  File fout = new File(fname);

  int max = 1<<35;
  for (int i=0; i<1000000; i+=1) {
    if (i % 100 == 0) {
      fout.writeAsBytesSync(Packer.pack(true), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(false), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(null), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack("hello"), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack("hello0123456789012345678901234567890"), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(((1<<32)+i)), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(((-1<<32)-i)), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(-33), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(-32), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(-31), mode:FileMode.APPEND);
      fout.writeAsBytesSync(Packer.pack(-0), mode:FileMode.APPEND);
      print("$i");
    }
    fout.writeAsBytesSync(Packer.pack("hello world...fわwふぁわぐぁfわfわfwgqわfafwagwfわwふぁwっっっっぐぁあ"), mode:FileMode.APPEND);
    fout.writeAsBytesSync(Packer.pack(i), mode:FileMode.APPEND);
    fout.writeAsBytesSync(Packer.pack(i.toDouble()), mode:FileMode.APPEND);
//    //List
//    List ll = new List();
//    ll.add(i);
//    ll.add(i.toDouble());
//    fout.writeAsBytesSync(Packer.pack(ll), mode:FileMode.APPEND);
    //Map
    Map m = new Map();
    for (int k=0; k<100; k++) {
      m[k+i] = (k+i).toDouble();
    }
    fout.writeAsBytesSync(Packer.pack(m), mode:FileMode.APPEND);
  }
  print("createPrimitiveBinary finished");
}

void createMapBinary(String fname) {
  File fout = new File(fname);

  int max = 1<<35;
  for (int i=0; i<1000000; i+=1) {
    //Map
    Map m = new Map();
    for (int k=0; k<100; k++) {
      m[k+i] = (k+i).toDouble();
    }
    fout.writeAsBytesSync(Packer.pack(m), mode:FileMode.APPEND);
  }
  print("createPrimitiveBinary finished");
}

void createBinary(String fname) {
  var jsonPrimitive = {
    "fixnum-":-20, "fixnum+":100,
    "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, //"uint64": (1<<48)-200,
    "int8": 200, "int16":-2000, "int32": (-1<<26) +222, //"int64": (-1<<56)+333,
    "double+": 323.00002, "double-": -12021.414134,
    "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
  };
  var jsonCollection = [{"key0":11, "key1":[0.1, 0.0, -0.1], "key2":[0,1,2,[100,200,300]],},
                 {}, [], [[],[[]]], 100, 0.1,
                 {"map001":{"key001":"value001", "key002": 100}, "map002":{"map002":"map002", "rec":jsonPrimitive}},
                 [true, false, null]
                 ];
  List<int> binPrimitive = Packer.pack(jsonPrimitive);
  List<int> binList = Packer.pack(jsonCollection);

  File fout = new File(fname);

  for (int i=0; i<10000; i++) {
    fout.writeAsBytesSync(binPrimitive, mode:FileMode.APPEND);
    fout.writeAsBytesSync(binList, mode:FileMode.APPEND);
    print(i);
  }
  print("createBinary finished");
  return ;
}

List writePackedStream(String fname) {
  List ret = new List();
  File fout = new File(fname);
  fout.deleteSync();

  StreamController controller = new StreamController();
  controller.stream.transform(new PackTransformer()).listen((e) {
    fout.writeAsBytesSync(e, mode:FileMode.APPEND);
  });
  for (int i=-256; i<256; i++) {
    controller.add(i);
    ret.add(i);
  }
  controller.close();
  print("finished");
  return ret;
}

void readPackedStream(String fname, List expected) {
  List ret = new List();
  File fin = new File(fname);
  int size = 0;
  fin.openRead().transform(new UnpackTransformer()).listen((obj) {
    ret.add(obj);
    size++;
  }, onDone : () {
    print("total size = $size");
    if (expected != ret) {
      print("NG");
      print(expected);
      print(ret);
    }
  });
}
int main() {
  List writed = writePackedStream("controll.txt");
  readPackedStream("controll.txt", writed);
//  createPrimitiveBinary("packed_map.bin");
//  createMapBinary("packed_map_only.bin");
//  createBinary("packed_data.large");
}