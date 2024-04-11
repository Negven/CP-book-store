

import 'package:client/@app/app_section.dart';
import 'package:client/@main/pages/not_found_page.dart';
import 'package:client/classes/pages.dart';
import 'package:client/service/_services.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:client/widgets/section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';


class Root extends StatelessWidget { // RootWidget - conflict with flutter

  static final Logger _logger = Logger((Root).toString());
  static String _previousPath = "";

  final _section = EmptySection.instance.obs;

  Root._private();

  // NB! Can be called multiple times with same args as it called after build
  navigateTo(String path, PageBuilder pageBuilder) {

    if (_previousPath == path) {
      return;
    }

    _logger.info("navigateTo $path");

    var section = EmptySection.instance;
    if (pageBuilder != NotFoundPage.new) {
      section =  AppSection.instance;
    }

    _section.value = section;
    _section.value.setPage(pageBuilder);
    _previousPath = path;

    CallUtils.onNextFrame(Services.navigation.triggerNavigation);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        color: context.color4background,
        child: Obx(() => _section.value)
    );

  }

  static final Root instance = Root._private();

}


