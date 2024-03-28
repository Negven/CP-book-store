

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/pages/inf_index__section.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/math_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class InfIndex$HowItWorks extends InfPage$Section {

  const InfIndex$HowItWorks({super.key}) : super(section : InfRoute.howItWorks);

  @override
  Widget build(BuildContext context) {

    final lines = [
      IconTextLine(Illustration.howItWorksStep1, 'infPage_howItWorks_step1'.T, 'infPage_howItWorks_step1Details'.T),
      IconTextLine(Illustration.howItWorksStep2, 'infPage_howItWorks_step2'.T, 'infPage_howItWorks_step2Details'.T),
      IconTextLine(Illustration.howItWorksStep3, 'infPage_howItWorks_step3'.T, 'infPage_howItWorks_step3Details'.T),
    ];

    final children = lines.map<Widget>((f) => ResponsiveLine(content: (info) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sizes.sizedBoxV.xs,
            Text(f.title, style: context.textTheme.titleLarge),
            sizes.sizedBoxV.md,
            Text(f.details, style: context.textTheme.bodyLarge),
            sizes.sizedBoxV.xxl,
          ]
      );
    }, icon: (info) =>
        Padding(
            padding: sizes.insetsV.md,
            child: context.toSvgLD(f.icon,
                width: MathUtils.multiply(info.iconWidth, 0.8),
                height: MathUtils.multiply(info.iconHeight, 0.8)
            )
        )

    )).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: wrapSection(context, children),
    );
  }

}



