class classtest<T> {
  T init;

  classtest(T x) {
    this.init = x;
  }

  retClosure(var n) {
    var init;
    if (n is double) {
      init = 1.0;
    } else {
      init = 1;
    }
    var func = rec(var N) {
      var ret;
      if (N > init) {
        ret = N * rec(N - init);
      } else {
        ret = init;
      }
      return ret;
    };
    return func;
  }
  recClosure(var n) {
    var init;
    if (n is double) {
      init = 1.0;
    } else {
      init = 1;
    }
    var func = fact(var N) {
//      print("N = ${N}");
      var ret;
      if (N > init) {
        ret = N * fact(N - init);
      } else {
        ret = init;
      }
//      print("ret = ${ret}");
      return ret;
    };
    return func(n);
  }
}

main() {
  List result = new List();
  for (int i=0; i<1000000; i++) {
    result.add(0);
  }

  print("start");
  var testint = new classtest<int>(1);
  var testdouble = new classtest<double>(1.0);

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = testint.recClosure(i%10); } };
    print ("recClosure(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = testint.recClosure(i%10.0); } };
    print ("recClosure(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = testint.recClosure(i%10); } };
    print ("recClosure(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = testint.recClosure(i%10.0); } };
    print ("recClosure(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var cc = testint.retClosure(10);
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = cc(i%10); } };
    print ("retClosure(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var cc = testint.retClosure(10.0);
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = cc(i%10.0); } };
    print ("retClosure(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var cc = testint.retClosure(10);
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = cc(i%10); } };
    print ("retClosure(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var cc = testint.retClosure(10.0);
    var ret = () { for (int i=0; i<1000000; i++) { result[i] = cc(i%10.0); } };
    print ("retClosure(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }




  print("end");
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

