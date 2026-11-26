import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/profile_failure.dart';

String localizedProfileFailure(AppLocalizations l10n, ProfileFailure failure) {
  return switch (failure.type) {
    ProfileFailureType.unauthenticated => l10n.profileErrorUnauthenticated,
    ProfileFailureType.permissionDenied => l10n.profileErrorPermission,
    ProfileFailureType.network => l10n.profileErrorNetwork,
    ProfileFailureType.invalidData => l10n.profileErrorInvalidData,
    ProfileFailureType.unexpected => l10n.errorLoadProfile,
  };
}
