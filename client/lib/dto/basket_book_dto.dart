

import 'package:client/dto/book_dto.dart';
import 'package:client/dto/page_dto.dart';
import 'package:client/utils/convert_utils.dart';

import 'dto.dart';

class _BasketBook {
  final id = "id";
  final basketId = "basketId";
  final bookId = "bookId";
  final book = "book";
}

class BasketBookDto extends Dto {

  static final f = _BasketBook();
  // late int id;
  late int basketId;
  late int bookId;
  late BookDto book;

  BasketBookDto(this.bookId, this.basketId);

  BasketBookDto.fromJson(Json json) {
    id = json[f.id];
    basketId = json[f.basketId];
    bookId = json[f.bookId];
    book = BookDto.fromJson(json[f.book]);
  }

  Json toJson() {
    final Json json = {};
    json[f.id] = id;
    json[f.basketId] = basketId;
    json[f.bookId] = bookId;
    // json[f.book] = book.toJson();
    return json;
  }

// @override
// String? get uid => id;
}

class BasketBookPageDto extends PageDto<BasketBookDto> {

  BasketBookPageDto.fromJson(json) : super.fromJson(json, BasketBookDto.fromJson);

}

