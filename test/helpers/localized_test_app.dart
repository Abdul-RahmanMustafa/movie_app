import 'package:flutter/material.dart';
import 'package:movie_app/l10n/generated/app_localizations.dart';

class LocalizedTestApp extends StatelessWidget {
  const LocalizedTestApp({
    super.key,
    required this.home,
    this.locale = const Locale('en'),
  });

  final Widget home;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );
  }
}
