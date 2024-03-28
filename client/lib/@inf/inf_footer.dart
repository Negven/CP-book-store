

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/widgets/top_menu.dart';
import 'package:client/classes/sized_value.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/theme/universal_colors.dart';
import 'package:client/widgets/space.dart';
import 'package:client/widgets/spendly.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/material.dart';


class _Separator extends StatelessWidget {

  const _Separator();

  @override
  Widget build(BuildContext context) => Text('•', style: context.texts.n.xs.copyWith(color: context.colors.inactiveText));

}

class InfFooter extends StatelessWidget {

  final Color color;
  const InfFooter({super.key, required this.color});

  @override
  Widget build(BuildContext context) {

    final homeButton = UniversalTextButton(size: SizeVariant.xs, onPressed: () => InfRoute.home.go(), theme: ColorTheme.text, text: "${SpendlyInfo.title} © 2021-${DateTime.now().year}");
    final privacyPolicyButton = UniversalTextButton(size: SizeVariant.xs, onPressed: () => InfRoute.privacyPolicy.go(), theme: ColorTheme.text, text: 'privacyPolicy_title'.T);
    final termsOfServiceButton = UniversalTextButton(size: SizeVariant.xs, onPressed: () => InfRoute.termsOfService.go(), theme: ColorTheme.text, text: 'termsOfService_title'.T);

    return Container(
      color: color,
      constraints: BoxConstraints.expand(height: TopMenu.height),
      child: Center(child: Space.row(
        size: SizeVariant.xxs,
          children: [homeButton, const _Separator(), privacyPolicyButton, const _Separator(), termsOfServiceButton]
      )),
    );
  }

}

