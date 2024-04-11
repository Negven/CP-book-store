import 'package:client/enum/language_code.dart';
import 'package:get/get.dart';

// Базовий інтерфейс для збереження налаштувань (укр. інтерфейс - interface)
abstract class BasePreference<T> {
  const BasePreference();

  // Отримати значення за замовчуванням (укр. значення за замовчуванням - default value)
  T defaultValue();

  // Перетворити значення (укр. перетворити значення - convert value)
  T convertValue(dynamic value);

  // Чи є значення (укр. чи є значення - has value)
  bool hasValue(T value) => value != null && (value.toString().isNotEmpty);
}

// Збереження рядків (укр. рядок - string)
class StringPreference extends BasePreference<String> {
  final String _defaultValue;
  const StringPreference([this._defaultValue = ""]);

  @override
  String convertValue(value) => (value ?? "").toString();

  @override
  String defaultValue() => _defaultValue;
}

// Збереження перерахувань (укр. перерахування - enum)
class EnumPreference<T extends Enum> extends BasePreference<T> {
  final T _defaultValue;
  final Iterable<T> _values;
  const EnumPreference(this._defaultValue, this._values);

  @override
  T defaultValue() => _defaultValue;

  @override
  T convertValue(value) => _values.byName(value.toString());
}

// Збереження коду мови (укр. код мови - language code)
class LanguageCodePreference extends EnumPreference<LanguageCode> {
  const LanguageCodePreference() : super(LanguageCode.fallback, LanguageCode.values);

  @override
  LanguageCode defaultValue() {
    final l = Get.deviceLocale;
    if (l == null) return super.defaultValue();
    return LanguageCode.fromLocale(l);
  }
}
