
main() {
  print("### start ###");
  for (var i = 0; i<4; i++) {
    print("call1 elapsed time = ${gettime(() => hot(calc1, 10000))} ms");
    print("call2 elapsed time = ${gettime(() => hot(calc2, 10000))} ms");
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

double calc1(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret = (i + ret) - (i * ret) / (i+3);
  }
  return ret;
}

double calc2(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret = (i.toDouble() + ret) - (i.toDouble() * ret) / (i + 3).toDouble();
  }
  return ret;
}
