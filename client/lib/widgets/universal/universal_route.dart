

import 'package:client/widgets/font_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;


typedef UniversalRoutes = List<UniversalRoute>;

class UniversalRoute {

  final String? route; // routers to support virtual tree structure
  final String? t;
  final FontIcon? icon;
  final String Function(String location)? redirect;
  final UniversalRoutes? routes;
  final Widget Function()? widget;
  final Object? data;
  final bool Function()? show;

  bool get canShow => show == null || show?.call() == true;

  const UniversalRoute({ this.route, this.t, this.icon, this.redirect, this.data, this.routes, this.show, this.widget });


  static Map<UniversalRoute, String> routeToPath(UniversalRoutes routes) {

    final Map<UniversalRoute, String> mapped = {};

    routes.eachRoute((route, parent) {
      mapped[route] = parent != null ? path.join(mapped[parent]!, route.route ?? '') : route.route ?? '';
    });

    return mapped;
  }

  static Map<String, UniversalRoute> pathToRoute(Map<UniversalRoute, String> routeToPath) =>
     Map<String, UniversalRoute>.fromEntries(
        routeToPath.entries.where((e) => e.key.route != null).map((e) => MapEntry(e.value, e.key))
    );

}



extension UniversalRoutesUtils on UniversalRoutes {

  void eachRoute<T>(void Function(UniversalRoute route, UniversalRoute? parent) reducer, [UniversalRoute? parent]) {

    for (final route in this) {

      if (!route.canShow) continue;

      reducer(route, parent);

      if (route.routes != null) {
        route.routes!.eachRoute(reducer, route);
      }
    }

  }

  UniversalRoutes findRoutes(bool Function(UniversalRoute route) predicate) {

    final UniversalRoutes result = [];

    eachRoute((route, parent) {
      if (predicate.call(route)) {
        result.add(route);
      }
    });

    return result;
  }




}