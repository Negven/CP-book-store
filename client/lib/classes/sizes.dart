

import 'dart:math';

import 'package:client/classes/sized_value.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

export 'package:client/classes/sized_value.dart';


abstract class _Guidelines {

  static double _v(int v) => double.parse(pow(1.5, v).toStringAsFixed(2));

  static final sCx = _v(11); // 86.50
  static final sBx = _v(10); // 57.66
  static final sAx = _v(09); // 38.44
  static final s9x = _v(08); // 25.62
  static final s8x = _v(07); // 17.08
  static final s7x = _v(06); // 11.39
  static final s6x = _v(05); //  7.59
  static final s5x = _v(04); //  5.06
  static final s4x = _v(03); //  3.38
  static final s3x = _v(02); //  2.25
  static final s2x = _v(01); //  1.50
  static final s1x = _v(00); //  1.00 <- pow(1.5, 00)
  static final sx1 = _v(-1); //  0.67
  static final sx2 = _v(-2); //  0.44
  static final sx3 = _v(-3); //  0.30
  static final sx4 = _v(-4); //  0.20
  static final sx5 = _v(-5); //  0.13
  static final sx6 = _v(-6); //  0.09
  static final sx7 = _v(-7); //  0.06

}


enum PaddingType {

  vh,
  hh,
  v0,
  h0;

  static const base = vh;
}


enum SurfaceShape {

  rectangle,
  circle;

  static const SurfaceShape base = rectangle;

  static SurfaceShape nvl(SurfaceShape? shape) => shape ?? base;
}

// column = in case of mobile in vertical orientation half of total width
class ContentDimensions {

  final int menus;
  final double menuWidth;

  final int columns;
  final double columnWidth;

  double get contentWidth => columns * columnWidth;
  double get totalWidth => menus * menuWidth + contentWidth;
  bool get isMenuVisible => menus > 0;

  const ContentDimensions._({ this.menus = 1, required this.menuWidth, this.columns = minColumns, required this.columnWidth });

  @override
  String toString() => '${menus > 0 ? 'Menu x$menus ($menuWidth px) + ' : ''}Column x$columns ($columnWidth px)';

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) return true;

    return other is ContentDimensions &&
        other.menus == menus &&
        other.menuWidth == menuWidth &&
        other.columns == columns &&
        other.columnWidth == columnWidth;
  }

  @override
  int get hashCode {
    return menus.hashCode ^
    menuWidth.hashCode ^
    columns.hashCode ^
    columnWidth.hashCode;
  }

  static const minColumns = 2;

  static ContentDimensions from(double width, double menu, double content) {

    final column = content / 2;

    if (width < menu + minColumns * column) {
      return ContentDimensions._(menus: 0, columnWidth: width, menuWidth: width);
    }

    int offset = 0;
    while (true) {
      final columns = minColumns - 1 + offset++;
      const menus = 1;
      if (width < menu + (columns + 1) * column) {
        final columnWidth = ((width - menu) / columns).floorToDouble();
        final menuWidth = (width - columns * columnWidth) / menus;
        return ContentDimensions._(menus: menus, menuWidth: menuWidth, columns: columns, columnWidth: columnWidth);
      }

    }

  }

}

// Commonly used values
class Sizes {

  final sCR = _Guidelines.sCx.remR;
  final sBR = _Guidelines.sBx.remR;
  final sAR = _Guidelines.sAx.remR;
  final s9R = _Guidelines.s9x.remR;
  final s8R = _Guidelines.s8x.remR;
  final s7R = _Guidelines.s7x.remR;
  final s6R = _Guidelines.s6x.remR;
  final s5R = _Guidelines.s5x.remR;
  final s4R = _Guidelines.s4x.remR;
  final s3R = _Guidelines.s3x.remR;
  final s2R = _Guidelines.s2x.remR;
  final s1R = _Guidelines.s1x.remR;

  final sx1 = _Guidelines.sx1.rem;

  double get selectableTileHeight => s4R;
  double get walletButton => sizes.s3R + sizes.paddingH.xs;

  final h100 = 100.vh;
  final w100 = 100.vw;

  final h80 = 80.vh;
  final w80 = 80.vw;

  final h40 = 40.vh;
  final w40 = 40.vw;

  final modal = SizedValue(
      xs: _Guidelines.s9x.remR,
      sm: _Guidelines.sAx.remR,
      md: _Guidelines.sBx.remR,
      lg: _Guidelines.sCx.remR
  );

  double get menuVerticalWidth => content.menuWidth;
  double get menuVerticalHeight => h100;

  double get menuHorizontalWidth => w100;
  double get menuHorizontalHeight => content.menuWidth;
  double get menuTopHeight => s5R;
  double get menuBottomHeight => s3R;

  double get bookCardWidth => 250;
  double get bookCardHeight => 550;

  double get containerWidth => w100 > desktopMinWidth ? desktopMinWidth : w100 > tabletMinWidth ? tabletMinWidth : mobileMinWidth;

  double get desktopMinWidth => 1200;
  double get tabletMinWidth => 768;
  double get mobileMinWidth => 360;

  late final ContentDimensions content;

  Sizes._private() {
    content = ContentDimensions.from(ScreenWidth.now.size, modal.xs, modal.sm);
  }



  final progressIndicatorSize = SizedValue(
      xs: _Guidelines.s1x.remR,
      sm: _Guidelines.s2x.remR,
      md: _Guidelines.s3x.remR,
      lg: _Guidelines.s4x.remR,
      xl: _Guidelines.s5x.remR,
      xxl: _Guidelines.s6x.remR
  );

