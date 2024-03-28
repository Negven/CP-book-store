

// import 'package:client/@app/modals/wallet_add/@add_wallet_modal.dart';
import 'package:client/classes/constants.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/translations_service.dart';
import 'package:client/theme/theme.dart';
import 'package:client/utils/network_utils.dart';
import 'package:client/widgets/font_icon.dart';
import 'package:client/widgets/universal/universal_template.dart';
import 'package:client/widgets/universal/universals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignInButtons extends StatelessWidget {

  final List<Widget> children;
  const SignInButtons({super.key, required this.children});

  @override
  Widget build(BuildContext context) {

    List<Widget> widgets = [
      ...children,
      sizes.sizedBoxV.lg
    ];

    // final (title, colorTheme, callback) = AddWalletModal.signIn();
    // widgets.add(UniversalFilledButton(onPressed: callback, theme: colorTheme, alignment: Alignment.center, size: SizeVariant.md, fontSize: SizeVariant.lg, elevation: SizeVariant.md, text: title));

    if (!GetPlatform.isMobile) {

      final (gpTitle, gpCallback) = Services.modals.protectIfNotReady(title: "Google Play", isReady: false, callback: () => NetworkUtils.openUrl(Constants.appLinkToGooglePlay));
      final (asTitle, asCallback) = Services.modals.protectIfNotReady(title: "App Store", isReady: false, callback: () => NetworkUtils.openUrl(Constants.appLinkToAppStore));

      final template = context.templates.whiteButton.copyWith(
          borderSize: SizeVariant.md,
          layoutOrientation: LayoutOrientation.vertical
      );

      widgets.addAll([
        sizes.sizedBoxV.lg,
        Text('or_download_from'.T, textAlign: TextAlign.center, style: context.texts.textInactiveStyle),
        sizes.sizedBoxV.lg,
        Row(
          children: [
            Expanded(child: UniversalTextButton(template: template, icon: FontIcon.playStore, text: gpTitle, onPressed: gpCallback)),
            sizes.sizedBoxH.lg,
            Expanded(child: UniversalTextButton(template: template, icon: FontIcon.appleIcon, text: asTitle, onPressed: asCallback)),
          ],
        ),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets
    );
  }

}