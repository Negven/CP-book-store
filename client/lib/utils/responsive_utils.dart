import 'dart:math';

import 'package:client/utils/font_utils.dart';
import 'package:client/utils/formatting_utils.dart';
import 'package:logging/logging.dart';

// _now - константа, що використовується для позначення поточної ширини екрану.
const double _now = -1;

// ScreenWidth - перерахування, що визначає ширину екрану для різних категорій.
enum ScreenWidth {
  now(_now),
  xs(320),
  sm(640),
  md(768),
  lg(1024),
  xl(1280),
  xxl(1536);

  final double _size; // розмір
  const ScreenWidth(this._size);

  // size - метод для отримання реального розміру ширини екрану.
  double get size => _size == _now ? ResponsiveUtils.screenWidth : _size;

  // оператори порівняння для ScreenWidth.
  bool operator <(ScreenWidth other) {
    return size < other.size;
  }

  bool operator >(ScreenWidth other) {
    return size > other.size;
  }

  bool operator >=(ScreenWidth other) {
    return size >= other.size;
  }

  bool operator <=(ScreenWidth other) {
    return size <= other.size;
  }

  // isSmOrLess - статичний метод для перевірки, чи ширина екрану є xs або менше.
  static bool get isSmOrLess => ScreenWidth.now <= ScreenWidth.sm;

  // isMdOrWider - статичний метод для перевірки, чи ширина екрану є md або більше.
  static bool get isMdOrWider => ScreenWidth.now >= ScreenWidth.md;
}

// ScreenAspect - клас, що містить методи для роботи з аспектом екрану.
abstract class ScreenAspect {
  // isHorizontal - метод для перевірки, чи екран горизонтальний.
  static bool get isHorizontal => ResponsiveUtils.screenWidth / ResponsiveUtils.screenHeight >= (4.0 / 3.0);

  // isVertical - метод для перевірки, чи екран вертикальний.
  static bool get isVertical => !isHorizontal;

  // prettifyAspect - метод для форматування аспекту екрану в зручний для відображення вигляд.
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

  // _aspectMod - приватний метод для форматування аспекту екрану з використанням модуля.
  static String _aspectMod(int w, int h) {
    for (int i in [2, 3, 5, 7]) {
      if (w % i == 0 && h % i == 0) {
        return _aspectMod((w ~/ i), (h ~/ i));
      }
    }
    return "$w ÷ $h";
  }
}

// _ResponsiveValue - клас для представлення значення, що залежить від ширини екрану.
class _ResponsiveValue<T> {
  late T from;
  late T xs;
  late T sm;
  late T md;
  late T lg;
  late T xl;
  late T xxl;

  // Конструктор класу _ResponsiveValue.
  _ResponsiveValue({required this.from, xs, sm, md, lg, xl, xxl}) {
    this.xs = xs ?? from;
    this.sm = sm ?? this.xs;
    this.md = md ?? this.sm;
    this.lg = lg ?? this.md;
    this.xl = xl ?? this.lg;
    this.xxl = xxl ?? this.xl;
  }

  // _value - метод для отримання значення відповідно до розміру екрану.
  T get _value {
    if (ScreenWidth.now < ScreenWidth.xs) return from;
    if (ScreenWidth.now < ScreenWidth.sm) return xs;
    if (ScreenWidth.now < ScreenWidth.md) return sm;
    if (ScreenWidth.now < ScreenWidth.lg) return md;
    if (ScreenWidth.now < ScreenWidth.xl) return lg;
    if (ScreenWidth.now < ScreenWidth.xxl) return xl;
    return xxl;
  }

  // _d - метод для отримання значення як double.
  double get _d {
    return (_value as num).toDouble();
  }

  // _dR - метод для отримання округленого значення як double.
  double get _dR {
    return (_value as num).roundToDouble();
  }
}

// ResponsiveUtils - клас для роботи з відгуком екрану.
class ResponsiveUtils {
  static final _logger = Logger((ResponsiveUtils).toString());

