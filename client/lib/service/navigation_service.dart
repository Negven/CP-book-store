import 'package:client/classes/pages.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

// Сервіс навігації
class NavigationService extends GetxService {

  // Отримати контекст
  BuildContext get context => Get.key.currentContext!;

  // Отримати роутер
  GoRouter get _router => GoRouter.of(context);

  // Отримати URI
  Uri get uri => _router.routeInformationProvider.value.uri;

  // Отримати шлях
  String get path => uri.toString();

  // Отримати шлях маршруту
  String get routePath => uri.path;

  // Початкова сторінка
  String initialPage() => Pages.catalogue;

  // Сторінка книги
  String bookPage(String bookId) => Pages.bookPageUrl(bookId);

  // Перейти на сторінку книги
  void goToBook(String bookId) => go(bookPage(bookId));

  // Перейти на початкову сторінку
  void goToInitial() => go(initialPage());

  // Підготувати місцезнаходження
  String _prepareLocation(String nextLocation, Map<String,String>? params) {
    Uri uri = Uri.parse(nextLocation);
    if (params != null && params.isNotEmpty) {
      final next = <String,String>{};
      next.addAll(uri.queryParameters);
      next.addAll(params);
      uri = uri.replace(queryParameters: next);
    }
    return uri.toString();
  }

  // Перейти на місцезнаходження
  void go(String location, [Map<String,String>? params]) {
    _router.go(_prepareLocation(location, params));
  }

  // Замінити параметри
  void replace(Map<String,String> params) {
    go(uri.path, params);
  }

  // Поточний шлях
  final currentPath = Routes.root.obs;
  int get currentUserId => Services.auth.storage.getItem("userId");

  // Запустити навігацію
  void triggerNavigation() {
    currentPath.value = path;
  }
}
