import 'package:client/dto/book_dto.dart';
import 'package:client/dto/page_dto.dart';
import 'package:client/utils/convert_utils.dart';

import 'dto.dart';

// Поля для об'єкту "Книга в кошику"
class _BasketBook {
  final id = "id"; // ID
  final basketId = "basketId"; // ID кошика
  final bookId = "bookId"; // ID книги
  final book = "book"; // Книга
}

// Об'єкт для представлення книги в кошику
class BasketBookDto extends Dto {

  static final f = _BasketBook(); // Поля об'єкту

  late int basketId; // ID кошика
  late int bookId; // ID книги
  late BookDto book; // Книга

  // Конструктор
  BasketBookDto(this.bookId, this.basketId);

  // Конструктор з JSON
  BasketBookDto.fromJson(Json json) {
    id = json[f.id];
    basketId = json[f.basketId];
    bookId = json[f.bookId];
    book = BookDto.fromJson(json[f.book]);
  }

  // Перетворення в JSON
  Json toJson() {
    final Json json = {};
    json[f.id] = id;
    json[f.basketId] = basketId;
    json[f.bookId] = bookId;
    // json[f.book] = book.toJson();
    return json;
  }
}

// Об'єкт для представлення сторінки книг в кошику
class BasketBookPageDto extends PageDto<BasketBookDto> {

  // Конструктор з JSON
  BasketBookPageDto.fromJson(json) : super.fromJson(json, BasketBookDto.fromJson);

}
