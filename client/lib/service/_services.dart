
import 'package:client/classes/lazy.dart';
import 'package:client/classes/pages.dart';
import 'package:client/service/auth_service.dart';
import 'package:client/service/events_service.dart';
import 'package:client/service/modals_service.dart';
import 'package:client/service/navigation_service.dart';
import 'package:client/service/public_api_service.dart';
import 'package:client/service/storage_service.dart';
import 'package:client/service/themes_service.dart';
import 'package:client/service/translations_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// NB! Lazy to optimize calling services with zero-delay
abstract class Services {

  static final _themes = Lazy<ThemesService>.find();
  static ThemesService get themes => _themes.value;

  static final _storage = Lazy<StorageService>.find();
  static StorageService get storage => _storage.value;

  static final _translations = Lazy<TranslationsService>.find();
  static TranslationsService get translations => _translations.value;

  static final _navigation = Lazy<NavigationService>.find();
  static NavigationService get navigation => _navigation.value;

  static BuildContext get context => navigation.context;

  static final _auth = Lazy<AuthService>.find();
  static AuthService get auth => _auth.value;

  static final _modals = Lazy<ModalsService>.find();
  static ModalsService get modals => _modals.value;

  static final _events = Lazy<EventsService>.find();
  static EventsService get events => _events.value;

  static PublicApiService get publicApi => Get.find<PublicApiService>();
  // static WalletApiService get walletApi => Get.find<WalletApiService>();

  //TO DO to initialPage
  static String redirectToInitialPage(String location) => navigation.initialPage();

}
