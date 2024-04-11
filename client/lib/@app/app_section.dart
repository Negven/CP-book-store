import 'package:client/@app/widgets/menu__horizontal.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/classes/types.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/section.dart';
import 'package:flutter/material.dart';



// Клас для розділу додатку
class AppSection extends ASection {
  AppSection._private(); // Приватний конструктор

  @override
  Widget build(BuildContext context) {
    // Визначення положення верхнього краю в залежності від наявності меню
    final top =  sizes.menuTopHeight;
    final left = (sizes.w100 - sizes.containerWidth) / 2;

    // Список дочірніх віджетів
    final children = [
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: context.colors.backgroundGradient,
            )
        ),
      ),
      Positioned(
          top: top,
          left: left,
          height: sizes.h100 - top,
          width: sizes.containerWidth,
          child: pageObx // NB! Must remains at the same position in widget tree to prevent State of stateful widgets recreation
      ),
      sizes.w100 > 800 ? const Menu$Horizontal$Top() : Empty(),

    ];
    // Використання Stack для збереження положення віджета сторінки в одному місці в дереві віджетів, щоб уникнути перестворення стану стейтфул-віджетів
    return Scaffold(
      appBar: sizes.w100 < 800 ? AppBar() : null,
      body: Stack(
        children: children,
      ),
      drawer: sizes.w100 < 800 ? Drawer(
          child: MenuHorizontal()
      ) : null,
    );
  }

  // Статичний екземпляр класу
  static final ASection instance = AppSection._private();
}
