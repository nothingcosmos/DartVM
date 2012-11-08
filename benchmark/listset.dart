#import('dart:scalarlist');

main() {
  print("### start ###");
  initIArray(10000);
  initDArray(10000);
  initIList(10000);
  initDList(10000);
  initInt32List(10000);
  initFloat32List(10000);
  initFloat64List(10000);
  for (var i = 0; i<4; i++) {
    print("initIList elapsed time = ${gettime(() => hotinit(initIList, 10000))} ms");
    print("initDList elapsed time = ${gettime(() => hotinit(initDList, 10000))} ms");
    print("initIArray elapsed time = ${gettime(() => hotinit(initIArray, 10000))} ms");
    print("initDArray elapsed time = ${gettime(() => hotinit(initDArray, 10000))} ms");
    print("initInt32List elapsed time = ${gettime(() => hotinit(initInt32List, 10000))} ms");
    print("initFloat32List elapsed time = ${gettime(() => hotinit(initFloat32List, 10000))} ms");
    print("initFloat64List elapsed time = ${gettime(() => hotinit(initFloat64List, 10000))} ms");
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

hotinit(var func, int N) {
  int ret = 0;
  for (int i=0; i<N; i++) {
    ret += func(N);
  }
  print("ret = $ret");
}

List<int> iarray;
initIArray(int N) {
  iarray = new List<int>(N);
  for (var i=0; i<N; i++) {
    iarray[i] = (i%100);
  }
  return 0;
}

List<double> darray;
initDArray(int N) {
  darray = new List<double>(N);
  for (var i=0; i<N; i++) {
    darray[i] = (i.toDouble()%100.0);
  }
  return 0;
}

List<int> ilist;
initIList(int N) {
  ilist = new List<int>();
  for (var i=0; i<N; i++) {
    ilist.add(i%100);
  }
  return 0;
}

List<double> dlist;
initDList(int N) {
  dlist = new List<double>();
  for (var i=0; i<N; i++) {
    dlist.add(i.toDouble()%100.0);
  }
  return 0;
}

double calcAddIList(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += ilist[i].toDouble();
  }
  return ret/100.0;
}

double calcAddDList(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += dlist[i];
  }
  return ret/100.0;
}

double calcAddIArray(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += iarray[i].toDouble();
  }
  return ret/100.0;
}

double calcAddDArray(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += darray[i];
  }
  return ret/100.0;
}


Int32List i32list;
initInt32List(int N) {
  i32list = new Int32List(N);
  for (var i=0; i<N; i++) {
    i32list[i] = (i%100);
  }
  return 0;
}

double calcAddInt32List(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += i32list[i].toDouble();
  }
  return ret/100.0;
}


Float32List f32list;
initFloat32List(int N) {
  f32list = new Float32List(N);
  for (var i=0; i<N; i++) {
    f32list[i] = (i.toDouble()%100.0);
  }
  return 0;
}

double calcAddFloat32List(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += f32list[i];
  }
  return ret/100.0;
}

Float64List f64list;
initFloat64List(int N) {
  f64list = new Float64List(N);
  for (var i=0; i<N; i++) {
    f64list[i] = (i.toDouble()%100.0);
  }
  return 0;
}

double calcAddFloat64List(double init) {
  double ret = init;
  for (int i=0; i<10000; i++) {
    ret += f64list[i].toDouble();
  }
  return ret/100.0;
}

