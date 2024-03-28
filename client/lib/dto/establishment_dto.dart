

import 'package:client/dto/dto.dart';
import 'package:client/enum/country_code.dart';
import 'package:client/enum/language_code.dart';
import 'package:client/utils/convert_utils.dart';


class _EstablishmentFields {
  final user = 'user';
  final email = 'email';
  final country = 'country';
  final language = 'language';
  final wallet = 'wallet';
  final currency = 'currency';
  final icon = 'icon';
}


class EstablishmentDto extends Dto {

  static final f = _EstablishmentFields();

  String? user;
  String? email;
  CountryCode? country;
  LanguageCode? language;
  String? wallet;
  String? currency;
  String? icon;


  Json toJson() {
    final json = createJson();
    json[f.user] = user!;
    json[f.email] = email!;
    json[f.country] = country!.name;
    json[f.language] = language!.name;
    json[f.wallet] = wallet!;
    json[f.currency] = currency!;
    json[f.icon] = icon;
    return json;
  }
}
