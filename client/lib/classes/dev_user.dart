
import 'package:client/env/env.dart';


// NB! On change -> sync with DevUser.java
class DevUser {

  final name = "Dev User";
  final email = "dev.user@spendly.eu";

  String get masterKey => iEnv.devUserMasterKey;
  String get pubKey => iEnv.devUserPublicKey;
  String get walletKey => iEnv.devUserWalletKey;

}

final iDevUser = DevUser();