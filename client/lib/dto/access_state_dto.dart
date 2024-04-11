import 'package:client/dto/access_details_dto.dart';
import 'package:client/enum/access_state.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';

// Поля для стану доступу
class _AccessStateFields {
  final state = 'state'; // Стан
  final token = "token"; // Токен
  final userId = "userId"; // ID користувача
}

// Об'єкт для стану доступу
class AccessStateDto {

  static final f = _AccessStateFields(); // Поля стану

  final AccessState state; // Стан доступу
  final bool isGranted; // Чи наданий доступ
  final String? token; // Токен
  final int? userId; // ID користувача

  // Конструктор
  AccessStateDto({required this.state, this.token, this.userId}) :
        isGranted = state == AccessState.granted; // Чи наданий доступ

  // Конструктор з JSON
  static AccessStateDto fromJson(Json json) {
    final state = AccessState.values.byName(json["message"][f.state]); // Стан
    final token = json["message"][f.token]; // Токен
    final userId = json["message"][f.userId]; // ID користувача

    return AccessStateDto(state: state, token: token, userId: userId);
  }
}

// Поля для об'єкту учасника
class _CredentialFields extends _AccessStateFields {
  final details = 'details'; // Деталі доступу
  final order = 'order'; // Порядок
}

// Об'єкт для об'єкту учасника
class CredentialDto extends AccessStateDto implements ToJson, Uid, Comparable<CredentialDto> {

  static final f = _CredentialFields(); // Поля

  late final AccessDetailsDto details; // Деталі доступу

  int _order = 0; // Порядок
  int get sortOrder => _order != 0 ? _order : uid!.hashCode; // Порядок
  set sortOrder(int order) { _order = order; } // Порядок

  // Конструктор
  CredentialDto(state, Json json) : super(state: state) {
    details = AccessDetailsDto.fromJson(json[f.details]);
    _order = json[f.order] ?? 0;
  }

  // Перевірка, чи токен прострочений
  bool isExpired() {
    return details.expiration.isBefore(UtcDateTime.now);
  }

  // Порівняння з іншим об'єктом учасника
  bool isSame(CredentialDto other) {
    return this == other;
  }

  @override
  // Перетворення в JSON
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    json[f.state] = state.name;
    json[f.order] = _order;
    json[f.details] = details.toJson();
    return json;
  }

  // Конвертація з JSON
  static CredentialDto fromJson(Map<String, dynamic> json) {
    return AccessStateDto.fromJson(json) as CredentialDto;
  }

  @override
  // Повертає ID об'єкту
  String? get uid => throw UnimplementedError();

  @override
  // Порівняння з іншим об'єктом учасника
  int compareTo(CredentialDto other) {
    return sortOrder.compareTo(other.sortOrder);
  }

  // Повертає список прострочених об'єктів учасника
  static List<CredentialDto> expired(Iterable<CredentialDto> dtos) {
    return dtos.where((element) => element.isExpired()).toList();
  }

  // Повертає список непрострочених об'єктів учасника
  static List<CredentialDto> notExpired(Iterable<CredentialDto> dtos) {
    return dtos.where((element) => !element.isExpired()).toList();
  }


}
