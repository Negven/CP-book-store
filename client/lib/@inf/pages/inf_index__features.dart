

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/pages/inf_index__section.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class InfIndex$Features extends InfPage$Section {

  const InfIndex$Features({super.key}) : super(section : InfRoute.features);

  @override
  Widget build(BuildContext context) {

    final lines = [
      IconTextLine(Illustration.anonymous, 'infPage_features_anonymous'.T, 'infPage_features_anonymousDetails'.T),
      IconTextLine(Illustration.centralized, 'infPage_features_centralized'.T, 'infPage_features_centralizedDetails'.T),
      IconTextLine(Illustration.secured, 'infPage_features_secured'.T, 'infPage_features_securedDetails'.T),
      IconTextLine(Illustration.collaborative, 'infPage_features_collaborative'.T, 'infPage_features_collaborativeDetails'.T),
      IconTextLine(Illustration.automate, 'infPage_features_automated'.T, 'infPage_features_automatedDetails'.T),
      IconTextLine(Illustration.crossPlatform, 'infPage_features_crossPlatform'.T, 'infPage_features_crossPlatformDetails'.T),
      IconTextLine(Illustration.customizable, 'infPage_features_customizable'.T, 'infPage_features_customizableDetails'.T)
    ];


    final children = lines.map<Widget>((f) => ResponsiveLine(content: (info) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          sizes.sizedBoxV.xs,
          Text(f.title, style: context.textTheme.titleLarge!.copyWith(color: context.color4text)),
          sizes.sizedBoxV.md,
          Text(f.details, style: context.textTheme.bodyLarge),
          sizes.sizedBoxV.xxl,
        ]
      );
    }, icon: (info) => context.toSvgLD(f.icon, width: info.iconWidth, height: info.iconHeight),
      iconFirst: f.icon.index % 2 == 0,
    )).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: wrapSection(context, children),
    );
  }



}
