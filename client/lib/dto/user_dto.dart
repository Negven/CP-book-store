

import 'package:client/dto/dto.dart';
import 'package:client/enum/access_role.dart';
import 'package:client/enum/country_code.dart';
import 'package:client/utils/convert_utils.dart';

class _User extends DtoF {
  final accessRole = 'accessRole';
  final active = 'active';
  final countryCode = 'countryCode';
  final languageCode = 'languageCode';
  final name = 'name';
  final email = 'email';
}

class ReadUserDto extends Dto {

  static final f = _User();

  late final AccessRole accessRole;
  late final String name;
  late final String email;
  late final bool active;
  late final CountryCode countryCode;
  late final String languageCode;

  ReadUserDto.fromJson(Json json) {
    fromJson(json);
    accessRole = AccessRole.values.byName(json[f.accessRole]);
    name = json[f.name];
    email = json[f.email];
    languageCode = json[f.languageCode];
    countryCode = CountryCode.values.byName(json[f.countryCode]);
    active = ConvertUtils.rParseBool(json[f.active]);
  }

  Json toJson() {
    final json = createJson();
    json[f.name] = name;
    json[f.email] = email;
    json[f.accessRole] = accessRole.name;
    json[f.languageCode] = languageCode;
    json[f.countryCode] = countryCode.name;
    json[f.active] = ConvertUtils.rFormatBool(active);
    return json;
  }

}