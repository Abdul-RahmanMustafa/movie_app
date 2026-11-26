import 'package:flutter/material.dart';

import 'locale_storage.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({this.storage, Locale? initialLocale})
    : _locale = initialLocale ?? const Locale('en');

  static const supportedLanguageCodes = {'en', 'ar'};

  final LocaleStorage? storage;
  Locale _locale;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> load() async {
    String? languageCode;
    try {
      languageCode = await storage?.readLocale();
    } catch (_) {
      return;
    }
    if (languageCode == null ||
        !supportedLanguageCodes.contains(languageCode) ||
        languageCode == _locale.languageCode) {
      return;
    }
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLanguageCodes.contains(locale.languageCode)) return;
    if (_locale.languageCode != locale.languageCode) {
      _locale = Locale(locale.languageCode);
      notifyListeners();
    }
    try {
      await storage?.writeLocale(locale.languageCode);
    } catch (_) {
      // The in-memory locale still changes even if local persistence fails.
    }
  }
}
