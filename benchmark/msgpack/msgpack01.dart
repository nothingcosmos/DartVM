library msgpack;
import 'dart:scalarlist';
import 'dart:math';
//C++で書いてDartVMに組み込みたいけど、
//Clientで使うことも考慮し、まずはDartで実装。
//VMでしか使えないクラスは使わないように。。
//Uint8Listを使う？
//IOStreamのほうがいいのでは？
//StreamのAPIか
//可能であればasyncも。
class MessagePack {
  List write(arg) {
    var ret = _write(arg);
    //debug
    //ret.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
    return ret;
  }
  read(List byte) {
    //debug
    //byte.forEach((e) => print("read=${e},${e.toRadixString(16)}"));
    return _read(byte);
  }
  _read(List byte) {
    var index = 0;
    var type = byte[index++];
    var num = 0;
    int size = 0;  

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
    
    switch (type) {
      case 0xc0:  return null;
      case 0xc2:  return false;
      case 0xc3:  return true;
      case 0xcb://double
        ByteArray view = new Uint8List(8).asByteArray(0, 8);
        for (int i=0; i<8; i++) {
          view.setUint8(i, byte[index++]);
        }
        return view.getFloat64(0);
      case 0xd0://signed  8bit integer (0xd0 0x)
        num += (byte[index++]^0xff);
        num = (num + 1)*-1;
        break;
      case 0xd1://signed 16bit integer (0xd1 0x 0x)
        num += (byte[index++]^0xff)<<8;
        num += (byte[index++]^0xff);
        num = (num + 1)*-1;
        break;
      case 0xd2://signed 32bit integer (0xd2 0x 0x 0x 0x)
        num += (byte[index++]^0xff)<<24;
        num += (byte[index++]^0xff)<<16;
        num += (byte[index++]^0xff)<<8;
        num += (byte[index++]^0xff);
        num = (num + 1)*-1;
        break;
      case 0xd3://signed 64bit integer (0xd3 0x 0x 0x 0x 0x 0x 0x 0x)
        num += (byte[index++]^0xff)<<56;
        num += (byte[index++]^0xff)<<48;
        num += (byte[index++]^0xff)<<40;
        num += (byte[index++]^0xff)<<32;
        num += (byte[index++]^0xff)<<24;
        num += (byte[index++]^0xff)<<16;
        num += (byte[index++]^0xff)<<8;
        num += (byte[index++]^0xff);
        num = (num + 1)*-1;
        break;
      case 0xcc://unsigned 8bit integer
        num += byte[index++];
        break;
      case 0xcd://unsigned 16bit integer
        num += byte[index++]<<8;
        num += byte[index++];
        break;
      case 0xce://unsigned 32bit integer
        num += byte[index++]<<24;
        num += byte[index++]<<16;
        num += byte[index++]<<8;
        num += byte[index++];
        break;
      case 0xcf://unsigned 64bit integer
        num += byte[index++]<<56;
        num += byte[index++]<<48;
        num += byte[index++]<<40;
        num += byte[index++]<<32;
        num += byte[index++]<<24;
        num += byte[index++]<<16;
        num += byte[index++]<<8;
        num += byte[index++];
        break;
      case 0xdb:
        size = _readByte(byte, 4);                       // raw 32
        index+=4;
        
        break;
      case 0xda:
        size = _readByte(byte, 2);   // raw 16
        index+=2;
        break;
      case 0xa0:
        /*
        i = that.index + 1;                             // raw
        that.index += size;
        // utf8.decode
        for (rv = [], ri = -1, iz = i + size; i < iz; ++i) {
          c = data[i]; // first byte
          if (c < 0x80) { // ASCII(0x00 ~ 0x7f)
            rv[++ri] = c;
          } else if (c < 0xe0) {
            rv[++ri] = (c & 0x1f) <<  6 | (data[++i] & 0x3f);
          } else if (c < 0xf0) {
            rv[++ri] = (c & 0x0f) << 12 | (data[++i] & 0x3f) << 6
                | (data[++i] & 0x3f);
          }
        }
      return String.fromCharCode.apply(null, rv);
      */
    }
    return num;
  }
  
  _writeBigInt(List<int> out, int d) {
    
  }
  _writeMint(List<int> out, int d) {
    
  }
  _writeSmi(List<int> out, int d) {
    if (d < -(1 << 5)) {
      if (d < -(1 << 15)) {
        // signed 32
        out.add(0xd2);
        out.add(d>>24);
        out.add(d>>16);
        out.add(d>>8);
        out.add(d&0xff);
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
        out.add(d>>24);
        out.add(d>>16);
        out.add(d>>8);
        out.add(d&0xff);
      }
    }
    
  }
  _writeDouble(List<int> out, double d) {
    out.add(0xcb);
    
    Uint8List ret = new Uint8List(8);
    ret.asByteArray(0, 8).setFloat64(0, d);
    out.addAll(ret.toList());
  }
  _readByte(List byte, int size) {
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
  _setType(List<int> out,
          int fixSize, // @param Number: fix size. 16 or 32
          int size,    // @param Number: size
          List<int> types) { // @param ByteArray: type formats. eg: [0x90, 0xdc, 0xdd]
    if (size < fixSize) {
        out.add(types[0] + size);
    } else if (size < 0x10000) { // 16
        out.add(types[1]);
        out.add(size >> 8);
        out.add(size & 0xff);
    } else if (size < 0x100000000) { // 32
        out.add(types[2]);
        out.add(size >> 24);
        out.add(size >> 16);
        out.add(size >>  8);
        out.add(size & 0xff);
    }
  }
  _writeString(List<int> out, String s) {
    _setType(out,32, s.length, [0xa0, 0xda, 0xdb]);
    for (int i=0; i<s.length; i++) {
      out.addAll(s.charCodes);
    }
  }

  _write(arg) {
    var buff = new List();
    if (arg == null) { // null -> 0xc0 ( null )
        buff.add(0xc0);
    } else if (arg == false) { // false -> 0xc2 ( false )
        buff.add(0xc2);
    } else if (arg == true) {  // true  -> 0xc3 ( true  )
        buff.add(0xc3);
    } else {
        //todo
      if (arg is int) {
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
      }
    }
    //Uint8Listに変換すること前提の組み立てになっている。
    var ret = new Uint8List(buff.length);
    for (int i=0; i<buff.length; i++) ret[i] = buff[i];
    return ret;
  }
  
  final max_smi = 1<<31-1;
  final min_smi = -1<<31;
  final max_mint = 1<<63-1;
  final min_mint = -1<<63;
}
