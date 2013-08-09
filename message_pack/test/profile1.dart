import "package:message_pack/message_pack.dart";
import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

StateUnpacker sunpacker = new StateUnpacker();

main() {
  var ll = [[1,2,3,4,5,6,7,8,9,0],
      [100,200,300,400,500,600,700,800,900],
      [4000,5000,6000,7000,8000,9000,2000,1000,2000,3000,4000,50000,6000007,100000],
      [4000,5000,6000,7000,8000,9000,2000,1000,2000,3000,4000,50000,6000007,100000],
//      [4000,5000,6000,7000,8000,9000,2000,1000,2000,3000,4000,50000,6000007,100000],
//      [4000,5000,6000,7000,8000,9000,2000,1000,2000,3000,4000,50000,6000007,100000],
      -20, 100, 200, 1025,
      (1<<24)+111, 200, -2000, (-1<<26)+222, 323.0003,
      -1230923.234, 322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225
      -1230923.234, 322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225
//      -1230923.234, +322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225
//      -1230923.234, +322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225
//      -1230923.234, +322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225
      ];

  List dlist = [-1230923.234, 322424.242,3.1415, 8949.24252, 2333.55555, 56.666,7782.2, -34242.225, 0.0, 0.1, 3.14, 2.0];
  Float32List f32list = new Float32List.fromList(dlist);
  Float64List f64list = new Float64List.fromList(dlist);

  var jsonPrimitive = {
    "fixnum-":-20, "fixnum+":100,
    "uint8": 200, "uint16": 1025, "uint32": (1<<24)+111, //"uint64": (1<<48)-200,
    "int8": 200, "int16":-2000, "int32": (-1<<26) +222, //"int64": (-1<<56)+333,
    "double+": 323.00002, "double-": -12021.414134,
    "StringRaw": "roaw", "String16": "0123456789qwertyuiop@[]:;lkkjjhhggfdfdsdsaazxcvcvbnm,././fじこ"
  };

  warmup(ll);
  warmup(f32list);
  warmup(f64list);
  warmup(jsonPrimitive);

  profile("ll", ll);
  profile("ll(uint8)", ll, true);
  profile("json", jsonPrimitive);
  profile("json(uint8)", jsonPrimitive, true);
}
warmup(var obj) {
  for (int i=0; i<3000; i++) {
  var bin = Packer.pack(obj, uint8:false);
  var bin2 = Packer.pack(obj, uint8:true);
  Unpacker.unpack(bin);
  sunpacker.read(bin);

  Unpacker.unpack(bin2);
  sunpacker.read(bin2);
  }
}

profile(String tag, var input, [bool uint8 = false]) {
//  for (int i=0; i<4; i++) {
//    var t = time(() {
//      var init = input;
//      for (int i=0; i<100000; i++) {
//        var bin = Packer.pack(init, uint8:uint8);
//        init = Unpacker.unpack(bin);
//      }
//    });
//    print("time result pack-unpack($tag) = ${t} ms, date = ${new DateTime.now()}");
//  }

  //pack only
  for (int i=0; i<4; i++) {
    var t = time(() {
      for (int i=0; i<100000; i++) {
        var bin = Packer.pack(input, uint8:uint8);
      }
    });
    print("time result pack($tag) = ${t} ms, date = ${new DateTime.now()}");
  }
  //unpack only
  for (int i=0; i<4; i++) {
    var t = time(() {
      var bin = Packer.pack(input, uint8:uint8);
      for (int i=0; i<100000; i++) {
        Unpacker.unpack(bin);
      }
    });
    print("time result unpack($tag) = ${t} ms, date = ${new DateTime.now()}");
  }
  //state unpack only
  for (int i=0; i<4; i++) {
    var t = time(() {
      var bin = Packer.pack(input, uint8:uint8);
      for (int i=0; i<100000; i++) {
        sunpacker.read(bin);
      }
    });
    print("time result state unpack($tag) = ${t} ms, date = ${new DateTime.now()}");
  }
}

//return milliseconds
time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}

