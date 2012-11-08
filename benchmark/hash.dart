
main() {
  print("### start ###");
  final int MAX = 100000;
  printtime("initList", () => initList(MAX));
//  printtime("initList",() => initList(MAX));
//  printtime("init1 hash", () => init1(hash1, MAX));
  printtime("init2 hash", () => init2(hash2, MAX));
//  printtime("init3 hash", () => init3(hash3, MAX));
  print("length1 = ${hash1.length}");
  print("length2 = ${hash2.length}");
  print("length3 = ${hash3.length}");
  for (var i = 0; i<4; i++) {
    printtime("search hash", () => search(hash2, MAX, "test"));
    printtime("search2 hash", () => search2(hash2, MAX, "test"));
    printtime("itereate hash", () => iterate(hash2, MAX, "test"));
    printtime("forEach hash", () => forEach(hash2, MAX, "test"));
  }
  print("### end   ###");
  return ;
}
printtime(var name, var func) {
  print("$name, time = ${gettime(() => func())} ms");
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

var hash1 = new HashMap<String, String>();
var hash2 = new HashMap<String, String>();
var hash3 = new HashMap<String, String>();
var values = new List<String>();
var keys = new List<String>();
var sdata = "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";

String key(int i) {
  return "keys = ${i}";
}
void initList(int N) {
  for (int i=0; i<N; i++) {
    keys.add(key(i));
    values.add("values = ${sdata}${i}");
  }
}

void init1(var hash, int N) {
  for (int i=0; i<N; i++) {
    var key = keys[i];
    var value = values[i];
    hash[key] = value;
  }
}

void init2(var hash, int N) {
  for (int i=0; i<N; i++) {
    values.add("values = ${sdata}${i}");
    hash[key(i)] = "values = ${sdata}${i}";
  }
}

void init3(var hash, int N) {
  for (int i=0; i<N; i++) {
    values.add("values = ${sdata}${i}");
    hash[key(i)] = "hash[${i}] = ${sdata}...${i}";
  }
}

void search(var hash, int N, String s) {
  for (int i=0; i<N; i++) {
    var ret = hash[keys[i]];
//    if (ret == s) {
//      print("get $ret");
//    }
  }
}

void search2(var hash, int N, String s) {
  for (int i=0; i<N; i++) {
    var ret = hash[key(i)];
//    if (ret == s) {
//      print("get $ret");
//    }
  }
}

void iterate(var hash, int N, String test) {
  for (String s in hash.values) {
    if (test == s) {
      break;
    }
  }
}

void forEach(var hash, int N, String test) {
  var func = (var key, var value) {
    if (test == value) {
      return;
    }
  };
//  var func2 = (var key, var value) => null;
  hash.forEach(func);
}


