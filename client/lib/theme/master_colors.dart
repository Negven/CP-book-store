
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/universal/universal_color.dart';
import 'package:flutter/material.dart';


class MasterColors extends ColorScheme {

  final Color text;
  final Color inactiveText;
  final Color disabledText;
  final Color onText;

  Color get backgroundL0 => background;
  final Color backgroundL1;
  final Color backgroundL2;
  final Color backgroundL3;
  late final backgroundGradient = [backgroundL3, backgroundL2, backgroundL3, backgroundL2, backgroundL3];

  Color get danger => error;
  Color dangerL2;

  final TextStyle textStyle;
  final TextStyle activeStyle;

  Color get elevation => shadow;
  final Color elevationPrimary;
  final Color elevationInner;

  Color resolveFlags(Color color, UniversalFlags flags) {
    brightness.toFlags(flags);
    return flags.resolveColor(color);
  }

  Color resolveColor(Color color) =>
    brightness.resolveColor(color);

  /// Colors that commonly used, so can be resolved once per brightness
  MasterColors(Brightness brightness) :
        text = brightness.resolveColor(textUC),
        inactiveText = brightness.toFlags([isInactiveFlag]).resolveColor(textUC),
        disabledText = brightness.toFlags([isDisabledFlag]).resolveColor(textUC),
        onText = brightness.resolveColor(onTextUC),
        dangerL2 = brightness.resolveColor(dangerL2UC),

        textStyle = TextStyle(color: brightness.resolveColor(textUC)),
        activeStyle = TextStyle(color: brightness.resolveColor(primaryUC)),

        backgroundL1 = brightness.resolveColor(backgroundL1UC),
        backgroundL2 = brightness.resolveColor(backgroundL2UC),
        backgroundL3 = brightness.resolveColor(backgroundL3UC),

        elevationPrimary = brightness.resolveColor(elevationPrimaryUC),
        elevationInner = brightness.resolveColor(elevationInnerUC),
        super(
          brightness: brightness,
          primary: brightness.resolveColor(primaryUC),
          onPrimary: brightness.resolveColor(whiteTextUC),
          secondary:  brightness.resolveColor(secondaryUC),
          onSecondary: brightness.resolveColor(textUC),
          error: brightness.resolveColor(dangerUC),
          onError: brightness.resolveColor(whiteTextUC),
          background: brightness.resolveColor(backgroundL0UC),
          onBackground: brightness.resolveColor(textUC),
          surface: brightness.resolveColor(backgroundL0UC),
          onSurface: brightness.resolveColor(textUC),
          surfaceTint: brightness.resolveColor(primaryUC),
          shadow: brightness.resolveColor(elevationUC)
        );

  static final colors = {
    Brightness.light: MasterColors(Brightness.light),
    Brightness.dark: MasterColors(Brightness.dark),
  };

  static void printSvgColors() {
    final l = colors[Brightness.light]!;
    final d = colors[Brightness.dark]!;

    // see details in py/svg/main.py file
    debugPrint("""
    
    # NB! Don't change colors manually, see 
    #  - initial log on client app start or
    #  - printSvgColors() in MasterColors
    primary = '${l.primary} ${d.primary}'
    danger = '${l.danger} ${d.danger}'
    danger_l2 = '${l.dangerL2} ${d.dangerL2}'
    text = '${l.text} ${d.text}'
    background_l0 = '${l.background} ${d.background}'
    background_l2 = '${l.backgroundL2} ${d.backgroundL2}'
    
    """.replaceAll('Color(0xff', '#')
       .replaceAll('Color(0x', '#')
       .replaceAll(')', ''));
  }

}


void main() {
  MasterColors.printSvgColors();
}