import '../utils/convert_utils.dart';
import 'dto.dart';

class _Reg {
  final email = "email";
  final name = "name";
  final password = "password";
}

class RegDto extends Dto {

  static final f = _Reg();

  String? email;
  String? password;
  String? name;


  Json toJson() {
    final json = createJson();
    json[f.email] = email;
    json[f.password] = password;
    json[f.name] = name;
    return json;
  }

}