  // recalculate - метод для перерахунку розмірів ширини і висоти екрану.
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
    _rem = responsiveSize.roundToDouble();
    _factor = _rem / FontUtils.fBase;

    _screenW = _screenWidth / 100.0;
    _screenH = _screenHeight / 100.0;

    _logger.info("1 REM: $_rem SIZE [ ${FormattingUtils.formatF2(width)} x ${FormattingUtils.formatF2(height)}, ${ScreenAspect.prettifyAspect(width / height)} ]");

    return true;
  }

  // factor - метод для отримання фактора розміру шрифту.
  static double get factor => _factor;

  static var _screenWidth = 0.0;
  static var _screenHeight = 0.0;
  static var _factor = 0.0;

  static var _rem = 0.0;
  static var _screenW = 0.0;
  static var _screenH = 0.0;

  // screenWidth - метод для отримання ширини екрану.
  static double get screenWidth => _screenWidth;

  // screenHeight - метод для отримання висоти екрану.
  static double get screenHeight => _screenHeight;

  // vw - метод для розрахунку відносної ширини екрану.
  static double vw(num input) => input * _screenW;

  // vh - метод для розрахунку відносної висоти екрану.
  static double vh(num input) => input * _screenH;

  // vMax - метод для розрахунку максимального розміру відносно до екрану.
  static double vMax(num input) {
    double vH = vh(input);
    double vW = vw(input);
    return max(vH, vW);
  }

  // vMin - метод для розрахунку мінімального розміру відносно до екрану.
  static double vMin(num input) {
    double vH = vh(input);
    double vW = vw(input);
    return min(vH, vW);
  }

  // rem - метод для розрахунку розміру відносно до екрану у величині 1 rem.
  static double rem(num input) => input * _rem;
}

// ResponsiveObjectExtension - розширення класу для розрахунку відповідного значення відносно розміру екрану.
extension ResponsiveObjectExtension<T> on T {
  T r({xs, sm, md, lg, xl, xxl}) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._value;
  }
}

// ResponsiveExtension - розширення класу для розрахунку значення відповідно до відгуку екрану.
extension ResponsiveExtension on num {
  // responsive - метод для розрахунку відповідного значення відносно розміру екрану.
  double r({xs, sm, md, lg, xl, xxl}) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._d;
  }

  // responsive Round - метод для розрахунку округленого значення відповідно до розміру екрану.
  double rR({xs, sm, md, lg, xl, xxl}) {
    return _ResponsiveValue(from: this, xs: xs, sm: sm, md: md, lg: lg, xl: xl, xxl: xxl)._dR;
  }

  // vh - метод для розрахунку відносної висоти екрану.
  double get vh => ResponsiveUtils.vh(this);

  // vw - метод для розрахунку відносної ширини екрану.
  double get vw => ResponsiveUtils.vw(this);

  // vMax - метод для розрахунку максимального розміру відносно до екрану.
  double get vMax => ResponsiveUtils.vMax(this);

  // vMin - метод для розрахунку мінімального розміру відносно до екрану.
  double get vMin => ResponsiveUtils.vMin(this);

  // rem - метод для розрахунку розміру відносно до екрану у величині 1 rem.
  double get rem => ResponsiveUtils.rem(this);

  // vhR - метод для розрахунку округленої відносної висоти екрану.
  double get vhR => ResponsiveUtils.vh(this).roundToDouble();

  // vwR - метод для розрахунку округленої відносної ширини екрану.
  double get vwR => ResponsiveUtils.vw(this).roundToDouble();

  // vMaxR - метод для розрахунку округленого максимального розміру відносно до екрану.
  double get vMaxR => ResponsiveUtils.vMax(this).roundToDouble();

  // vMinR - метод для розрахунку округленого мінімального розміру відносно до екрану.
  double get vMinR => ResponsiveUtils.vMin(this).roundToDouble();

  // remR - метод для розрахунку округленого розміру відносно до екрану у величині 1 rem.
  double get remR => ResponsiveUtils.rem(this).roundToDouble();
}
