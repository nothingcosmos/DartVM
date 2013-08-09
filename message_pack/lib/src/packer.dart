part of message_pack;

/**
 * MessagePack is supported to similar as Dart's Message Snapshot.
 *
 *    A primitive value (null, num, bool, double, String)
 *
 *    A list or map whose elements are any of the above,
 *    including other lists and maps
 *
 * - Bigint is not support.
 * - Float32 is not support. but possible to decode as cast to typed_data Flaot32
 * - String is supported with UTF-8
 */
class PackTransformer extends StreamEventTransformer<dynamic, List<int>> {
  void _handle(dynamic data, EventSink<List<int>> sink, bool isClosing) {
    List<int> ret = Packer.pack(data, uint8:true);
    sink.add(ret);
    if (isClosing) {
      //todo throw exception
    }
    return ;
  }

  void handleData(dynamic data, EventSink<List<int>> sink) {
    _handle(data, sink, false);
  }

  void handleDone(EventSink<List<int>> sink) {
    sink.close();
  }
}

class Packer {
  /**
   * if uint8:true, convert List<int> to Uint8List.
   * Uint8List, Memory 1/4 and is not required GC's store barrier.
   * because it is good for working in memory.
   */
  static List pack(arg, {uint8:false}) {
    if (uint8) {
      Uint8ListOutput buff = new Uint8ListOutput(new Uint8List(1024));
      //ArrayOutput buff = new ArrayOutput(new Uint8List(1024), _resizeUint8List);
      _write(buff, arg);
      List ret = buff.pack();
      //debug
      //ret.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
      return ret;
    } else {
      ArrayOutput buff = new ArrayOutput(new List(1024), _resizeList);
      _write(buff, arg);
      List ret = buff.pack();
      //debug
      //ret.forEach((e) => print("write=${e},${e.toRadixString(16)}"));
      return ret;
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
    } else {
      throw new FallThroughError();
    }
  }
  /**
   * TODO
   * message_packのStringの仕様がどうなったのか調査が必要。現在はUTF-8
   * encodeUtf8内部は非常に遅いし、getRange()が走っている。
   * libを展開してgetRange()を除去できればStringは2-3倍速くなるはず
   */
  static _writeString(Output out, String s) {
    final rawTypeList = [fixRawType, raw16Type, raw32Type];
    List<int> enc = encodeUtf8(s);
    _writeType(out, 32, enc.length, rawTypeList);
    out.writeList(enc);
  }

  static _writeMap(Output out, Map m) {
    final mapTypeList = [fixMapType, map16Type, map32Type];
    int size = m.length;
    int index = _writeType(out, 16, size, mapTypeList);
    for (var key in m.keys) {
      _write(out, key);
      _write(out, m[key]);
    }
  }

  static _writeList(Output out, List m) {
    final listTypeList =  [fixArrayType, array16Type, array32Type];
    int size = m.length;
    int index = _writeType(out, 16, size,listTypeList);
    for (int i=0; i<m.length; i++) {
      _write(out, m[i]);
    }
  }

  static _write(Output buff, arg) {
    if (arg == null) {
        buff.writeUint8(nullType);
    } else if (arg is int) {
      _writeInt(buff, arg);
    } else if (arg is double) {
      buff.writeByteAndDouble(doubleType, arg);
    } else if (arg is String) {
      _writeString(buff, arg);
    } else if (arg is List) {
      // @notice
      // 4x slow,if specialize to typed_data.
      _writeList(buff, arg);
    } else if (arg is Map) {
      _writeMap(buff, arg);
    } else if (arg is bool) {
      if (arg == false) buff.writeUint8(falseType);
      else buff.writeUint8(trueType);
    } else {
      throw new ArgumentError("${arg.runtimeType} type serialization is not support, arg = ${arg}");
    }
  }
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

class Uint8ListOutput implements Output {
  Uint8ListOutput(Uint8List list) {
    _buffer_size = list.length;
    _buffer = list;
  }
  int _buffer_size;
  int _idx = 0;
  Uint8List _buffer;
  ByteData _byte64 = new ByteData(8);

  _reserve(int len) {
    if (_idx + len > _buffer_size) {
      _resize(_buffer_size*2);
    }
  }

  _resize(int len) {
    var old_buff = _buffer;
    var old_size = _buffer_size;
    _buffer_size = len;
    _buffer = new Uint8List(len);

    int size = min(len, old_size);
    for (int i=0; i< size; i++) {
      _buffer[i] = old_buff[i];
    }
    return _buffer;
  }
  Uint8List pack() {
    return new Uint8List.view(_buffer.buffer, 0, _idx);
  }

