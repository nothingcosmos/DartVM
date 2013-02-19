library msgpack;
import 'dart:utf';
import 'dart:async';
import 'dart:scalarlist';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

//fix doubleの変換をどうするか。
//  sclarlistのByteArrayのviewを使って操作を行う。
//fix 負数のdeserializeに失敗する。
//  2の補数表現から^と-1して、intの負数に変換する。
//fix マルチバイト文字に未対応
//  文字列はutf8にencode/decode
//fix pythonからmapを投げるとdecodeに失敗する。
//  packとunpackにおいて、size*2して、keyとvalueそれぞれのsizeをカウントしていた。
//fix -33～-128まで、utf8=falseのときに失敗する。
//  ここだけList<int>にint型をそのままaddしていたため、符号拡張されていた。
//  uint8へのキャストの代わりに、byte16に一回いれてgetUint8()で対応。

//todo1
//  writeのbuffを、List<int>からUint8Listにしたいが、Uint8Listは切り詰めできない。
//  どのくらい速度向上するかRangeErrorを投げて親でbuffを2倍にして再確保してみると
//  RangeErrorを投げるコードがdeoptされて、再度Optimizeされなくなる。
//  packer作って内部で使わないとだめぽいな。
//todo2
//  stream対応。これもpackerつくって内部で切り替えですね。
//  Uint8Listを使っても、fileioやstreamの際にはList<int>に変換されるだろうか？？
//  Streamやasync向けのAPIも用意すべきか。
//  他APIではfeedと読んでいるけど、Dartの場合sinkを作って、そこにadd？
//todo3
//  デフォルトasyncで、Syncつけるのを義務付けるのもどうかと。。
//  名前を逆にするか、、
//  asyncは、timer使わずにisolateで別Threadにしようかな。
//  その場合、msgpackとsnapshotで2回シリアライズが走るが。。
//todo4
//  scalarlistはcore apiだが、dart2jsで使えないらしい。
//  dart2jsで使うことを考慮する場合、dart:htmlのみで作成する必要があるだろう。
//todo5
//  文字列はfixRawにutf8で格納している。
//  オプションでLatin-1をサポートするか？
//todo6
//  Dart VMの場合、内部のSmi Mint Bigint向けに特殊化された分岐のほうが速い？
//todo7
//  scalarlistごとに、高速化したWriterを用意すべきだろうか？
//  あまり使わないか？
//  外部ライブラリでuint8listに変換したものをrawに突っ込むことを想定してみよう。
//  拡張する際に考えることか。
//todo8
//  msgpack java版が1secなのに対し、dart版が6sec
//  1secがList.addを使っているデータ構造の問題
//  0.5secがUtf8のencode/decodeのcopyが冗長な点
//  0.5secがDart VMのpremitive型のオーバーヘッド
//  0.5secが、Dart VMにbyte型がない問題。Uint8Listにより代替できるかもしれないけど
//  3secがint型がSmi,Mint,Bigintが混在してPolymorphicInstanceCallになってdispatchがクソ遅くなる問題。。
//  Mint型の遅延は、x64環境であれば解決する。64bitまでSmi型で表現できるため。
//  x64環境である場合、dart版は2sec、python版が1sec、

_packIsolate() {
  port.receive((msg, replyTo) {
    replyTo.send(MessagePack.packbSync(msg));
  });
}
_unpackIsolate() {
  port.receive((msg, replyTo) {
    replyTo.send(MessagePack.unpackbSync(msg));
  });
}

/**
 * msgpackの対象は、dartのsnapshotに合わせる。
 *
 *    A primitive value (null, num, bool, double, String)
 *
 *    A list or map whose elements are any of the above,
 *    including other lists and maps
 *
 * - 64bitで表現できないintは対象外。
 * - 浮動小数点はdoubleのみ対応。
 * - Float32はdecodeしてdoubleにキャスト(scalarlist getFloat32)する。
 * - Stringは、utf8でencode/decodeする。
 */
