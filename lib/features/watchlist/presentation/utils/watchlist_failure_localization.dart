import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/watchlist_failure.dart';

String localizedWatchlistFailure(
  AppLocalizations l10n,
  WatchlistFailure failure,
) {
  return switch (failure.type) {
    WatchlistFailureType.unauthenticated => l10n.watchlistErrorUnauthenticated,
    WatchlistFailureType.permissionDenied => l10n.watchlistErrorPermission,
    WatchlistFailureType.network => l10n.watchlistErrorNetwork,
    WatchlistFailureType.invalidData => l10n.watchlistErrorInvalidData,
    WatchlistFailureType.unexpected => l10n.errorWatchList,
  };
}
