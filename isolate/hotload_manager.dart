import 'dart:isolate';
import 'dart:async';
import 'dart:io';

SendPort load(String dir, String filename, [int num=0]) {
  print("${new DateTime.now()}:load $dir/${num}${filename}");
  var subport = spawnUri("$dir/${num}$filename");
  return subport;
}

int fibo(int n) {
  if (n < 2) {
    return n;
  } else {
    return fibo(n-1) + fibo(n-2);
  }
}

//port.close()する必要ない。
//loadは並行して実行されるのに、並行にログが出力されない。
bench() {
  SendPort p;
  for (int i = 0; i<1000; i++) {
    if (i % 100 == 0) {
      p = load("hotload", "hotloaded_node.dart", i~/100);
    }
    p.send("${new DateTime.now()}:send msg ${i}");
  }
}

//sleepを挿入すれば、message詰りがなく、理想的な状態でisolateを切り替え
//isolateをshutdownしないので、常時10個 isolateが走る。
benchWithSleep() {
  SendPort p;
  for (int i = 0; i<1000; i++) {
    if (i % 100 == 0) {
      if (p != null) {
        fibo(41);
      }
      p = load("hotload", "hotloaded_node.dart", i~/100);
    }
    p.send("${new DateTime.now()}:send msg ${i}");
  }
}

//こっちはisolateをshutdownで閉じているので、綺麗にリソースを開放する。
benchWithShutdown() {
  SendPort p;
  for (int i = 0; i<1000; i++) {
    if (i % 100 == 0) {
      if (p != null) {
        print("send shutdown");
        p.send("shutdown");
      }
      p = load("hotload", "hotloaded_node.dart", i~/100);
    }
    p.send("${new DateTime.now()}:send msg ${i}");
  }
  if (p != null) {
    p.send("shutdown");
  }
}

main() {
//  benchWithSleep();
//  bench();
  benchWithShutdown();
  fibo(45);
  print("stop main");
}


