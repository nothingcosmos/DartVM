
typedef int func(int a, int b);

Map<String, func> a;

int intFuncIntInt(int a, int b) {}
void FuncIntInt(int a, int b) {}
FuncDoubleDouble(double a, double b) {}
FuncIntDouble(int a, double b) {}
FuncInt(int a) {}
FuncIntIntInt(int a, int b, int c) {}

main() {
  print("start");
  a["test"] = intFuncIntInt;
  a["test2"] = FuncIntInt;
  a["test3"] = FuncDoubleDouble; //warning
  a["test4"] = FuncInt; //warning
  a["test5"] = FuncIntDouble; //warning
  a["test6"] = FuncIntIntInt; //warning
}