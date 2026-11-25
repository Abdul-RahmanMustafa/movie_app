enum MovieFailureType { network, timeout, api, invalidResponse, unexpected }

class MovieFailure implements Exception {
  const MovieFailure({required this.type, required this.message});

  final MovieFailureType type;
  final String message;
}
