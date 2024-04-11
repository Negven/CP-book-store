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

// Визначення класу для верхнього горизонтального меню
class Menu$Horizontal$Top extends StatelessWidget {
  const Menu$Horizontal$Top({super.key}); // Конструктор

  @override
  Widget build(BuildContext context) {
    // Повернення контейнера з обмеженнями і дочірнім віджетом
    return Container(
      constraints: BoxConstraints.tightFor(width: sizes.menuHorizontalWidth, height: sizes.menuTopHeight),
      child: MenuHorizontal(), // Виклик віджету MenuHorizontal
    );
  }
}

// Визначення класу для кожного пункту меню
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
    // Повернення універсального кнопкового віджету для кожного пункту меню
    return UniversalButton(
      size: SizeVariant.xs,
      onPressed: onPressed,
      icon: icon,
      iconColor: context.iconColor,
      layoutOrientation: LayoutOrientation.vertical,
      text: "$title".T, // Перекладений заголовок
      backgroundColor: context.color4background,
    );
  }
}

// Визначення класу для горизонтального меню
class MenuHorizontal extends StatelessWidget {
  final RxBool isAuth = Services.auth.isSignedIn.obs; // Реактивний булевий тип для статусу аутентифікації

  MenuHorizontal({super.key}); // Конструктор

  // Віджет для кнопки входу
  Widget loginButton(BuildContext context) {
    final (title, callback) = LoginAccountModal.addOne();
    return UniversalTextButton(
      textColor: context.color4text,
      backgroundColor: context.color4background,
      onPressed: callback,
      text: "${"login".T} / ${"reg".T}", // Перекладений текст для входу/реєстрації
    );
  }

  // Віджет для кнопок облікового запису
  Widget accountButtons(BuildContext context) {
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
      ],
    );
  }

  // Метод для встановлення статусу аутентифікації
  setAuth() {
    isAuth.value = Services.auth.isSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    Services.auth.listen(setAuth, instant: true); // Слухання змін статусу аутентифікації
    var items = menuRouts.map((r) {
      var path = routeToPath[r];
      return MenuItem(icon: r.icon, path: path, title: r.route, onPressed: () => Services.navigation.go(path!),); // Створення пунктів меню
    }).toList();
    // Повернення розміщеного  боксу з рядом/колонкою в залежності від ширини екрану
    return SizedBox(
        child: sizes.w100 > 800 ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...items,
            Spacer(),
            ThemeModeToggle(), // Кнопка перемикання теми
            Obx(() => isAuth.value ? accountButtons(context) : loginButton(context)) // Відображення кнопок облікового запису або кнопки входу в залежності від статусу аутентифікації
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...items,
            Spacer(),
            ThemeModeToggle(), // Кнопка перемикання теми
            Obx(() => isAuth.value ? accountButtons(context) : loginButton(context)) // Відображення кнопок облікового запису або кнопки входу в залежності від статусу аутентифікації
          ],
        )
    );
  }
}
