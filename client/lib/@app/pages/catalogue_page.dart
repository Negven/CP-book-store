import 'package:client/@app/app_page.dart';
import 'package:client/@app/widgets/Book.dart';
import 'package:client/classes/api_service.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/dto/book_dto.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Визначення класу CataloguePage, який представляє сторінку каталогу книг
class CataloguePage extends AppPage {
  // Змінна для зберігання списку книг
  late final RxList<BookDto> books = <BookDto>[].obs;

  // Конструктор класу, який завантажує дані про книги
  CataloguePage({super.key}) {
    Services.publicApi.getBooks(size: PV.pageSizeMax)
        .then((page) => page.map((book) => books.add(book)));
  }

  @override
  // Метод для відображення вмісту сторінки
  Widget content(BuildContext context) {
    return Container(
      child: Obx(() {
        return Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: sizes.paddingH.md,
          children: books.map((bookData) => Book(bookData: bookData)).toList(),
        );
      }),
    );
  }
}
