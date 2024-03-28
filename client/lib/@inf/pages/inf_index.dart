

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/inf_page.dart';
import 'package:client/@inf/pages/inf_index__features.dart';
import 'package:client/@inf/pages/inf_index__home.dart';
import 'package:client/@inf/pages/inf_index__how_it_workds.dart';
import 'package:client/@inf/pages/inf_index__pricing.dart';
import 'package:client/@inf/pages/inf_index__who_we_are.dart';
import 'package:client/@inf/widgets/centered_content.dart';
import 'package:client/@inf/widgets/top_menu.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/classes/unexpected_error.dart';
import 'package:flutter/material.dart';


class InfIndex extends InfPage {

  const InfIndex({super.key});

  @override
  List<Widget> buildSections(BuildContext context) {
    return InfRoute.indexSections.map<Widget>((route) => Container(
        key: route.key,
        color: toSectionColor(context, InfRoute.indexSections.indexOf(route)),
        padding: EdgeInsets.only(top: TopMenu.height, bottom: TopMenu.height / 2),
        constraints: BoxConstraints(minWidth: double.infinity, minHeight: sizes.h100),
        child: CenteredContent(child: buildSection(route))
    )).toList();
  }

  Widget buildSection(InfRoute section) {
    switch (section) {
      case InfRoute.home: return const InfIndex$Home();
      case InfRoute.features: return const InfIndex$Features();
      case InfRoute.howItWorks: return const InfIndex$HowItWorks();
      case InfRoute.whoWeAre: return const InfIndex$WhoWeAre();
      case InfRoute.pricing: return const InfIndex$Pricing();
      default:
        throw UnexpectedError();
    }
  }

}