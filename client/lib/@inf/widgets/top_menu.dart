

import 'package:client/@app/widgets/language_select.dart';
import 'package:client/@app/widgets/theme_mode_toggle.dart';
import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/widgets/centered_content.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/material/outlined_popup_menu_button.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/spendly.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';




class TopMenuScaffold extends StatelessWidget {

  const TopMenuScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.color4background,
            border:  Border(bottom: BorderSide(width: sizes.border.sm, color: context.colors.backgroundL1))
        ),
        child: const CenteredContent(child: TopMenu())
    );
  }

}


class TopMenu extends StatelessWidget {

  const TopMenu({super.key});

  static double get height => sizes.s5R;

  @override
  Widget build(BuildContext context) {

    final logoHeight = height - 2 * sizes.s2R;

    final elevation = SizeVariant.none.r(md: SizeVariant.base);
    bool isMenuItemsExpanded = ScreenWidth.now > ScreenWidth.lg;

    Widget? menu;
    if (isMenuItemsExpanded) {
      menu = Space.row(
          size: SizeVariant.sm,
          children: InfRoute.inTopMenu.map((v) => UniversalTextButton(onPressed: v.go, theme: ColorTheme.text, text: v.title, fontSize: SizeVariant.xs)).toList()
      );
    } else {
      menu = OutlinedPopupMenuButton<InfRoute>(
          builder: (showMenu) => UniversalButton(
            elevation: elevation,
            icon: FontIcon.menu,
            shape: SurfaceShape.rectangle,
            template: context.templates.menuCircleButton,
            onPressed: showMenu
          ),
          onSelected: InfRoute.goTo,
          itemBuilder: (BuildContext context) {
            return InfRoute.inTopMenu.map((v) => PopupMenuItem<InfRoute>(
              value: v,
              child: Text(v.title),
            )).toList();
          }
      );
    }

    return Container(
        padding: EdgeInsets.only(left: sizes.paddingH.xs, right: sizes.paddingH.md),
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UniversalButton(
              type: SurfaceType.text,
              theme: ColorTheme.text,
              child: Spendly(height: logoHeight),
              onPressed: () => InfRoute.home.go()
            ),
            if (isMenuItemsExpanded) menu,
            Space.row(
              size: SizeVariant.none.r(md: SizeVariant.md),
              children: [
                ThemeModeToggle(elevation: elevation),
                LanguageSelect(elevation: elevation),
                if (!isMenuItemsExpanded) menu,
              ],
            )
          ],
        ),
    );
  }

}