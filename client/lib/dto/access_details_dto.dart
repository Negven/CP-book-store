

import 'package:client/dto/user_dto.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';


class _AccessDetailsFields {
  final jwt = 'jwt';
  final expiration = 'expiration';
  final createdAt = 'createdAt';
  final ws = 'ws';
  final wallet = 'wallet';
  final user = 'user';
}

class AccessDetailsDto {

  static final f = _AccessDetailsFields();

  late final String jwt;
  late final UtcDateTime expiration;
  late final UtcDateTime createdAt;

  late final String ws;

  late final ReadUserDto user;

  // NB! Details stored on client end, don't add required fields without fallbacks here
  AccessDetailsDto.fromJson(Json json) {

    jwt = json[f.jwt];
    expiration = UtcDateTime.parse(json[f.expiration]);
    createdAt = UtcDateTime.tryParse(json[f.createdAt]) ?? UtcDateTime.from(DateTime.now().subtract(const Duration(days: 30)));

    ws = json[f.ws];

    user = ReadUserDto.fromJson(json[f.user]);
  }

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


