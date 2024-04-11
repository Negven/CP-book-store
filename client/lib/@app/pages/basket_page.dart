import 'package:client/dto/basket_book_dto.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../@main/main_routes.dart';
import '../../classes/sizes.dart';
import '../../service/_services.dart';
import '../../widgets/empty.dart';
import '../app_page.dart';
import '../app_routes.dart';

// Визначення класу BasketPage, який є сторінкою кошика користувача
class BasketPage extends AppPage {
  // Змінна для зберігання списку товарів у кошику
  late final RxList<BasketBookDto> basketItems = <BasketBookDto>[].obs;
  // Змінна для зберігання загальної ціни товарів у кошику
  int totalPrice = 0;

  // Метод для завантаження товарів у кошику
  void loadBasket() {
    final userId = Services.navigation.currentUserId;
    basketItems.value = [];
    totalPrice = 0;
    Services.publicApi.getBasketBooks(userId)
        .then((page) => page.map((basketItem) {
      basketItems.add(basketItem);
      totalPrice += basketItem.book.price;
    }));

  }

  // Конструктор класу, який викликає метод завантаження кошика
  BasketPage({super.key}){
    loadBasket();
  }

  // Метод для відображення одного товару у кошику
  Widget basketItem(BasketBookDto basketItemData, BuildContext context) {
    final book = basketItemData.book;
    return SizedBox(
        width: sizes.containerWidth,
        child: UniversalButton(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: sizes.containerWidth,
            child: Wrap(
              direction: sizes.w100 > 800 ? Axis.horizontal : Axis.vertical,
              spacing: 30,
              children: [
                Container(
                  width: 200,
                  child: book.img != "" ?  Image.network("http://192.168.178.67:5000/${book.img}") : const Empty(),
                ),
                Text(book.name),
                Text(book.price.toString()),
                Container(
                  width: 100,
                  child: UniversalTextButton(
                    backgroundColor: context.color4action,
                    textColor: context.color4text,
                    text: "delete".T,
                    onPressed: () => {
                      Services.publicApi.deleteBasketItems(basketItemData).then((value) => loadBasket())
                    },
                  ),
                )
              ],
            ),
          ),
          onPressed: () => Services.navigation.goToBook("${book.id}"),
        )
    );
  }

  @override
  // Метод для відображення вмісту сторінки
  Widget content(BuildContext context) {
    return Container(
        child: Obx(() {
          return Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: sizes.paddingH.md,
              direction: Axis.vertical,
              children: [
                // Відображення списку товарів у кошику
                ...basketItems.map((basketItemData) => basketItem(basketItemData, context)).toList(),
                Text("${"totalPrice".T}$totalPrice"),
                // Кнопка для оформлення замовлення
                UniversalTextButton(
                  backgroundColor: context.color4background,
                  textColor: context.color4text,
                  text: "makeOrder".T,
                  onPressed: () {
                    Services.navigation.go(routeToPath[authRouts[1]]!);
                  },
                ),
              ]
          );
        })
    );
  }
}
