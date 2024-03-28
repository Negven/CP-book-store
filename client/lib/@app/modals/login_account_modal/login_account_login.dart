import 'package:client/dto/login_dto.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../../utils/validate_utils.dart';
import '../../../widgets/material/materials.dart';

class LoginAccountLogin extends StatefulWidget {

  const LoginAccountLogin({super.key});

  @override
  LoginAccountLoginState createState() {
    return LoginAccountLoginState();
  }

}

class LoginAccountLoginState extends State<LoginAccountLogin> {

  final TextEditingController mailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final LocalStorage storage = LocalStorage('book_store.json');

  final _formKey = GlobalKey<FormState>();
  bool invalidValidation = false;



  void login(String email, String password) {
    final loginDto = LoginDto();
    loginDto.email = email;
    loginDto.password = password;
    Services.publicApi.login(loginDto).then(
            (value) {
              Services.auth.signIn(value);
            }
    ).onError(
            (error, stackTrace) {
              print(error);
              setState(() {
                invalidValidation = true;
              });
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:
        [
          Materials.textFormField(context,
            controller: mailController,
            labelText: '_mail'.T,
            validator: ValidateUtils.requiredEmail,
          ),
          Materials.textFormField(context,
            controller: passwordController,
            obscureText: true,
            labelText: '_password'.T,
            validator: ValidateUtils.requiredPassword,
          ),
          invalidValidation ? Text("invalidValidation".T, style: TextStyle(color: context.colors.danger)) : Empty(),
          UniversalTextButton(
            text: "login".T,
            backgroundColor: context.color4action,
            textColor: context.color4text,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                login(mailController.text, passwordController.text);
              }
            },
          )
        ],
      ));
  }

}