class MessagePack {
  static const String version = "0.3";
  static final SendPort _packPort = spawnFunction(_packIsolate);
  static final SendPort _unpackPort = spawnFunction(_unpackIsolate);

  static Future<List> pack(arg) {
    return _packPort.call(arg);
  }

  static Future unpack(List byte) {
    return _unpackPort.call(byte);
  }

  /**
   * uint8:trueを指定すると、Uint8List型で返す。通常はList<int>を返す。
   *
   * Uint8Listの利点は、省メモリ 1/4、かつList内部はGCの対象外になることである。
   * そのため、OnMemoryで保存することを考える場合はこちらが最適である。
   *
   * しかしUint8Listを固定バッファとして確保して、切り詰めて返すことができない。
   * List<int>からUint8Listにcopyして返すため、10%から20%程度遅い。
   */
  static List packbSync(arg, {uint8:false}) {
    if (uint8) {
      ByteArrayOutput buff = new ByteArrayOutput();
      _write(buff, arg);
      List ret = buff.pack();
      //debug
      //buff.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
      return ret;
    } else {
      ListOutput buff = new ListOutput(new List());
      _write(buff, arg);
      List ret = buff.pack();
      //debug
      //ret.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
      return ret;
    }
  }

  static unpackbSync(List byte) {
    if (byte is List) {
      //ok
    } else {
      throw new ArgumentError("arg is not List, arg = ${byte}");
    }

    _ridx = 0;
    //debug
    //byte.forEach((e) => print("read=${e},${e.toRadixString(16)}"));
    return _read(byte);
  }
  static int _ridx;
  static _read(List byte) {
    int size = 0;
    var type = byte[_ridx++];

    if (type >= negativeFixnumType) {// Negative FixNum (111x xxxx) (-32 ~ -1)
        return type - 0x100;
    }
    if (type < (128)) {              // Positive FixNum (0xxx xxxx) (0 ~ 127)
        return type;
    }
    if (type < fixArrayType) {       // FixMap (1000 xxxx)
        size = type - fixMapType;
        type = fixMapType;
    } else if (type < fixRawType) { // FixArray (1001 xxxx)
        size = type - fixArrayType;
        type = fixArrayType;
    } else if (type < nullType) {   // FixRaw (101x xxxx)
        size = type - fixRawType;
        type = fixRawType;
    }
    var num = 0;
    switch (type) {
      case nullType:
        return null;
      case falseType:
        return false;
      case trueType:
        return true;
      case doubleType:
        _byte64.setUint8(7, byte[_ridx++]);
        _byte64.setUint8(6, byte[_ridx++]);
        _byte64.setUint8(5, byte[_ridx++]);
        _byte64.setUint8(4, byte[_ridx++]);
        _byte64.setUint8(3, byte[_ridx++]);
        _byte64.setUint8(2, byte[_ridx++]);
        _byte64.setUint8(1, byte[_ridx++]);
        _byte64.setUint8(0, byte[_ridx++]);
        return _byte64.getFloat64(0);
      case int64Type:
        num += (byte[_ridx++]^0xff)<<56;
        num += (byte[_ridx++]^0xff)<<48;
        num += (byte[_ridx++]^0xff)<<40;
        num += (byte[_ridx++]^0xff)<<32;
        continue label32;
label32:
      case int32Type:
        num += (byte[_ridx++]^0xff)<<24;
        num += (byte[_ridx++]^0xff)<<16;
        continue label16;
label16:
      case int16Type:
        num += (byte[_ridx++]^0xff)<<8;
        continue label8;
label8:
      case int8Type:
        num += (byte[_ridx++]^0xff);

        num = (num + 1)*-1;
        return num;
      case uint64Type:
        num += byte[_ridx++]<<56;
        num += byte[_ridx++]<<48;
        num += byte[_ridx++]<<40;
        num += byte[_ridx++]<<32;
        continue labelUint32;
labelUint32:
      case uint32Type:
        num += byte[_ridx++]<<24;
        num += byte[_ridx++]<<16;
        continue labelUint16;
labelUint16:
      case uint16Type:
        num += byte[_ridx++]<<8;
        continue labelUint8;
labelUint8:
      case uint8Type:
        num += byte[_ridx++];
        return num;
      case raw32Type:// raw 32
        size = _readByte(byte, _ridx, 4);
        _ridx+=4;
        continue labelFixRaw;
      case raw16Type:// raw 16
        size = _readByte(byte, _ridx, 2);
        _ridx+=2;
        continue labelFixRaw;
labelFixRaw:
      case fixRawType:
        String ret = decodeUtf8(byte, _ridx, size);
        _ridx+=size;
        return ret;
      case map32Type:
        size += byte[_ridx++]<<24;
        size += byte[_ridx++]<<16;
        continue labelMap16;
labelMap16:
      case map16Type:
        size += byte[_ridx++]<<8;
        size += byte[_ridx++];
        continue labelFixMap;
labelFixMap:
      case fixMapType:
        Map ret = new Map();
        for (int i=0; i<size; i++) {
          var key = (_read(byte));
          ret[key] = (_read(byte));
        }
        return ret;
    case array32Type:
      size += byte[_ridx++]<<24;
      size += byte[_ridx++]<<16;
      continue labelArray16;
labelArray16:
    case array16Type:
      size += byte[_ridx++]<<8;
      size += byte[_ridx++];
      continue labelFixArray;
labelFixArray:
    case fixArrayType:
      List ret = new List(size);
      for (int i=0; i<size; i++) {
        ret[i] = (_read(byte));
      }
      return ret;
    case floatType:
      //JavaやC/C++からの相互変換用。
      //未テスト
      _byte32.setUint8(3, byte[_ridx++]);
      _byte32.setUint8(2, byte[_ridx++]);
      _byte32.setUint8(1, byte[_ridx++]);
      _byte32.setUint8(0, byte[_ridx++]);
      return _byte32.getFloat32(0);
    default:
      throw new MessageTypeException("header is illegal, header = ${type}");
    }
  }

