enum WatchlistFailureType {
  unauthenticated,
  permissionDenied,
  network,
  invalidData,
  unexpected,
}

class WatchlistFailure implements Exception {
  const WatchlistFailure({required this.type, required this.message});

  final WatchlistFailureType type;
  final String message;
}
