
import 'package:client/@inf/pages/legal/privacy_policy.dart';
import 'package:client/@inf/pages/legal/terms_of_service.dart';
import 'package:client/classes/pages.dart';
import 'package:client/widgets/universal/universal_route.dart';

const infRoutes = [
  UniversalRoute(
      route: Routes.legal,
      routes: [
        UniversalRoute(route: Routes.privacyPolicyOld, widget: PrivacyPolicy.new),
        UniversalRoute(route: Routes.privacyPolicy, widget: PrivacyPolicy.new),
        UniversalRoute(route: Routes.termsOfService, widget: TermsOfService.new)
      ]
  )

];