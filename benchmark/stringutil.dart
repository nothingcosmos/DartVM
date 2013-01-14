
main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  for (var i = 0; i<4; i++) {
    print("substring time = ${gettime(() => hotString(substring, 10000))} ms");
    print("indeOf time = ${gettime(() => hotString(indexOf, 10000))} ms");
    print("charCodeAt time = ${gettime(() => hotString(charCodeAt, 10000))} ms");
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


hotString(var func, int N) {
  String ret = "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789";
  for (int i=0; i<N; i++) {
    func(ret, i);
  }
  return ret.length;
}


String substring(String init, int i) {
  return init.substring(i%100);
}

int indexOf(String init, int i) {
  return init.indexOf((i%100).toString());
}

int charCodeAt(String init, int i) {
  return init.charCodeAt((i%100));
}
