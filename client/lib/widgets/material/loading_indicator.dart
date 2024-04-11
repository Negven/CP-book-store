
import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {

  final SizeVariant size; // Розмір
  final SizeVariant stroke; // Товщина ліній
  final Color? color; // Колір
  final SurfaceShape shape; // Форма індикатора
  final SizeVariant? radius; // Радіус (для прямокутного індикатора)
  final bool hidden; // Показує, чи прихований індикатор

  const LoadingIndicator.rectangle({super.key, required this.size, this.color, SizeVariant? radius, this.hidden = false})
      : shape = SurfaceShape.rectangle, stroke = size, radius = radius ?? size; // Конструктор для прямокутного індикатора

  const LoadingIndicator.circular({super.key, required this.size, this.color, this.hidden = false, SizeVariant? stroke})
      : shape = SurfaceShape.circle, radius = null, stroke = stroke ?? size; // Конструктор для кругового індикатора

  @override
  Widget build(BuildContext context) {

    final stroke = sizes.progressIndicatorStroke.get(this.stroke); // Отримання товщини лінії
    final color = this.color ?? context.styles.colors.primary; // Отримання кольору або використання основного кольору за замовчуванням
    final backgroundColor = color.withOpacity(color.opacity * 0.2); // Встановлення фонового кольору

    switch (shape) {

      case SurfaceShape.rectangle: // Якщо обрано прямокутну форму

        final indicator = hidden ? Empty.instance : LinearProgressIndicator( // Створення лінійного індикатора
          backgroundColor: backgroundColor, // Фоновий колір
          color: color, // Колір
          minHeight: stroke, // Мінімальна висота
          borderRadius: sizes.borderRadiusCircular.tryGet(radius, BorderRadius.zero), // Закруглення кутів (якщо вказано)
        );

        return SizedBox(
          height: stroke,
          child: indicator,
        );

      case SurfaceShape.circle: // Якщо обрано кругову форму

        final indicator = hidden ? Empty.instance : CircularProgressIndicator( // Створення кругового індикатора
            backgroundColor: backgroundColor,
            color: color,
            strokeWidth: stroke,
            strokeAlign: -1.0
        );

        final size = sizes.progressIndicatorSize.get(this.size); // Отримання розміру

        return SizedBox(
            width: size,
            height: size,
            child: indicator
        );
    }

  }

}
