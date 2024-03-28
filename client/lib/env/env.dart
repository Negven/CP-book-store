

import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/network_utils.dart';
import 'package:client/utils/string_utils.dart';

// NB! Must be same as in Profile.java
enum Profile { dev, prod }

class Env {

  Profile? profile;
  String googleAuthClientId = "";

  String _apiUrl = "";
  String get apiUrl => _apiUrl;
  set apiUrl(String url) => _apiUrl = NetworkUtils.prepareUrl(url);

  String devUserMasterKey = "";
  String devUserPublicKey = "";
  String devUserWalletKey = "";

  get isProd => profile == Profile.prod;
  get isDev => profile == Profile.dev;

  validate() {

    if (ConvertUtils.anyIsEmpty([profile, googleAuthClientId, apiUrl])) {
      throw "Invalid Env configuration";
    }

    if (isDev) {
      if (StringUtils.anyIsEmpty([devUserMasterKey, devUserPublicKey, devUserWalletKey])) {
        throw "Invalid DevUser configuration";
      }
    }

    if (isProd){
      if (StringUtils.anyNotEmpty([devUserMasterKey, devUserPublicKey, devUserWalletKey])) {
        throw "Invalid DevUser configuration";
      }
    }
  }

}


final Env iEnv = Env();

// To use in const/static values
bool isDev() => iEnv.isDev;
bool isProd() => iEnv.isProd;
