import 'package:client/widgets/font_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

// Тип для маршрутів універсального типу.
typedef UniversalRoutes = List<UniversalRoute>;

// Клас, що представляє один маршрут універсального типу.
class UniversalRoute {

  final String? route; // Шлях маршруту для підтримки віртуальної структури дерева.
  final String? t; // Текстовий ключ для інтернаціоналізації.
  final FontIcon? icon; // Іконка маршруту.
  final String Function(String location)? redirect; // Функція перенаправлення маршруту.
  final UniversalRoutes? routes; // Підмаршрути маршруту.
  final Widget Function()? widget; // Віджет, що відповідає маршруту.
  final Object? data; // Додаткові дані, пов'язані з маршрутом.
  final bool Function()? show; // Функція, що визначає, чи потрібно показувати маршрут.

  // Перевіряє, чи можна показати маршрут.
  bool get canShow => show == null || show?.call() == true;

  const UniversalRoute({ this.route, this.t, this.icon, this.redirect, this.data, this.routes, this.show, this.widget });


  // Створює зв'язок між маршрутами і їх шляхами.
  static Map<UniversalRoute, String> routeToPath(UniversalRoutes routes) {

    final Map<UniversalRoute, String> mapped = {};

    routes.eachRoute((route, parent) {
      mapped[route] = parent != null ? path.join(mapped[parent]!, route.route ?? '') : route.route ?? '';
    });

    return mapped;
  }

  // Створює зв'язок між шляхами і маршрутами.
  static Map<String, UniversalRoute> pathToRoute(Map<UniversalRoute, String> routeToPath) =>
      Map<String, UniversalRoute>.fromEntries(
          routeToPath.entries.where((e) => e.key.route != null).map((e) => MapEntry(e.value, e.key))
      );

}


// Розширення для списку маршрутів універсального типу.
extension UniversalRoutesUtils on UniversalRoutes {

  // Викликає функцію обробки для кожного маршруту.
  void eachRoute<T>(void Function(UniversalRoute route, UniversalRoute? parent) reducer, [UniversalRoute? parent]) {

    for (final route in this) {

      if (!route.canShow) continue;

      reducer(route, parent);

      if (route.routes != null) {
        route.routes!.eachRoute(reducer, route);
      }
    }

  }

  // Знаходить підходящі маршрути за допомогою предиката.
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
