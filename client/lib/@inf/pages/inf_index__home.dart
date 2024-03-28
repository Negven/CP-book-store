

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/pages/inf_index__section.dart';
import 'package:client/@inf/pages/inf_index__sign_in_buttons.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InfIndex$Home extends InfPage$Section {

  const InfIndex$Home({super.key}) : super(section : InfRoute.home);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLine(
      content: (info) {

        final textStyle = info.isColumn ? context.textTheme.displaySmall : context.textTheme.displayMedium;

        final ultraStyle = textStyle!.copyWith(
            fontVariations: VariableWeight.ultra,
        );

        return SignInButtons(
          children: [
            Text("infPage_home_grow".T, style: ultraStyle, textAlign: TextAlign.end),
            Text("infPage_home_plan".T, style: ultraStyle, textAlign: TextAlign.center),
            Text("infPage_home_track".T, style: ultraStyle, textAlign: TextAlign.left),
          ]
        );
      },
      icon: (info) => Stack(alignment: Alignment.center, children: [
          DropShadow(color: context.colors.shadow, blurRadius: sizes.elevation.sm, offset: const Offset(0, 0),
              child: context.toSvgLD(Illustration.paymentWithCardBottom, width: info.iconWidth, height: info.iconHeight)),
          context.toSvgLD(Illustration.paymentWithCardTop, width: info.iconWidth, height: info.iconHeight)
        ])
    );
  }

}
