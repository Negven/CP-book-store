

// import 'dart:ui';

import 'package:flutter/cupertino.dart';



enum UniversalFlag {

  isDark,
  isInactive, // textInactiveStyle
  isFocused,
  isDisabled,
  isOn, // on-colors
  ;

  BigInt get _bit => BigInt.two.pow(index);

}

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


typedef UniversalFlags = List<UniversalFlag>;

UniversalFlags flags() => [];

extension UniversalFlagExtension on UniversalFlags {

  BigInt get _bit => UniversalColor.resolveBits(this);

  Color resolveColor(Color color) => color.resolveFlags(this);

  UniversalFlags toggle(bool? hasFlag, UniversalFlag flag) {
    if (hasFlag != null && hasFlag) add(flag);
    return this;
  }

}

extension UniversalFlagBrightness on Brightness {

  UniversalFlags toFlags(UniversalFlags list) =>
    list.toggle(this == Brightness.dark, UniversalFlag.isDark);


  BigInt get toBits => this == Brightness.dark ? isDarkBit : BigInt.zero;

  Color resolveColor(Color color) => color.resolveBits(toBits);

}







extension BigIntBits on BigInt {
  bool hasBits(BigInt bits) => (bits & this) == bits;
}

typedef UniversalColorSpecMap = Map<BigInt, Color>;

UniversalColor ucs(List<UniversalColorSpecMap> colors) =>
    UniversalColor._build(null, null, colors);

UniversalColor uc(Color main, [List<UniversalColorSpecMap>? colors]) =>
    UniversalColor._build(main, null, colors);

UniversalColor uca(Color main, double opacity, [List<UniversalColorSpecMap>? colors]) =>
    UniversalColor._build(main, opacity, colors);

UniversalColor ld(Color light, Color dark) =>
    uc(light, [ {isDarkBit: dark} ]);

UniversalColor lda(Color light, Color dark, double opacity) =>
    uca(light, opacity, [ {isDarkBit: dark} ]);

UniversalColor lada(Color color, double lightOpacity, [double? darkOpacity]) =>
    ld(uca(color, lightOpacity), uca(color, darkOpacity ?? lightOpacity));

class _Color {

  final BigInt bits;
  final Color color; // NB! Color can be UniversalColor

  const _Color(this.bits, this.color);

  factory _Color.fromMap(UniversalColorSpecMap map) {
    if (map.length != 1) throw 'Size of map must be == 1, check colors settings';
    var e = map.entries.first;
    return _Color(e.key, e.value);
  }
}


class UniversalColor extends Color {

  final List<_Color> _colors; // Must be list to make choosing by priority
  final double? _opacity;
  const UniversalColor._private(this._colors, this._opacity) : super(0xFFFF00FF);

  static UniversalColor _build(Color? main, double? opacity, List<UniversalColorSpecMap>? colors) {

    List<_Color> list = [];

    if (colors != null && colors.isNotEmpty) {
      for (var map in colors) {
        if (map.length != 1) throw 'Size of map must be == 1, check colors settings';
        list.add(_Color.fromMap(map));
      }
    }

    if (main != null) {
      list.add(_Color(isAnyBit, main));
    }

    if (list.last.bits != isAnyBit) {
      throw 'Last color in UniversalColor.colors must be with `isAnyBit`';
    }

    return UniversalColor._private(list, opacity);
  }

  static Iterable<UniversalFlag> resolveFlags(BigInt bits) {
    return UniversalFlag.values.where((f) => (bits & f._bit) == f._bit);
  }

  static BigInt resolveBits(UniversalFlags flags) {
    var result = BigInt.zero;
    for (var f in flags) {
      result = result + f._bit;
    }
    return result;
  }

  Color fromFlags(UniversalFlags flags)
    => fromBits(resolveBits(flags));

  Color fromBits(BigInt bits) {

    Color color = _colors.firstWhere((p) => bits.hasBits(p.bits)).color;

    var result = color.resolveBits(bits);
    if (_opacity != null) {
      // NB! Don't inherit opacity, as it hard to control
      result = result.withOpacity(_opacity!);
    }
    return result;
  }


}


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

