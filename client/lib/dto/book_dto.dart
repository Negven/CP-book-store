import 'package:client/dto/page_dto.dart';
import 'package:client/utils/convert_utils.dart';

import 'dto.dart';

// Поля для об'єкту "Книга"
class _Book {
  final id = "id"; // ID
  final name = "name"; // Назва
  final price = "price"; // Ціна
  final rating = "rating"; // Рейтинг
  final img = "img"; // Зображення
  final info = "info"; // Інформація
  final genreId = "genreId"; // ID жанру
  final authorId = "authorId"; // ID автора
  final genreName = "genreName"; // Назва жанру
  final authorName = "authorName"; // Ім'я автора
}

// Об'єкт для представлення книги
class BookDto extends Dto {

  static final f = _Book(); // Поля об'єкту

  late String name; // Назва
  late int price; // Ціна
  late int rating; // Рейтинг
  late String img; // Зображення
  late String info; // Інформація
  late int genreId; // ID жанру
  late int authorId; // ID автора
  late String genreName; // Назва жанру
  late String authorName; // Ім'я автора

  // Конструктор
  BookDto(){
    name = "";
    price = 0;
    rating = 0;
    img = "";
    info = "";
    genreId = 0;
    authorId = 0;
    genreName = "";
    authorName = "";
  }

  // Конструктор з JSON
  BookDto.fromJson(Json json) {
    id = json[f.id];
    name = json[f.name];
    price = json[f.price];
    rating = json[f.rating];
    img = json[f.img];
    info = json[f.info];
    genreId = json[f.genreId];
    authorId = json[f.authorId];
    genreName = json[f.genreName];
    authorName = json[f.authorName];
  }

  // Перетворення в JSON
  Json toJson() {
    final Json json = {};
    json[f.id] = id;
    json[f.name] = name;
    json[f.price] = price;
    json[f.rating] = rating;
    json[f.img] = img;
    json[f.info] = info;
    json[f.genreId] = genreId;
    json[f.authorId] = authorId;
    json[f.genreName] = genreName;
    json[f.authorName] = authorName;
    return json;
  }

}

// Об'єкт для представлення сторінки книг
class BookPageDto extends PageDto<BookDto> {

  // Конструктор з JSON
  BookPageDto.fromJson(json) : super.fromJson(json, BookDto.fromJson);

}
