import 'package:client/classes/sized_value.dart';
import 'package:client/enum/language_code.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/material/outlined_popup_menu_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/universal/universal_button.dart';

// Визначення класу LanguageSelect, який відображає вибір мови
class LanguageSelect extends StatelessWidget {
  // Значення елевації
  final SizeVariant elevation;

  // Конструктор класу LanguageSelect
  const LanguageSelect({super.key, this.elevation = SizeVariant.base});

  @override
  // Метод для побудови інтерфейсу вибору мови
  Widget build(BuildContext context) {
    return OutlinedPopupMenuButton<LanguageCode>(
      // Початкове значення
      initialValue: LanguageCode.now,
      // Обробник вибору мови
      onSelected: (LanguageCode code) => Services.translations.setLanguage(code),
      // Функція для побудови кнопки
      builder: (showMenu) => UniversalButton(
        elevation: elevation,
        icon: FontIcon.translate,
        template: context.templates.menuCircleButton,
        onPressed: showMenu,
      ),
      // Функція для побудови пунктів меню
      itemBuilder: (BuildContext context) {
        return LanguageCode.values.map((code) => PopupMenuItem<LanguageCode>(
          value: code,
          // Відображення мови з використанням локалізованого рядка
          child: Text('language_${code.name}'.T),
        )).toList();
      },
    );
  }
}