  static _writeInt(Output out, int d) {
    if (d < -(1 << 5)) {
      if (d < -(1 << 15)) {
        if (d < -(1 << 31)) {
          if (d < -(1<<63)) {
            throw new ArgumentError("bigint serialization is not support, arg = ${d}");
          } else {
            out.writeByteAndUint64(int64Type, d);

          }
        } else {
          out.writeByteAndUint32(int32Type, d);
        }
      } else {
        if (d < -(1 << 7)) {
          out.writeByteAndUint16(int16Type, d);
        } else {
          out.writeByteAndUint8(int8Type, d);
        }
      }
    } else if (d < (1 << 7)) {
      out.writeUint8(d);
    } else {
      if (d < (1 << 16)) {
        if (d < (1 << 8)) {
          out.writeByteAndUint8(uint8Type, d);
        } else {
          out.writeByteAndUint16(uint16Type, d);
        }
      } else {
        if (d < (1 << 32)) {
          out.writeByteAndUint32(uint32Type, d);
        } else if (d < ((1<<64))) {
          out.writeByteAndUint64(uint64Type, d);
        } else {
          throw new ArgumentError("bigint serialization is not support, arg = ${d}");
        }
      }
    }
  }

  static _readByte(List byte, int base, int size) {
    int ret = 0;
    if (size == 4) {
      ret += byte[base] << 24;
      ret += byte[base+1] << 16;
      ret += byte[base+2] << 8;
      ret += byte[base+3];
    } else if (size == 2) {
      ret += byte[base] << 8;
      ret += byte[base+1];
    } else {
      ret += byte[base];
    }
    return ret;
  }
  static _writeType(Output out,
          int fixSize,
          int size,
          List<int> types) {
    if (size < fixSize) {
      out.writeUint8(types[0] + size);
      return 1;
    } else if (size < 0x10000) { // 16
      out.writeByteAndUint16(types[1], size);
      return 3;
    } else if (size < 0x100000000) { // 32
      out.writeByteAndUint32(types[2], size);
      return 5;
    }
  }
  //encodeUtf8内部は非常に遅いし、getRange()が走っている。
  //libを展開してgetRange()を除去できればStringは2-3倍速くなるはず。
  static _writeString(Output out, String s) {
    List<int> enc = encodeUtf8(s);
    _writeType(out, 32, enc.length, [fixRawType, raw16Type, raw32Type]);
    out.writeList(enc);
  }

