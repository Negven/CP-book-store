

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/pages/inf_index__section.dart';
import 'package:client/@inf/widgets/responsive_line.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/global_event.dart';
import 'package:client/enum/svg.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/svg_utils.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InfIndex$WhoWeAre extends InfPage$Section {

  const InfIndex$WhoWeAre({super.key}) : super(section : InfRoute.whoWeAre);

  @override
  Widget build(BuildContext context) =>
    TeamContent(section: section);

}


class TeamContent extends StatefulWidget {

  final InfRoute section;

  const TeamContent({super.key, required this.section});

  @override
  State<StatefulWidget> createState() => TeamState();

}

class _TeamMember {

  final String? icon;
  final String name;
  final String title;

  final String techSkills;
  final int experience;
  final String hobby;

  bool get isHiring => icon == null;

  const _TeamMember(String? icon, this.name, this.title, this.techSkills, this.experience, this.hobby) : icon = icon != null ? "assets/@inf/team/$icon" : null;

}

class _TeamPair {

  final _TeamMember left;
  final _TeamMember right;

  const _TeamPair({required this.left, required this.right});
}




class TeamState extends UtilizableState<TeamContent> {

  late final showTeamMembers = u(false.obs);

  @override
  Widget build(BuildContext context) =>
      Obx(() => showTeamMembers.value ? buildMembers(context) : buildInfo(context));

  Widget buildInfo(BuildContext context) {

    final org = [
      'Spendly AS',
      '${'infPage_whoWeAre_orgNo'.T}: 928 182 754',
      '',
      'Oslo, St.Olavs gate 8A',
      'Norway, 0165'
    ].join('\n');

    final lines = [
      IconTextLine(Illustration.ourTeam, 'infPage_whoWeAre_team'.T, 'infPage_whoWeAre_teamDetails'.T),
      IconTextLine(Illustration.norwayMap, 'infPage_whoWeAre_legal'.T, org),
    ];

    print(">> T ${context.colors.text} A ${context.color4action} Error ${context.colors.error} B0 ${context.colors.backgroundL0} B1 ${context.colors.backgroundL1} B2 ${context.colors.backgroundL2}");

    final children = lines.map<Widget>((f) => ResponsiveLine(content: (info) {

      bool showDetailsToggle = f.icon == Illustration.ourTeam;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sizes.sizedBoxV.xs,
            Text(f.title, style: context.textTheme.titleLarge),
            sizes.sizedBoxV.md,
            Text(f.details, style: context.textTheme.bodyLarge),
            if (showDetailsToggle) sizes.sizedBoxV.md,
            if (showDetailsToggle) Row(children: [UniversalOutlinedButton(text: 'infPage_whoWeAre_showTeam'.T, onPressed: () => showTeamMembers.value = true)]),
            sizes.sizedBoxV.xxl,
          ]
      );
    }, icon: (info) => context.toSvgLD(Illustration.ourTeam, width: info.iconWidth, height: info.iconHeight),
      iconFirst: f.icon == Illustration.norwayMap,
    )).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: context.wrapSection(widget.section, children),
    );
  }


  Widget buildMembers(BuildContext context) {

    final pairs = [
      _TeamPair(
        right: _TeamMember('andrey.png', 'Andrii Bryl', 'andrey_title'.T, 'andrey_techSkills'.T, 10, 'andrey_hobby'.T),
        left: _TeamMember('igor.png', 'Igor Orlov', 'igor_title'.T, 'igor_techSkills'.T, 10, 'igor_hobby'.T),
      ),
      _TeamPair(
        right: _TeamMember('artur.png', 'Artur Shatailo', 'artur_title'.T, 'artur_techSkills'.T, 5, 'artur_hobby'.T),
        left: _TeamMember(null, 'hiring_name'.T, 'hiring_title'.T, 'hiring_techSkills'.T, 3, 'hiring_hobby'.T),
      ),
    ];

    ResponsiveLineBuilder toLineBuilder(_TeamMember member) => (info) {

      final size = info.avatarSize;

      final Widget image = member.icon != null ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ClipRRect(
                borderRadius: sizes.borderRadiusCircular.xl,
                child: Image(image: AssetImage(member.icon!), width: size, height: size, fit: BoxFit.fill)
            )]
          )
          :
          context.toSvgLD(Illustration.hiring,
              width: size,
              height: size
          );

      final skills = <TableRow>[];

      fillSkill(String title, String value) {
        skills.add(
            TableRow(
                children: [
                  Padding(padding: sizes.insetsVH.xxs, child: Text(title, style: context.texts.m.sm, textAlign: TextAlign.right)),
                  Padding(padding: sizes.insetsVH.xxs, child: Text(value, style: context.texts.n.sm, textAlign: TextAlign.left)),
                ]
            )
        );
      }

      fillSkill('infPage_whoWeAre_techSkills'.T, member.techSkills);
      fillSkill('infPage_whoWeAre_experience'.T, "${member.experience}+ ${'infPage_whoWeAre_experience_years'.T}");
      fillSkill('infPage_whoWeAre_hobby'.T, member.hobby);

      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sizes.sizedBoxV.xxl,
            image,
            sizes.sizedBoxV.lg,
            Text(member.name, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
            sizes.sizedBoxV.xs,
            Text(member.title, style: context.textTheme.bodyLarge, textAlign: TextAlign.center),
            sizes.sizedBoxV.lg,
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: skills,
            ),
            sizes.sizedBoxV.xxl,
          ]
      );
    };

    final children = pairs.map<Widget>((p) => ResponsiveLine(content: toLineBuilder(p.left), icon: toLineBuilder(p.right), iconCenter: false, iconFirst: true)).toList();
    children.add(sizes.sizedBoxV.xxl);
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UniversalOutlinedButton(text: 'infPage_whoWeAre_showCompany'.T, onPressed: ()  {
            showTeamMembers.value = false;
            CallUtils.timeout(() => Services.events.trigger(GlobalEvent.navigateToInfRoute, InfRoute.whoWeAre), 200);
          })
        ]
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: context.wrapSection(widget.section, children),
    );
  }
}