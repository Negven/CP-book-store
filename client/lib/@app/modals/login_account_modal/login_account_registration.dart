import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/widgets/empty.dart';
import 'package:client/widgets/universal/universal_button.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../../../dto/reg_dto.dart';
import '../../../utils/validate_utils.dart';
import '../../../widgets/material/materials.dart';

// Визначення класу LoginAccountRegistration, який є станом віджета для реєстрації користувача
class LoginAccountRegistration extends StatefulWidget {
  const LoginAccountRegistration({super.key});

  @override
  LoginAccountRegistrationState createState() {
    return LoginAccountRegistrationState();
  }
}

// Визначення класу LoginAccountRegistrationState, який відповідає за стан віджета реєстрації користувача
class LoginAccountRegistrationState extends State<LoginAccountRegistration> {
  // Контролери для полів введення
  final TextEditingController mailController = TextEditingController(text: "");
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController passwordController = TextEditingController(text: "");
  final LocalStorage storage = LocalStorage('book_store.json');

  // Глобальний ключ для форми
  final _formKey = GlobalKey<FormState>();
  bool invalidValidation = false;

  // Метод для реєстрації користувача
  void reg(String email, String password, String name, BuildContext context) {
    final regDto = RegDto();
    regDto.email = email;
    regDto.name = name;
    regDto.password = password;
    Services.publicApi.registration(regDto).then(
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
    // Повернення форми для реєстрації користувача
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
          // Поле введення імені
          Materials.textFormField(context,
            controller: nameController,
            labelText: '_name'.T,
            validator: ValidateUtils.requiredString,
          ),
          // Поле введення паролю
          Materials.textFormField(context,
            controller: passwordController,
            obscureText: true,
            labelText: '_password'.T,
            validator: ValidateUtils.requiredPassword,
          ),
          // Відображення повідомлення про невірну валідацію
          invalidValidation ? Text("mailBusy".T, style: TextStyle(color: context.colors.danger)) : Empty(),
          // Кнопка для реєстрації
          UniversalTextButton(
            text: "reg".T,
            backgroundColor: context.color4action,
            textColor: context.color4text,
            onPressed: () {
              // Перевірка валідації форми перед реєстрацією
              if (_formKey.currentState!.validate()) {
                reg(mailController.text, passwordController.text, nameController.text, context);
              }
            },
          )
        ],
      ),
    );
  }
}
