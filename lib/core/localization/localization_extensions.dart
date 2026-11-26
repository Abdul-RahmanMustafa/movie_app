import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}

extension GenreLocalization on AppLocalizations {
  String genreLabel(String genre) {
    return switch (genre.trim().toLowerCase()) {
      'action' => genreAction,
      'adventure' => genreAdventure,
      'animation' => genreAnimation,
      'biography' => genreBiography,
      'comedy' => genreComedy,
      'crime' => genreCrime,
      'documentary' => genreDocumentary,
      'drama' => genreDrama,
      'family' => genreFamily,
      'fantasy' => genreFantasy,
      'history' => genreHistory,
      'horror' => genreHorror,
      'music' => genreMusic,
      'musical' => genreMusical,
      'mystery' => genreMystery,
      'romance' => genreRomance,
      'sci-fi' || 'science fiction' => genreSciFi,
      'sport' => genreSport,
      'thriller' => genreThriller,
      'war' => genreWar,
      'western' => genreWestern,
      _ => genre,
    };
  }
}
