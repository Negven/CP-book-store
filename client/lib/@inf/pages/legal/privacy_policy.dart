

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/inf_page.dart';
import 'package:client/@inf/pages/legal/legal_notice_template.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/universal/universal_markdown.dart';
import 'package:flutter/material.dart';


class PrivacyPolicy extends InfPage {

  const PrivacyPolicy({super.key});

  @override
  List<Widget> buildSections(BuildContext context) {
    return [
      LegalNoticeTemplate(
          route: InfRoute.privacyPolicy,
          title: 'privacyPolicy_title'.T,
          date: 'privacyPolicy_date'.T,
          child: UniversalMarkdown('privacyPolicy'.T)
      )
    ];
  }

}
