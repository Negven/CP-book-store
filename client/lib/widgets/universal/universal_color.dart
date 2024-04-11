// import 'dart:ui';

import 'package:flutter/cupertino.dart';

// Перерахування для визначення різних прапорців, пов'язаних з UniversalColor.
enum UniversalFlag {
  isDark, // Темний режим
  isInactive, // Неактивний стиль тексту
  isFocused, // Сфокусовано
  isDisabled, // Вимкнено
  isOn, // Колір увімкнення
}

extension UniversalFlagExtension on UniversalFlag {
  BigInt get _bit => BigInt.two.pow(index); // Повертає значення прапорця у вигляді BigInt.
}

// Попередньо визначені константи, що представляють конкретні UniversalFlag.
const isInactiveFlag = UniversalFlag.isInactive;
final isInactiveBit = isInactiveFlag._bit;

const isFocusedFlag = UniversalFlag.isFocused;
final isFocusedBit = isFocusedFlag._bit;

const isDisabledFlag = UniversalFlag.isDisabled;
final isDisabledBit = isDisabledFlag._bit;

const isOnFlag = UniversalFlag.isOn;
final isOnBit = isOnFlag._bit;

final isOnAndDisabledBit = [isOnFlag, isDisabledFlag]._bit;

final isDarkBit = UniversalFlag.isDark._bit;

final isAnyBit = BigInt.zero;

// Тип, який представляє список UniversalFlags.
typedef UniversalFlags = List<UniversalFlag>;

// Функція, яка повертає пустий список UniversalFlags.
UniversalFlags flags() => [];

// Розширення для списку UniversalFlags.
extension UniversalFlagExtensions on UniversalFlags {
  // Повертає бітове представлення списку флагів.
  BigInt get _bit => UniversalColor.resolveBits(this);

  // Вирішує колір на основі флагів.
  Color resolveColor(Color color) => color.resolveFlags(this);

  // Перемикає флаг, якщо він встановлений.
  UniversalFlags toggle(bool? hasFlag, UniversalFlag flag) {
    if (hasFlag != null && hasFlag) add(flag);
    return this;
  }
}

// Розширення для типу Brightness для перетворення його в UniversalFlags.
extension UniversalFlagBrightness on Brightness {
  // Перетворюється універсальні флаги на основі яскравості.
  UniversalFlags toFlags(UniversalFlags list) =>
      list.toggle(this == Brightness.dark, UniversalFlag.isDark);

  // Повертає бітове представлення для яскравості.
  BigInt get toBits => this == Brightness.dark ? isDarkBit : BigInt.zero;

  // Вирішує колір на основі яскравості.
  Color resolveColor(Color color) => color.resolveBits(toBits);
}

// Розширення для BigInt для перевірки бітів.
extension BigIntBits on BigInt {
  bool hasBits(BigInt bits) => (bits & this) == bits;
}

// Тип, який представляє мапу BigInt до Color.
typedef UniversalColorSpecMap = Map<BigInt, Color>;

// Функція, яка повертає UniversalColor за списком карт специфікацій кольорів.
UniversalColor ucs(List<UniversalColorSpecMap> colors) =>
    UniversalColor._build(null, null, colors);

// Функція, яка повертає UniversalColor з основним кольором та необов'язковим списком карт специфікацій кольорів.
UniversalColor uc(Color main, [List<UniversalColorSpecMap>? colors]) =>
    UniversalColor._build(main, null, colors);

// Функція, яка повертає UniversalColor з основним кольором, непрозорістю та необов'язковим списком карт специфікацій кольорів.
UniversalColor uca(Color main, double opacity,
    [List<UniversalColorSpecMap>? colors]) =>
    UniversalColor._build(main, opacity, colors);

// Функція, яка повертає UniversalColor з кольорами для світлого та темного режиму.
UniversalColor ld(Color light, Color dark) => uc(light, [{isDarkBit: dark}]);

// Функція, яка повертає UniversalColor з кольорами та непрозорістю для світлого та темного режиму.
UniversalColor lda(Color light, Color dark, double opacity) =>
    uca(light, opacity, [{isDarkBit: dark}]);

// Функція, яка повертає UniversalColor з кольором та різною непрозорістю для світлого та темного режиму.
UniversalColor lada(Color color, double lightOpacity,
    [double? darkOpacity]) =>
    ld(uca(color, lightOpacity), uca(color, darkOpacity ?? lightOpacity));

// Клас для представлення кольору з розширеними можливостями.
class _Color {
  final BigInt bits;
  final Color color; // Колір може бути також UniversalColor

  const _Color(this.bits, this.color);

  factory _Color.fromMap(UniversalColorSpecMap map) {
    if (map.length != 1) throw 'Розмір карти має бути == 1, перевірте налаштування кольорів';
    var e = map.entries.first;
    return _Color(e.key, e.value);
  }
}

// Клас, який представляє універсальний колір.
class UniversalColor extends Color {
  final List<_Color> _colors; // Список для вибору за пріоритетом
  final double? _opacity;

  const UniversalColor._private(this._colors, this._opacity) : super(0xFFFF00FF);

  // Створює UniversalColor на основі заданого кольору, непрозорості та карт специфікацій кольорів.
  static UniversalColor _build(Color? main, double? opacity,
      List<UniversalColorSpecMap>? colors) {
    List<_Color> list = [];

    if (colors != null && colors.isNotEmpty) {
      for (var map in colors) {
        if (map.length != 1) throw 'Розмір карти має бути == 1, перевірте налаштування кольорів';
        list.add(_Color.fromMap(map));
      }
    }

    if (main != null) {
      list.add(_Color(isAnyBit, main));
    }

    if (list.last.bits != isAnyBit) {
      throw 'Останній колір у UniversalColor.colors має бути з isAnyBit';
    }

    return UniversalColor._private(list, opacity);
  }

  // Вирішує флаги на основі бітів.
  static Iterable<UniversalFlag> resolveFlags(BigInt bits) {
    return UniversalFlag.values.where((f) => (bits & f._bit) == f._bit);
  }

  // Вирішує біти на основі списку флагів.
  static BigInt resolveBits(UniversalFlags flags) {
    var result = BigInt.zero;
    for (var f in flags) {
      result = result + f._bit;
    }
    return result;
  }

  // Повертає колір на основі флагів.
  Color fromFlags(UniversalFlags flags) => fromBits(resolveBits(flags));

  // Повертає колір на основі бітів.
  Color fromBits(BigInt bits) {
    Color color = _colors.firstWhere((p) => bits.hasBits(p.bits)).color;

    var result = color.resolveBits(bits);
    if (_opacity != null) {
      // Не успадковує непрозорість, оскільки це важко контролювати
      result = result.withOpacity(_opacity!);
    }
    return result;
  }
}

// Розширення для типу Color для вирішення кольору на основі флагів або бітів.
extension UniversalColorExtension on Color {
  Color resolveFlags(UniversalFlags flags) {
    var color = this;
    return color is UniversalColor ? color.fromFlags(flags) : color;
  }

  Color resolveBits(BigInt bits) {
    var color = this;
    return color is UniversalColor ? color.fromBits(bits) : color;
  }
}
