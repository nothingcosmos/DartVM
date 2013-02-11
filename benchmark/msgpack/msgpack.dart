library msgpack;
import 'dart:utf';
import 'dart:async';
import 'dart:scalarlist';

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
//  また、RangeErrorを投げて親でbuffを2倍にして再確保すると、
//  RangeErrorを投げるコードがdeoptされて、再度Optimizeされなくなる。
//todo2
//  stream対応。
//  Uint8Listを使っても、fileioやstreamの際にはList<int>に変換されるだろうか？？
//  Streamやasync向けのAPIも用意すべきか。
//  他APIではfeedと読んでいるけど、Dartの場合sinkを作って、そこにaddかな？
//  stream対応する場合、他のAPIのようにpacker/unpackerを作るのがいいのかな？
//todo3
//  デフォルトasyncで、Syncつけるのを義務付けるのもどうかと。。
//  名前を逆にするか、、
//todo4
//  scalarlistはdart2jsで使えないらしい。dartiumかServerでしか使えない。
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
  static String version = "0.1";

  static Future<List> packb(arg, {uint8:false}) {
    Completer c = new Completer();
    new Timer(0, (timer) => c.complete(packbSync(arg, uint8:uint8)));
    return c.future;
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
    var buff = new List();
    _write(buff, arg);

    //debug
    //buff.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
    //Streamとして使う場合、List<int>にする必要があるはず。。
    if (!uint8) {
      return buff;
    } else {
      int len = buff.length;
      var ret = new Uint8List(len);
      for (int i=0; i<len; i++) {
        ret[i] = buff[i];
      }
      return ret;
    }
  }

  static Future unpackb(List byte) {
    Completer c = new Completer();
    new Timer(0, (timer) => c.complete(unpackbSync(byte)));
    return c.future;
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
        for (int i=0; i<8; i++) {
          _byte64.setUint8(i, byte[_ridx++]);
        }
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
        size = _readByte(byte.skip(_ridx), 4);
        _ridx+=4;
        continue labelFixRaw;
      case raw16Type:// raw 16
        size = _readByte(byte.skip(_ridx), 2);
        _ridx+=2;
        continue labelFixRaw;
labelFixRaw:
      case fixRawType:
        //String ret = new String.fromCharCodes(byte.getRange(_ridx, size));
        //ここでarrayのviewだけかえしたいんだけど。
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
      for (int i=0; i<4; i++) {
        _byte32.setUint8(i, byte[_ridx++]);
      }
      return _byte32.getFloat32(0);
    default:
      throw new MessageTypeException("header is illegal, header = ${type}");
    }
  }

  static _writeInt64(List<int> out, int d) {
    _byte64.setUint64(0, d);
    out.add(int64Type);
    out.add(_byte64.getUint8(7));
    out.add(_byte64.getUint8(6));
    out.add(_byte64.getUint8(5));
    out.add(_byte64.getUint8(4));
    out.add(_byte64.getUint8(3));
    out.add(_byte64.getUint8(2));
    out.add(_byte64.getUint8(1));
    out.add(_byte64.getUint8(0));
  }
  static _writeInt32(List<int> out, int d) {
    _byte32.setInt32(0, d);
    out.add(int32Type);
    out.add(_byte32.getUint8(3));
    out.add(_byte32.getUint8(2));
    out.add(_byte32.getUint8(1));
    out.add(_byte32.getUint8(0));
  }
  static _writeInt16(List<int> out, int d) {
    _byte32.setInt16(0, d);
    out.add(int16Type);
    out.add(_byte32.getUint8(1));
    out.add(_byte32.getUint8(0));
  }
  static _writeInt8(List<int> out, int d) {
    _byte16.setUint16(0, d);
    out.add(int8Type);
    out.add(_byte16.getUint8(0));
  }
  static _writeUint64(List<int> out, int d) {
    _byte64.setUint64(0, d);
    out.add(uint64Type);
    out.add(_byte64.getUint8(7));
    out.add(_byte64.getUint8(6));
    out.add(_byte64.getUint8(5));
    out.add(_byte64.getUint8(4));
    out.add(_byte64.getUint8(3));
    out.add(_byte64.getUint8(2));
    out.add(_byte64.getUint8(1));
    out.add(_byte64.getUint8(0));
  }
  static _writeUint32(List<int> out, int d) {
    _byte32.setUint32(0, d);
    out.add(uint32Type);
    out.add(_byte32.getUint8(3));
    out.add(_byte32.getUint8(2));
    out.add(_byte32.getUint8(1));
    out.add(_byte32.getUint8(0));

  }
  static _writeUint16(List<int> out, int d) {
    _byte16.setUint16(0, d);
    out.add(uint16Type);
    out.add(_byte16.getUint8(1));
    out.add(_byte16.getUint8(0));
  }
  static _writeUint8(List<int> out, int d) {
    _byte16.setUint16(0, d);
    out.add(uint8Type);
    out.add(_byte16.getUint8(0));
  }

  static _writeInt(List<int> out, int d) {
    if (d < -(1 << 5)) {
      if (d < -(1 << 15)) {
        if (d < -(1 << 31)) {
          if (d < -(1<<63)) {
            throw new ArgumentError("bigint serialization is not support, arg = ${d}");
          } else {
            _writeInt64(out, d);
          }
        } else {
          _writeInt32(out, d);
        }
      } else {
        if (d < -(1 << 7)) {
          _writeInt16(out, d);
        } else {
          _writeInt8(out, d);
        }
      }
    } else if (d < (1 << 7)) {
      out.add(d);
    } else {
      if (d < (1 << 16)) {
        if (d < (1 << 8)) {
          _writeUint8(out, d);
        } else {
          _writeUint16(out, d);
        }
      } else {
        if (d < (1 << 32)) {
          _writeUint32(out, d);
        } else if (d < ((1<<64))) {
          _writeUint64(out, d);
        } else {
          throw new ArgumentError("bigint serialization is not support, arg = ${d}");
        }
      }
    }
  }

  static _writeDouble(List<int> out, double d) {
    out.add(doubleType);
    _buff64.asByteArray().setFloat64(0, d);
    for (int i=0; i<8; i++) out.add(_buff64[i]);
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
  static _writeType(List<int> out,
          int fixSize,
          int size,
          List<int> types) {
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
        out.add(size >> 8);
        out.add(size & 0xff);
        return 5;
    }
  }
  //encodeUtf8内部は非常に遅いし、getRange()が走っている。
  //ここを改善できれば、2-3倍速くなるはず。
  static _writeString(List<int> out, String s) {
    List<int> enc = encodeUtf8(s);
    _writeType(out,32, enc.length, [fixRawType, raw16Type, raw32Type]);
    out.addAll(enc);
  }

  static _writeMap(List<int> out, Map m) {
    int size = m.length;
    int index = _writeType(out, 16, size, [fixMapType, map16Type, map32Type]);
    for (var key in m.keys) {
      _write(out, key);
      _write(out, m[key]);
    }
  }

  static _writeList(List<int> out, List m) {
    int size = m.length;
    int index = _writeType(out, 16, size, [fixArrayType, array16Type, array32Type]);
    for (int i=0; i<m.length; i++) {
      _write(out, m[i]);
    }
  }

  static _write(List buff, arg) {
    if (arg == null) {
        buff.add(nullType);
    } else if (arg is bool) {
      if (arg == false) buff.add(falseType);
      else buff.add(trueType);
    } else if (arg is int) {
      _writeInt(buff, arg);
    } else if (arg is double) {
      _writeDouble(buff, arg);
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
  static final ByteArray _byte8 = new Uint8List(1).asByteArray(0,1);
  static final ByteArray _byte16 = new Uint8List(2).asByteArray(0,2);
  static final ByteArray _byte32 = new Uint8List(4).asByteArray(0,4);
  static final ByteArray _byte64 = new Uint8List(8).asByteArray(0,8);
  static final Uint8List _buff32 = new Uint8List(4);
  static final Uint8List _buff64 = new Uint8List(8);
  static ByteArray _buff32View() => _buff32.asByteArray(0,4);
  static ByteArray _buff64View() => _buff64.asByteArray(0,8);

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
