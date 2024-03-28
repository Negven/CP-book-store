

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/widgets/centered_content.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/@inf/widgets/top_menu.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:flutter/material.dart';


class LegalNoticeTemplate extends StatelessWidget {

  final InfRoute route;
  final String title;
  final String date;
  final Widget child;

  const LegalNoticeTemplate({super.key, required this.route, required this.title, required this.date, required this.child});

  @override
  Widget build(BuildContext context) {

    var info = ResponsiveLineInfo();
    var width = info.isColumn ? info.maxWidth : info.maxWidth * 2;
    final text = Container(
        constraints: BoxConstraints(maxWidth: width, minWidth: width),
        child: child
    );

    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        SizedBox(height: 2 * TopMenu.height),
        ResponsiveLine(
            icon: (info) => context.toSvgLD(Illustration.privacyPolicy,
                width: info.iconWidth, height: info.iconHeight
            ),
            content: (info) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizes.sizedBoxV.xs,
                  Text(title, style: context.texts.m.xl),
                  sizes.sizedBoxV.md,
                  Text(date, style: context.texts.n.md),
                  sizes.sizedBoxV.xxl,
                ]
            )
        ),
        sizes.sizedBoxV.xxl,
        Center(child: text),
        SizedBox(height: TopMenu.height),
      ]
    );

    return CenteredContent(
      key: route.key,
        child: content
    );
  }

}
