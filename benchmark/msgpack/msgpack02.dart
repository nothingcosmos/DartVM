library msgpack;
import 'dart:scalarlist';
//C++で書いてDartVMに組み込みたいけど、
//Clientで使うことも考慮し、まずはDartで実装。
//VMでしか使えないクラスは使わないように。。
//Uint8Listを使う？普通のList<int>？
//sclarlistの場合、ByteArrayのviewを使ってbyte操作を行う。
//Listを順にたどる場合、takeやskipを使ってviewを使ったほうがよいのか？
//Streamやasync向けのAPIも用意すべきか。
//Smi Mint BigInt向けに処理を分けたほうがいい？

//msgpackの対象は、dartのsnapshotと同じにする。
//A primitive value (null, num, bool, double, String)
//A list or map whose elements are any of the above, including other lists and maps

//内部のbuffをuint8listにしたいが、サイズを切り詰めるメソッドが存在しない。

class MessagePack {
  static List packb(arg) {
    var buff = new List();
    _write(buff, arg);
    //debug
    //ret.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
    //Uint8Listに変換すること前提の組み立てになっている。
    //Streamとして使う場合、List<int>にする必要があるはず。。
    int len = buff.length;
    var ret = new Uint8List(len);
    for (int i=0; i<len; i++) {
      ret[i] = buff[i];
    }
    return ret;
  }
  static unpackb(List byte) {
    _ridx = 0;
    //debug
    //byte.forEach((e) => print("read=${e},${e.toRadixString(16)}"));
    return _read(byte);
  }
  //引数はcopy渡し
  static int _ridx;
  static _read(List byte) {
    int size = 0;
    
    var type = byte[_ridx++];
    if (type >= 0xe0) {         // Negative FixNum (111x xxxx) (-32 ~ -1)
        return type - 0x100;
    }
    if (type < 0x80) {          // Positive FixNum (0xxx xxxx) (0 ~ 127)
        return type;
    }
    if (type < 0x90) {          // FixMap (1000 xxxx)
        size = type - 0x80;
        type = 0x80;
    } else if (type < 0xa0) {   // FixArray (1001 xxxx)
        size = type - 0x90;
        type = 0x90;
    } else if (type < 0xc0) {   // FixRaw (101x xxxx)
        size = type - 0xa0;
        type = 0xa0;
    }
    
    var num = 0;
    switch (type) {
      case 0xc0:  return null;
      case 0xc2:  return false;
      case 0xc3:  return true;
      case 0xcb://double
        ByteArray view = _createByteArray(8);
        for (int i=0; i<8; i++) {
          view.setUint8(i, byte[_ridx++]);
        }
        return view.getFloat64(0);
      case 0xd0://signed  8bit integer (0xd0 0x)
        num += (byte[_ridx++]^0xff);
        num = (num + 1)*-1;
        return num;
      case 0xd1://signed 16bit integer (0xd1 0x 0x)
        num += (byte[_ridx++]^0xff)<<8;
        num += (byte[_ridx++]^0xff);
        num = (num + 1)*-1;
        return num;
      case 0xd2://signed 32bit integer (0xd2 0x 0x 0x 0x)
        num += (byte[_ridx++]^0xff)<<24;
        num += (byte[_ridx++]^0xff)<<16;
        num += (byte[_ridx++]^0xff)<<8;
        num += (byte[_ridx++]^0xff);
        num = (num + 1)*-1;
        return num;
      case 0xd3://signed 64bit integer (0xd3 0x 0x 0x 0x 0x 0x 0x 0x)
        num += (byte[_ridx++]^0xff)<<56;
        num += (byte[_ridx++]^0xff)<<48;
        num += (byte[_ridx++]^0xff)<<40;
        num += (byte[_ridx++]^0xff)<<32;
        num += (byte[_ridx++]^0xff)<<24;
        num += (byte[_ridx++]^0xff)<<16;
        num += (byte[_ridx++]^0xff)<<8;
        num += (byte[_ridx++]^0xff);
        num = (num + 1)*-1;
        return num;
      case 0xcc://unsigned 8bit integer
        num += byte[_ridx++];
        return num;
      case 0xcd://unsigned 16bit integer
        num += byte[_ridx++]<<8;
        num += byte[_ridx++];
        return num;
      case 0xce://unsigned 32bit integer
        num += byte[_ridx++]<<24;
        num += byte[_ridx++]<<16;
        num += byte[_ridx++]<<8;
        num += byte[_ridx++];
        return num;
      case 0xcf://unsigned 64bit integer
        num += byte[_ridx++]<<56;
        num += byte[_ridx++]<<48;
        num += byte[_ridx++]<<40;
        num += byte[_ridx++]<<32;
        num += byte[_ridx++]<<24;
        num += byte[_ridx++]<<16;
        num += byte[_ridx++]<<8;
        num += byte[_ridx++];
        return num;
      case 0xdb:// raw 32
        size = _readByte(byte.skip(_ridx), 4);                       
        _ridx+=4;
        String ret = new String.fromCharCodes(byte.getRange(_ridx, size));
        _ridx+=size;
        return ret;
      case 0xda:// raw 16
        size = _readByte(byte.skip(_ridx), 2);   
        _ridx+=2;
        String ret = new String.fromCharCodes(byte.getRange(_ridx, size));
        _ridx+=size;
        return ret;
      case 0xa0:// fixraw
        String ret = new String.fromCharCodes(byte.getRange(_ridx, size));
        _ridx+=size;
        return ret;
      case 0xdf:// 0xdf: map32 
        size += byte[_ridx++]<<24;
        size += byte[_ridx++]<<16;
        size += byte[_ridx++]<<8;
        size += byte[_ridx++];
        Map ret = new Map();
        for (int i=0; i<size; i+=2) {
          var key = (_read(byte));
          ret[key] = (_read(byte));
        }
        return ret;
      case 0xde: //0xde: map16
        size += byte[_ridx++]<<8;
        size += byte[_ridx++];
        
        Map ret = new Map();
        for (int i=0; i<size; i+=2) {
          var key = (_read(byte));
          ret[key] = (_read(byte));
        }
        return ret;
      case 0x80: //0x80: map
        Map ret = new Map();
        for (int i=0; i<size; i+=2) {
          var key = (_read(byte));
          ret[key] = (_read(byte));
        }
        return ret;    
    case 0xdd:  // 0xdd: array32, 0xdc: array16, 0x90: array
      size += byte[_ridx++]<<24;
      size += byte[_ridx++]<<16;
      size += byte[_ridx++]<<8;
      size += byte[_ridx++];
      
      List ret = new List(size);
      for (int i=0; i<size; i++) {
        ret[i] = (_read(byte));
      }
      return ret;
    case 0xdc:
      size += byte[_ridx++]<<8;
      size += byte[_ridx++];
      
      List ret = new List(size);
      for (int i=0; i<size; i++) {
        ret[i] = (_read(byte));
      }
      return ret;
    case 0x90:
      List ret = new List(size);
      for (int i=0; i<size; i++) {
        ret[i] = (_read(byte));
      }
      return ret;       
    }
  }
  
