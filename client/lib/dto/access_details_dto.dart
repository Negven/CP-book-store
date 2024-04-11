import 'package:client/dto/user_dto.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';

// Поля для доступу до даних
class _AccessDetailsFields {
  final jwt = 'jwt'; // JWT токен
  final expiration = 'expiration'; // Термін дії
  final createdAt = 'createdAt'; // Дата створення
  final ws = 'ws'; // WebSocket
  final wallet = 'wallet'; // Гаманець
  final user = 'user'; // Користувач
}

// Об'єкт для деталей доступу
class AccessDetailsDto {

  static final f = _AccessDetailsFields(); // Поля доступу

  late final String jwt; // JWT токен
  late final UtcDateTime expiration; // Термін дії
  late final UtcDateTime createdAt; // Дата створення

  late final String ws; // WebSocket

  late final ReadUserDto user; // Інформація про користувача

  // Конструктор з JSON
  AccessDetailsDto.fromJson(Json json) {

    jwt = json[f.jwt];
    expiration = UtcDateTime.parse(json[f.expiration]);
    createdAt = UtcDateTime.tryParse(json[f.createdAt]) ?? UtcDateTime.from(DateTime.now().subtract(const Duration(days: 30)));

    ws = json[f.ws];

    user = ReadUserDto.fromJson(json[f.user]);
  }

  // Перетворення в JSON
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    json[f.jwt] = jwt;
    json[f.expiration] = expiration.format();
    json[f.createdAt] = createdAt.format();
    json[f.ws] = ws;
    json[f.user] = user.toJson();
    return json;
  }

}
