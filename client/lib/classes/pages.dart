


abstract class Routes { // Common routes

  static const String root = "/",

      // only top-routes starts with /
      app = "/app",
      api = "/api",
      inf = "/inf",

      catalogue = "catalogue",
      main = "main",
      action = "action",
      contact = "contact",
      book = "book",
      bookId = ":bookId",

      adminPage = "adminPage",
      basket = "basket",
      order = "order",
      user = "user",

      legal = 'legal',
      termsOfService = 'terms-of-service',
      privacyPolicyOld = 'privacyPolicy',
      privacyPolicy = 'privacy-policy';

  static final RegExp bookIdRegExp = RegExp('^($app|$api)/$book/([^/]+).*\$');

}


abstract class Pages {

  static const String root = Routes.root;

  static const String app = Routes.app,
      book = "${Routes.app}/${Routes.book}",
      catalogue = "${Routes.app}/${Routes.catalogue}";
  static List<String> auth = [Routes.user, Routes.basket, Routes.order, Routes.adminPage].map((path) => "${Routes.app}/$path").toList();
  //     walletsOverview = "${Routes.app}/${Routes.wallets}/${Routes.overview}";

  static const String inf = Routes.inf,
      privacyPolicy = "${Routes.inf}/${Routes.legal}/${Routes.privacyPolicy}",
      termsOfService = "${Routes.inf}/${Routes.legal}/${Routes.termsOfService}";


  static String bookPageUrl(String bookId) => "$book/$bookId";

  static String? bookIdFromUri(Uri uri) => bookIdFromPath(uri.toString());

  static String? bookIdFromPath(String path) =>
      Routes.bookIdRegExp.firstMatch(path)?.group(2);

}


