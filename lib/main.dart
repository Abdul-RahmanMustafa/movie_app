import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/localization/locale_controller.dart';
import 'core/localization/locale_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final localeController = LocaleController(
    storage: const SharedPreferencesLocaleStorage(),
  );
  await localeController.load();
  runApp(MovieApp(localeController: localeController));
}
