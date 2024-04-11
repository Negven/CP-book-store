import 'package:client/@app/app_page.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/dto/book_dto.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../classes/pages.dart';
import '../modals/login_account_modal/@login_account_modal.dart';
import '../widgets/Book.dart';

// Визначення класу BookPage, який представляє сторінку книги
class BookPage extends AppPage {
  // Змінна для зберігання даних про книгу
  late final Rx<BookDto?> bookData = BookDto().obs;
  // Змінна для визначення статусу автентифікації користувача
  final RxBool isAuth = Services.auth.isSignedIn.obs;

  // Конструктор класу, який завантажує дані про книгу
  BookPage({super.key}) {
    Services.publicApi.getBook(Pages.bookIdFromUri(Services.navigation.uri))
        .then((book) {
      bookData.value = book;
    });
  }

  // Метод для встановлення статусу автентифікації
  setAuth() {
    isAuth.value = Services.auth.isSignedIn;
  }

  // Метод для відображення вмісту книги
  List<Widget> bookContent(BuildContext context) {
    Services.auth.listen(setAuth, instant: true);
    final (title, callback) = LoginAccountModal.addOne();
    final book = bookData.value;
    return [
      Container(
        width: sizes.bookCardWidth,
        child: book?.img != "" ?  Image.network("http://192.168.178.67:5000/${book?.img}") : const Empty(),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Автор: ${book?.authorName}", textAlign: TextAlign.start),
          Text("Про книжку \"${book?.name}\"", textAlign: TextAlign.start),
          SizedBox(
            width: sizes.containerWidth - sizes.bookCardWidth,
            height: 200,
            child: Text(
              "${book?.info}",
              textAlign: TextAlign.start,
            ),
          ),
          Text(book?.price.toString() ?? ""),
          Obx(() =>
              UniversalTextButton(
                backgroundColor: context.color4action,
                textColor: context.color4text,
                text: "addToBasket".T,
                onPressed:  isAuth.value ? () => Book.addToBasket(book!) : callback,
              )
          )
        ],
      ),
    ];
  }

  @override
  // Метод для відображення вмісту сторінки
  Widget content(BuildContext context) {
    return Obx(() {
      final book = bookData.value;
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(book?.name ?? "")
              ],
            ),
            sizes.w100 > 800 ? Row(children: bookContent(context)) : Column(children: bookContent(context),),
          ],
        ),
      );
    });
  }
}
