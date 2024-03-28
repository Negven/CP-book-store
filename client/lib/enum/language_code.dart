

import 'dart:ui';

import 'package:get/get.dart';

enum LanguageCode {
  // system(auto) locale can't be used as we need to know locale on the server side
  en(Locale('en')),
  nb(Locale('nb'));

  static const fallback = en;
  static const local = "local"; // texts in local language

  final Locale locale;
  const LanguageCode(this.locale);

  bool isSupported(Locale locale) => locale.languageCode.startsWith(name);

  @override
  String toString() => name;


  static LanguageCode fromLocale(Locale locale) =>
      values.firstWhere((l) => l.isSupported(locale), orElse: () => fallback);

  static LanguageCode get now => LanguageCode.fromLocale(Get.locale!);
  static bool get isEnNow => now == LanguageCode.en;
}
