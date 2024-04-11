import 'package:client/utils/convert_utils.dart';

const _unknown = -1;

// Клас для сторінки Dto
class PageDto<T> {

  late final int total; // Загальна кількість записів
  late final int page; // Номер поточної сторінки
  late final int size; // Розмір сторінки
  late final List<T> content; // Вміст сторінки

  // Кількість сторінок
  int? get pages => total == _unknown ? null : (size == 0 ? 0 : (total.toDouble() / size).ceil());

  // Перевірка на пустоту
  bool get isEmpty => content.isEmpty;

  // Конструктор
  PageDto(this.content, {this.total = 0, this.page = 0, this.size = 0});

  // Конструктор зі списку
  PageDto.fromArray(this.content) {
    this.size = this.total = this.content.length;
  }

  // Конструктор з JSON
  PageDto.fromJson(Json json, FromJson<T> converter) {
    total = json['count'];
    page = json['page'];
    size = int.parse(json['limit']);
    content = (json['rows'] as List<dynamic>).map((item) => converter.call(item as Json)).toList();
  }

  // Мапування сторінки
  PageDto<V> map<V>(V Function(T item) mapper) {
    final content = this.content.map(mapper).toList();
    return PageDto(content, total: this.total, page: this.page, size: this.size);
  }

  // Створення порожньої сторінки
  static PageDto<T> empty<T>() => PageDto([]);
}
