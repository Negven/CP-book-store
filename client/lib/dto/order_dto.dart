

import 'package:client/dto/book_dto.dart';
import 'package:client/utils/convert_utils.dart';

import 'dto.dart';

class _Order {
  final id = "id";
}

class OrderDto extends Dto {

  static final f = _Order();
  // late int id;
  late List<BookDto> books;

  OrderDto(this.books);

  OrderDto.fromJson(Json json) {
    id = json[f.id];
  }

  Json toJson() {
    final Json json = {};
    json[f.id] = id;
    return json;
  }

// @override
// String? get uid => id;
}