  final progressIndicatorStroke = SizedValue(
      xs: _Guidelines.sx6.remR,
      sm: _Guidelines.sx5.remR,
      md: _Guidelines.sx4.remR,
      lg: _Guidelines.sx3.remR,
      xl: _Guidelines.sx2.remR,
      xxl: _Guidelines.sx1.remR
  );

  final radius = SizedValue(
      xs: _Guidelines.sx3.remR,
      sm: _Guidelines.sx2.remR,
      md: _Guidelines.sx1.remR,
      lg: _Guidelines.s1x.remR,
      xl: _Guidelines.s2x.remR,
  );

  late final radiusCircular = radius.map(Radius.circular);
  late final borderRadiusCircular = radius.map(BorderRadius.circular);
  late final roundedRectangleBorder = borderRadiusCircular.map((brc) => RoundedRectangleBorder(borderRadius: brc));
  late final roundedRectangleBorderMs = roundedRectangleBorder.map(MaterialStatePropertyAll.new);


  // NB! Don't use remR on small values
  final border = SizedValue(
      xs: _Guidelines.sx7.rem,
      sm: _Guidelines.sx6.rem,
      md: _Guidelines.sx5.rem,
      lg: _Guidelines.sx4.remR,
      xl: _Guidelines.sx3.remR,
      xxl: _Guidelines.sx2.remR
  );

  // I - inner
  final paddingI = SizedValue(
      xxs: _Guidelines.sx4.remR,
      xs: _Guidelines.sx3.remR,
      sm: _Guidelines.sx2.remR,
      md: _Guidelines.sx1.remR,
      lg: _Guidelines.s1x.remR,
      xl: _Guidelines.s2x.remR,
      xxl: _Guidelines.s3x.remR
  );

  // V - vertical
  final paddingV = SizedValue(
      xxs: _Guidelines.sx3.remR,
      xs: _Guidelines.sx2.remR,
      sm: _Guidelines.sx1.remR,
      md: _Guidelines.s1x.remR,
      lg: _Guidelines.s2x.remR,
      xl: _Guidelines.s3x.remR,
      xxl: _Guidelines.s4x.remR
  );

  // H - horizontal
  final paddingH = SizedValue(
      xxs: _Guidelines.sx2.remR,
      xs: _Guidelines.sx1.remR,
      sm: _Guidelines.s1x.remR,
      md: _Guidelines.s2x.remR,
      lg: _Guidelines.s3x.remR,
      xl: _Guidelines.s4x.remR,
      xxl: _Guidelines.s5x.remR
  );



  SizedValue<double> padding(PaddingType type) {
    switch (type) {
      case PaddingType.v0:
        return paddingV;
      case PaddingType.h0:
        return paddingH;
      default:
        throw "Can't be used";
    }
  }

  late final insetsVH = SizedValue.mapDuo(paddingV, paddingH, (v, h) => EdgeInsets.symmetric(vertical: v, horizontal: h));
  late final insetsHeadings = SizedValue.mapDuo(paddingV, paddingI, (v, i) => EdgeInsets.only(top: v, bottom: i));

  late final modalInsets = insetsVH.md;
  // NB! Different because buttons takes space and footer looks to wide
  late final modalFooterColumnInsets = modalInsets;
  late final modalFooterRowInsets = EdgeInsets.symmetric(vertical: paddingV.sm, horizontal: paddingH.md);

  late final insetsHH = paddingH.map(EdgeInsets.all);
  late final insetsHHms = insetsHH.map(MaterialStatePropertyAll.new);

  late final insetsH = paddingH.map((ph) => EdgeInsets.symmetric(horizontal: ph));
  late final insetsV = paddingV.map((ph) => EdgeInsets.symmetric(vertical: ph));

  SizedValue<EdgeInsets> _insets(PaddingType type) {
    switch (type) {
      case PaddingType.v0:
        return insetsV;
      case PaddingType.h0:
        return insetsH;
      case PaddingType.vh:
        return insetsVH;
      case PaddingType.hh:
        return insetsHH;
    }
  }

  EdgeInsets insetsBy(PaddingType paddingType, SizeVariant padding) {
    return _insets(paddingType).tryGet(padding, EdgeInsets.zero);
  }


  OutlinedBorder shapeBy(SurfaceShape shape, SizeVariant radius) {
    switch (shape) {
      case SurfaceShape.rectangle:
        return sizes.roundedRectangleBorder.get(radius);
      case SurfaceShape.circle:
        return const CircleBorder();
    }
  }

  late final sizedBoxH = paddingH.map((ph) => SizedBox(width: ph));
  late final sizedBoxV = paddingV.map((ph) => SizedBox(height: ph));

  final elevation = SizedValue(
    sm: _Guidelines.sx2.remR,
    md: _Guidelines.sx1.remR,
  );

  final icon = FontUtils.height.map((f) => FontUtils.toFontSize(f, _Guidelines.s1x.rem).toDouble());
  late final lineHeight = icon.map((v) => v * 1.3);


  static Sizes _cached = Sizes._private();

  static void updateCache() {

    _cached = Sizes._private();

    // if (kDebugMode) {
    //   for (int i = -7; i <= 4; i++) {
    //     print("Space s${ i >= 0 ? '${i + 1}x' : 'x${-i}' } ${FormattingUtils.formatF2(_space(i))} rem = ${FormattingUtils.formatF2(_space(i).rem)} dp");
    //   }
    // }
  }
}


Sizes get sizes => Sizes._cached;
