


import 'dart:ui';

import 'package:client/classes/sized_value.dart';
import 'package:google_fonts/google_fonts.dart';


typedef FontVariations = List<FontVariation>;

abstract class VariableWeight {

  static const FontVariations normal = [FontVariation('wght', 450)];
  static const FontVariations medium = [FontVariation('wght', 600)];
  static const FontVariations bold = [FontVariation('wght', 650)];
  static const FontVariations extra = [FontVariation('wght', 700)];
  static const FontVariations ultra = [FontVariation('wght', 800)];

}

abstract class FontUtils {

  static const double
      f10 = 10.0,
      f11 = 11.0,
      f12 = 12.0,
      f14 = 14.0,
      f16 = 16.0,
      f22 = 22.0,
      f28 = 28.0,
      f32 = 32.0,
      f36 = 36.0,
      f45 = 45.0,
      f57 = 57.0,
      fBase = f14;


  static const height = SizedValue(
    xxs: f10,
    xs: f12,
    sm: f14,
    md: f16,
    lg: f22,
    xl: f28,
    xxl: f32
  );

  /// Custom made font of icons, see ./py/icons/README.md
  static const icons = 'Icons';
  static const family = 'Montserrat';
  static const emoji = 'Noto Color Emoji';

  static const features = [FontFeature.tabularFigures()];

  static int toBase(double factor) => (fBase * factor).round(); // round() to make pixel perfect
  static int toFontSize(double font, double baseHeight) => (baseHeight * font / fBase).round(); // round() to make pixel perfect

  static void init() {
    GoogleFonts.config.allowRuntimeFetching = false;
  }


}
