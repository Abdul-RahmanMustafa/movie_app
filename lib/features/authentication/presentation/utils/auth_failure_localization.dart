import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/auth_failure.dart';

String localizedAuthFailure(AppLocalizations l10n, AuthFailure failure) {
  return switch (failure.type) {
    AuthFailureType.invalidEmail => l10n.authInvalidEmail,
    AuthFailureType.invalidCredentials => l10n.authInvalidCredentials,
    AuthFailureType.emailAlreadyInUse => l10n.authEmailInUse,
    AuthFailureType.weakPassword => l10n.authWeakPassword,
    AuthFailureType.networkUnavailable => l10n.authNetwork,
    AuthFailureType.tooManyRequests => l10n.authTooManyRequests,
    AuthFailureType.userDisabled => l10n.authUserDisabled,
    AuthFailureType.cancelled => l10n.authCancelled,
    AuthFailureType.accountConflict => l10n.authAccountConflict,
    AuthFailureType.providerConfiguration => l10n.authProviderConfiguration,
    AuthFailureType.permissionDenied => l10n.authPermissionDenied,
    AuthFailureType.profileCreationFailed => l10n.authProfileCreationFailed,
    AuthFailureType.unexpected => l10n.errorUnexpected,
  };
}
