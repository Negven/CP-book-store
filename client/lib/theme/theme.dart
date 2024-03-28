
import 'package:client/theme/master_colors.dart';
import 'package:client/theme/master_styles.dart';
import 'package:client/theme/master_texts.dart';
import 'package:client/utils/font_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

export 'package:client/theme/master_styles.dart';


class ThemeBuilder {

  final Brightness brightness;
  ThemeBuilder(this.brightness);

  MasterStyles? _current;

  ThemeData build(double factor) {

    final nextBase = FontUtils.toBase(factor);
    if (_current != null && _current!.texts.base == nextBase) {
      return _current!.theme;
    }

    debugPrint("Recreating master styles for brightness: ${brightness.name} with base: $nextBase");

    _current = MasterStyles.from(brightness, factor);
    return _current!.theme;
  }

}

final iLightThemeBuilder = ThemeBuilder(Brightness.light);

final iDarkThemeBuilder = ThemeBuilder(Brightness.dark);



extension BuildContextExtension on BuildContext {

  MasterStyles get styles => theme.extension<MasterStyles>()!;
  MasterTemplates get templates => styles.templates;
  MasterColors get colors => styles.colors;
  MasterTexts get texts => styles.texts;

  // Most commonly used

  Color get color4action => colors.primary;
  Color get color4text => colors.text;
  Color get color4disabled => colors.disabledText;
  Color get color4background => colors.backgroundL0;

  TextStyle get style4text => styles.texts.textStyle;

}




