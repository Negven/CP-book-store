

import 'package:client/classes/sized_value.dart';
import 'package:client/service/_services.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';


class ThemeModeToggle extends StatelessWidget {

  final SizeVariant elevation;
  const ThemeModeToggle({super.key, this.elevation = SizeVariant.base});

  @override
  Widget build(BuildContext context) {
    return UniversalButton(
      elevation: elevation,
      template: context.templates.menuCircleButton,
      icon: FontIcon.themeMode,
      onPressed: () => Services.themes.toggleTheme()
    );
  }

}

