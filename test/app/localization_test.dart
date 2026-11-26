import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/app/app.dart';
import 'package:movie_app/core/localization/locale_controller.dart';
import 'package:movie_app/core/localization/localization_extensions.dart';
import 'package:movie_app/features/authentication/presentation/widgets/language_toggle.dart';

void main() {
  testWidgets('language toggle switches between LTR English and RTL Arabic', (
    tester,
  ) async {
    final controller = LocaleController();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Column(
              children: [Text(context.l10n.login), const LanguageToggle()],
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MovieApp(routerConfig: router, localeController: controller),
    );

    final englishText = find.text('Login');
    expect(englishText, findsOneWidget);
    expect(Directionality.of(tester.element(englishText)), TextDirection.ltr);

    await tester.tap(find.bySemanticsLabel('Arabic'));
    await tester.pumpAndSettle();

    final arabicText = find.text('تسجيل الدخول');
    expect(arabicText, findsOneWidget);
    expect(Directionality.of(tester.element(arabicText)), TextDirection.rtl);
    expect(controller.locale, const Locale('ar'));
  });
}
