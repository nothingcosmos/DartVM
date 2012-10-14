
main() {
  print("### start ###");
  //var call1 = () { hot(calc1, 10000); };
  //var call1 = () => hot(calcDiv, 10000);
  //var ret1 = gettime( () => hot(calcSimpleDiv, 10000));
  int hh = 256;
  int ww = 256;
  int nn = 2;
  var wrap = wkernel(double d) {
    return kernel(ww, hh, nn, d);
  };
  for (var i = 0; i<4; i++) {
    print("kernel elapsed time = ${gettime(() => hot((double d) => kernel(ww, hh, nn, d), 100))} ms");
    print("kerneld elapsed time = ${gettime(() => hot((double d) => kerneld(ww, hh, nn, d), 100))} ms");
    print("kernelid elapsed time = ${gettime(() => hot((double d) => kernelid(ww, hh, nn, d), 100))} ms");
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

double kernel(int w, int h, int n, double ret) {
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int v=0; v<n; v++) {
        for (int u=0; u<n; u++) {
          double px = (x + (u / n) - (w / 2.0)) / (w / 2.0);
          double py = (y + (v / n) - (h / 2.0)) / (h / 2.0);
          py = -py;
          ret = ret + px + py;
        }
      }
    }
  }
  return ret;
}

double kerneld(int w, int h, int n, double ret) {
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int v=0; v<n; v++) {
        for (int u=0; u<n; u++) {
          double px = (x.toDouble() + (u.toDouble() / n.toDouble()) - (w.toDouble() / 2.0)) / (w.toDouble() / 2.0);
          double py = (y.toDouble() + (v.toDouble() / n.toDouble()) - (h.toDouble() / 2.0)) / (h.toDouble() / 2.0);
          py = -py;
          ret = ret + px + py;
        }
      }
    }
  }
  return ret;
}

double kernelid(int w, int h, int n, double ret) {
  double wd = w.toDouble();
  double hd = h.toDouble();
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int v = 0; v < n; v++) {
        for (int u = 0; u < n; u++) {
          double px = (x + (u / n) - (wd / 2.0)) / (wd / 2.0);
          double py = (y + (v / n) - (hd / 2.0)) / (hd / 2.0);
          py = -py;
          ret = ret + px + py;
        }
      }
    }
  }
  return ret;
}

