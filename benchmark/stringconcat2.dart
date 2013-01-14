
main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  for (var i = 0; i<4; i++) {
    print("String.concat() elapsed time = ${gettime(() => hotString(concatString, 10000))} ms");
    print("literal interpolate elapsed time = ${gettime(() => hotString(literalString, 10000))} ms");
    print("StringBuffer.add() elapsed time = ${gettime(() => hotStringBuffer(addStringBuffer, 10000))} ms");
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

hotStringBuffer(var func, int N) {
  var ret = new StringBuffer();
  for (int i=0; i<N; i++) {
    ret = func(ret, i);
  }
  return ret.toString().length;
}

String concatString(var init, int i) {
  return init.concat(i.toString());
}

String literalString(var init, int i) {
  return "${init}${i}";
}

String addStringBuffer(var init, int i) {
  init.add(i);
  return init;
}
