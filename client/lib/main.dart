
import 'package:client/@main/main_app.dart';
import 'package:client/@main/main_init.dart';
import 'package:client/env/env.dart';
import 'package:client/env/env_dev.dart';
import 'package:flutter/material.dart';
import 'package:dcdg/dcdg.dart';
void main() async {

  // Fully extracting release preferences for debug
  iEnv.configureDev();
  await MainInit.beforeAppStart();
  runApp(MainApp());

}
