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

class UnpackTransformer extends StreamEventTransformer<List<int>, dynamic> {
  List<int> _carry = null;
  StateUnpacker unpacker = new StateUnpacker();

  void _handle(List<int> data, EventSink<dynamic> sink, bool isClosing) {
    if (_carry != null) {
       _carry.addAll(data);
      data = _carry;
      _carry = null;
    }
    int pos = 0;
    while(pos < data.length) {
      pos += unpacker.read(data, pos);
      if (unpacker.hasCompleteValue()) {
        sink.add(unpacker.completeValue);
      } else {
        _carry = new List.from(data.getRange(pos, data.length), growable:true);
        break;
      }
    }
    if (isClosing) {
      //todo throw exception
    }
    return ;
  }

  void handleData(List<int> data, EventSink<String> sink) {
    _handle(data, sink, false);
  }

  void handleDone(EventSink<String> sink) {
    _handle(new List<int>(), sink, true);
    sink.close();
  }
}

class _StateType {
  final String name;
  const _StateType(this.name);
  String toString() => name;
}
const _StateType _STATE_ARRAY  = const _StateType('array');
const _StateType _STATE_MAP    = const _StateType('map');
const _StateType _STATE_MAP_KEY = const _StateType('map key');
const _StateType _STATE_INIT = const _StateType('initial state');

class _State {
  _StateType stateType;
  int num;
  int curr = 0;
  dynamic container;
  dynamic map_key;
  _State(this.stateType, this.container, this.num);
  void clear() {
    container = null;
    map_key = null;
  }
  String toString() => "$stateType ${curr}/${num}";
}

class StateUnpacker {
  List<_State> _StateStack = new List<_State>();
  dynamic _completeValue;

  void _init() {
    _completeValue = _STATE_INIT;
  }
  get completeValue => _completeValue;
  bool hasCompleteValue() {
    return _completeValue != _STATE_INIT;
  }

  int read(List<int> byte, [int idx = 0]) {
    if (_StateStack.isEmpty) return _forwardHeader(byte, idx);
    _State state = _StateStack.last;
    if (state.stateType == _STATE_ARRAY) {
      return _readListContainer(byte, idx);
    } else if (state.stateType == _STATE_MAP) {
      return _readMapContainer(byte, idx);
    } else if (state.stateType == _STATE_MAP_KEY) {
      return _readMapContainer(byte, idx);
    } else {
      //throw
    }
  }

  //return readed idx
  int _readListContainer(List<int> byte, int idx) {
    _State state = _StateStack.last;
    List container = state.container;
    int num = state.num;
    int curr = state.curr;
    int readedIdx = 0;
    while (curr < num) {
      readedIdx += _forwardHeader(byte, idx + readedIdx);
      if (hasCompleteValue()) {
          container[curr] = completeValue;
          curr++;
      } else {
        break;
      }
    }
    if (curr == state.num) {
      _completeValue = container;
      _State remove = _StateStack.removeLast();
      remove.clear();
    } else {
      state.curr = curr;
    }
    return readedIdx;
  }

  //return readed idx
  int _readMapContainer(List<int> byte, int idx) {
    _State state = _StateStack.last;
    Map container = state.container;
    int num = state.num;
    int curr = state.curr;
    int readedIdx = 0;
    while (curr < num) {
      if (state.stateType == _STATE_MAP) {
        //get key
        readedIdx += _forwardHeader(byte, idx + readedIdx);
        if (hasCompleteValue()) {
          state.map_key = completeValue;
          state.stateType = _STATE_MAP_KEY;
        } else {
          state.curr = curr;
          return readedIdx;
        }
      }

      if (state.stateType == _STATE_MAP_KEY) {
        // get value
        readedIdx += _forwardHeader(byte, idx + readedIdx);
        if (hasCompleteValue()) {
          container[state.map_key] = completeValue;
          state.stateType = _STATE_MAP;
        } else {
          state.curr = curr;
          return readedIdx;
        }
      }
      curr++;
    }
    if (curr == state.num) {
      _completeValue = container;
      _State remove = _StateStack.removeLast();
      remove.clear();
    } else {
      state.curr = curr;
    }
    return readedIdx;
  }

  static bool overArrayBounds(List<int> byte, int idx, int length) {
    return (byte.length < (idx + length));
  }

