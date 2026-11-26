enum AuthFailureType {
  invalidEmail,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  networkUnavailable,
  tooManyRequests,
  userDisabled,
  cancelled,
  accountConflict,
  providerConfiguration,
  permissionDenied,
  profileCreationFailed,
  unexpected,
}

class AuthFailure implements Exception {
  const AuthFailure({required this.type, required this.message});

  final AuthFailureType type;
  final String message;
}
