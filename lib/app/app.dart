import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/locale_controller.dart';
import '../core/localization/locale_scope.dart';
import '../core/theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';

class MovieApp extends StatefulWidget {
  const MovieApp({super.key, this.routerConfig, this.localeController});

  final GoRouter? routerConfig;
  final LocaleController? localeController;

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  late final LocaleController _localeController =
      widget.localeController ?? LocaleController();
  late final bool _ownsLocaleController = widget.localeController == null;

  @override
  void dispose() {
    if (_ownsLocaleController) _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      controller: _localeController,
      child: AnimatedBuilder(
        animation: _localeController,
        builder: (context, _) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.darkTheme,
          locale: _localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: widget.routerConfig ?? AppRouter.router,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: mediaQuery.textScaler.clamp(
                  minScaleFactor: 0.9,
                  maxScaleFactor: 1.2,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
