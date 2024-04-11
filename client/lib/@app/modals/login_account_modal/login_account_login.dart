import 'package:client/dto/login_dto.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/universal/universal_button.dart';
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
  // Контролери для полів введення
  final TextEditingController mailController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final LocalStorage storage = LocalStorage('book_store.json');

  // Глобальний ключ для форми
  final _formKey = GlobalKey<FormState>();
  bool invalidValidation = false;

  // Метод для входу в систему
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
    // Повернення форми з полями введення та кнопкою для входу
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Поле введення електронної пошти
          Materials.textFormField(context,
            controller: mailController,
            labelText: '_mail'.T,
            validator: ValidateUtils.requiredEmail,
          ),
          // Поле введення паролю
          Materials.textFormField(context,
            controller: passwordController,
            obscureText: true,
            labelText: '_password'.T,
            validator: ValidateUtils.requiredPassword,
          ),
          // Відображення повідомлення про невірну валідацію
          invalidValidation ? Text("invalidValidation".T, style: TextStyle(color: context.colors.danger)) : Empty(),
          // Кнопка для входу
          UniversalTextButton(
            text: "login".T,
            backgroundColor: context.color4action,
            textColor: context.color4text,
            onPressed: () {
              // Перевірка валідації форми перед входом
              if (_formKey.currentState!.validate()) {
                login(mailController.text, passwordController.text);
              }
            },
          )
        ],
      ),
    );
  }
}
