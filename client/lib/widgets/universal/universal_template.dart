
import 'package:client/classes/sizes.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:flutter/material.dart';



enum SurfaceType {

  filled(true),
  text(false),
  outlined(false);

  final bool isFilled;
  const SurfaceType(this.isFilled);

}


enum IconPosition {
  prefix,
  suffix;

  static const base = prefix;
}


enum TextWeight {

  normal,
  medium,
  bold,
  extra,
  ultra;

}

enum LayoutOrientation {
  horizontal,
  vertical;

  static const base = horizontal;
}

enum StrokeAlignment {

  inside(BorderSide.strokeAlignInside),
  center(BorderSide.strokeAlignCenter),
  outside(BorderSide.strokeAlignOutside);

  final double value;
  const StrokeAlignment(this.value);

  static const base = inside;
}

class UniversalTemplate {

  final SurfaceType? type;

  final ColorTheme? theme;
  final Color? textColor;
  final Color? borderColor;
  final Color? overlayColor;
  final Color? backgroundColor;

  final SizeVariant? size;
  final SizeVariant? elevationSize;
  final SizeVariant? radiusSize;
  final SizeVariant? borderSize;
  final SizeVariant? paddingSize;
  final PaddingType? paddingType;

  final SurfaceShape? shape;
  final AlignmentGeometry? textAlignment;
  final StrokeAlignment? strokeAlignment;

  final SizeVariant? textSize;
  final Color? iconColor;
  final SizeVariant? iconSize;
  final IconPosition? iconPosition;

  final TextWeight? textWeight;
  final SizeVariant? spaceSize;
  final LayoutOrientation? layoutOrientation;

  final Gradient? underBorder;

  final int _hashCode;

  UniversalTemplate({this.theme, this.shape, this.type, this.textWeight, this.size, this.paddingSize, this.borderSize, this.elevationSize, this.textSize, this.spaceSize, this.textAlignment, this.iconSize, this.textColor, this.iconColor, this.iconPosition, this.backgroundColor, this.radiusSize, this.paddingType, this.overlayColor, this.borderColor, this.layoutOrientation, this.underBorder, this.strokeAlignment}) :
      _hashCode = Object.hashAll([theme, shape, type, textWeight, size, paddingSize, borderSize, elevationSize, textSize, spaceSize, textAlignment, iconSize, textColor, iconColor, iconPosition, backgroundColor, radiusSize, paddingType, overlayColor, borderColor, layoutOrientation, underBorder, strokeAlignment]);

  @override
  int get hashCode => _hashCode;

  @override
  bool operator ==(Object other) {
    return other is UniversalTemplate && (_hashCode == other._hashCode);
  }

  UniversalTemplate copyWith({
    SurfaceType? type,
    ColorTheme? theme,
    Color? textColor,
    Color? borderColor,
    Color? overlayColor,
    Color? backgroundColor,
    SizeVariant? size,
    SizeVariant? elevationSize,
    SizeVariant? radiusSize,
    SizeVariant? borderSize,
    SizeVariant? paddingSize,
    PaddingType? paddingType,
    SurfaceShape? shape,
    AlignmentGeometry? textAlignment,
    SizeVariant? textSize,
    Color? iconColor,
    SizeVariant? iconSize,
    IconPosition? iconPosition,
    TextWeight? textWeight,
    SizeVariant? spaceSize,
    LayoutOrientation? layoutOrientation,
    Gradient? underBorder,
    StrokeAlignment? strokeAlignment,
  }) {
    return UniversalTemplate(
      type: type ?? this.type,
      theme: theme ?? this.theme,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      overlayColor: overlayColor ?? this.overlayColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      size: size ?? this.size,
      elevationSize: elevationSize ?? this.elevationSize,
      radiusSize: radiusSize ?? this.radiusSize,
      borderSize: borderSize ?? this.borderSize,
      paddingSize: paddingSize ?? this.paddingSize,
      paddingType: paddingType ?? this.paddingType,
      shape: shape ?? this.shape,
      textAlignment: textAlignment ?? this.textAlignment,
      textSize: textSize ?? this.textSize,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      iconPosition: iconPosition ?? this.iconPosition,
      textWeight: textWeight ?? this.textWeight,
      spaceSize: spaceSize ?? this.spaceSize,
      layoutOrientation: layoutOrientation ?? this.layoutOrientation,
      underBorder: underBorder ?? this.underBorder,
      strokeAlignment: strokeAlignment ?? this.strokeAlignment,
    );
  }

}

class UniversalTemplateDefaults {

  const UniversalTemplateDefaults();

  SizeVariant size(SizeVariant? size, UniversalTemplate? template) =>
      size ?? template?.size ?? SizeVariant.base;

  ColorTheme theme(ColorTheme? theme, UniversalTemplate? template) =>
      theme ?? template?.theme ?? ColorTheme.base;

  Color borderColor(Color? borderColor, UniversalTemplate? template, ColorTheme theme) =>
      borderColor ?? template?.borderColor ?? theme.borderColor;

  Color backgroundColor(Color? borderColor, UniversalTemplate? template, ColorTheme theme) =>
      borderColor ?? template?.backgroundColor ?? theme.backgroundColor;

  Color textColor(Color? textColor, UniversalTemplate? template, ColorTheme theme) =>
      textColor ?? template?.textColor ?? theme.textColor;

  Color overlayColor(Color? overlayColor, UniversalTemplate? template, ColorTheme theme) =>
      overlayColor ?? template?.overlayColor ?? theme.overlayColor;

}

const defaultOf = UniversalTemplateDefaults();
