import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the real Roboto font for layout tests.
///
/// `flutter_test` uses Ahem by default, where every glyph is a square as wide
/// as the font size. That makes short rows look far wider than they do on a
/// device and produces false overflow reports. The app theme uses Roboto, so
/// loading the SDK copy gives tests realistic text metrics.
Future<void> loadRobotoForTests() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) return;

  final fontFile = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
  );
  if (!fontFile.existsSync()) return;

  final bytes = await fontFile.readAsBytes();
  final loader = FontLoader('Roboto')
    ..addFont(Future<ByteData>.value(ByteData.view(bytes.buffer)));
  await loader.load();
}
