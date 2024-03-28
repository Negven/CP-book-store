import 'dart:math';

import 'package:client/utils/font_utils.dart';
import 'package:client/utils/formatting_utils.dart';
import 'package:logging/logging.dart';


const double _now = -1;

enum ScreenWidth {

  now(_now),
  xs(320),
  sm(640),
  md(768),
  lg(1024),
  xl(1280),
  xxl(1536);

  final double _size; // from size
  const ScreenWidth(this._size);

  double get size => _size == _now ? ResponsiveUtils.screenWidth : _size;

  bool operator < (ScreenWidth other) {
    return size < other.size;
  }

  bool operator > (ScreenWidth other) {
    return size > other.size;
  }

  bool operator >= (ScreenWidth other) {
    return size >= other.size;
  }

  bool operator <= (ScreenWidth other) {
    return size <= other.size;
  }

  static bool get isSmOrLess => ScreenWidth.now <= ScreenWidth.sm;
  static bool get isMdOrWider => ScreenWidth.now >= ScreenWidth.md;

}

abstract class ScreenAspect {

    static bool get isHorizontal => ResponsiveUtils.screenWidth / ResponsiveUtils.screenHeight >= (4.0 / 3.0);
    static bool get isVertical => !isHorizontal;

    static String prettifyAspect(double aspect) {

      var delta = 100.0;
      String result = "? ÷ ?";

      for (int w = 1; w <= 6; w++) {

        for (int h = 6; h >= 1; h--) {
          final double a = w.toDouble() / h;
          final nextDelta = (a - aspect).abs();
          if (nextDelta < delta) {
            result = _aspectMod(w, h);
            delta = nextDelta;
          }

        }

      }

      return result;
    }

    static String _aspectMod(int w, int h) {

      for (int i in [2, 3, 5, 7]) {
        if (w % i == 0 && h % i == 0) {
          return _aspectMod((w / i) as int, (h / i) as int);
        }
      }

      return "$w ÷ $h";
    }
}


class _ResponsiveValue<T> {

  late T from;
  late T xs;
  late T sm;
  late T md;
  late T lg;
  late T xl;
  late T xxl;

  _ResponsiveValue({ required this.from, xs, sm, md, lg, xl, xxl }) {
    this.xs = xs ?? from;
    this.sm = sm ?? this.xs;
    this.md = md ?? this.sm;
    this.lg = lg ?? this.md;
    this.xl = xl ?? this.lg;
    this.xxl = xxl ?? this.xl;
  }

  T get _value {
    if (ScreenWidth.now < ScreenWidth.xs) return from;
    if (ScreenWidth.now < ScreenWidth.sm) return xs;
    if (ScreenWidth.now < ScreenWidth.md) return sm;
    if (ScreenWidth.now < ScreenWidth.lg) return md;
    if (ScreenWidth.now < ScreenWidth.xl) return lg;
    if (ScreenWidth.now < ScreenWidth.xxl) return xl;
    return xxl;
  }

  double get _d {
    return (_value as num).toDouble();
  }

  double get _dR {
    return (_value as num).roundToDouble();
  }


}


class ResponsiveUtils {

  static final _logger = Logger((ResponsiveUtils).toString());

  static bool recalculate(double width, double height) {

    if (width == double.infinity || height == double.infinity) {
      throw "Invalid BoxConstraints($width, $height)";
    }

    if (_screenWidth == width && _screenHeight == height && _factor > 0.0) {
      return false;
    } else {
      _screenWidth = width;
      _screenHeight = height;
    }

    double responsiveSize = 12.0 + 0.005 * (ScreenWidth.now < ScreenWidth.sm ? height : min(width, height));
    _rem = responsiveSize.roundToDouble(); // making changes by only ints (to make it pixel perfect)
    _factor = _rem / FontUtils.fBase;

    _screenW = _screenWidth / 100.0;
    _screenH = _screenHeight / 100.0;

    _logger.info("1 REM: $_rem SIZE [ ${FormattingUtils.formatF2(width)} x ${FormattingUtils.formatF2(height)}, ${ ScreenAspect.prettifyAspect(width / height) } ]");

    return true;
  }

  static double get factor => _factor;

  static var _screenWidth = 0.0;
  static var _screenHeight = 0.0;
  static var _factor = 0.0;

  static var _rem = 0.0;
  static var _screenW = 0.0;
  static var _screenH = 0.0;

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  static double vw(num input) => input * _screenW;
  static double vh(num input) => input * _screenH;

  static double vMax(num input) {
    double vH = vh(input);
    double vW = vw(input);
    return max(vH, vW);
  }

  static double vMin(num input) {
    double vH = vh(input);
    double vW = vw(input);
    return min(vH, vW);
  }

  static double rem(num input) => input * _rem;

}

extension ResponsiveObjectExtension<T> on T {
  T r({ xs, sm, md, lg, xl, xxl }) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._value;
  }
}

extension ResponsiveExtension on num {

  // responsive
  double r({ xs, sm, md, lg, xl, xxl }) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._d;
  }

  // responsive Round
  double rR({ xs, sm, md, lg, xl, xxl }) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._dR;
  }

  double get vh => ResponsiveUtils.vh(this);
  double get vw => ResponsiveUtils.vw(this);

  double get vMax => ResponsiveUtils.vMax(this);
  double get vMin => ResponsiveUtils.vMin(this);

  double get rem => ResponsiveUtils.rem(this);

  // Preferable for values >= 3 "px"
  double get vhR => ResponsiveUtils.vh(this).roundToDouble();
  double get vwR => ResponsiveUtils.vw(this).roundToDouble();

  double get vMaxR => ResponsiveUtils.vMax(this).roundToDouble();
  double get vMinR => ResponsiveUtils.vMin(this).roundToDouble();

  double get remR => ResponsiveUtils.rem(this).roundToDouble();

}
