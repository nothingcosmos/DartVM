doubleCInt(double n) {
  double ret;
  if (n > 1) {
    ret = n * doubleCInt(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}


intCInt(int n) {
  int ret;
  if (n > 1) {
    ret = n * intCInt(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}

varCInt(var n) {
  var ret;
  if (n > 1) {
    ret = n * varCInt(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}

varCDouble(var n) {
  var ret;
  if (n > 1.0) {
    ret = n * varCInt(n - 1.0);
  } else {
    ret = 1.0;
  }
  return ret;
}

main() {
  List result = new List();
  for (int i=0; i<10; i++) {
    result.add(0);
  }
  print("###start");

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = intCInt(i%10); } };
    print ("intCInt = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = intCInt(i%10); } };
    print ("intCInt = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = doubleCInt(i%10.0); } };
    print ("doubleCInt = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = doubleCInt(i%10.0); } };
    print ("doubleCInt = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }


  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10); } };
    print ("varCInt(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10); } };
    print ("varCInt(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10.0); } };
    print ("varCInt(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10.0); } };
    print ("varCInt(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
/*
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10.0); } };
    print ("varCInt(double) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
*/

  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10); } };
    print ("varCInt(int) = ${gettime(ret)}ms");
    print("ret = ${result[9]}");
  }
  {
    var ret = () { for (int i=0; i<1000000; i++) { result[i%10] = varCInt(i%10); } };
    print ("varCInt(int) = ${gettime(ret)}ms");
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

