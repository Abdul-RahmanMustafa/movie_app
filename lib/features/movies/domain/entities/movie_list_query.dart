enum MovieSortBy {
  title,
  year,
  rating,
  peers,
  seeds,
  downloadCount,
  likeCount,
  dateAdded,
}

enum MovieOrder { ascending, descending }

class MovieListQuery {
  const MovieListQuery({
    this.page = 1,
    this.limit = 20,
    this.queryTerm,
    this.genre,
    this.minimumRating = 0,
    this.sortBy = MovieSortBy.dateAdded,
    this.order = MovieOrder.descending,
  });

  final int page;
  final int limit;
  final String? queryTerm;
  final String? genre;
  final int minimumRating;
  final MovieSortBy sortBy;
  final MovieOrder order;

  void validate() {
    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Must be at least 1.');
    }
    if (limit < 1 || limit > 50) {
      throw ArgumentError.value(limit, 'limit', 'Must be between 1 and 50.');
    }
    if (minimumRating < 0 || minimumRating > 9) {
      throw ArgumentError.value(
        minimumRating,
        'minimumRating',
        'Must be between 0 and 9.',
      );
    }
  }
}
