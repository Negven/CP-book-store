
import 'dart:collection';
import 'dart:math';

import 'package:client/utils/math_utils.dart';
import 'package:flutter/widgets.dart';

class _ColorsAndStops {
  _ColorsAndStops(this.colors, this.stops);
  final List<Color> colors;
  final List<double> stops;
}

Color _sample(List<Color> colors, List<double> stops, double t) {
  assert(colors.isNotEmpty);
  assert(stops.isNotEmpty);
  if (t <= stops.first) {
    return colors.first;
  }
  if (t >= stops.last) {
    return colors.last;
  }
  final int index = stops.lastIndexWhere((double s) => s <= t);
  assert(index != -1);
  return Color.lerp(
    colors[index], colors[index + 1],
    (t - stops[index]) / (stops[index + 1] - stops[index]),
  )!;
}

_ColorsAndStops _interpolateColorsAndStops(
    List<Color> aColors,
    List<double> aStops,
    List<Color> bColors,
    List<double> bStops,
    double t,
    ) {
  assert(aColors.length >= 2);
  assert(bColors.length >= 2);
  assert(aStops.length == aColors.length);
  assert(bStops.length == bColors.length);
  final SplayTreeSet<double> stops = SplayTreeSet<double>()
    ..addAll(aStops)
    ..addAll(bStops);
  final List<double> interpolatedStops = stops.toList(growable: false);
  final List<Color> interpolatedColors = interpolatedStops.map<Color>(
        (double stop) => Color.lerp(_sample(aColors, aStops, stop), _sample(bColors, bStops, stop), t)!,
  ).toList(growable: false);
  return _ColorsAndStops(interpolatedColors, interpolatedStops);
}

const t = GradientRotation(0);

enum _GradientBegin {

  topLeft,
  topRight,
  bottomRight,
  bottomLeft;

  double _resolveAngle(Rect rect) {
    double angleA = atan(rect.height / rect.width);
    double angleB = pi/2 - angleA;
    return switch (this) {
      topLeft => angleA,
      topRight => angleA + 2 * angleB,
      bottomRight => pi + angleA,
      bottomLeft => pi + angleA + 2 * angleB
    };
  }
}

class DiagonalGradientTransform extends GradientTransform {

  static const topLeft = DiagonalGradientTransform._(_GradientBegin.topLeft);
  static const topRight = DiagonalGradientTransform._(_GradientBegin.topRight);
  static const bottomRight = DiagonalGradientTransform._(_GradientBegin.bottomRight);
  static const bottomLeft = DiagonalGradientTransform._(_GradientBegin.bottomLeft);

  final _GradientBegin _begin;
  const DiagonalGradientTransform._(this._begin);

  static Rect inscribeRect90(Rect originalRect) {

    double inscribedHeight;
    double inscribedWidth;

    if (originalRect.width > originalRect.height) {
      inscribedHeight = originalRect.height;
      inscribedWidth = inscribedHeight * MathUtils.divideOrZero(originalRect.height, originalRect.width);
    } else {
      inscribedWidth = originalRect.width;
      inscribedHeight = inscribedWidth * MathUtils.divideOrZero(originalRect.width, originalRect.height);
    }

    return Rect.fromCenter(
      center: originalRect.center,
      width: inscribedWidth,
      height: inscribedHeight,
    );
  }

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {

    final double centerX = bounds.center.dx;
    final double centerY = bounds.center.dy;

    final scale = MathUtils.divideOrZero(min(bounds.width, bounds.height), max(bounds.width, bounds.height));

    final inscribed = inscribeRect90(bounds);

    final Matrix4 rotationMatrix = Matrix4.identity()
      ..translate(centerX, centerY)
      ..rotateZ(_begin._resolveAngle(inscribed))
      ..scale(scale)
      ..translate(-centerX, -centerY);

    return rotationMatrix;
  }

}

class DiagonalGradient extends LinearGradient {

  const DiagonalGradient.atTopLeft({
    required super.colors,
    super.stops,
    super.tileMode = TileMode.clamp
  }) : super(begin: Alignment.centerLeft, end: Alignment.centerRight, transform: DiagonalGradientTransform.topLeft);

  const DiagonalGradient.atTopRight({
    required super.colors,
    super.stops,
    super.tileMode = TileMode.clamp
  }) : super(begin: Alignment.centerLeft, end: Alignment.centerRight, transform: DiagonalGradientTransform.topRight);

  const DiagonalGradient.atBottomRight({
    required super.colors,
    super.stops,
    super.tileMode = TileMode.clamp
  }) : super(begin: Alignment.centerLeft, end: Alignment.centerRight, transform: DiagonalGradientTransform.bottomRight);

  const DiagonalGradient.atBottomLeft({
    required super.colors,
    super.stops,
    super.tileMode = TileMode.clamp
  }) : super(begin: Alignment.centerLeft, end: Alignment.centerRight, transform: DiagonalGradientTransform.bottomLeft);

}