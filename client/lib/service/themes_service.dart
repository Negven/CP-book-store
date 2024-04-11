import 'package:client/enum/preferences.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Сервіс тем
class ThemesService extends GetxService {

  // Отримати режим теми
  ThemeMode get themeMode => Preference.uiThemeMode.storedValue;

  // Встановити режим теми
  void setThemeMode(ThemeMode themeMode) {
    Preference.uiThemeMode.storedValue = themeMode;
    Get.changeThemeMode(themeMode);
  }

  // Перемкнути тему
  toggleTheme() {
    setThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  // Створити світлу тему
  ThemeData light(double factor) {
    return iLightThemeBuilder.build(factor);
  }

  // Створити темну тему
  ThemeData dark(double factor) {
    return iDarkThemeBuilder.build(factor);
  }

  // Колір панелі стану
  Color? _statusBarColor;

  // Оновити стиль накладного шару
  void updateOverlayStyle(BuildContext context) {

    // Отримати колір фону
    final background = context.color4background;

    // Якщо колір панелі стану не визначений або відрізняється від фону
    if (_statusBarColor == null || _statusBarColor != background) {

      // Встановити стиль накладного шару
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Необхідно, щоб краще затемнювався фон
        statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark, // Для Android (темні значки)
        statusBarBrightness: Get.isDarkMode ? Brightness.dark : Brightness.light, // Для iOS (темні значки)
      ));

      // Оновити колір панелі стану
      _statusBarColor = background;
    }
  }
}
