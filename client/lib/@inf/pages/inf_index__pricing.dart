

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/pages/inf_index__section.dart';
import 'package:client/@inf/pages/inf_index__sign_in_buttons.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/font_utils.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';


class PricingFeature {

  final String title;
  final bool isFree;

  const PricingFeature(this.title, [this.isFree = true]);

}

class PricingVariant extends StatelessWidget {

  final bool isFree;
  final String title;
  final String subtitle;
  final double maxWidth;


  const PricingVariant({super.key, required this.isFree, required this.title, required this.subtitle, required this.maxWidth});

  @override
  Widget build(BuildContext context) {

    final column = [
      Text(title, style: context.texts.titleLarge, textAlign: TextAlign.center,),
      sizes.sizedBoxV.md,
      Text(subtitle, style: context.texts.labelLarge, textAlign: TextAlign.center),
      sizes.sizedBoxV.lg,
    ];

    final features = [
      PricingFeature('infPage_pricing_starterFeature1'.T),
      PricingFeature('infPage_pricing_starterFeature2'.T),
      PricingFeature('infPage_pricing_starterFeature3'.T),
      PricingFeature('infPage_pricing_starterFeature4'.T),
      PricingFeature('infPage_pricing_starterFeature5'.T),
      PricingFeature('infPage_pricing_starterFeature6'.T),
      PricingFeature('infPage_pricing_starterFeature7'.T),
      PricingFeature('infPage_pricing_premiumFeature1'.T, false),
      PricingFeature('infPage_pricing_premiumFeature2'.T, false)
    ];

    for (var feature in features) {
      final isIncluded = !isFree || feature.isFree;
      final icon = isIncluded ? FontIcon.add : FontIcon.subtract;
      column.add(Space.row(children: [
        icon.fontIcon(color: isIncluded ? context.color4action : context.color4disabled),
        Expanded(child: Text(feature.title, maxLines: 1, overflow: TextOverflow.ellipsis))
      ]));
      column.add(sizes.sizedBoxV.sm);
    }

    return Material(
      elevation: sizes.elevation.sm,
      color: context.colors.backgroundL0,
      shadowColor: context.colors.shadow,
      borderRadius: BorderRadius.all(sizes.radiusCircular.md),
      child: Container(
        padding: sizes.insetsVH.lg,
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: column
        ),
      ),
    );
  }

}

class InfIndex$Pricing extends InfPage$Section {

  const InfIndex$Pricing({super.key}) : super(section : InfRoute.pricing);


  @override
  Widget build(BuildContext context) {

    final paddingSize = ScreenWidth.isSmOrLess ? SizeVariant.md : SizeVariant.lg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: wrapSection(context, [
        ResponsiveLine(
          content: (info) => Padding(padding: sizes.insetsVH.get(paddingSize), child: PricingVariant(maxWidth: info.maxWidth, isFree: false, title: 'infPage_pricing_premium'.T, subtitle: 'infPage_pricing_premiumPrice'.T)),
          icon: (info) => Padding(padding: sizes.insetsVH.get(paddingSize), child: PricingVariant(maxWidth: info.maxWidth, isFree: true, title: 'infPage_pricing_starter'.T, subtitle: 'infPage_pricing_starterPrice'.T)),
          iconFirst: true,
        ),
        SizedBox(height: sizes.s6R),
        ResponsiveLine(
          content: (info) => Padding(padding: sizes.insetsVH.lg, child: Text('infPage_pricing_stopAction'.T, style: context.titleLarge, textAlign: TextAlign.center)),
          icon: (info) => context.toSvgLD(Illustration.chasingMoney,
              width: info.iconWidth,
              height: info.iconHeight
          ),
          iconFirst: true,
        ),
        SizedBox(height: sizes.s6R),
        ResponsiveLine(
          content: (info) => SignInButtons(
              children: [
                Padding(padding: sizes.insetsVH.lg, child: Text('infPage_pricing_growAction'.T, style: context.titleLarge, textAlign: TextAlign.center,)),
                Text('infPage_pricing_growAction_now'.T, style: context.texts.displayMedium!.copyWith(color: context.color4action, fontVariations: VariableWeight.ultra), textAlign: TextAlign.center)
              ]
          ),
          icon: (info) => context.toSvgLD(Illustration.growingMoney,
              width: info.iconWidth,
              height: info.iconHeight
          ),
        ),
      ]),
    );
  }

}


