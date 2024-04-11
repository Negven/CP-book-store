import 'package:client/@main/main_routes.dart';
import 'package:client/@main/pages/not_found_page.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:client/widgets/page_placeholder.dart';
import 'package:client/widgets/root.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Побудова маршрутів
GoRouter buildRoutes () {

  // Створення маршрутів GoRouter з використанням мапи шляхів
  final goRoutes = pathToRoute.entries.map((e) => GoRoute(
      path: e.key,
      redirect: e.value.redirect == null ? null : (c, s) => e.value.redirect!(s.fullPath!),
      builder: build(e.value.widget)
  )).sorted((r1, r2) => -r1.path.length.compareTo(r2.path.length) );

  // Повернення екземпляру GoRouter з визначеними маршрутами
  return GoRouter(
    errorBuilder: build(NotFoundPage.new),
    navigatorKey: Get.key, // NB! Making GetX lib work with GoRouter, needed at least for Get.isDakMode
    routes: goRoutes,
  );
}

// Псевдонім для функції побудови маршруту
typedef RouteBuilder = Widget Function(BuildContext, GoRouterState);

// Функція для перевірки правильності побудови маршруту
Widget assertBuilder(BuildContext c, GoRouterState s) {
  throw "This builder should not be called";
}

// Функція для побудови маршруту
RouteBuilder build(PageBuilder? pageBuilder) {

  if (pageBuilder == null) return assertBuilder;

  return (BuildContext context, GoRouterState state) {
    CallUtils.onNextFrame(() => Root.instance.navigateTo(state.matchedLocation, pageBuilder));
    return const PagePlaceholder();
  };
}
