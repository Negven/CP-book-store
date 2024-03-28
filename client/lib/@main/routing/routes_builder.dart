

import 'package:client/@main/main_routes.dart';
import 'package:client/@main/pages/not_found_page.dart';
import 'package:client/@main/routing/auth_guard.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:client/widgets/page_placeholder.dart';
import 'package:client/widgets/root.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';



GoRouter buildRoutes () {

  // NB! GoRouter works not in the same way as WebRouter
  // SAME: matches path of url to page
  // DIFF: sub routes placed on top of parent route, to make MOBILE-back works by layers, not by pages as WEB-back.
  // Temp solution for now: make all routes linear.

  final goRoutes = pathToRoute.entries.map((e) => GoRoute(
      path: e.key,
      redirect: e.value.redirect == null ? null : (c, s) => e.value.redirect!(s.fullPath!),
      builder: build(e.value.widget)
  )).sorted((r1, r2) => -r1.path.length.compareTo(r2.path.length) );

  return GoRouter(
      errorBuilder: build(NotFoundPage.new),
      navigatorKey: Get.key, // NB! Making GetX lib work with GoRouter, needed at least for Get.isDakMode
      routes: goRoutes,
      redirect: authGuard
  );
}

typedef RouteBuilder = Widget Function(BuildContext, GoRouterState);

Widget assertBuilder(BuildContext c, GoRouterState s) {
  throw "This builder should not be called";
}

RouteBuilder build(PageBuilder? pageBuilder) {

  if (pageBuilder == null) return assertBuilder;

  return (BuildContext context, GoRouterState state) {
    CallUtils.onNextFrame(() => Root.instance.navigateTo(state.matchedLocation, pageBuilder));
    return const PagePlaceholder();
  };
}