import 'package:client/@app/pages/basket_page.dart';
import 'package:client/@app/pages/book_page.dart';
import 'package:client/@app/pages/catalogue_page.dart';
import 'package:client/@app/pages/order_page.dart';
import 'package:client/classes/pages.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/universal/universal_route.dart';

// Список маршрутів для головного меню
const menuRouts = [
  UniversalRoute(
    route: Routes.main,
    widget: Empty.new,
    t: "main",
  ),
  UniversalRoute(
    route: Routes.catalogue,
    widget: CataloguePage.new,
    t: "catalogue",
  ),
  UniversalRoute(
    route: Routes.action,
    widget: Empty.new,
    t: "action",
  ),
  UniversalRoute(
    route: Routes.contact,
    widget: Empty.new,
    t: "contact",
  ),
];

// Список маршрутів додатку
const appRouts = [
  ...menuRouts,
  UniversalRoute(
      route: Routes.book,
      routes: [
        UniversalRoute(
          route: Routes.bookId,
          widget: BookPage.new,
        )
      ]
  ),
  ...authRouts
];

// Список маршрутів аутентифікованих юзерів
const authRouts = [
  UniversalRoute(
    route: Routes.basket,
    widget: BasketPage.new,
  ),
  UniversalRoute(
    route: Routes.order,
    widget: OrderPage.new,
  ),
  UniversalRoute(
    route: Routes.user,
    widget: Empty.new,
  )
];