  writeUint8(int d) {
    const int offset = 1;
    _reserve(offset);
    _buffer[_idx+0] = (d)&0xff;
    _idx+=offset;
  }
  writeUint16(int d) {
    const int offset = 2;
    _reserve(offset);
    _buffer[_idx+0] = (d>>8)&0xff;
    _buffer[_idx+1] = (d)&0xff;
    _idx+=offset;
  }
  writeUint32(int d) {
    const int offset = 4;
    _reserve(offset);
    _buffer[_idx+0] = (d>>24)&0xff;
    _buffer[_idx+1] = (d>>16)&0xff;
    _buffer[_idx+2] = (d>>8)&0xff;
    _buffer[_idx+3] = (d)&0xff;
    _idx+=offset;
  }
  writeUint64(int d) {
    const int offset = 8;
    _reserve(offset);
    _buffer[_idx+0] = (d>>56)&0xff;
    _buffer[_idx+1] = (d>>48)&0xff;
    _buffer[_idx+2] = (d>>40)&0xff;
    _buffer[_idx+3] = (d>>32)&0xff;
    _buffer[_idx+4] = (d>>24)&0xff;
    _buffer[_idx+5] = (d>>16)&0xff;
    _buffer[_idx+6] = (d>>8)&0xff;
    _buffer[_idx+7] = (d)&0xff;
    _idx+=offset;
  }
  writeDouble(double d) {
    const int offset = 8;
    _reserve(offset);
    _byte64.setFloat64(0, d);
    _buffer[_idx+0] = _byte64.getUint8(0);
    _buffer[_idx+1] = _byte64.getUint8(1);
    _buffer[_idx+2] = _byte64.getUint8(2);
    _buffer[_idx+3] = _byte64.getUint8(3);
    _buffer[_idx+4] = _byte64.getUint8(4);
    _buffer[_idx+5] = _byte64.getUint8(5);
    _buffer[_idx+6] = _byte64.getUint8(6);
    _buffer[_idx+7] = _byte64.getUint8(7);
    _idx+=offset;
  }
  writeList(List d) {
    int offset = d.length;
    _reserve(offset);
    d.forEach((int e) => _buffer[_idx++] = e);
  }

  writeByteAndUint8(int b, int d) {
    const int offset = 2;
    _reserve(offset);
    _buffer[_idx+0] = b;
    _buffer[_idx+1] = (d)&0xff;
    _idx+=offset;
  }
  writeByteAndUint16(int b, int d) {
    const int offset = 3;
    _reserve(offset);
    _buffer[_idx+0] = b;
    _buffer[_idx+1] = (d>>8)&0xff;
    _buffer[_idx+2] = (d)&0xff;
    _idx+=offset;
  }
  writeByteAndUint32(int b, int d) {
    const int offset = 5;
    _reserve(offset);
    _buffer[_idx+0] = b;
    _buffer[_idx+1] = (d>>24)&0xff;
    _buffer[_idx+2] = (d>>16)&0xff;
    _buffer[_idx+3] = (d>>8)&0xff;
    _buffer[_idx+4] = (d)&0xff;
    _idx+=offset;
  }
  writeByteAndUint64(int b, int d) {
    const int offset = 9;
    _reserve(offset);
    _buffer[_idx+0] = b;
    _buffer[_idx+1] = (d>>56)&0xff;
    _buffer[_idx+2] = (d>>48)&0xff;
    _buffer[_idx+3] = (d>>40)&0xff;
    _buffer[_idx+4] = (d>>32)&0xff;
    _buffer[_idx+5] = (d>>24)&0xff;
    _buffer[_idx+6] = (d>>16)&0xff;
    _buffer[_idx+7] = (d>>8)&0xff;
    _buffer[_idx+8] = (d)&0xff;
    _idx+=offset;
  }
  writeByteAndDouble(int b, double d) {
    const int offset = 9;
    _reserve(offset);
    _buffer[_idx+0] = b;
    _byte64.setFloat64(0, d);
    _buffer[_idx+1] = _byte64.getUint8(0);
    _buffer[_idx+2] = _byte64.getUint8(1);
    _buffer[_idx+3] = _byte64.getUint8(2);
    _buffer[_idx+4] = _byte64.getUint8(3);
    _buffer[_idx+5] = _byte64.getUint8(4);
    _buffer[_idx+6] = _byte64.getUint8(5);
    _buffer[_idx+7] = _byte64.getUint8(6);
    _buffer[_idx+8] = _byte64.getUint8(7);
    _idx+=offset;
  }
}

// @attention
// - if used in conjunction with Uint8List, it is very slow. because translated to polymorphic ic.
_resizeUint8List(List old, int newlen) {
  var old_buff = old;
  var old_size = old.length;
  List ret = new Uint8List(newlen);

  int size = min(newlen, old_size);
  for (int i=0; i< size; i++) {
    ret[i] = old_buff[i];
  }
  return ret;
}

_resizeList(List old, int newlen) {
  var old_buff = old;
  var old_size = old.length;
  List ret = new List(newlen);

  int size = min(newlen, old_size);
  for (int i=0; i< size; i++) {
    ret[i] = old_buff[i];
  }
  return ret;
}

class ArrayOutput implements Output {
  ArrayOutput(this._buffer, dynamic resize) {
    _resize = resize;
  }
  int idx = 0;
  List _buffer;
  dynamic _resize;

