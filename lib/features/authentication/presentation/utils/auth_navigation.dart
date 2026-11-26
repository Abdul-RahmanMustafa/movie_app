abstract final class AuthNavigation {
  static const Set<String> protectedPaths = {'/home', '/edit-profile'};

  static bool isProtectedPath(String path) {
    return protectedPaths.contains(path) || path.startsWith('/movie/');
  }

  static String? safeProtectedDestination(String? rawDestination) {
    if (rawDestination == null || rawDestination.isEmpty) return null;
    final destination = Uri.tryParse(rawDestination);
    if (destination == null ||
        destination.hasScheme ||
        destination.hasAuthority ||
        !isProtectedPath(destination.path)) {
      return null;
    }
    return destination.toString();
  }

  static String routeWithDestination(String route, String? destination) {
    final safeDestination = safeProtectedDestination(destination);
    if (safeDestination == null) return route;
    return Uri(
      path: route,
      queryParameters: {'from': safeDestination},
    ).toString();
  }
}
