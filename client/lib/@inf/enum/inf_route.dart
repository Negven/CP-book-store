
import 'package:client/classes/pages.dart';
import 'package:client/classes/utilizable_state.dart';
import 'package:client/enum/global_event.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/scroll_utils.dart';
import 'package:flutter/cupertino.dart';

enum InfRoute {

  home,
  privacyPolicy(Pages.privacyPolicy),
  termsOfService(Pages.termsOfService),

  features,
  howItWorks,
  whoWeAre,
  pricing;

  final String page;
  const InfRoute([this.page = Pages.inf]);

  static final inTopMenu = [features, howItWorks, whoWeAre, pricing];
  static final indexSections = [home, ...inTopMenu];

  static final Map<InfRoute, GlobalKey> _keys = ConvertUtils.mapFrom(InfRoute.values, (v) => GlobalKey());

  GlobalKey get key => _keys[this]!;
  String get title => "infPageSection_$name".T;
  void go() => goTo(this);

  static navigation(U u) {
    u(Services.events.listen(GlobalEvent.navigateToInfRoute, (InfRoute route) {

      if (route.key.currentContext == null) {
        Services.navigation.go(route.page);
        CallUtils.callAsNotNull(() => route.key.currentContext, ScrollUtils.scrollFastTo, delayBeforeCall: 300); // giving time to render the page fully
      } else {
        ScrollUtils.scrollSlowTo(route.key.currentContext);
      }

    }));
  }

  static goTo(InfRoute pageSection) {
    Services.events.trigger(GlobalEvent.navigateToInfRoute, pageSection);
  }

}