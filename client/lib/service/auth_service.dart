

import 'dart:async';

import 'package:client/dto/access_state_dto.dart';
import 'package:client/enum/preferences.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';
import 'package:client/utils/error_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logging/logging.dart';

import '_services.dart';


const _empty = <CredentialDto>[];

class AuthService extends GetxService {

  static final Logger _logger = Logger((AuthService).toString());

  final credentials = <String, CredentialDto>{}; // Map - to make possible update silently expired credentials

  String jwt(String walletId) {
    final c = credentials[walletId];
    return c!.details.jwt;
  }

  @override
  void onInit() {
    super.onInit();

    if (!Preference.authCredentials.hasValue) {
      _logger.info("Credentials are empty");
      return;
    }

    _logger.info("Stored ${Preference.authCredentials.storedValue} credentials");

    final storedCredentials = ConvertUtils.fromJsonListStr(Preference.authCredentials.storedValue, CredentialDto.fromJson);
    _logger.info("Loaded ${storedCredentials.length} credentials");

    for (var c in storedCredentials) {
      // _logger.info("Available credentials with userId: ${c.details.user.id} and walletId: ${c.details.wallet.id}");
    }

    var saved = CredentialDto.notExpired(storedCredentials);
    _logger.info("Found ${saved.length} not expired credentials");

    ConvertUtils.fillMapUid(credentials, saved);

    CallUtils.timeout(() => renewCredentials(force: false), 1000);
  }

  void renewCredentials({required bool force}) async {

    var toUpdate = <CredentialDto>[];
    var toRemove = <CredentialDto>[];
    for (var credential in credentials.values) {

      if (!force && credential.details.createdAt.isAfter(UtcDateTime.now.subtract(const Duration(days: 3)))) {
        continue; // NB! making renew once per 3 days
      }

      try {
        // final result = await Services.walletApi.tokenRenew(credential.uid!);
        // if (result.isGranted) {
        //   toUpdate.add(result as CredentialDto);
        // } else {
        //   toRemove.add(credential);
        // }
      } catch (e) {

        if (e is ResponseError) {
          if (e.status.isUnauthorized) {
            printInfo(info: "Removing expired token from credential for ${credential.uid}");
            toRemove.add(credential);
          }
        }

        debugPrint("$e");
      }

    }

    make(signIn: toUpdate, signOut: toRemove);

  }

  final LocalStorage storage = LocalStorage('book_store.json');

  void signIn(AccessStateDto value) {
    storage.setItem("token", value.token);
    storage.setItem('userId', value.userId);
    triggerChange();
    Services.modals.closeOne();
  }

  bool get isSignedIn => storage.getItem("token") != null;
  String get token => storage.getItem("token");

  void logOut () {
    storage.deleteItem("token");
    triggerChange();
  }

  String? getInitialWalletId() {
    var sorted = ConvertUtils.sort(credentials.values);
    return ConvertUtils.firstUid(sorted);
  }

  storeCredentials() {
    Preference.authCredentials.storedValue = ConvertUtils.toJsonListStr(credentials.values);
    _logger.info("Storing credentials ${Preference.authCredentials.storedValue}");
    triggerChange();
  }

  final event = 0.obs;

  void triggerChange() {
    event.value++;
  }

  StreamSubscription<int> listen(Function() fn, { bool instant = false }) {
    try {
      return event.listen((_) { fn.call(); });
    } finally {
      if (instant) fn.call();
    }
  }

  make({Iterable<CredentialDto> signIn = _empty, Iterable<CredentialDto> signOut = _empty}) {

    if (signIn.isNotEmpty) {
      for (var credential in signIn) {
        credentials[credential.uid!] = credential;
      }
    }

    if (signOut.isNotEmpty) {
      for (var c in signOut) {
        credentials.remove(c.uid);
      }
    }

    storeCredentials();
  }

  void signOutAll({ fromAllDevices = false }) {

    if (fromAllDevices) {
      throw "NIE"; // TODO
    }

    make(signOut: credentials.values);
  }

}
