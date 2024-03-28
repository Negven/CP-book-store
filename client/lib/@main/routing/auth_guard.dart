

import 'dart:async';

import 'package:client/classes/pages.dart';
import 'package:client/service/_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


FutureOr<String?> authGuard(BuildContext c, GoRouterState s) {

  // NB! Making sure that app routes only available under
  var path = s.uri.path;
  if (Pages.auth.map((e) => path.contains(e)).toList().where((element) => element).isNotEmpty) {

    if (!Services.auth.isSignedIn) {

      debugPrint("Not authorized to get to: ${s.uri}");
      return Services.navigation.initialPage();
    }

    // if (path.startsWith("${Pages.wallet}/")) {
    //
    //   String? walletId = Pages.walletIdFromUri(s.uri);
    //   if (walletId == null || !Services.auth.credentials.containsKey(walletId)) {
    //     debugPrint("Not authorized to get page for wallet: $walletId");
    //     return Services.navigation.initialPage();
    //   }
    // }

    return null;
  }

  return null;
}

