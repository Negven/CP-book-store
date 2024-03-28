

import 'package:client/dto/dto.dart';
import 'package:client/dto/establishment_dto.dart';
import 'package:client/enum/auth_provider.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/encryption_utils.dart';


class _SignInFields {
  final state = 'state';
  final masterKey = 'masterKey';
}

abstract class SignInDto extends Dto {

  static final f = _SignInFields();

  // internal, should not be sent to the server
  AuthProvider $provider = AuthProvider.unknown;

  // server
  String? state;
  MasterKey? masterKey;
  EstablishmentDto? _establishment;


  Json toJson() {
    final json = createJson();
    json[f.state] = state!;
    json[f.masterKey] = masterKey!.toBase64Url();
    return json;
  }

}


class _CreateSignInFields extends _SignInFields {
  final establishment = 'establishment';
}

class CreateSignInDto extends SignInDto {

  static final f = _CreateSignInFields();

  CreateSignInDto() {
    _establishment = EstablishmentDto();
  }

  EstablishmentDto get establishment => _establishment!;

  @override
  Json toJson() {
    var json = super.toJson();
    json[f.establishment] = establishment.toJson();
    return json;
  }
}

class ConnectSignInDto extends SignInDto {

  ConnectSignInDto();

}
