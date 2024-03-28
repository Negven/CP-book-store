


import 'package:client/classes/key_value_cache.dart';
import 'package:client/classes/sized_value.dart';
import 'package:client/theme/hsv.dart';
import 'package:client/widgets/universal/universal_color.dart';
import 'package:flutter/material.dart';



abstract class L {

  static const _l94 = 0.94;
  static const _l88 = 0.88;
  static const _l80 = 0.80;
  static const _l64 = 0.64;
  static const _l48 = 0.48;
  static const _l32 = 0.32;
  static const _l24 = 0.24;
  static const _l16 = 0.16;
  static const _l08 = 0.08;
  static const _l02 = 0.02;

  static const backgroundL0 = _l02;
  static const backgroundL1 = _l08;
  static const backgroundL2 = _l16;
  static const backgroundL3 = _l24;

  static const border = _l32;
  static const borderFocused = _l64;

  static const secondaryColor = _l32;

  static const colorInactive = _l64;

  static const color = _l80;
  static const onColor = _l08;

  static const colorFocused = _l88;
  static const colorBright = _l94;

  static const divider = _l08;

  static const disabled = _l16;
  static const onDisabled = _l80;
}

abstract class O {

  // ignore: unused_field
  static const _o02 = L._l02;
  static const _o08 = L._l08;
  static const _o16 = L._l16;
  static const _o32 = L._l32;
  // ignore: unused_field
  static const _o48 = L._l48;
  static const _o64 = L._l64;
  static const _o80 = L._l80;
  static const _o88 = L._l88;
  static const _o94 = L._l94;

  static const placeholderContent = _o80;
  static const unfocusedHeader = _o80;
  static const markdownBlock = _o08;
  static const icon = _o88;
  static const verticalMenu = _o16;
  static const verticalMenuBorder = _o64;
  static const tooltip = _o94;
}


// private

final primaryMC = _MasterColor(const Color(0xFF2962FF));
final yellowMC = _MasterColor(const Color(0xffffae00));
final greenMC = _MasterColor(const Color(0xFF38BE18));
final redMC = _MasterColor(const Color(0xFFEA0E0E));

final blackMC = _BlackColor();
final whiteMC = _WhiteColor();

final whiteOverlayUC = SizedValue(
  sm: whiteMC.color.withOpacity(O._o16),
  md: whiteMC.color.withOpacity(O._o32),
  lg: whiteMC.color.withOpacity(O._o48),
);

final _overlayColor = KeyValueCache<ColorTheme, Color>((key) {
  var color = key.textColor;
  return uca(color, O._o08);
});

final primaryUC = uc(primaryMC.la(L.color), []);
final dangerUC = uc(redMC.la(L.color), []);
final dangerL2UC = uc(redMC.la(L.backgroundL2), []);
final secondaryUC = uc(primaryMC.la(L.secondaryColor), []);



UniversalColor _wbText(_MasterColorBase color) => uca(color.la(L.color), O._o80, [
  { isOnAndDisabledBit: color.la(L.onDisabled) },
  { isDisabledBit: color.la(L.disabled) },
  { isOnBit: color.la(L.onColor) },
  { isInactiveBit: color.la(L.colorInactive) }
]);

final blackTextUC = _wbText(blackMC);
final whiteTextUC = _wbText(whiteMC);

final _bwUC = ld(blackTextUC, whiteTextUC);
final _wbUC = ld(whiteTextUC, blackTextUC);

// text-color = black on light, white on dark

final textUC = uc(_bwUC, [
  { isOnBit: _wbUC }
]);

// onText-color = white on light, black on dark

final onTextUC = uc(_wbUC, [
  { isOnBit: _bwUC }
]);

UniversalColor _colorText(_MasterColor color) => uc(color.la(L.color), [
  { isOnBit: blackTextUC },
  { isDisabledBit: textUC },
  { isInactiveBit: color.la(L.colorInactive) }
]);

final primaryTextUC = _colorText(primaryMC);
final dangerTextUC = _colorText(redMC);
final warningTextUC = _colorText(yellowMC);
final successTextUC = _colorText(greenMC);

final backgroundL0UC = primaryMC.la(L.backgroundL0);
final backgroundL1UC = primaryMC.la(L.backgroundL1);
final backgroundL2UC = primaryMC.la(L.backgroundL2);
final backgroundL3UC = primaryMC.la(L.backgroundL3);

final elevationPrimaryUC = primaryMC.la(L._l16, L._l88);

final elevationUC = uc(primaryMC.la(L._l48, L._l32), [
  {isDisabledBit: Colors.transparent},
  {isOnBit: elevationPrimaryUC}
]);

