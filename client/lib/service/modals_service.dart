



import 'package:client/classes/unexpected_error.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/widgets/modal_scaffold.dart';
import 'package:client/widgets/page_builder.dart';
import 'package:client/widgets/under_construction_modal.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum ConfirmResult {
  confirm,
  cancel,
  other
}

typedef ConfirmResultType = Future<ConfirmResult>;


// Mainly created to make rendering modals over app content
class ModalsService extends GetxService {

  static final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ModalsNavigator');

  NavigatorState get navigatorState => navigatorKey.currentState!;
  BuildContext get _context => navigatorState.context;

  @override
  void onInit() {
    super.onInit();

    Services.navigation.currentPath.listen((_) {

      // NB! If path changed then closing any modal or dialog
      if (navigatorState.canPop()) {
        _closeAll();
      }

    });
  }


  void closeOne() {
    if (navigatorState.canPop()) {
      navigatorState.pop();
    }
  }

  void closeWith<T>(T? result) {
    if (navigatorState.canPop()) {
      navigatorState.pop<T>(result);
    }
  }

  bool _closeAll() {

    var closed = false;

    // NB! Don't replace with pop until as it's not working
    while(navigatorState.canPop()) {
      closed = true;
      navigatorState.pop();
    }

    return closed;
  }

  // If some modals is open, don't close application on mobile Back press (or left swipe)
  Future<bool> onWillPop() async  {

    if (_closeAll()) {
      return false;
    }

    return true;
  }

  Future<T?> showModal<T>(PageBuilder modal) => showGeneralDialog<T>(
      context: _context,
      pageBuilder: (c, animation, secondaryAnimation) => ModalScaffold(modal),
      barrierDismissible: true,
      barrierLabel: 'x'
  );

  ConfirmResultType showAlert(String content) async {
    return showConfirm(title: 'Alert'.T, content: content, ok: true);
  }

  // TODO stylize confirm box
  ConfirmResultType showConfirm({
    String? title, required String content,
    String? okText, bool ok = true,
    String? cancelText, bool? cancel,
    String? otherText, bool? other }) async {

    var result = await showDialog<ConfirmResult>(
      context: _context,
      builder: (BuildContext context) {

        var actions = <Widget>[];

        if (other == true || otherText != null) {
          actions.add(UniversalTextButton(
            text: otherText ?? 'Other'.T,
            onPressed: () => Navigator.pop(context, ConfirmResult.other),
          ));
        }

        if (cancel == true || cancelText != null) {
          actions.add(UniversalTextButton(
            text: cancelText ?? 'Cancel'.T,
            onPressed: () => Navigator.pop(context, ConfirmResult.cancel),
          ));
        }

        if (ok == true || okText != null) {
          actions.add(UniversalTextButton(
            text: okText ?? 'OK'.T,
            onPressed: () => Navigator.pop(context, ConfirmResult.confirm),
          ));
        }

        if (actions.isEmpty) throw UnexpectedError();

        return AlertDialog(
            title: Text(title ?? 'Confirm'.T),
            // backgroundColor: Colors.lightBlue,
            content: Text(content),
            actions: actions
          );
        }
    );

    return result ?? ConfirmResult.cancel; // if closed by barrierDismissible
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text(text))
    );
  }


  (String, VoidCallback) protectIfNotReady({required String title, required VoidCallback callback, required bool isReady}) {

    if (!isReady) {
      return (title, () => showModal(() => UnderConstructionModal(title: title)));
    }

    return (title, callback);
  }

  void showIfReady({required String title, required PageBuilder callback, required bool isReady}) {

    showModal(isReady ? callback : () => UnderConstructionModal(title: title));
  }
}


