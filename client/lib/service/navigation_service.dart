

import 'package:client/classes/pages.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';



class NavigationService extends GetxService {

  BuildContext get context => Get.key.currentContext!;

  @override
  void onReady() {
    super.onReady();

    Services.auth.listen(() {
      // In case of credentials outdated/expired
      // final walletId = nCurrentWalletId;
      // if (walletId != null) {
      //   if (!Services.auth.credentials.containsKey(walletId)) {
      //     go(initialPage());
      //   }
      // }
    });
  }

  GoRouter get _router => GoRouter.of(context);
  Uri get uri => _router.routeInformationProvider.value.uri;

  String get path => uri.toString(); // /app/wallet/AA12BCD34/overview
  String get routePath => uri.path; //  /app/wallet/:walletId/overview

  // String initialPage([String? walletId]) => Services.auth.isSignedIn ? Pages.catalogue : Pages.inf;
  String initialPage() => Pages.catalogue;

  String bookPage(String bookId) => Pages.bookPageUrl(bookId);

  void goToBook(String bookId) => go(bookPage(bookId));
  void goToInitial() => go(initialPage());

  // WalletId taken from URL
  // String? get nCurrentWalletId => Pages.walletIdFromPath(path);
  // String get rCurrentWalletId => nCurrentWalletId!;

  String _prepareLocation(String nextLocation, Map<String,String>? params) {

    Uri uri = Uri.parse(nextLocation);
    if (params != null && params.isNotEmpty) {
      final next = <String,String>{};
      next.addAll(uri.queryParameters);
      next.addAll(params);
      uri = uri.replace(queryParameters: next);
    }

    return uri.toString();
  }

  void go(String location, [Map<String,String>? params]) {
    _router.go(_prepareLocation(location, params));
  }

  void replace(Map<String,String> params) {
    go(uri.path, params);
  }

  final currentPath = Routes.root.obs;
  int get currentUserId => Services.auth.storage.getItem("userId");

  void triggerNavigation() {
    // currentUserId.value = nCurrentWalletId; // to make possible use in UI
    currentPath.value = path;
  }


}