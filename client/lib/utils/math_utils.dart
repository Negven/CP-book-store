import 'package:flutter/physics.dart';

class MathUtils {

  static const double epsilon = 0.0000001;

  static num roundByDivider(num value, num divider) {
    return (value * divider).round() / divider;
  }

  static bool isZero(double value) {
    return nearZero(value, epsilon);
  }

  static double? multiply(double? a, double? b) {
    if (a == null || b == null) return null;
    return a * b;
  }

  static double divideOrZero(double? a, double? b) {
    if  (a == null || b == null || b == 0.0) return 0.0;
    return a / b;
  }


}