  static _writeBigInt(List<int> out, int d) {
    
  }
  static _writeMint(List<int> out, int d) {
    
  }
  
  static _writeSmi(List<int> out, int d) {
    if (d < -(1 << 5)) {
      if (d < -(1 << 15)) {
        // signed 32
        out.add(0xd2);
        ByteArray ret = new Uint8List(4).asByteArray(0, 4);
        ret.setInt32(0, d);
        for (int i=0; i<4; i++) {
          out.add(ret.getUint8(3-i));
        }
      } else if (d < -(1 << 7)) {
        // signed 16
        out.add(0xd1);
        out.add(d>>8);
        out.add(d&0xff);
      } else {
        // signed 8
        out.add(0xd0);
        out.add(d);
      }
    } else if (d < (1 << 7)) {
      // fixnum
      out.add(d);
    } else {
      if (d < (1 << 8)) {
        // unsigned 8
        out.add(0xcc);
        out.add(d);
      } else if (d < (1 << 16)) {
        // unsigned 16
        out.add(0xcd);
        out.add(d>>8);
        out.add(d&0xff);
      } else {
        // unsigned 32
        out.add(0xce);
        ByteArray ret = new Uint8List(4).asByteArray(0, 4);
        ret.setUint32(0, d);
        for (int i=0; i<4; i++) {
          out.add(ret.getUint8(3-i));
        }
      }
    }
    
  }
  static _writeDouble(List<int> out, double d) {
    out.add(0xcb);
    
    Uint8List ret = new Uint8List(8);
    ret.asByteArray(0, 8).setFloat64(0, d);
    out.addAll(ret.toList());
  }
  static _readByte(List byte, int size) {
    int ret = 0;
    if (size == 4) {
      ret += byte[0] << 24;
      ret += byte[1] << 16;
      ret += byte[2] << 8;
      ret += byte[3];
    } else if (size == 2) {
      ret += byte[0] << 8;
      ret += byte[1];
    } else {
      ret += byte[0];
    }
    return ret;
  }
  static _setType(List<int> out,
          int fixSize, // @param Number: fix size. 16 or 32
          int size,    // @param Number: size
          List<int> types) { // @param ByteArray: type formats. eg: [0x90, 0xdc, 0xdd]
    if (size < fixSize) {
        out.add(types[0] + size);
        return 1;
    } else if (size < 0x10000) { // 16
        out.add(types[1]);
        out.add(size >> 8);
        out.add(size & 0xff);
        return 3;
    } else if (size < 0x100000000) { // 32
        out.add(types[2]);
        out.add(size >> 24);
        out.add(size >> 16);
        out.add(size >>  8);
        out.add(size & 0xff);
        return 5;
    }
  }
  static _writeString(List<int> out, String s) {
    _setType(out,32, s.length, [0xa0, 0xda, 0xdb]);
    out.addAll(s.charCodes);
  }

