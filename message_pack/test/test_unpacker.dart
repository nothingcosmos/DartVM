import 'package:message_pack/message_pack.dart';
import 'package:unittest/unittest.dart';

import 'dart:typed_data';
import 'dart:async';
import 'dart:io';

pack(var a, bool uint8) {
  var w = Packer.pack(a, uint8:uint8);
  var ret =  Unpacker.unpack(w);
  return ret;
}

testStream() {
  var stringPrimitive = {"null":"0123456789012345678901234567890123456"};
  var listPrimitive = [[], 0, 1, -1, -33, 127, 128, 129, 0.1, -0.1, 0.0, [[],[]], [[0],[0.0],[null]], [0,1,2], [0.1,0.2,0.3], true, false, null, [[[0]]]];
  var jsonPrimitive = {"null":null, "true":true, "false":false, "fixnum-":-20, "fixnum+":100,
                       "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, "uint64": (1<<48)-200,
                       "int8": 200, "int16":-2000, "int32": (-1<<26) +222, "int64": (-1<<56)+333,
                       "double+": 0.0000002, "double-": -12021.414134,
                       "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
                       };

  var json001 = [{"key0":11, "key1":[0.1, 0.0, -0.1], "key2":[0,1,2,[100,200,300]],},
                 {}, [], [[],[[]]], 100, 0.1,
                 {"map001":{"key001":"value001", "key002": 100}, "map002":{"map002":"map002", "rec":jsonPrimitive}},
                 [true, false, null]
                 ];
  List input = new List();
  input.add(Packer.pack(listPrimitive));
  input.add(Packer.pack(stringPrimitive));
  input.add(Packer.pack(jsonPrimitive));
  input.add(Packer.pack(json001));
  input.add(Packer.pack(json001));
  input.add(Packer.pack(json001));
  input.add(Packer.pack(json001));

  Stream s = new Stream.fromIterable(input);
  s.transform(new UnpackTransformer()).listen((obj) {
    print(obj);
  });
}

readPackedData(String fname) {
  File fin = new File(fname);
  int size = 0;
  fin.openRead().transform(new UnpackTransformer()).listen((obj) {
    size++;
  }, onDone : () {
    print("total size = $size");
  });
}

readOnlyData(String fname) {
  File fin = new File(fname);
  int size = 0;
  fin.openRead().listen((obj) {
    Map m = new Map();
    for (int i=0; i<100; i++) {
      m[size+i] = obj;
    }
    size++;
  }, onDone : () {
    print("total size = $size");
  });
}

testReadFile() {
  String fname = "packed_map_only.bin";
  List args = new Options().arguments;
  if (args.length > 0) {
    fname = args[0];
    print(fname);
  }
  if (fname == "readonly") {
    readOnlyData("packed_map_only.bin");
  } else {
    readPackedData(fname);
  }
}

main() {
  //testStream();
  testReadFile();
}