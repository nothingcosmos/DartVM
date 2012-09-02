
main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  for (var i = 0; i<4; i++) {
    print("calcDiv elapsed time = ${gettime(() => hot(calcDiv, 10000))} ms");
    print("calcSimpleDiv elapsed time = ${gettime(() => hot(calcSimpleDiv, 10000))} ms");

    //infinite
    print("calcDivInt elapsed time = ${gettime(() => hot(calcDivInt, 10000))} ms");
    print("calcSimpleDivInt elapsed time = ${gettime(() => hot(calcSimpleDivInt, 10000))} ms");
  }
  print("### end   ###");
  return ;
}

gettime(var func) {
    var stime = new Date.now();
    //
    func();
    //
    var etime = new Date.now();
    var elapsedTime = etime.difference(stime).inMilliseconds;
    return elapsedTime;
}

hot(var func, int N) {
  double ret = 2.0;
  for (int i=0; i<N; i++) {
    ret += func(ret);
  }
  print("ret = $ret");
}


double calcDivInt(double init) {
  int ret = init;
  for (int i=0; i<10000; i++) {
    ret = (i * ret) / (i + 3);
  }
  return ret.toDouble();
}

double calcSimpleDivInt(double init) {
  int ret = init;
  for (int i=0; i<10000; i++) {
    ret = (i * ret / i);
  }
  return ret.toDouble();
}


double calcDiv(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret = (i.toDouble() * ret) / (i.toDouble() + 1.1);
  }
  return ret;
}


double calcSimpleDiv(double init) {
  double ret = init;
  for (double i=1.0; i<10000.0; i+=1.0) {
    ret = (i * ret / i);
  }
  return ret;
}

