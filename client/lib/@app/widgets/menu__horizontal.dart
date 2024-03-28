import 'package:client/@app/app_routes.dart';
import 'package:client/@app/modals/login_account_modal/@login_account_modal.dart';
import 'package:client/@app/widgets/theme_mode_toggle.dart';
import 'package:client/@main/main_routes.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/font_icon.dart';

class Menu$Horizontal$Top extends StatelessWidget {

  const Menu$Horizontal$Top({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
        constraints: BoxConstraints.tightFor(width: sizes.menuHorizontalWidth, height: sizes.menuTopHeight),
        child: MenuHorizontal()
    );
  }

}

class MenuItem extends StatelessWidget {
  final FontIcon? icon;
  final String? path;
  final String? title;
  final VoidCallback? onPressed;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.path,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UniversalButton(
      size: SizeVariant.xs,
      onPressed: onPressed,
      // padding: SizeVariant.xs,
      icon: icon,
      iconColor: context.iconColor,
      layoutOrientation: LayoutOrientation.vertical,
      text: "$title".T,
      backgroundColor: context.color4background,
    );
  }
}

class MenuHorizontal extends StatelessWidget {
  final RxBool isAuth = Services.auth.isSignedIn.obs;

  MenuHorizontal({super.key});

  Widget loginButton (BuildContext context) {
    final (title, callback) = LoginAccountModal.addOne();
    return UniversalTextButton(
      textColor: context.color4text,
      backgroundColor: context.color4background,
      onPressed: callback,
      text: "${"login".T} / ${"reg".T}",
    );
  }

  Widget accountButtons (BuildContext context) {
    return Row(
      children: [
        UniversalTextButton(
          backgroundColor: context.color4background,
          textColor: context.color4text,
          text: "basket".T,
          onPressed: () {
            Services.navigation.go(routeToPath[authRouts[0]]!);
          },
        ),
        UniversalTextButton(
          backgroundColor: context.color4background,
          textColor: context.color4text,
          text: "Account",
        ),
        UniversalTextButton(
          backgroundColor: context.color4background,
          textColor: context.color4text,
          onPressed: () {
            Services.auth.logOut();
          },
          text: "Log out",
        ),
      ]
    );
  }


  setAuth() {
    isAuth.value = Services.auth.isSignedIn;
  }


  @override
  Widget build(BuildContext context) {
    Services.auth.listen(setAuth, instant: true);
    var items = menuRouts.map((r) {
      var path = routeToPath[r];
      return MenuItem(icon: r.icon, path: path, title: r.route, onPressed: () => Services.navigation.go(path!),);
    }).toList();
    return SizedBox(
      // width: sizes.containerWidth,
      child: sizes.w100 > 800 ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...items,
          Spacer(),
          ThemeModeToggle(),
          Obx(() => isAuth.value ? accountButtons(context) : loginButton(context))
        ],
      ) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...items,
            Spacer(),
            ThemeModeToggle(),
            Obx(() => isAuth.value ? accountButtons(context) : loginButton(context))

          ],
        )
    );


  }

}