import 'package:client/@app/app_page.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:flutter/cupertino.dart';

import '../../dto/basket_book_dto.dart';
import '../../service/_services.dart';
import '../../utils/validate_utils.dart';
import '../../widgets/empty.dart';
import '../../widgets/material/materials.dart';
import '../../widgets/universal/universal_button.dart';

class OrderPage extends AppPage {
  final TextEditingController fistNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController cardOwnerController = TextEditingController();
  final TextEditingController ccvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool invalidValidation = false;

  void makeOrder() {
    final userId = Services.navigation.currentUserId;
    final List<BasketBookDto> basketItems = [];
    Services.publicApi.getBasketBooks(userId)
        .then((page) => page.map((basketItem) {
      basketItems.add(basketItem);
    })).then((value) => basketItems.forEach((b) { Services.publicApi.deleteBasketItems(b);}) );

  }

  @override
  Widget content(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children:
          [
            Text("contactInfo".T),
            Materials.textFormField(context,
              controller: fistNameController,
              labelText: '_fMame'.T,
              validator: ValidateUtils.requiredString,
            ),
            Materials.textFormField(context,
              controller: secondNameController,
              labelText: '_sName'.T,
              validator: ValidateUtils.requiredString,
            ),
            Materials.textFormField(context,
              controller: middleNameController,
              labelText: '_mName'.T,
              validator: ValidateUtils.requiredString,
            ),
            Materials.textFormField(context,
              controller: mailController,
              labelText: '_mail'.T,
              validator: ValidateUtils.requiredEmail,
            ),
            Materials.textFormField(context,
              controller: phoneController,
              labelText: '_password'.T,
              validator: ValidateUtils.requiredString,
            ),
            Text("pay".T),
            Materials.textFormField(context,
              controller: cardController,
              labelText: '_card'.T,
              validator: ValidateUtils.requiredString,
            ),
            Materials.textFormField(context,
              controller: cardOwnerController,
              labelText: '_mail'.T,
              validator: ValidateUtils.requiredString,
            ),
            Materials.textFormField(context,
              controller: ccvController,
              labelText: 'CCV'.T,
              validator: ValidateUtils.requiredString,
            ),
            invalidValidation ? Text("invalidValidation".T, style: TextStyle(color: context.colors.danger)) : Empty(),
            UniversalTextButton(
              text: "pay".T,
              backgroundColor: context.color4action,
              textColor: context.color4text,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  makeOrder();
                }
              },
            )
          ],
        ));
  }
  
}