import 'dart:isolate';
import 'dart:async';

fibo(var n) {
  if (n<2) {
    return n;
  } else {
    return fibo(n-1) + fibo(n-2);
  }
}

bench() {
  for (var i in [0,1,2]) {
    print("loop $i");
    var t = microtime(() => fromSync(()=>fibo(40)).then((r) => print(r)));
    print("overhead = ${t} micros");
  }
  return ;
}

Future<int> fromSync(sync()) {
  var completer = new Completer();
  new Timer(0, (timer) => completer.complete(sync()));
  return completer.future;
}

Future<int> atime(synccall()) {
  var completer = new Completer();
  var sw = new Stopwatch()..start();
  synccall();
  sw.stop();
  completer.complete(sw.elapsedMilliseconds);
  return completer.future;
}

//return milliseconds
microtime(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMicroseconds;
}

//return milliseconds
time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}

hot(func(double), int N) {
  double ret = 2.0;
  for (int i=0; i<N; i++) {
    ret += func(ret);
  }
  print("ret = $ret");
}

testfunc(double d) {
  return d * d;
}
main() {
  print("### ${new Options().script} start ###");
  bench();
  print("### ${new Options().script} end   ###");
}
