


import 'package:client/enum/auth_status.dart';
import 'package:client/enum/country_code.dart';
import 'package:client/utils/convert_utils.dart';


class OAuth2LinkDto {

  String? link;
  String? state;

  OAuth2LinkDto.fromJson(Json json) {
    state = json['state'];
    link = json['link'];
  }

}



class OAuth2StatusDto {

  AuthStatus? status;

  String? error;
  String? email;
  String? name;
  CountryCode? countryCode;
  String? currency;

  OAuth2StatusDto.fromJson(Json json) {

    status = ConvertUtils.rParseEnum(AuthStatus.values, json['status']);
    error = json['error'];
    email = json['email'];
    name = json['name'];
    countryCode = ConvertUtils.nParseEnum(CountryCode.values, json['countryCode']);
    currency = json['currency'];
  }
}