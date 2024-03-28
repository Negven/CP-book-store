import 'package:client/@app/translations/app_en.dart';
import 'package:client/@app/translations/app_ua.dart';
import 'package:client/@inf/translations/inf_en.dart';
import 'package:client/@inf/translations/inf_nb.dart';
import 'package:client/enum/language_code.dart';
import 'package:client/enum/preferences.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';
import 'package:client/utils/string_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';


final Map<String, Map<String, String>> iKeys = {
  LanguageCode.en.name: ConvertUtils.mergeUnique([AppEN.translations, InfEN.translations]),
  LanguageCode.nb.name: ConvertUtils.mergeUnique([AppUA.translations, InfNB.translations]),
};


class TranslationKeys extends Translations {

  @override
  Map<String, Map<String, String>> get keys => iKeys;

  validateKeys() {

    int size = 0;

    String invalidTranslations = "";
    Map<String, String>? first;

    keys.forEach((key, value) {
      if (size == 0) {
        first = value;
        size = value.keys.length;
      } else {
        if (size != value.keys.length) {
          invalidTranslations = "Lang $key hasn't same size: $size != ${value.keys.length}. ";
        }

        for (var tKey in first!.keys) {
          if (!value.containsKey(tKey)) {
            invalidTranslations += "[$key]: $tKey";
          }
        }
      }
    });

    if (StringUtils.isNotEmpty(invalidTranslations)) {
      throw invalidTranslations;
    }

    validatePositions(AppEN.translations, AppUA.translations);
    validatePositions(InfEN.translations, InfNB.translations);

  }

  validatePositions(Map<String, String> main, Map<String, String> other) {
     final aKeys = main.keys.toList();
     final bKeys = other.keys.toList();
     for (var i = 0; i < aKeys.length; i++) {
       final key = aKeys[i];
       if (key != bKeys[i]) {
         throw " Key '$key' not at the same position, move it from ${bKeys.indexOf(aKeys[i]) + 1} to ${ i + 1 } line";
       }
     }
  }

}

class TranslationsService extends GetxService {

  final localizationsDelegates = [...GlobalMaterialLocalizations.delegates];
  late final supportedLocales = LanguageCode.values.map((e) => e.locale);

  final keys = TranslationKeys();

  @override
  void onInit() {
    super.onInit();

    if (kDebugMode) {
      keys.validateKeys();
    }

    setLanguage(Preference.uiLanguageCode.storedValue, true);
  }

  TextDirection get textDirection => (rtlLanguages.contains(Get.locale!.languageCode) ? TextDirection.rtl : TextDirection.ltr);

  // TODO call on wallet button click if not the same on user
  setLanguage(LanguageCode code, [bool initial = false]) {

    DateTimeUtils.setLocale(code);

    if (initial) {
      Get.locale = code.locale;
      Get.fallbackLocale = LanguageCode.fallback.locale;
    } else {
      Preference.uiLanguageCode.storedValue = code;
      Get.updateLocale(code.locale);
    }

  }

  LanguageCode get storedValue => Preference.uiLanguageCode.storedValue;

}


extension TranslateExtension on String {

  String get T {

    if (kDebugMode) {
      if (!iKeys[iKeys.keys.first]!.containsKey(this)) {
        print("Unknown key: $this");
      }
    }

    return tr;
  }

  // ignore: non_constant_identifier_names
  String T1 (Object param) {
    var trans = tr;
    trans = trans.replaceAll('{0}', param.toString());
    return trans;
  }

}