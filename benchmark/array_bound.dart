//#import ('dart:scalarlist');
import 'dart:scalarlist';

main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  var cmember = new ClassMemberArray();
  var cfloat64= new ClassMemberFloat64();
  for (var i = 0; i<4; i++) {
    print("forInitArray elapsed time = ${gettime(() => hot(forInitArray, 10000))} ms");
    print("forInitList elapsed time = ${gettime(() => hot(forInitList, 10000))} ms");
    print("forStaticArray elapsed time = ${gettime(() => hot(forStaticArray, 10000))} ms");
    print("forStaticList elapsed time = ${gettime(() => hot(forStaticList, 10000))} ms");
    print("forInitFloat64 elapsed time = ${gettime(() => hot(forInitFloat64, 10000))} ms");
    print("forStaticFloat64 elapsed time = ${gettime(() => hot(forStaticFloat64, 10000))} ms");
    print("forClassMemberArray elapsed time = ${gettime(() => hot(cmember.forClassMemberArray, 10000))} ms");
    print("forClassMemberFloat64 elapsed time = ${gettime(() => hot(cfloat64.forMemberFloat64, 10000))} ms");
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

double forInitArray(double arg) {
  double ret = 0.0;
  var darray = new List<double>(1000);
  for (int i=0; i<1000; i++) {
    //eliminated
    darray[i] = (i.toDouble());
  }
  for (int i=0; i<1000; i++) {
    //eliminated
    ret += darray[i];
  }
  return ret;
}

double forInitList(double arg) {
  double ret = 0.0;
  var dlist = new List<double>();
  for (int i=0; i<1000; i++) {
    // add
    // polymorphic
    dlist.add(i.toDouble());
  }
  for (int i=0; i<1000; i++) {
    // check
    ret += dlist[i];
  }
  return ret;
}

double forInitFloat64(double arg) {
  double ret = 0.0;
  var darray = new Float64List(1000);
  for (int i=0; i<1000; i++) {
    // checked
    darray[i] = i.toDouble();
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += darray[i];
  }
  return ret;
}

var sfloat64 = new Float64List(1000);
double forStaticFloat64(double arg) {
  double ret = 0.0;
  for (int i=0; i<1000; i++) {
    // checked
    sfloat64[i] = i.toDouble();
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += sfloat64[i];
  }
  return ret;
}

var slist = new List<double>();
double forStaticList(double arg) {
  double ret = 0.0;
  //var darray = new List<double>(1000);
  for (int i=0; i<1000; i++) {
    // add
    // polymorphic
    slist.add(i.toDouble());
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += slist[i];
  }
  slist.clear();
  return ret;
}

var sarray = new List<double>(1000);
double forStaticArray(double arg) {
  double ret = 0.0;
  //var darray = new List<double>();
  for (int i=0; i<1000; i++) {
    // checked
    sarray[i] = i.toDouble();
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += sarray[i];
  }
  return ret;
}

class ClassMemberArray {
  final List<double> carray = new List<double>(1000);
  ClassMemberArray() { }
  double forClassMemberArray(double arg) {
  double ret = 0.0;
  //var darray = new List<double>();
  for (int i=0; i<1000; i++) {
    // checked
    carray[i] = i.toDouble();
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += carray[i];
  }
  return ret;
  }
}

class ClassMemberFloat64{
  final Float64List carray = new Float64List(1000);
  ClassMemberArray() { }
  double forMemberFloat64(double arg) {
  double ret = 0.0;
  //var darray = new List<double>();
  for (int i=0; i<1000; i++) {
    // checked
    carray[i] = i.toDouble();
  }
  for (int i=0; i<1000; i++) {
    // checked
    ret += carray[i];
  }
  return ret;
  }
}

