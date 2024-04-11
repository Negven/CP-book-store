import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';

// Перерахування для кольорів виділення.
enum HighlightColor {
  backgroundL1, // Фоновий колір рівня L1
  backgroundL2; // Фоновий колір рівня L2

  Color of(BuildContext context) {
    final colors = context.colors;
    switch (this) {

      case HighlightColor.backgroundL1:
        return colors.backgroundL1;
      case HighlightColor.backgroundL2:
        return colors.backgroundL2;
    }
  }
}

class UniversalInkWell extends StatelessWidget {
  final Color? hoverColor; // Колір при наведенні
  final HighlightColor? highlightColor; // Колір виділення
  final FocusNode? focusNode; // Вузол фокусу
  final bool canRequestFocus; // Можливість запиту фокусу
  final void Function(bool)? onFocusChange; // Зміна фокусу
  final VoidCallback? onTap; // Обробник натискання
  final SizeVariant? radius; // Радіус скруглення
  final Widget child; // Дитячий віджет

  const UniversalInkWell({
    Key? key,
    this.hoverColor,
    this.highlightColor,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.onTap,
    this.radius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: hoverColor,
      focusColor: Colors.transparent,
      highlightColor: (highlightColor ?? HighlightColor.backgroundL1).of(context), // Вибір кольору виділення
      splashColor: context.colors.secondary, // Колір сплеску
      borderRadius: sizes.borderRadiusCircular.get(radius ?? SizeVariant.base), // Скруглення

      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      onTap: onTap,
      child: child,
    );
  }
}
