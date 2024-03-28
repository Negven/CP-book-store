
import 'package:client/enum/language_code.dart';
import 'package:get/get.dart';

abstract class BasePreference<T> {

  const BasePreference();

  T defaultValue();
  T convertValue(dynamic value);
  bool hasValue(T value) => value != null && (value.toString().isNotEmpty);

}

class StringPreference extends BasePreference<String> {

  final String _defaultValue;
  const StringPreference([this._defaultValue = ""]);

  @override
  String convertValue(value) => (value ?? "").toString();

  @override
  String defaultValue() => _defaultValue;

}

class EnumPreference<T extends Enum> extends BasePreference<T> {

  final T _defaultValue;
  final Iterable<T> _values;
  const EnumPreference(this._defaultValue, this._values);

  @override
  T defaultValue() => _defaultValue;

  @override
  T convertValue(value) => _values.byName(value.toString());

}

class LanguageCodePreference extends EnumPreference<LanguageCode> {

  const LanguageCodePreference() : super(LanguageCode.fallback, LanguageCode.values);

  @override
  LanguageCode defaultValue() {
    final l = Get.deviceLocale;
    if (l == null) return super.defaultValue();
    return LanguageCode.fromLocale(l);
  }
}