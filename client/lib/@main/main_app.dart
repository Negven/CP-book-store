
import 'package:client/@main/routing/routes_builder.dart';
import 'package:client/classes/logger_extension.dart';
import 'package:client/classes/sizes.dart';
import 'package:client/service/_services.dart';
import 'package:client/service/modals_service.dart';
import 'package:client/utils/responsive_utils.dart';
import 'package:client/utils/widget_utils.dart';
import 'package:client/widgets/emoji_loader.dart';
import 'package:client/widgets/on_layout_initializer.dart';
import 'package:client/widgets/root.dart';
import 'package:client/widgets/spendly.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';


// NB! All widgets renders out of MaterialApp context, but some of them are using Overlay, Material or Navigator, so creating needed stack
class MaterialMiddleware extends StatelessWidget {

  const MaterialMiddleware({super.key});

  @override
  Widget build(BuildContext context) {

      final materialStack = Scaffold(body: Stack(
          fit: StackFit.expand,
          children: [
            EmojiLoader.instance, // NB! Must be here to be "invisible"
            Root.instance
          ]
      ));

      return HeroControllerScope(
          controller: MaterialApp.createMaterialHeroController(),
          child: Navigator(
            key: ModalsService.navigatorKey,
            onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                // builder: (context) => materialStack
                builder: (context) => materialStack

          )
          )
      );
  }

}

class MainApp extends StatelessWidget {

  static final _logger = Logger((MainApp).toString());

  final _router = Rxn<GoRouter>();
  final _middleware = MaterialMiddleware(key: GlobalKey(debugLabel: "MiddlewareKey"));

  MainApp({super.key});

  Widget mainBuilder(BuildContext context, Widget? child) {

    // TODO test theme change
    Services.themes.updateOverlayStyle(context);

    final content = Stack(
        fit: StackFit.expand,
        children: [
          child!, // Must be here and must be visible to make MaterialApp work
          _middleware,
        ]
    );

    return Directionality(
        textDirection: Services.translations.textDirection,
        child: SafeArea(
            bottom: false, // Ignoring opening on screen keyboard
            child: content
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    final t = Services.translations;

    return OnLayoutBuild(
        listener: (constraints) {

          if (ResponsiveUtils.recalculate(constraints.maxWidth, constraints.maxHeight)) {

            var previous = sizes.content;
            Sizes.updateCache(); // Must be called first
            _logger.infoOnChange("Content", previous, sizes.content);

            // NB! looks like calling Get.rootController.update() not needed as on resize global build called
            Get.rootController.theme = Services.themes.light(ResponsiveUtils.factor);
            Get.rootController.darkTheme = Services.themes.dark(ResponsiveUtils.factor);

            // NB! Needed to recalculate all responsive values on ResponsiveUtils.factor change
            WidgetUtils.markNeedsBuildAll(_middleware.key as GlobalKey);
          }

          var previous = Get.rootController.themeMode;
          Get.rootController.themeMode = Services.themes.themeMode;
          _logger.infoOnChange("ThemeMode", previous, Get.rootController.themeMode);
        },
        child: GetBuilder<GetMaterialController>(
          init: Get.rootController,
          initState: (i) {
            Get.smartManagement = SmartManagement.keepFactory; // NB! Don't change, can break GetX lifecycle
            Get.addTranslations(t.keys.keys);
            _router.value = buildRoutes();
            _logger.info("Initialized");
          },
          dispose: (_) {
            _logger.info("Disposed");
          },
          builder: (_) {

            _logger.info("Build ${ _.theme!.brightness }  ${ _.darkTheme!.brightness } ${_.themeMode!}");

            return MaterialApp.router(
              // NB! Don't use onGenerateTitle as its not generating title
              // NB! To change title dynamically on web use Title widget
              title: SpendlyInfo.title,

              key: _.unikey,
              debugShowCheckedModeBanner: false,

              routerConfig: _router.value!,

              builder: mainBuilder,

              color: _.theme!.primaryColor,
              theme: _.theme!,
              darkTheme: _.darkTheme!,
              themeMode: _.themeMode!,

              locale: Get.locale,
              scaffoldMessengerKey: _.scaffoldMessengerKey,
              localizationsDelegates: t.localizationsDelegates,
              supportedLocales: t.supportedLocales,

              // shortcuts: shortcuts // Can be used in the future
            );

          }
        )
    );
  }
}
