

import 'package:client/@app/app_page.dart';
import 'package:client/@app/widgets/Book.dart';
import 'package:client/classes/api_service.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/dto/book_dto.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class CataloguePage extends AppPage {
  late final RxList<BookDto> books = <BookDto>[].obs;

  CataloguePage({super.key}){
    Services.publicApi.getBooks(size: PV.pageSizeMax)
        .then((page) => page.map((book) => books.add(book)));
    
  }

  @override
  Widget content(BuildContext context) {
    return Container(
      child: Obx(() {
        return Wrap(
          alignment: WrapAlignment.spaceAround,
          spacing: sizes.paddingH.md,
          children: books.map((bookData) => Book(bookData: bookData)).toList(),
        );
      })
    );
  }

}