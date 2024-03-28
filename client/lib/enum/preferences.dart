import 'package:client/classes/preferences.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/material.dart';

// Customizable settings that :
// - can be different between devices (uiThemeMode)
// - must be available instantly on app start (uiLanguageCode)
enum Preference {

  uiThemeMode(EnumPreference(ThemeMode.system, ThemeMode.values)),
  uiLanguageCode(LanguageCodePreference()),
  authCredentials(StringPreference());

  final BasePreference _p;
  const Preference(this._p);

  dynamic get storedValue => Services.storage.getValue(name, _p.defaultValue(), _p.convertValue);
  set storedValue(value) => Services.storage.setValue(name, value, _p.defaultValue());
  bool get hasValue => _p.hasValue(storedValue);
  void reset() => storedValue = _p.defaultValue();

}

