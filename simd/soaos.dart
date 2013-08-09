import "dart:typed_data";

const int testSize = 10000000;
init(List list, int n, var init) {
  for (int i=0; i<n; i++) {
    list[i] = init;
  }
  return list;
}
typedef callFloat64List(Float64List x, Float64List y, int n);
saxpyFloat64List(Float64List x, Float64List y, double a, int n) {
  for (int i=0; i<n; i++) {
    y[i] = a * x[i] + y[i];
  }
}

mulFloat64List(Float64List x, Float64List y, int n) {
  for (int i=0; i<n; i++) {
    x[i] = x[i] * y[i];
  }
}

addFloat64List(Float64List x, Float64List y, int n) {
  for (int i=0; i<n; i++) {
    x[i] = x[i] + y[i];
  }
}

typedef callVecFloat64List(Float64List a, Float64List b, Float64List c, Float64List x, Float64List y, Float64List z, int n);
vecSaxpyFloat64List(Float64List a, Float64List b, Float64List c, Float64List x, Float64List y, Float64List z, double base, int n) {
  for (int i=0; i<n; i++) {
    a[i] = base * x[i] + a[i];
    b[i] = base * y[i] + b[i];
    c[i] = base * z[i] + c[i];
  }
}

vecAddFloat64List(Float64List a, Float64List b, Float64List c, Float64List x, Float64List y, Float64List z, int n) {
  for (int i=0; i<n; i++) {
    a[i] += x[i];
    b[i] += y[i];
    c[i] += z[i];
  }
}

vecMulFloat64List(Float64List a, Float64List b, Float64List c, Float64List x, Float64List y, Float64List z, int n) {
  for (int i=0; i<n; i++) {
    a[i] *= x[i];
    b[i] *= y[i];
    c[i] *= z[i];
  }
}

saxpyFloat32x4(Float32x4List x, Float32x4List y, double a, int n) {
  Float32x4 base = new Float32x4(a,a,a,a);
  for (int i=0; i<n; i++) {
    y[i] = base * x[i] + y[i];
  }
}

addFloat32x4(Float32x4List a, Float32x4List x, int n) {
  for (int i=0; i<n; i++) {
    a[i] = a[i] + x[i];
  }
}

mulFloat32x4(Float32x4List a, Float32x4List x, int n) {
  for (int i=0; i<n; i++) {
    a[i] = a[i] * x[i];
  }
}

benchFloat64List(String msg, callFloat64List callback) {
  Float64List x = new Float64List(testSize);
  Float64List y = new Float64List(testSize);
  Float64List z = new Float64List(testSize);

  init(x, testSize, 2.0);
  init(y, testSize, 3.0);
  init(z, testSize, 5.0);
  print("$msg = ${time(() => callback(x, y, testSize))} ms");
}

benchVecFloat64List(String msg, callVecFloat64List callback) {
  Float64List x = new Float64List(testSize);
  Float64List y = new Float64List(testSize);
  Float64List z = new Float64List(testSize);
  Float64List a = new Float64List(testSize);
  Float64List b = new Float64List(testSize);
  Float64List c = new Float64List(testSize);

  init(x, testSize, 2.0);
  init(y, testSize, 3.0);
  init(z, testSize, 5.0);
  init(a, testSize, 3.0);
  init(b, testSize, 4.0);
  init(c, testSize, 5.0);
  print("$msg = ${time(() => callback(a,b,c,x,y,z,testSize))} ms");
}

bench1() {
  Float64List x = new Float64List(testSize);
  Float64List y = new Float64List(testSize);
  Float64List z = new Float64List(testSize);

  init(x, testSize, 2.0);
  init(y, testSize, 3.0);
  init(z, testSize, 5.0);
  print("elapsed time saxpy f64 = ${time(() => saxpyFloat64List(x, y, 3.0, testSize))} ms");
}

bench2() {
  Float64List x = new Float64List(testSize);
  Float64List y = new Float64List(testSize);
  Float64List z = new Float64List(testSize);

  init(x, testSize, 2.0);
  init(y, testSize, 3.0);
  init(z, testSize, 5.0);
  print("elapsed time mul f64 = ${time(() => mulFloat64List(x, y, testSize))} ms");
}

bench3() {
  Float64List x = new Float64List(testSize);
  Float64List y = new Float64List(testSize);
  Float64List z = new Float64List(testSize);
  Float64List a = new Float64List(testSize);
  Float64List b = new Float64List(testSize);
  Float64List c = new Float64List(testSize);

  init(x, testSize, 2.0);
  init(y, testSize, 3.0);
  init(z, testSize, 5.0);
  init(a, testSize, 3.0);
  init(b, testSize, 4.0);
  init(c, testSize, 5.0);
  print("elapsed time d3 add f64 = ${time(() => vecAddFloat64List(a,b,c,x, y, z, testSize))} ms");
}

typedef callFloat32x4List(Float32x4List a, Float32x4List b, int n);

benchF32(String msg, callFloat32x4List callback) {
  Float32x4List a = new Float32x4List(testSize);
  Float32x4List x = new Float32x4List(testSize);
  init(a, testSize, new Float32x4(1.0, 2.0, 3.0, 4.0));
  init(x, testSize, new Float32x4(5.0, 6.0, 7.0, 8.0));
  print("elapsed time f4 saxpy = ${time(() => callback(a, x, testSize))} ms");
}

time(callback()) {
  var sw = new Stopwatch()..start();
  callback();
  sw.stop();
  return sw.elapsedMilliseconds;
}

main() {
  benchFloat64List("elapsed time saxpy f64", (x,y,n) => saxpyFloat64List(x, y, 3.0, n));
  benchFloat64List("elapsed time saxpy f64", (x,y,n) => saxpyFloat64List(x, y, 3.0, n));
  benchFloat64List("elapsed time add f64", addFloat64List);
  benchFloat64List("elapsed time add f64", addFloat64List);
  benchFloat64List("elapsed time mul f64", mulFloat64List);
  benchFloat64List("elapsed time mul f64", mulFloat64List);

  benchVecFloat64List("elapsed time saxpy VecF64", (a,b,c,x,y,z,n) => vecSaxpyFloat64List(a, b, c, x, y, z, 3.0, n));
  benchVecFloat64List("elapsed time saxpy VecF64", (a,b,c,x,y,z,n) => vecSaxpyFloat64List(a, b, c, x, y, z, 3.0, n));
  benchVecFloat64List("elapsed time add VecF64", vecAddFloat64List);
  benchVecFloat64List("elapsed time add VecF64", vecAddFloat64List);
  benchVecFloat64List("elapsed time mul VecF64", vecMulFloat64List);
  benchVecFloat64List("elapsed time mul VecF64", vecMulFloat64List);

  benchF32("elapsed time f4 saxpy", (a, b, n) => saxpyFloat32x4(a, b, 3.0, n));
  benchF32("elapsed time f4 saxpy", (a, b, n) => saxpyFloat32x4(a, b, 3.0, n));
  benchF32("elapsed time f4 add", addFloat32x4);
  benchF32("elapsed time f4 add", addFloat32x4);
  benchF32("elapsed time f4 mul", mulFloat32x4);
  benchF32("elapsed time f4 mul", mulFloat32x4);
}