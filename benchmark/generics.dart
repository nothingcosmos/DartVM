class classnogenerics {
  var init;
  classnogenerics(var x) {
    this.init = x;
  }
  getsq() {
    return init * init;
  }
}


class classtest<T> {
  T init;

  classtest(T x) {
    this.init = x;
  }

  varRec(var n) {
    var ret;
    if (n > 1) {
      ret = n * varRec(n - 1);
    } else {
      ret = 1;
    }
    return ret;
  }

  int intRec(int n) {
    int ret;
    if (n > 1) {
      ret = n * intRec(n - 1);
    } else {
      ret = 1;
    }
    return ret;
  }

  T TRec(T n) {
    T ret;
    if (n > 1) {
      ret = n * TRec(n - 1);
    } else {
      ret = 1;
    }
    return ret;
  }

  T TinitRec(T n) {
    T ret;
    if (n > init) {
      ret = n * TinitRec(n - init);
    } else {
      ret = init;
    }
    return ret;
  }
  T TintRec(T n) {
    T ret;
    if (n > init) {
      ret = n * TintRec(n - init);
    } else {
      ret = init;
    }
    return ret;
  }
}

doubleIf(double n) {
  double ret;
  if (n > 1) {
    ret = n * doubleIf(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}


intIf(int n) {
  int ret;
  if (n > 1) {
    ret = n * intIf(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}

intFor(int n) {
  int ret=1;
  for (int i=1; i<=n; i++) {
    ret *= i;
  }
  return ret;
}

varIf(var n) {
  var ret;
  if (n > 1) {
    ret = n * varIf(n - 1);
  } else {
    ret = 1;
  }
  return ret;
}

varFor(var n) {
  var ret=1;
  for (var i=1; i<=n; i++) {
    ret *= i;
  }
  return ret;
}

main() {
  print("start");
  for (int i=0; i<10000; i++) {
    var t = new classtest(1);
    var t2 = new classnogenerics(100);
    var testint = new classtest<int>(1);
    var testdouble = new classtest<double>(1.0);

    var ret0 = t2.getsq();
    print("0:$ret0");

    var ret1 = varIf(i%10);
    print("1:$ret1");

    var ret2 = varFor(i%10);
    print("2:$ret2");

    int ret3 = intIf(i%10);
    print("3:$ret3");

    int ret4 = intFor(i%10);
    print("4:$ret4");

    var ret5 = t.varRec(i%10);
    print("5:$ret5");

    int ret6 = t.intRec(i%10);
    print("6:$ret6");

    int ret7 = doubleIf(i.toDouble()%10.0);
    print("7:$ret7");

    var ret8 = testint.TRec(i%10);
    print("8:$ret8");

    var ret9 = testdouble.TRec(i.toDouble()%10.0);
    print("9:$ret9");

    var ret10 = testint.TinitRec(i%10);
    print("10:$ret10");

    var ret11 = testdouble.TinitRec(i.toDouble()%10.0);
    print("11:$ret11");

    var ret12 = testint.TintRec(i%10);
    print("12:$ret12");
  }
  print("end");
}
