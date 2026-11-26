import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/localization/locale_controller.dart';
import 'package:movie_app/core/localization/locale_scope.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/l10n/generated/app_localizations.dart';

/// A named logical surface size used by the responsive layout tests.
class ScreenSize {
  const ScreenSize(this.name, this.size);

  final String name;
  final Size size;
}

/// Small phones up to tablets, portrait and landscape.
const kResponsiveScreenSizes = <ScreenSize>[
  ScreenSize('small phone 320x568', Size(320, 568)),
  ScreenSize('compact android 360x640', Size(360, 640)),
  ScreenSize('iphone 8 375x667', Size(375, 667)),
  ScreenSize('iphone 13 390x844', Size(390, 844)),
  ScreenSize('pixel 412x915', Size(412, 915)),
  ScreenSize('figma 430x932', Size(430, 932)),
  ScreenSize('tablet 768x1024', Size(768, 1024)),
  ScreenSize('tablet landscape 1024x768', Size(1024, 768)),
  ScreenSize('phone landscape 844x390', Size(844, 390)),
];

/// Pumps [screen] on a surface of exactly [screenSize] logical pixels.
///
/// The widget is wrapped in the real app theme so text styles and colours match
/// production. Callers should follow up with `tester.pump()` (and more pumps
/// when the screen loads data) before asserting.
Future<void> pumpScreenAtSize(
  WidgetTester tester,
  ScreenSize screenSize,
  Widget screen, {
  double textScaleFactor = 1,
}) async {
  tester.view.physicalSize = screenSize.size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final localeController = LocaleController();
  addTearDown(localeController.dispose);

  await tester.pumpWidget(
    LocaleScope(
      controller: localeController,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(textScaleFactor),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: screen,
      ),
    ),
  );
}
