import 'package:client/classes/sizes.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:flutter/material.dart';

// Тип поверхні.
enum SurfaceType {
  filled(true), // заповнена
  text(false), // текстова
  outlined(false); // межова

  final bool isFilled; // заповнено
  const SurfaceType(this.isFilled);
}

// Позиція іконки.
enum IconPosition {
  prefix, // префікс
  suffix; // суфікс

  static const base = prefix; // базова
}

// Товщина шрифту.
enum TextWeight {
  normal, // звичайний
  medium, // середній
  bold, // жирний
  extra, // додатковий
  ultra; // надзвичайний
}

// Орієнтація макету.
enum LayoutOrientation {
  horizontal, // горизонтальна
  vertical; // вертикальна

  static const base = horizontal; // базова
}

// Вирівнювання контуру.
enum StrokeAlignment {
  inside(BorderSide.strokeAlignInside), // всередині
  center(BorderSide.strokeAlignCenter), // по центру
  outside(BorderSide.strokeAlignOutside); // зовні

  final double value; // значення
  const StrokeAlignment(this.value); // конструктор

  static const base = inside; // базове
}

// Універсальний шаблон.
class UniversalTemplate {
  final SurfaceType? type; // тип
  final ColorTheme? theme; // тема
  final Color? textColor; // колір тексту
  final Color? borderColor; // колір межі
  final Color? overlayColor; // колір накладання
  final Color? backgroundColor; // колір фону
  final SizeVariant? size; // розмір
  final SizeVariant? elevationSize; // висота
  final SizeVariant? radiusSize; // радіус
  final SizeVariant? borderSize; // товщина межі
  final SizeVariant? paddingSize; // розмір відступу
  final PaddingType? paddingType; // тип відступу
  final SurfaceShape? shape; // форма
  final AlignmentGeometry? textAlignment; // вирівнювання тексту
  final StrokeAlignment? strokeAlignment; // вирівнювання контуру
  final SizeVariant? textSize; // розмір тексту
  final Color? iconColor; // колір іконки
  final SizeVariant? iconSize; // розмір іконки
  final IconPosition? iconPosition; // позиція іконки
  final TextWeight? textWeight; // товщина тексту
  final SizeVariant? spaceSize; // розмір проміжку
  final LayoutOrientation? layoutOrientation; // орієнтація макету
  final Gradient? underBorder; // під межею
  final int _hashCode; // хеш-код

  UniversalTemplate({
    this.theme,
    this.shape,
    this.type,
    this.textWeight,
    this.size,
    this.paddingSize,
    this.borderSize,
    this.elevationSize,
    this.textSize,
    this.spaceSize,
    this.textAlignment,
    this.iconSize,
    this.textColor,
    this.iconColor,
    this.iconPosition,
    this.backgroundColor,
    this.radiusSize,
    this.paddingType,
    this.overlayColor,
    this.borderColor,
    this.layoutOrientation,
    this.underBorder,
    this.strokeAlignment,
  }) : _hashCode = Object.hashAll([
    theme,
    shape,
    type,
    textWeight,
    size,
    paddingSize,
    borderSize,
    elevationSize,
    textSize,
    spaceSize,
    textAlignment,
    iconSize,
    textColor,
    iconColor,
    iconPosition,
    backgroundColor,
    radiusSize,
    paddingType,
    overlayColor,
    borderColor,
    layoutOrientation,
    underBorder,
    strokeAlignment,
  ]); // конструктор

  @override
  int get hashCode => _hashCode; // хеш-код

  @override
  bool operator ==(Object other) {
    return other is UniversalTemplate && (_hashCode == other._hashCode);
  } // оператор порівняння

  // Копіювання змінних шаблону.
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
  } // копіювання змінних шаблону
}

// Клас зі значеннями за замовчуванням.
class UniversalTemplateDefaults {
  const UniversalTemplateDefaults(); // конструктор

  // Отримати розмір.
  SizeVariant size(SizeVariant? size, UniversalTemplate? template) =>
      size ?? template?.size ?? SizeVariant.base;

  // Отримати тему.
  ColorTheme theme(ColorTheme? theme, UniversalTemplate? template) =>
      theme ?? template?.theme ?? ColorTheme.base;

  // Отримати колір межі.
  Color borderColor(Color? borderColor, UniversalTemplate? template, ColorTheme theme) =>
      borderColor ?? template?.borderColor ?? theme.borderColor;

  // Отримати колір фону.
  Color backgroundColor(Color? borderColor, UniversalTemplate? template, ColorTheme theme) =>
      borderColor ?? template?.backgroundColor ?? theme.backgroundColor;

  // Отримати колір тексту.
  Color textColor(Color? textColor, UniversalTemplate? template, ColorTheme theme) =>
      textColor ?? template?.textColor ?? theme.textColor;

  // Отримати колір накладання.
  Color overlayColor(Color? overlayColor, UniversalTemplate? template, ColorTheme theme) =>
      overlayColor ?? template?.overlayColor ?? theme.overlayColor;
}

// Константа шаблону за замовчуванням.
const defaultOf = UniversalTemplateDefaults();
