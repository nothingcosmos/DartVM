import 'dart:isolate';
import 'dart:async';
import 'dart:io';


func() {
  try {
    var obj = new List<String>();
    obj.throwException();

  } catch (NoSuchMethodError) {
    print(NoSuchMethodError);
  }
  try {
    port.receive((num, replyPort) {
      print("server$replyPort: last state result = $num");
      throw new ArgumentError(num); //効果なし
    });

  } on ArgumentError catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
}

main() {
  print("start0");
  func();
  print("finish");
}