import 'package:client/classes/sized_value.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/theme/master_colors.dart';
import 'package:client/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MasterTexts extends TextTheme {

  final double factor;
  final int base;

  final SizedValue<TextStyle> n; // normal
  final SizedValue<TextStyle> m; // medium
  final SizedValue<TextStyle> b; // bold
  final SizedValue<TextStyle> e; // extra
  final SizedValue<TextStyle> u; // ultra

  TextStyle get inputText => m.base;
  TextStyle get textStyle => n.base;

  final TextStyle textInactiveStyle;


  TextStyle get tileTitle => inputText;
  final TextStyle walletIcon;


  const MasterTexts._private({
    
    required this.factor,
    required this.base,

    required this.n,
    required this.m,
    required this.b,
    required this.e,
    required this.u,

    // Cached
    required this.walletIcon,
    required this.textInactiveStyle,

    // Regular
    super.displayLarge,
    super.displayMedium,
    super.displaySmall,
    super.headlineLarge,
    super.headlineMedium,
    super.headlineSmall,
    super.bodyLarge,
    super.bodyMedium,
    super.bodySmall,

    // Medium
    super.titleLarge,
    super.titleMedium,
    super.titleSmall,
    super.labelLarge,
    super.labelMedium,
    super.labelSmall,

  });
  
  static MasterTexts from(double factor, MasterColors colors) {


    TextStyle ts(double fontSize, FontVariations variations) => _baseStyle
        .copyWith(
          color: colors.text,
          fontSize: (fontSize * factor).roundToDouble(), // making changes by only ints (to make it pixel perfect)
          fontVariations: variations
        );

    TextStyle normal(double fontSize) => ts(fontSize, VariableWeight.normal);
    TextStyle medium(double fontSize) => ts(fontSize, VariableWeight.medium);
    TextStyle bold(double fontSize) => ts(fontSize, VariableWeight.bold);
    TextStyle extra(double fontSize) => ts(fontSize, VariableWeight.extra);
    TextStyle ultra(double fontSize) => ts(fontSize, VariableWeight.ultra);


    final n12 = normal(FontUtils.f12);
    final n14 = normal(FontUtils.f14);
    final n16 = normal(FontUtils.f16);
    final n22 = normal(FontUtils.f22);
    final n28 = normal(FontUtils.f28);
    final n32 = normal(FontUtils.f32);

    final n36 = normal(FontUtils.f36);
    final n45 = normal(FontUtils.f45);
    final n57 = normal(FontUtils.f57);

    final SizedValue<TextStyle> n = FontUtils.height.map(normal);

    final m11 = medium(FontUtils.f11);
    final m12 = medium(FontUtils.f12);
    final m14 = medium(FontUtils.f14);
    final m16 = medium(FontUtils.f16);
    final m22 = medium(FontUtils.f22);

    final m = FontUtils.height.map(medium);
    final b = FontUtils.height.map(bold);
    final e = FontUtils.height.map(extra);
    final u = FontUtils.height.map(ultra);

    final next = MasterTexts._private(

      factor: factor,
      base: FontUtils.toBase(factor),

      n: n,
      m: m,
      b: b,
      e: e,
      u: u,

      textInactiveStyle: n14.copyWith(color: colors.inactiveText),
      walletIcon: withEmoji(n.lg),
      
      displayLarge: n57,
      displayMedium: n45,
      displaySmall: n36,
      headlineLarge: n32,
      headlineMedium: n28,
      headlineSmall: n22,
      titleLarge: m22,
      titleMedium: m16,
      titleSmall: m14,
      labelLarge:  m14,
      labelMedium: m12,
      labelSmall: m11,
      bodyLarge: n16,
      bodyMedium: n14,
      bodySmall: n12,
    );

    return next;
  }


  static const TextStyle _baseStyle = TextStyle(
      inherit: true, // NB! to make possible auto-customize themes
      fontWeight: FontWeight.normal, // NB! Must be normal to prevent double adjusting weights [FontWeight.700 & Variation('wght', 700) != 700]
      fontFeatures: FontUtils.features,
      fontFamily: FontUtils.family,
      height: 1.2, // NB! Important to make better line height for widgets, especially buttons
      fontFamilyFallback: [FontUtils.family]
  );



  static TextStyle withEmoji(TextStyle style) {

    final googleStyle = GoogleFonts.getFont(FontUtils.emoji);

    return googleStyle.copyWith(
      inherit: style.inherit,
      fontFeatures: style.fontFeatures,
      fontFamilyFallback: style.fontFamilyFallback!,
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      fontVariations: style.fontVariations,
      color: style.color,
      height: style.height,
      decoration: style.decoration
    );
  }


}


