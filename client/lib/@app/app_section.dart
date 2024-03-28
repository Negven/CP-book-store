

// import 'package:client/@app/widgets/menu__vertical.dart';
import 'package:client/@app/widgets/menu__horizontal.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/classes/types.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/section.dart';
import 'package:flutter/material.dart';


class Menu$Horizontal$Bottom extends StatelessWidget {

  const Menu$Horizontal$Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints.tightFor(height: sizes.menuBottomHeight, width: sizes.menuHorizontalWidth), child: const Center(child: Empty(),),);
  }

}


class AppSection extends ASection {

  AppSection._private();

  @override
  Widget build(BuildContext context) {

    // bool menu = sizes.content.isMenuVisible;
    bool menu = false;
    final top = menu ? 0.0 : sizes.menuTopHeight;
    final left = (sizes.w100 - sizes.containerWidth) / 2;

    final Children children = [
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
      // menu ? const Menu$Vertical() : Empty.instance,
      // menu ? const Menu$Horizontal$Top() : Empty.instance,
      menu ? Empty.instance : Positioned(
        left: 0,
        top: sizes.h100 - sizes.menuBottomHeight,
        height: sizes.menuBottomHeight,
        width: sizes.menuHorizontalWidth,
          child: const Menu$Horizontal$Bottom()
      ),
    ];

    // NB! Using Stack to remain page widget at the same position in widget tree to prevent State of stateful widgets recreation
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

  static final ASection instance = AppSection._private();

}