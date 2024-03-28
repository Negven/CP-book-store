

import 'package:client/utils/convert_utils.dart';

const _unknown = -1;

class PageDto<T> {

  late final int total;
  late final int page;
  late final int size;
  late final List<T> content;

  int? get pages => total == _unknown ? null : (size == 0 ? 0 : (total.toDouble() / size).ceil()); // 0 == empty page dto

  bool get isEmpty => content.isEmpty;

  PageDto(this.content, {this.total = 0, this.page = 0, this.size = 0});

  PageDto.fromArray(this.content) {
    this.size = this.total = this.content.length;
  }

  PageDto.fromJson(Json json, FromJson<T> converter) {
    total = json['count'];
    page = json['page'];
    size = int.parse(json['limit']);
    content = (json['rows'] as List<dynamic>).map((item) => converter.call(item as Json)).toList();
  }

  PageDto<V> map<V>(V Function(T item) mapper) {
    final content = this.content.map(mapper).toList();
    return PageDto(content, total: this.total, page: this.page, size: this.size);
  }

  static PageDto<T> empty<T>() => PageDto([]);
}
