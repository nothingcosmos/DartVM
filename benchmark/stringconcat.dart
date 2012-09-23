
main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  for (var i = 0; i<4; i++) {
    print("String.concat() elapsed time = ${gettime(() => hotString(concatString, 10000))} ms");
    print("literal interpolate elapsed time = ${gettime(() => hotString(literalString, 10000))} ms");
    print("StringBuffer.add() elapsed time = ${gettime(() => hotString(addStringBuffer, 10000))} ms");
    print("Strings.concatAll() elapsed time = ${gettime(() => hotString(concatAll, 10000))} ms");
    print("Strings.concatAll(init args) elapsed time = ${gettime(() => hotString(concatAll2, 10000))} ms");
  }
  print("### end   ###");
  return ;
}

gettime(var func) {
    var stime = new Date.now();
    //
    var ret = func();
    //
    var etime = new Date.now();
    var elapsedTime = etime.difference(stime).inMilliseconds;

    print("ret = $ret");
    return elapsedTime;
}

hotdouble(var func, int N) {
  double ret = 2.0;
  for (int i=0; i<N; i++) {
    ret += func(ret);
  }
  return ret;
}

hotString(var func, int N) {
  String ret = "";
  for (int i=0; i<N; i++) {
    ret = func(ret, i);
  }
  return ret.length;
}


String concatString(String init, int i) {
// PolymorphicInstanceCall(concat, 
// PolymorphicInstanceCall(concat, 
// PolymorphicInstanceCall(concat, 
// PolymorphicInstanceCall(concat, 
//
// String_base.concat is native "String_concat"
// String_concat -> Object.cc RawString* String::Concat();
//
  // must toString()
  return "<test>".concat(init).concat(i.toString()).concat("</test>");
}

String literalString(String init, int i) {
//  PushArgument
//  PushArgument
//  ...
//  CreateArray
//  pushArgument
//  _interpolate (array
//
//static String _interpolate(List values) {
//  int numValues = values.length;
//  var stringList = new ObjectArray(numValues);
//  for (int i = 0; i < numValues; i++) {
//    stringList[i] = values[i].toString();
//  }
//  return _concatAll(stringList);  <-- Strings.concatAll(List<String>)
//}
//
// _concatAll -> Object.cc RawString* String::ConcatAll(const Array& strings,...
  return "<test>${init}${i}</test>";
}

String addStringBuffer(String init, int i) {
  StringBuffer b = new StringBuffer();
  b.add("<test>");
  b.add(init);
  b.add(i);  // may toString()
  b.add("</test>");
  return b.toString();
}

String concatAll(String init, int i) {
  List<String> arg = new List<String>();
  arg.add("<test>");
  arg.add(init);
  arg.add(i.toString());  // must toString()
  arg.add("</test>");
  return Strings.concatAll(arg);
}

List<String> initarg = ["<test>", "", "", "</test>"];
String concatAll2(String init, int i) {
  initarg[1] = init;
  initarg[2] = i.toString();
  return Strings.concatAll(initarg);
}

