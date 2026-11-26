import '../../../../l10n/generated/app_localizations.dart';

String? Function(String?) requiredValidator(AppLocalizations l10n) {
  return (value) =>
      value == null || value.trim().isEmpty ? l10n.validationRequired : null;
}

String? Function(String?) emailValidator(AppLocalizations l10n) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validationEmailRequired;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
      return l10n.validationEmailInvalid;
    }
    return null;
  };
}

String? Function(String?) passwordValidator(AppLocalizations l10n) {
  return (value) {
    if (value == null || value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.length < 8) return l10n.validationPasswordLength;
    return null;
  };
}
