import 'package:client/@app/modals/login_account_modal/@login_account_modal.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/dto/basket_book_dto.dart';
import 'package:client/dto/book_dto.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Book extends StatelessWidget {
  final RxBool isAuth = Services.auth.isSignedIn.obs;

  final BookDto bookData;
  Book({super.key, required this.bookData});

  static void addToBasket(BookDto book){
    final basketItem = BasketBookDto(book.id!, Services.navigation.currentUserId);
    Services.publicApi.addItemInBasket(basketItem);
  }

  setAuth() {
    isAuth.value = Services.auth.isSignedIn;
  }

  @override
  Widget build(BuildContext context) {
    Services.auth.listen(setAuth, instant: true);
    final (title, callback) = LoginAccountModal.addOne();
    return SizedBox(
      width: sizes.bookCardWidth,
      height: sizes.bookCardHeight,
      child: UniversalButton(
        onPressed: () => Services.navigation.goToBook("${bookData.id}"),
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            Image.network("http://192.168.178.67:5000/${bookData.img}"),
            Text(bookData.name),
            Text(bookData.authorName),
            Text(bookData.price.toString()),
            Obx(() =>
                UniversalTextButton(
                  backgroundColor: context.color4action,
                  textColor: context.color4text,
                  text: "addToBasket".T,
                  onPressed:  isAuth.value ? () => addToBasket(bookData) : callback,
                )
            )

          ],
        ),
      )

    );
  }

}