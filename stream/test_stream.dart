import "dart:typed_data";
import "dart:async";
import "dart:io";
import "dart:isolate";

////pipe
test_pipe_pipe(List input) {
  int i = 0;
  StreamController<List<int>> encorder = new StreamController<List<int>>();
  encorder.stream.listen((obj) {
    if (input[i] == obj) {
      print("pipe2enc:${input[i]}, $obj");
    }
    i++;
  });

  int k = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.listen((obj) {
    if (input[k] == obj) {
      print("pipe2dec:${input[k]}, $obj");
    }
    k++;
  });

  Stream inputStream = new Stream.fromIterable(input);
  inputStream.pipe(encorder);
  //pipeの引数はconsumerなので、さらにpipeでstreamを繋げるのは無理。
  //transformで変換するか、broadcastで分岐させる。
  //もしくはconsumerを設定しているlistenを削除する。
  //encorder.stream.pipe(decorder);
}

test_broadcast(List input) {
  var bd = new Stream.fromIterable(input).asBroadcastStream();
  bd.listen((e) => print("bd1:$e"));
  bd.listen((e) => print("bd2:$e"));
}

test_pipe(List input) {
  int i = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.listen((obj) {
    if (input[i] == obj) {
      print("pipe:${input[i]}, $obj");
    }
    i++;
  });

  Stream inputStream = new Stream.fromIterable(input);
  inputStream.pipe(decorder);
}

test_iterable_to_sink(List input) {
  int i = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.listen((obj) {
    if (input[i] == obj) {
      print("itos:${input[i]}, $obj");
    }
    i++;
  });

  Stream inputStream = new Stream.fromIterable(input);
  inputStream.listen((e) {
    decorder.add(e);
  });
}

test_sink_to_sink(List input) {
  int i = 0;
  StreamController<List<int>> decorder = new StreamController<List<int>>();
  decorder.stream.listen((obj) {
    if (input[i] == obj) {
      print("stos:${input[i]}, $obj");
    }
    i++;
  });

  StreamController encoder = new StreamController();
  encoder.stream.listen((obj) {
    decorder.add(obj);
  });
  input.forEach((e) {
    encoder.add(e);
  });
}

main() {
  List input = new List.generate(100, (e) => e);
  List input_string = new List.generate(100, (e) => "test$e");
  test_iterable_to_sink(input);
  test_sink_to_sink(input);
  test_iterable_to_sink(input_string);
  test_sink_to_sink(input_string);
  test_pipe(input);
  test_broadcast(input);
  test_pipe_pipe(input);

  //port.receive((msg, reply) => print(msg));
}