  //return readed length
  int _forwardHeader(List<int> byte, [int idx = 0]) {
    _init();
    if (byte.length <= idx) return 0;
    int header = byte[idx];
    if (header >= negativeFixnumType) {// Negative FixNum (111x xxxx) (-32 ~ -1)
      _completeValue = header - 0x100;
      return negativeFixnumLength;
    }
    if (header < (128)) {              // Positive FixNum (0xxx xxxx) (0 ~ 127)
      _completeValue = header;
      return positiveFixnumLength;
    }

    int type = header;
    int num;
    if (header < fixArrayType) {       // FixMap (1000 xxxx)
      num = header - fixMapType;
      type = fixMapType;
    } else if (header < fixRawType) { // FixArray (1001 xxxx)
      num = header - fixArrayType;
      type = fixArrayType;
    } else if (header < nullType) {   // FixRaw (101x xxxx)
      num = header - fixRawType;
      type = fixRawType;
    }
    switch(type) {
    case nullType:
      _completeValue = null;
      return nullLength;
    case falseType:
      _completeValue = false;
      return falseLength;
    case trueType:
       _completeValue = true;
      return trueLength;
    default:
      break;
    }

    switch (type) {
      case doubleType:
        if (overArrayBounds(byte, idx, doubleLength)) return 0;
        _completeValue = Unpacker._readDouble(byte, idx);
        return doubleLength;
      case int64Type:
        if (overArrayBounds(byte, idx, int64Length)) return 0;
        _completeValue = Unpacker._readInt64(byte, idx);
        return int64Length;
      case int32Type:
        if (overArrayBounds(byte, idx, int32Length)) return 0;
        _completeValue = Unpacker._readInt32(byte, idx);
        return int32Length;
      case int16Type:
        if (overArrayBounds(byte, idx, int16Length)) return 0;
        _completeValue = Unpacker._readInt16(byte, idx);
        return int16Length;
      case int8Type:
        if (overArrayBounds(byte, idx, int8Length)) return 0;
        _completeValue = Unpacker._readInt8(byte, idx);
        return int8Length;
      case uint64Type:
        if (overArrayBounds(byte, idx, uint64Length)) return 0;
        _completeValue = Unpacker._readUint64(byte, idx);
        return uint64Length;
      case uint32Type:
        if (overArrayBounds(byte, idx, uint32Length)) return 0;
        _completeValue = Unpacker._readUint32(byte, idx);
        return uint32Length;
      case uint16Type:
        if (overArrayBounds(byte, idx, uint16Length)) return 0;
        _completeValue = Unpacker._readUint16(byte, idx);
        return uint16Length;
      case uint8Type:
        if (overArrayBounds(byte, idx, uint8Length)) return 0;
        _completeValue = Unpacker._readUint8(byte, idx);
        return uint8Length;
      case raw32Type:// raw 32
        if (overArrayBounds(byte, idx, raw32TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, raw32TypeLength);
        if (overArrayBounds(byte, idx, raw32TypeLength + num)) return 0;
        _completeValue = Unpacker._readRaw(byte, idx, raw32TypeLength, num);
        return raw32TypeLength + num;
      case raw16Type:// raw 16
        if (overArrayBounds(byte, idx, raw16TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, raw16TypeLength);
        if (overArrayBounds(byte, idx, raw16TypeLength + num)) return 0;
        _completeValue = Unpacker._readRaw(byte, idx, raw16TypeLength, num);
        return raw16TypeLength + num;
      case fixRawType:
        if (overArrayBounds(byte, idx, fixRawTypeLength + num)) return 0;
        _completeValue = Unpacker._readRaw(byte, idx, fixRawTypeLength, num);
        return fixRawTypeLength + num;
      case map32Type:
        if (overArrayBounds(byte, idx, map32TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, map32TypeLength);
        _StateStack.add(new _State(_STATE_MAP, new Map(), num));
        return map32TypeLength + _readMapContainer(byte, idx + map32TypeLength);
      case map16Type:
        if (overArrayBounds(byte, idx, map16TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, map16TypeLength);
        _StateStack.add(new _State(_STATE_MAP, new Map(), num));
        return map16TypeLength  + _readMapContainer(byte, idx + map16TypeLength);
      case fixMapType:
        _StateStack.add(new _State(_STATE_MAP, new Map(), num));
        return fixMapTypeLength + _readMapContainer(byte, idx + fixMapTypeLength);
      case array32Type:
        if (overArrayBounds(byte, idx, array32TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, array32TypeLength);
        _StateStack.add(new _State(_STATE_ARRAY, new List(num), num));
        return array32TypeLength + _readListContainer(byte, idx + array32TypeLength);
      case array16Type:
        if (overArrayBounds(byte, idx, array16TypeLength)) return 0;
        int num = Unpacker._readNumOfElements(byte, idx, array16TypeLength);
        _StateStack.add(new _State(_STATE_ARRAY, new List(num), num));
        return array16TypeLength + _readListContainer(byte, idx + array16TypeLength);
      case fixArrayType:
        _StateStack.add(new _State(_STATE_ARRAY, new List(num), num));
        return fixArrayTypeLength + _readListContainer(byte, idx + fixArrayTypeLength);
      case floatType:
        if (overArrayBounds(byte, idx, floatLength)) return 0;
        _completeValue = Unpacker._readFloat(byte, idx);
        return floatLength;
      default:
        //throw new MessageTypeException("header is illegal, header = ${header}");
    }
  }
}

class Unpacker {
  static final ByteData _byte32 = new ByteData(4);
  static final ByteData _byte64 = new ByteData(8);
  static unpack(List byte) {
    if (byte is List) {
      //ok
    } else {
      throw new ArgumentError("arg is not List, arg = ${byte}");
    }
    //_ridx = 0;
    //debug
    //byte.forEach((e) => print("read=${e},${e.toRadixString(16)}"));
    return _read(byte);
  }
  static void saveIndex(int size) {
    _idx = _idx + size;
  }
  static int _idx = 0;
  static _read(List byte, [int idx = 0]) {
    int size = 0;
    var type = byte[idx];

    if (type >= negativeFixnumType) {// Negative FixNum (111x xxxx) (-32 ~ -1)
      saveIndex(negativeFixnumLength);
      return type - 0x100;
    }
    if (type < (128)) {              // Positive FixNum (0xxx xxxx) (0 ~ 127)
      saveIndex(positiveFixnumLength);
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
    switch (type) {
      case nullType:
        saveIndex(nullLength);
        return null;
      case falseType:
        saveIndex(falseLength);
        return false;
      case trueType:
        saveIndex(trueLength);
        return true;
      case doubleType:
        double ret = _readDouble(byte, idx);
        saveIndex(doubleLength);
        return ret;
      case int64Type:
        int ret =  _readInt64(byte, idx);
        saveIndex(int64Length);
        return ret;
      case int32Type:
        int ret =  _readInt32(byte, idx);
        saveIndex(int32Length);
        return ret;
      case int16Type:
        int ret =  _readInt16(byte, idx);
        saveIndex(int16Length);
        return ret;
      case int8Type:
        int ret =  _readInt8(byte, idx);
        saveIndex(int8Length);
        return ret;
      case uint64Type:
        int ret =  _readUint64(byte, idx);
        saveIndex(uint64Length);
        return ret;
      case uint32Type:
        int ret = _readUint32(byte, idx);
        saveIndex(uint32Length);
        return ret;
      case uint16Type:
        int ret =  _readUint16(byte, idx);
        saveIndex(uint16Length);
        return ret;
      case uint8Type:
        int ret =  _readUint8(byte, idx);
        saveIndex(uint8Length);
        return ret;
      case raw32Type:// raw 32
        int size = _readNumOfElements(byte, idx, raw32TypeLength);
        var ret = _readRaw(byte, idx, raw32TypeLength, size);
        saveIndex(raw32TypeLength + size);
        return ret;
      case raw16Type:// raw 16
        int size = _readNumOfElements(byte, idx, raw16TypeLength);
        var ret = _readRaw(byte, idx, raw16TypeLength, size);
        saveIndex(raw16TypeLength + size);
        return ret;
      case fixRawType:
        var ret = _readRaw(byte, idx, fixRawTypeLength, size);
        saveIndex(fixRawTypeLength + size);
        return ret;
      case map32Type:
        int num = _readNumOfElements(byte, idx, map32TypeLength);
        return _readMap(byte, idx, map32TypeLength, num);
      case map16Type:
        int num = _readNumOfElements(byte, idx, map16TypeLength);
        return _readMap(byte, idx, map16TypeLength, num);
      case fixMapType:
        return _readMap(byte, idx, fixMapTypeLength, size);
      case array32Type:
        int num = _readNumOfElements(byte, idx, array32TypeLength);
        return _readArray(byte, idx, array32TypeLength, num);
      case array16Type:
        int num = _readNumOfElements(byte, idx, array16TypeLength);
        return _readArray(byte, idx, array16TypeLength, num);
      case fixArrayType:
        return _readArray(byte, idx, fixArrayTypeLength, size);
      case floatType:
        int ret = _readFloat(byte, idx);
        saveIndex(floatLength);
        return ret;
      default:
        //throw new MessageTypeException("header is illegal, header = ${type}");
    }
  }
  /**
   * Conversion from Java or C/C+
   */
  static _readFloat(List byte, int idx) {
    idx++;
    _byte32.setUint8(0, byte[idx++]);
    _byte32.setUint8(1, byte[idx++]);
    _byte32.setUint8(2, byte[idx++]);
    _byte32.setUint8(3, byte[idx++]);
    return _byte32.getFloat32(0);
  }
  static _readDouble(List byte, int idx) {
    idx++;
    for (int i=0; i<8; i++) {
      _byte64.setUint8(i, byte[idx+i]);
    }
    return _byte64.getFloat64(0);
  }

  static _readInt64(List byte, int idx) {
    idx++;
    int num = 0;
    num += (byte[idx++]^0xff)<<56;
    num += (byte[idx++]^0xff)<<48;
    num += (byte[idx++]^0xff)<<40;
    num += (byte[idx++]^0xff)<<32;
    num += (byte[idx++]^0xff)<<24;
    num += (byte[idx++]^0xff)<<16;
    num += (byte[idx++]^0xff)<<8;
    num += (byte[idx++]^0xff);
    num = (num + 1)*-1;
    return num;
  }
  static _readInt32(List byte, int idx) {
    idx++;
    int num = 0;
    num += (byte[idx++]^0xff)<<24;
    num += (byte[idx++]^0xff)<<16;
    num += (byte[idx++]^0xff)<<8;
    num += (byte[idx++]^0xff);
    num = (num + 1)*-1;
    return num;
  }
  static _readInt16(List byte, int idx) {
    idx++;
    int num = 0;
    num += (byte[idx++]^0xff)<<8;
    num += (byte[idx++]^0xff);
    num = (num + 1)*-1;
    return num;
  }
  static _readInt8(List byte, int idx) {
    idx++;
    int num = 0;
    num += (byte[idx++]^0xff);
    num = (num + 1)*-1;
    return num;
  }

  static _readUint64(List byte, int idx) {
    idx++;
    int num = 0;
    num += byte[idx++]<<56;
    num += byte[idx++]<<48;
    num += byte[idx++]<<40;
    num += byte[idx++]<<32;
    num += byte[idx++]<<24;
    num += byte[idx++]<<16;
    num += byte[idx++]<<8;
    num += byte[idx++];
    return num;
  }
  static _readUint32(List byte, int idx) {
    idx++;
    int num = 0;
    num += byte[idx++]<<24;
    num += byte[idx++]<<16;
    num += byte[idx++]<<8;
    num += byte[idx++];
    return num;
  }
  static _readUint16(List byte, int idx) {
    idx++;
    int num = 0;
    num += byte[idx++]<<8;
    num += byte[idx++];
    return num;
  }

  static _readUint8(List byte, int idx) {
    idx++;
    int num = 0;
    num += byte[idx++];
    return num;
  }

  static _readMap(List byte, int idx, int typeLength, int num) {
    _idx = idx + typeLength;
    Map ret = new Map();
    for (int i=0; i<num; i++) {
      var key = (_read(byte, _idx));
      var val = (_read(byte, _idx));
      ret[key] = val;
    }
    return ret;
  }

  static _readArray(List byte, int idx, int typeLength, int num) {
    _idx = idx + typeLength;
      List ret = new List(num);
      for (int i=0; i<num; i++) {
        ret[i] = (_read(byte, _idx));
      }
      return ret;
  }

  static _readRaw(List byte, int idx, int typeLength, int size) {
    String ret = decodeUtf8(byte, idx + typeLength, size);
    return ret;
  }

  static _readNumOfElements(List byte, int idx, int size) {
    idx++;
    int num = 0;
    if (size == 5) {
      num += byte[idx]   << 24;
      num += byte[idx+1] << 16;
      num += byte[idx+2] << 8;
      num += byte[idx+3];
    } else if (size == 3) {
      num += byte[idx]   << 8;
      num += byte[idx+1];
    } else {
      num += byte[idx];
    }
    return num;
  }
}
