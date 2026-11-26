import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/movie_failure.dart';

String localizedMovieFailure(AppLocalizations l10n, MovieFailure failure) {
  return switch (failure.type) {
    MovieFailureType.network => l10n.movieErrorNetwork,
    MovieFailureType.timeout => l10n.movieErrorTimeout,
    MovieFailureType.api => l10n.movieErrorApi,
    MovieFailureType.invalidResponse => l10n.movieErrorInvalidResponse,
    MovieFailureType.unexpected => l10n.errorUnexpected,
  };
}
