import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocaleStorage {
  Future<String?> readLocale();

  Future<void> writeLocale(String languageCode);
}

class SharedPreferencesLocaleStorage implements LocaleStorage {
  const SharedPreferencesLocaleStorage();

  static const String localeKey = 'selected_locale';

  @override
  Future<String?> readLocale() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(localeKey);
  }

  @override
  Future<void> writeLocale(String languageCode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(localeKey, languageCode);
  }
}
