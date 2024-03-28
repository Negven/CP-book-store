

import 'package:client/dto/page_dto.dart';
import 'package:client/utils/convert_utils.dart';

import 'dto.dart';

class _Book {
  final id = "id";
  final name = "name";
  final price = "price";
  final rating = "rating";
  final img = "img";
  final info = "info";
  final genreId = "genreId";
  final authorId = "authorId";
  final genreName = "genreName";
  final authorName = "authorName";
}

class BookDto extends Dto {

  static final f = _Book();
  // late int id;
  late String name;
  late int price;
  late int rating;
  late String img;
  late String info;
  late int genreId;
  late int authorId;
  late String genreName;
  late String authorName;

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

  // @override
  // String? get uid => id;
}

class BookPageDto extends PageDto<BookDto> {

  BookPageDto.fromJson(json) : super.fromJson(json, BookDto.fromJson);

}
