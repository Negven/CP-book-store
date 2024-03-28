import '../utils/convert_utils.dart';
import 'dto.dart';

class _Login {
  final email = "email";
  final password = "password";
}

class LoginDto extends Dto {

  static final f = _Login();

  String? email;
  String? password;


  Json toJson() {
    final json = createJson();
    json[f.email] = email;
    json[f.password] = password;
    return json;
  }

}

