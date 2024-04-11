import 'package:client/@app/modals/login_account_modal/login_account_modal__choose_flow.dart';
import 'package:client/classes/stepped_state.dart';

enum LoginAccountModalStep with SteppedStep {
  // Оголошення кроку вибору потоку
  chooseFlow;

  // Статична константа для визначення кроків та їх відповідних віджетів
  static const steps = {
    chooseFlow: {
      chooseFlow: LoginAccount$ChooseFlow(),
    }
  };
}
