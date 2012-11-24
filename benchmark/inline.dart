class B extends bench { int get() { return 1; } }
class C extends bench { int get() { return 2; } }

abstract class bench {
  int get();
  static final int LEN=100000;
  int test( ) {
    int sum=0;
    for( int i=0; i<LEN; i++ )
      sum += get();
    return sum;
  }
}

testInline() {
  bench f = new B();
  int sum = 0;
  for (int i=0; i<10000; i++) {
    sum += f.test();
  }
  print("ret = $sum");
}

main() {
  print("start");
  var stime = new Date.now();
  testInline();
  var etime = new Date.now();
  var  elapsedTime = etime.difference(stime).inMilliseconds;
  print("elapsed time = $elapsedTime ms");
  print("end");
}