  static _write(List buff, arg) {
    if (arg == null) { // null -> 0xc0 ( null )
        buff.add(0xc0);
    } else if (arg is bool) {
      if (arg == false) { // false -> 0xc2 ( false )
        buff.add(0xc2);
      } else {  // true  -> 0xc3 ( true  )
        buff.add(0xc3);
      }
    } else if (arg is int) {
        if (min_smi <= arg && arg <= max_smi) {
          _writeSmi(buff, arg);
        } else if (min_mint <= arg && arg <= max_mint) {
          _writeMint(buff, arg);
        } else {
          _writeBigInt(buff, arg);
        }
    } else if (arg is double) {
      _writeDouble(buff, arg);
    } else if (arg is String) {
      _writeString(buff, arg);
    } else if (arg is List) {
      int size = arg.length;
      int index = _setType(buff, 16, size, [0x90, 0xdc, 0xdd]);
      for (int i=0; i<arg.length; i++) {
        _write(buff, arg[i]);
      }
    } else if (arg is Map) {
      int size = arg.length;
      int index = _setType(buff, 16, size*2, [0x80, 0xde, 0xdf]);
      for (var key in arg.keys) {
        _write(buff, key);
        _write(buff, arg[key]);
      }    
    } else {
      //error
    }
  }
  
  static ByteArray _createByteArray(int size) {
    return new Uint8List(size).asByteArray(0, size);
  }
  static final max_smi = 1<<31-1;
  static final min_smi = -1<<31;
  static final max_mint = 1<<63-1;
  static final min_mint = -1<<63;
}
