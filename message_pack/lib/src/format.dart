part of message_pack;

//Fixnum
const int negativeFixnumType = 0xe0;
const int negativeFixnumMask = 0x1f;
const int map32Type = 0xdf;
const int map16Type =  0xde;
const int array32Type = 0xdd;
const int array16Type = 0xdc;
const int raw32Type = 0xdb;
const int raw16Type = 0xda;
const int int64Type = 0xd3;
const int int32Type = 0xd2;
const int int16Type = 0xd1;
const int int8Type = 0xd0;
const int uint64Type = 0xcf;
const int uint32Type = 0xce;
const int uint16Type = 0xcd;
const int uint8Type = 0xcc;
const int doubleType = 0xcb;
const int floatType = 0xca;
const int trueType = 0xc3;
const int falseType = 0xc2;
const int nullType = 0xc0;
//FixRaw
const int fixRawType = 0xa0;
const int fixRawMask = 0x1f;
//FixArray
const int fixArrayType = 0x90;
const int fixArrayMask = 0x0f;
//FixMap
const int fixMapType = 0x80;
const int fixMapMask = 0x0f;
//Fixnum
const int positiveFixnumType = 0x00;
const int positiveFIxnumMask = 0x7f;

//length
const int negativeFixnumLength = 1;
const int map32TypeLength = 5;
const int map16TypeLength = 3;
const int array32TypeLength = 5;
const int array16TypeLength = 3;
const int raw32TypeLength = 5;
const int raw16TypeLength = 3;
const int int64Length = 9;
const int int32Length = 5;
const int int16Length = 3;
const int int8Length = 2;
const int uint64Length = 9;
const int uint32Length = 5;
const int uint16Length = 3;
const int uint8Length = 2;
const int doubleLength = 9;
const int floatLength = 5;
const int trueLength = 1;
const int falseLength = 1;
const int nullLength = 1;
const int fixRawTypeLength = 1;
const int fixArrayTypeLength = 1;
const int fixMapTypeLength = 1;
const int positiveFixnumLength = 1;
