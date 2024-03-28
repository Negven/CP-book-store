

import 'package:client/theme/theme.dart';
import 'package:client/utils/call_utils.dart';
import 'package:client/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiLoader extends StatelessWidget {

  final canLoad = false.obs;

  EmojiLoader._private() {
    // Loading after main resources loaded
    CallUtils.timeout(() => canLoad.value = true, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Obx(() => canLoad.value ? Text("🧁", style: context.texts.walletIcon) : Empty.instance));
  }

  static final instance = EmojiLoader._private();
}
