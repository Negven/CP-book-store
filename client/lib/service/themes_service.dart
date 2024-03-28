import 'package:client/enum/preferences.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class ThemesService extends GetxService {

  ThemeMode get themeMode => Preference.uiThemeMode.storedValue;

  void setThemeMode(ThemeMode themeMode) {
    Preference.uiThemeMode.storedValue = themeMode;
    Get.changeThemeMode(themeMode);
  }

  toggleTheme() {
    setThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  ThemeData light(double factor) {
    return iLightThemeBuilder.build(factor);
  }

  ThemeData dark(double factor) {
    return iDarkThemeBuilder.build(factor);
  }

  Color? _statusBarColor;

  void updateOverlayStyle(BuildContext context) {

    final background = context.color4background;
    if (_statusBarColor == null || _statusBarColor != background) {

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // NB! Must be transparent to better dimming background
        statusBarIconBrightness: Get.isDarkMode ? Brightness.light : Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Get.isDarkMode ? Brightness.dark : Brightness.light, // For iOS (dark icons)
      ));

      _statusBarColor = background;
    }


  }
}
