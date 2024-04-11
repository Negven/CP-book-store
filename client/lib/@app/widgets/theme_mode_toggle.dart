import 'package:client/classes/sized_value.dart';
import 'package:client/service/_services.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:flutter/material.dart';

import '../../widgets/universal/universal_button.dart';

// Визначення класу для перемикача теми
class ThemeModeToggle extends StatelessWidget {

  final SizeVariant elevation;
  const ThemeModeToggle({super.key, this.elevation = SizeVariant.base}); // Конструктор зі значенням за замовчуванням для висоти

  @override
  Widget build(BuildContext context) {
    // Повернення універсального кнопкового віджету для перемикача теми
    return UniversalButton(
        elevation: elevation,
        template: context.templates.menuCircleButton,
        icon: FontIcon.themeMode,
        onPressed: () => Services.themes.toggleTheme() // Виклик методу для зміни теми
    );
  }

}
