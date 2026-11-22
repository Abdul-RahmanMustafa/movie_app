enum ProfileFailureType {
  unauthenticated,
  permissionDenied,
  network,
  invalidData,
  unexpected,
}

class ProfileFailure implements Exception {
  const ProfileFailure({required this.type, required this.message});

  final ProfileFailureType type;
  final String message;
}