  final ByteData _byte64 = new ByteData(8);

  _reserve(int len) {
    if (idx + len > _buffer.length) {
      _buffer = _resize(_buffer, _buffer.length * 2);
    }
  }

  List pack() {
    return _resize(_buffer, idx);
  }

  writeUint8(int d) {
    const int offset = 1;
    _reserve(offset);
    _buffer[idx+0] = (d)&0xff;
    idx+=offset;
  }
  writeUint16(int d) {
    const int offset = 2;
    _reserve(offset);
    _buffer[idx+0] = (d>>8)&0xff;
    _buffer[idx+1] = (d)&0xff;
    idx+=offset;
  }
  writeUint32(int d) {
    const int offset = 4;
    _reserve(offset);
    _buffer[idx+0] = (d>>24)&0xff;
    _buffer[idx+1] = (d>>16)&0xff;
    _buffer[idx+2] = (d>>8)&0xff;
    _buffer[idx+3] = (d)&0xff;
    idx+=offset;
  }
  writeUint64(int d) {
    const int offset = 8;
    _reserve(offset);
    _buffer[idx+0] = (d>>56)&0xff;
    _buffer[idx+1] = (d>>48)&0xff;
    _buffer[idx+2] = (d>>40)&0xff;
    _buffer[idx+3] = (d>>32)&0xff;
    _buffer[idx+4] = (d>>24)&0xff;
    _buffer[idx+5] = (d>>16)&0xff;
    _buffer[idx+6] = (d>>8)&0xff;
    _buffer[idx+7] = (d)&0xff;
    idx+=offset;
  }
  writeDouble(double d) {
    const int offset = 8;
    _reserve(offset);
    _byte64.setFloat64(0, d);
    _buffer[idx+0] = _byte64.getUint8(0);
    _buffer[idx+1] = _byte64.getUint8(1);
    _buffer[idx+2] = _byte64.getUint8(2);
    _buffer[idx+3] = _byte64.getUint8(3);
    _buffer[idx+4] = _byte64.getUint8(4);
    _buffer[idx+5] = _byte64.getUint8(5);
    _buffer[idx+6] = _byte64.getUint8(6);
    _buffer[idx+7] = _byte64.getUint8(7);
    idx+=offset;
  }
  writeList(List d) {
    int offset = d.length;
    _reserve(offset);
    d.forEach((int e) => _buffer[idx++] = e);
  }

  writeByteAndUint8(int b, int d) {
    const int offset = 2;
    _reserve(offset);
    _buffer[idx+0] = b;
    _buffer[idx+1] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint16(int b, int d) {
    const int offset = 3;
    _reserve(offset);
    _buffer[idx+0] = b;
    _buffer[idx+1] = (d>>8)&0xff;
    _buffer[idx+2] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint32(int b, int d) {
    const int offset = 5;
    _reserve(offset);
    _buffer[idx+0] = b;
    _buffer[idx+1] = (d>>24)&0xff;
    _buffer[idx+2] = (d>>16)&0xff;
    _buffer[idx+3] = (d>>8)&0xff;
    _buffer[idx+4] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndUint64(int b, int d) {
    const int offset = 9;
    _reserve(offset);
    _buffer[idx+0] = b;
    _buffer[idx+1] = (d>>56)&0xff;
    _buffer[idx+2] = (d>>48)&0xff;
    _buffer[idx+3] = (d>>40)&0xff;
    _buffer[idx+4] = (d>>32)&0xff;
    _buffer[idx+5] = (d>>24)&0xff;
    _buffer[idx+6] = (d>>16)&0xff;
    _buffer[idx+7] = (d>>8)&0xff;
    _buffer[idx+8] = (d)&0xff;
    idx+=offset;
  }
  writeByteAndDouble(int b, double d) {
    const int offset = 9;
    _reserve(offset);
    _buffer[idx+0] = b;
    _byte64.setFloat64(0, d);
    _buffer[idx+1] = _byte64.getUint8(0);
    _buffer[idx+2] = _byte64.getUint8(1);
    _buffer[idx+3] = _byte64.getUint8(2);
    _buffer[idx+4] = _byte64.getUint8(3);
    _buffer[idx+5] = _byte64.getUint8(4);
    _buffer[idx+6] = _byte64.getUint8(5);
    _buffer[idx+7] = _byte64.getUint8(6);
    _buffer[idx+8] = _byte64.getUint8(7);
    idx+=offset;
  }
}

class MessagePackUnsupportedObjectError implements Error {
  final unsupportedObject;
  final cause;

  MessagePackUnsupportedObjectError(this.unsupportedObject, { this.cause });

  String toString() {
    if (cause != null) {
      return "Calling toJson method on object failed.";
    } else {
      return "Object toJson method returns non-serializable value.";
    }
  }

  StackTrace get stackTrace => null; // TODO implement this getter
}
