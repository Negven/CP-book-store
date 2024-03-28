

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vector_graphics/vector_graphics.dart';


abstract class ISvg {
  String get asset;
}

abstract class SvgUtils {

  static BoxFit _resolveFit(double? width, double? height) {
    BoxFit fit = BoxFit.contain;

    if (width == null || height == null) {
      fit = BoxFit.cover;
    }
    if (width == null && height != null) {
      fit = BoxFit.fitHeight;
    }

    if (width != null && height == null) {
      fit = BoxFit.fitWidth;
    }
    return fit;
  }

  static Widget toSvgLD(bool isDarkMode, ISvg svg, {double? height, double? width, Color? color}) {
    BoxFit fit = _resolveFit(width, height);
    final filter = color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null;
    return SvgPicture(AssetBytesLoader("assets/svg/${svg.asset}_${isDarkMode ? 'd' : 'l'}.svg.vec"), height: height, width: width, colorFilter: filter, fit: fit);
  }

}


extension SvgExtension on BuildContext {

  Widget toSvgLD(ISvg svg, {double? height, double? width, Color? color}) =>
    SvgUtils.toSvgLD(isDarkMode, svg, height: height, width: width, color: color);

}