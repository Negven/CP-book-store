

import 'package:client/@inf/enum/inf_route.dart';
import 'package:client/@inf/inf_page.dart';
import 'package:client/@inf/pages/legal/legal_notice_template.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/universal/universal_markdown.dart';
import 'package:flutter/material.dart';


class TermsOfService extends InfPage {

  const TermsOfService({super.key});

  @override
  List<Widget> buildSections(BuildContext context) {
    return [
      LegalNoticeTemplate(
          route: InfRoute.termsOfService,
          title: 'termsOfService_title'.T,
          date: 'termsOfService_date'.T,
          child: UniversalMarkdown('termsOfService'.T)
      )
    ];
  }

}
