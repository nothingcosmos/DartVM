import 'dart:isolate';
import 'dart:async';
import 'dart:io';

fibo(var n) {
  if (n<2) {
    return n;
  } else {
    return fibo(n-1) + fibo(n-2);
  }
}

startFibo() {
  print("init startFibo()");
  File log = new File("fibo.out");
  OutputStream out = log.openOutputStream(FileMode.APPEND);

  port.receive((msg, replyTo) {
    var arg = int.parse(msg);
    print("receive $arg");
    print("fibo $arg = ${fibo(arg)}");
    out.writeString("fibo $arg = ${fibo(arg)}\n");
  });
  print("finish startFibo()");
}

bench() {
  var port = spawnFunction(startFibo);
  fibo(41);
  for (var i in [0,1,2,3,4,5,6,7]) {
    var t = time(() => port.send("40"));
    print("time = ${t} ms");
  }
  fibo(41);
  fibo(41);
  fibo(41);
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

//return micro seconds
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
  print("time bench = ${time(() => bench())}");
  print("### ${new Options().script} end   ###");
}
