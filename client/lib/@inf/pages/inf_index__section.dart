

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/material.dart';



extension InfPage$Common on BuildContext {

  TextStyle get titleLarge => texts.b.lg;

  List<Widget> wrapSection(InfRoute section, List<Widget> widgets) {
    widgets.insert(0, sizes.sizedBoxV.xxl);
    widgets.insert(1, Text(section.title.toUpperCase(), style: titleLarge, textAlign: TextAlign.center));
    widgets.insert(2, sizes.sizedBoxV.xl);

    widgets.add(sizes.sizedBoxV.xxl);
    widgets.add(sizes.sizedBoxV.xxl);
    return widgets;
  }

}

class IconTextLine {

  final Illustration icon;
  final String title;
  final String details;

  const IconTextLine(this.icon, this.title, this.details);

}

abstract class InfPage$Section extends StatelessWidget {

  final InfRoute section;

  const InfPage$Section({super.key, required this.section});

  List<Widget> wrapSection(BuildContext context, List<Widget> widgets) =>
    context.wrapSection(section, widgets);

}