  static _writeString2(Output out, String s) {
    //sからlengthを先に計算できるんだっけ？
    List<int> enc = encodeUtf8(s);
    _writeType(out, 32, enc.length, [fixRawType, raw16Type, raw32Type]);
    out.writeList(enc);
  }


  static _writeMap(Output out, Map m) {
    int size = m.length;
    int index = _writeType(out, 16, size, [fixMapType, map16Type, map32Type]);
    for (var key in m.keys) {
      _write(out, key);
      _write(out, m[key]);
    }
  }

  static _writeList(Output out, List m) {
    int size = m.length;
    int index = _writeType(out, 16, size, [fixArrayType, array16Type, array32Type]);
    for (int i=0; i<m.length; i++) {
      _write(out, m[i]);
    }
  }

  static _write(Output buff, arg) {
    if (arg == null) {
        buff.writeUint8(nullType);
    } else if (arg is bool) {
      if (arg == false) buff.writeUint8(falseType);
      else buff.writeUint8(trueType);
    } else if (arg is int) {
      _writeInt(buff, arg);
    } else if (arg is double) {
      buff.writeByteAndDouble(doubleType, arg);
    } else if (arg is String) {
      _writeString(buff, arg);
    } else if (arg is List) {
      _writeList(buff, arg);
      //todo scalarlist
//      if (arg is Float64List) {
//      } else if (arg is Float32List) {
//      } else if (arg is Uint8List) {
//      } else if (arg is Int32List) {
//      } else if (arg is Int64List) {
//      }
    } else if (arg is Map) {
      _writeMap(buff, arg);
    } else {
      throw new ArgumentError("${arg.runtimeType} type serialization is not support, arg = ${arg}");
    }
  }

  static final ByteArray _byte32 = new Uint8List(4).asByteArray(0,4);
  static final ByteArray _byte64 = new Uint8List(8).asByteArray(0,8);

  static const _max_smi = (1<<31)-1;
  static const _min_smi = (-1<<31);
  static const _max_mint = (1<<63)-1;
  static const _min_mint = (-1<<63);

  //表現形式
  //Fixnum
  static const int negativeFixnumType = 0xe0;
  static const int negativeFixnumMask = 0x1f;
  static const int map32Type = 0xdf;
  static const int map16Type =  0xde;
  static const int array32Type = 0xdd;
  static const int array16Type = 0xdc;
  static const int int64Type = 0xd3;
  static const int int32Type = 0xd2;
  static const int int16Type = 0xd1;
  static const int raw32Type = 0xdb;
  static const int raw16Type = 0xda;
  static const int int8Type = 0xd0;
  static const int uint64Type = 0xcf;
  static const int uint32Type = 0xce;
  static const int uint16Type = 0xcd;
  static const int uint8Type = 0xcc;
  static const int doubleType = 0xcb;
  static const int floatType = 0xca;
  static const int trueType = 0xc3;
  static const int falseType = 0xc2;
  static const int nullType = 0xc0;
  //FixRaw
  static const int fixRawType = 0xa0;
  static const int fixRawMask = 0x1f;
  //FixArray
  static const int fixArrayType = 0x90;
  static const int fixArrayMask = 0x0f;
  //FixMap
  static const int fixMapType = 0x80;
  static const int fixMapMask = 0x0f;
  //Fixnum
  static const int positiveFixnumType = 0x00;
  static const int positiveFIxnumMask = 0x7f;
}


class MessageTypeException implements Exception {
  const MessageTypeException([String this.message]);
  String toString() => "MessageTypeException: $message";
  final String message;
}

