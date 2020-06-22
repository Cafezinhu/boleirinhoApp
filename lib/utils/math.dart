import 'dart:math';

class MathUtils{
  static String doubleToString(double value, int precision){
    int dezElevado = pow(10, precision);
    return ((value * dezElevado).ceilToDouble()/dezElevado).toStringAsFixed(precision);
  }

  static double doubleRoundPrecision(double value, int precision){
    return double.tryParse(doubleToString(value, precision));
  }
}