final elevationInnerUC = primaryMC.la(L._l48, L._l08);



UniversalColor _textBorder(_MasterColorBase color) => uc(color.la(L.border), [
  {isDisabledBit: color.la(L.disabled)},
  {isFocusedBit: color.la(L.borderFocused)}
]);


final blackTextBorderUC = _textBorder(blackMC);
final whiteTextBorderUC = _textBorder(whiteMC);

final textBorderUC = uc(blackTextBorderUC, [
  {isDarkBit: whiteTextBorderUC}
]);


UniversalColor _border(_MasterColorBase color) => uc(color.la(L.border), [
  {isDisabledBit: textBorderUC},
  {isFocusedBit: color.la(L.borderFocused)}
]);

final primaryBorderUC = _border(primaryMC);
final dangerBorderUC = _border(redMC);
final successBorderUC = _border(greenMC);
final warningBorderUC = _border(yellowMC);

final whiteBorderUC = ucs([
  { isFocusedBit: whiteMC.color },
  { isAnyBit: whiteMC.color.withOpacity(O._o94) }
]);



final primaryDividerUC = primaryMC.la(L.divider);
final onTextDividerUC = primaryMC.la(L._l02);


UniversalColor _background(_MasterColor color) => uc(Colors.transparent, [
  {isOnAndDisabledBit: textBorderUC},
  {isOnBit: color.la(L.color)}
]);

final textBackgroundUC = uc(Colors.transparent, [
  {isOnAndDisabledBit: textBorderUC},
  {isOnBit: blackTextUC}
]);

final primaryBackgroundUC = _background(primaryMC);
final dangerBackgroundUC = _background(redMC);
final successBackgroundUC = _background(greenMC);
final warningBackgroundUC = _background(yellowMC);
final whiteBackgroundUC = ucs([
  { isFocusedBit: whiteMC.color.withOpacity(O._o88) },
  { isAnyBit: whiteMC.color.withOpacity(O._o48) }
]);

enum ColorTheme {

  primary,
  text,
  warning,
  success,
  danger;

  static const base = primary;

  Color get borderColor => switch (this) {
    text => textBorderUC,
    success => successBorderUC,
    primary => primaryBorderUC,
    warning => warningBorderUC,
    danger => dangerBorderUC
  };

  Color get backgroundColor => switch (this) {
    text => textBackgroundUC,
    success => successBackgroundUC,
    primary => primaryBackgroundUC,
    warning => warningBackgroundUC,
    danger => dangerBackgroundUC
  };

  Color get textColor => switch (this) {
    text => textUC,
    success => successTextUC,
    primary => primaryTextUC,
    warning => warningTextUC,
    danger => dangerTextUC
  };

  Color get overlayColor => _overlayColor.get(this);


}





class _MasterColorBase {

  final HSVColor hsv;
  final Color color;

  const _MasterColorBase(this.color, this.hsv);

  Color whiter(double level, [double opacity = 1.0]) {
    var whiter = _blend(whiteHSV, hsv, level, opacity);
    return whiter.toColor();
  }

  Color blacker(double level, [double opacity = 1.0]) {
    var darken = _blend(blackHSV, hsv, level, opacity);
    return darken.toColor();
  }

  UniversalColor la(double level, [double opacity = 1.0]) =>
      ld(whiter(level, opacity), blacker(level, opacity));

  UniversalColor lda(double l, double d, [double opacity = 1.0]) =>
      ld(whiter(l, opacity), blacker(d, opacity));

  UniversalColor wld(double l, double d, [double opacity = 1.0]) =>
      ld(whiter(l, opacity), whiter(d, opacity));

  UniversalColor bld(double l, double d, [double opacity = 1.0]) =>
      ld(blacker(l, opacity), blacker(d, opacity));


  static HSVColor _blend(HSVColor from, HSVColor to, double level, double opacity) {
    return HSVColor.fromAHSV(
        opacity,
        to.hue,
        from.saturation - (from.saturation - to.saturation) * level,
        from.value - (from.value - to.value) * level);
  }
}

class _MasterColor extends _MasterColorBase {

  _MasterColor(Color color) : super(color, HSVColor.fromColor(color));

}

class _WhiteColor extends _MasterColorBase {

  _WhiteColor() : super(whiteHSV.toColor(), whiteHSV);

  @override
  Color whiter(double level, [double opacity = 1.0]) => blacker(level, opacity);
}

class _BlackColor extends _MasterColorBase {

  _BlackColor() : super(blackHSV.toColor(), blackHSV);

  @override
  Color blacker(double level, [double opacity = 1.0]) => whiter(level, opacity);
}
