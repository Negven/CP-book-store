
abstract class Routes {
  // Спільні маршрути
  static const String root = "/", // Головний маршрут

  // Тільки верхні маршрути починаються з "/"
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

  // Регулярний вираз для вилучення ідентифікатора книги з URL-адреси
  static final RegExp bookIdRegExp = RegExp('^($app|$api)/$book/([^/]+).*\$');
}

abstract class Pages {
  static const String root = Routes.root; // Коренева сторінка

  static const String app = Routes.app, // Маршрут для основного вмісту програми
      book = "${Routes.app}/${Routes.book}", // Маршрут для сторінки книги
      catalogue = "${Routes.app}/${Routes.catalogue}"; // Маршрут для каталогу

  // Список авторизованих сторінок
  static List<String> auth = [Routes.user, Routes.basket, Routes.order, Routes.adminPage]
      .map((path) => "${Routes.app}/$path")
      .toList();

  // Функція для створення URL-адреси сторінки книги за ідентифікатором
  static String bookPageUrl(String bookId) => "$book/$bookId";

  // Функція для отримання ідентифікатора книги з URI (за потреби)
  static String? bookIdFromUri(Uri uri) => bookIdFromPath(uri.toString());

  // Функція для отримання ідентифікатора книги з шляху
  static String? bookIdFromPath(String path) =>
      Routes.bookIdRegExp.firstMatch(path)?.group(2);
}
