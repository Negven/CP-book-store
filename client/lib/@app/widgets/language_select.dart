

import 'package:client/classes/sized_value.dart';
import 'package:client/enum/language_code.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/material/outlined_popup_menu_button.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';


class LanguageSelect extends StatelessWidget {

  final SizeVariant elevation;
  const LanguageSelect({super.key, this.elevation = SizeVariant.base});

  @override
  Widget build(BuildContext context) {
    return OutlinedPopupMenuButton<LanguageCode>(
        initialValue: LanguageCode.now,
        onSelected: (LanguageCode code) => Services.translations.setLanguage(code),
        builder: (showMenu) => UniversalButton(
              elevation: elevation,
              icon: FontIcon.translate,
              template: context.templates.menuCircleButton,
              onPressed: showMenu
          ),
        itemBuilder: (BuildContext context) {
          return LanguageCode.values.map((code) => PopupMenuItem<LanguageCode>(
            value: code,
            child: Text('language_${code.name}'.T),
          )).toList();
      }
    );
  }

}

