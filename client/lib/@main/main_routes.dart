

import 'package:client/@app/app_routes.dart';
import 'package:client/@inf/inf_routes.dart';
import 'package:client/@inf/pages/inf_index.dart';
import 'package:client/classes/pages.dart';
import 'package:client/service/_services.dart';
import 'package:client/widgets/universal/universal_route.dart';


const mainRoutes = [
  UniversalRoute(
      route: Pages.root,
      redirect: Services.redirectToInitialPage
  ),
  // UniversalRoute(
  //     route: Pages.inf,
  //     widget: InfIndex.new,
  //     routes: infRoutes
  // ),
  UniversalRoute(
      route: Pages.app,
      redirect: Services.redirectToInitialPage,
      routes: appRouts
  )
];

final routeToPath = UniversalRoute.routeToPath(mainRoutes);
final pathToRoute = UniversalRoute.pathToRoute(routeToPath);