abstract class Output {
  writeUint8(int d);
  writeUint16(int d);
  writeUint32(int d);
  writeUint64(int d);
  writeDouble(double d);
  writeByteAndUint8(int b, int d);
  writeByteAndUint16(int b, int d);
  writeByteAndUint32(int b, int d);
  writeByteAndUint64(int b, int d);
  writeByteAndDouble(int b, double d);
  writeList(List d);
}


class ByteArrayOutput implements Output {
  ByteArrayOutput({int size:1024}) {
    buffer_size = size;
    buffer = new Uint8List(size);
  }
  int buffer_size;
  int idx = 0;
  Uint8List buffer;
  final ByteArray _byte8 = new Uint8List(1).asByteArray(0,1);
  final ByteArray _byte16 = new Uint8List(2).asByteArray(0,2);
  final ByteArray _byte32 = new Uint8List(4).asByteArray(0,4);
  final ByteArray _byte64 = new Uint8List(8).asByteArray(0,8);

  _reserve(int len) {
    if (idx + len > buffer_size) {
      _resize(buffer_size*2);
    }
  }

  _resize(int len) {
    var old_buff = buffer;
    var old_size = buffer_size;
    buffer_size = len;
    buffer = new Uint8List(len);

    //ここは高速化できそう。
    int size = min(len, old_size);
    for (int i=0; i< size; i++) {
      buffer[i] = old_buff[i];
    }
    return buffer;
  }
  Uint8List pack() {
    return new Uint8List.view(buffer.asByteArray(), 0, idx);
    //return List<int> //return buffer.getRange(0, idx);
    //return _resize(idx);
  }

  writeUint8(int d) {
    int offset = 1;
    _reserve(offset);
    buffer[idx+0] = (d)&0xff;
    idx+=offset;
  }
  writeUint16(int d) {
    int offset = 2;
    _reserve(offset);
    buffer[idx+0] = (d>>8)&0xff;
    buffer[idx+1] = (d)&0xff;
    idx+=offset;
  }
  writeUint32(int d) {
    int offset = 4;
    _reserve(offset);
    buffer[idx+0] = (d>>24)&0xff;
    buffer[idx+1] = (d>>16)&0xff;
    buffer[idx+2] = (d>>8)&0xff;
    buffer[idx+3] = (d)&0xff;
    idx+=offset;
  }
  writeUint64(int d) {
    int offset = 8;
    _reserve(offset);
    buffer[idx+0] = (d>>56)&0xff;
    buffer[idx+1] = (d>>48)&0xff;
    buffer[idx+2] = (d>>40)&0xff;
    buffer[idx+3] = (d>>32)&0xff;
    buffer[idx+4] = (d>>24)&0xff;
    buffer[idx+5] = (d>>16)&0xff;
    buffer[idx+6] = (d>>8)&0xff;
    buffer[idx+7] = (d)&0xff;
    idx+=offset;
  }
  writeDouble(double d) {
    int offset = 8;
    _reserve(offset);
    _byte64.setFloat64(0, d);
    buffer[idx++] = _byte64.getUint8(7);
    buffer[idx++] = _byte64.getUint8(6);
    buffer[idx++] = _byte64.getUint8(5);
    buffer[idx++] = _byte64.getUint8(4);
    buffer[idx++] = _byte64.getUint8(3);
    buffer[idx++] = _byte64.getUint8(2);
    buffer[idx++] = _byte64.getUint8(1);
    buffer[idx++] = _byte64.getUint8(0);
  }
  writeList(List d) {
    int offset = d.length;
    _reserve(offset);
    d.forEach((int e) => buffer[idx++] = e);
  }

