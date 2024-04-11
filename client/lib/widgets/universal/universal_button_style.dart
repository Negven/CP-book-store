
import 'package:client/classes/sizes.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:flutter/material.dart';

// UniversalButtonStyle - клас, що визначає стиль універсальної кнопки.
class UniversalButtonStyle extends UniversalTemplate {

  @override ColorTheme get theme => super.theme!;
  @override Color get textColor => super.textColor!;
  @override Color get borderColor => super.borderColor!;
  @override Color get backgroundColor => super.backgroundColor!;
  @override SurfaceType get type => super.type!;
  @override SizeVariant get elevationSize => super.elevationSize!;
  @override SizeVariant get size => super.size!;
  @override SizeVariant get radiusSize => super.radiusSize!;
  @override SizeVariant get textSize => super.textSize!;
  @override SizeVariant get iconSize => super.iconSize!;
  @override IconPosition get iconPosition => super.iconPosition!;
  @override SurfaceShape get shape => super.shape!;
  @override TextWeight get textWeight => super.textWeight!;
  @override SizeVariant get paddingSize => super.paddingSize!;
  @override SizeVariant get borderSize => super.borderSize!;
  @override SizeVariant get spaceSize => super.spaceSize!;
  @override LayoutOrientation get layoutOrientation => super.layoutOrientation!;
  @override AlignmentGeometry get textAlignment => super.textAlignment!;
  @override StrokeAlignment get strokeAlignment => super.strokeAlignment!;
  @override PaddingType get paddingType => super.paddingType!;
  @override Color get overlayColor => super.overlayColor!;

  UniversalButtonStyle._private({
    required super.textColor,
    required super.iconColor,
    required super.backgroundColor,
    required super.borderColor,
    required super.theme,
    required super.shape,
    required super.type,
    required super.textWeight,
    required super.size,
    required super.paddingSize,
    required super.borderSize,
    required super.elevationSize,
    required super.textSize,
    required super.spaceSize,
    required super.layoutOrientation,
    required super.textAlignment,
    required super.iconSize,
    required super.iconPosition,
    required super.radiusSize,
    required super.paddingType,
    required super.overlayColor,
    required super.underBorder,
    required super.strokeAlignment,
  });

// Метод для вирішення стану кнопки.
  MaterialStateProperty<T> resolveWith<T>(T Function(UniversalButtonStyle, Set<MaterialState>) resolver) =>
      MaterialStateProperty.resolveWith((states) => resolver(this, states));
  // Статичний метод для створення стилю кнопки на основі переданих параметрів.
  static UniversalButtonStyle from({
      ColorTheme? theme,
      Color? textColor,
      Color? iconColor,
      Color? overlayColor,
      Color? backgroundColor,
      Color? borderColor,
      SurfaceType? type,
      SizeVariant? elevation,
      SizeVariant? size,
      SizeVariant? fontSize,
      SizeVariant? radius,
      SizeVariant? padding,
      SizeVariant? border,
      SurfaceShape? shape,
      TextWeight? weight,
      SizeVariant? space,
      LayoutOrientation? layoutOrientation,
      AlignmentGeometry? textAlignment,
      StrokeAlignment? strokeAlignment,
      SizeVariant? iconSize,
      IconPosition? iconVariant,
      PaddingType? paddingType,
      Gradient? underBorder,
      UniversalTemplate? template,
    }) {
    // Визначення параметрів за замовчуванням.
    ColorTheme t = defaultOf.theme(theme, template);
    SizeVariant s = defaultOf.size(size, template);

    SizeVariant fs = fontSize ?? template?.textSize ?? s;
    LayoutOrientation lo = layoutOrientation ?? template?.layoutOrientation ?? LayoutOrientation.base;
    var isVertical = lo == LayoutOrientation.vertical;
    SizeVariant p = padding ?? template?.paddingSize ?? (isVertical ? s.bigger : s);
    // Створення та повернення стилю кнопки з врахуванням переданих параметрів.
    return UniversalButtonStyle._private(
        theme: t,
        textColor: defaultOf.textColor(textColor, template, t),
        iconColor: iconColor ?? template?.iconColor,
        borderColor: defaultOf.borderColor(borderColor, template, t),
        overlayColor: defaultOf.overlayColor(overlayColor, template, t),
        backgroundColor: defaultOf.backgroundColor(backgroundColor, template, t),
        size: s,
        textSize: fs,
        elevationSize: elevation ?? template?.elevationSize ?? SizeVariant.none,
        paddingSize: p,
        type: type ?? template?.type ?? SurfaceType.filled,
        borderSize: border ?? template?.borderSize ?? (type == SurfaceType.outlined ? s : SizeVariant.none),
        shape: shape ?? template?.shape ?? SurfaceShape.base,
        textWeight: weight ?? template?.textWeight ?? TextWeight.medium,
        spaceSize: space ?? template?.spaceSize ?? s,
        layoutOrientation: lo,
        textAlignment: textAlignment ?? template?.textAlignment ?? (isVertical ? Alignment.center : Alignment.centerLeft),
        strokeAlignment: strokeAlignment ?? template?.strokeAlignment ?? StrokeAlignment.base,
        iconPosition: iconVariant ?? template?.iconPosition ?? IconPosition.base,
        iconSize: iconSize ?? (isVertical ? s.bigger.bigger : s),
        radiusSize: radius ?? template?.radiusSize ?? (isVertical ? s.bigger : s),
        paddingType: paddingType ?? template?.paddingType ?? PaddingType.base,
        underBorder: underBorder ?? template?.underBorder
    );

  }

}

// Розширення для набору станів MaterialState.
extension MaterialStates on Set<MaterialState> {
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isActive => !isDisabled;
  bool get isFocused => contains(MaterialState.focused) || contains(MaterialState.hovered) || contains(MaterialState.selected);
  bool get isPressed => contains(MaterialState.pressed);

}
