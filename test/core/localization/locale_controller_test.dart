import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/core/localization/locale_controller.dart';
import 'package:movie_app/core/localization/locale_storage.dart';

void main() {
  test('restores and persists supported locales', () async {
    final storage = _FakeLocaleStorage('ar');
    final controller = LocaleController(storage: storage);

    await controller.load();
    expect(controller.locale, const Locale('ar'));

    await controller.setLocale(const Locale('en'));
    expect(controller.locale, const Locale('en'));
    expect(storage.savedLanguageCode, 'en');
  });

  test('ignores an unsupported stored locale', () async {
    final controller = LocaleController(storage: _FakeLocaleStorage('fr'));

    await controller.load();

    expect(controller.locale, const Locale('en'));
  });
}

class _FakeLocaleStorage implements LocaleStorage {
  _FakeLocaleStorage(this.savedLanguageCode);

  String? savedLanguageCode;

  @override
  Future<String?> readLocale() async => savedLanguageCode;

  @override
  Future<void> writeLocale(String languageCode) async {
    savedLanguageCode = languageCode;
  }
}