  writeByteAndUint8(int b, int d) {
    int offset = 2;
    _reserve(offset);
    buffer[idx+0] = b;
    buffer[idx+1] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint16(int b, int d) {
    int offset = 3;
    _reserve(offset);
    buffer[idx+0] = b;
    buffer[idx+1] = (d>>8)&0xff;
    buffer[idx+2] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint32(int b, int d) {
    int offset = 5;
    _reserve(offset);
    buffer[idx+0] = b;
    buffer[idx+1] = (d>>24)&0xff;
    buffer[idx+2] = (d>>16)&0xff;
    buffer[idx+3] = (d>>8)&0xff;
    buffer[idx+4] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint64(int b, int d) {
    int offset = 9;
    _reserve(offset);
    buffer[idx+0] = b;
    buffer[idx+1] = (d>>56)&0xff;
    buffer[idx+2] = (d>>48)&0xff;
    buffer[idx+3] = (d>>40)&0xff;
    buffer[idx+4] = (d>>32)&0xff;
    buffer[idx+5] = (d>>24)&0xff;
    buffer[idx+6] = (d>>16)&0xff;
    buffer[idx+7] = (d>>8)&0xff;
    buffer[idx+8] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndDouble(int b, double d) {
    int offset = 9;
    _reserve(offset);
    buffer[idx++] = b;
    _byte64.setFloat64(0, d);
    buffer[idx++] = _byte64.getUint8(7);
    buffer[idx++] = _byte64.getUint8(6);
    buffer[idx++] = _byte64.getUint8(5);
    buffer[idx++] = _byte64.getUint8(4);
    buffer[idx++] = _byte64.getUint8(3);
    buffer[idx++] = _byte64.getUint8(2);
    buffer[idx++] = _byte64.getUint8(1);
    buffer[idx++] = _byte64.getUint8(0);
  }
}

class ListOutput implements Output {
  ListOutput(List buff) {
    buffer = buff;
  }
  List buffer;
  final ByteArray _byte8 = new Uint8List(1).asByteArray(0,1);
  final ByteArray _byte16 = new Uint8List(2).asByteArray(0,2);
  final ByteArray _byte32 = new Uint8List(4).asByteArray(0,4);
  final ByteArray _byte64 = new Uint8List(8).asByteArray(0,8);

  List pack() {
    return buffer;
  }

  writeUint64(int d) {
    _byte64.setUint64(0, d);
    buffer.add(_byte64.getUint8(7));
    buffer.add(_byte64.getUint8(6));
    buffer.add(_byte64.getUint8(5));
    buffer.add(_byte64.getUint8(4));
    buffer.add(_byte64.getUint8(3));
    buffer.add(_byte64.getUint8(2));
    buffer.add(_byte64.getUint8(1));
    buffer.add(_byte64.getUint8(0));
  }
  writeUint32(int d) {
    _byte32.setUint32(0, d);
    buffer.add(_byte32.getUint8(3));
    buffer.add(_byte32.getUint8(2));
    buffer.add(_byte32.getUint8(1));
    buffer.add(_byte32.getUint8(0));
  }
  writeUint16(int d) {
    _byte16.setUint16(0, d);
    buffer.add(_byte16.getUint8(1));
    buffer.add(_byte16.getUint8(0));
  }
  writeUint8(int d) {
    _byte16.setUint16(0, d);
    buffer.add(_byte16.getUint8(0));
  }

  writeDouble(double d) {
    _byte64.setFloat64(0, d);
    buffer.add(_byte64.getUint8(7));
    buffer.add(_byte64.getUint8(6));
    buffer.add(_byte64.getUint8(5));
    buffer.add(_byte64.getUint8(4));
    buffer.add(_byte64.getUint8(3));
    buffer.add(_byte64.getUint8(2));
    buffer.add(_byte64.getUint8(1));
    buffer.add(_byte64.getUint8(0));
  }
  writeList(List d) {
    buffer.addAll(d);
  }
  writeByteAndUint8(int b, int d) {
    buffer.add(b);
    writeUint8(d);
  }
  writeByteAndUint16(int b, int d) {
    buffer.add(b);
    writeUint16(d);
  }
  writeByteAndUint32(int b, int d) {
    buffer.add(b);
    writeUint32(d);
  }
  writeByteAndUint64(int b, int d) {
    buffer.add(b);
    writeUint64(d);
  }
  writeByteAndDouble(int b, double d) {
    buffer.add(b);
    writeDouble(d);
  }
}

typedef List Callback(List b, int len);

