import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../explore/presentation/widgets/explore_movie_card.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/entities/movie_list_query.dart';
import '../../../movies/domain/movie_failure.dart';
import '../../../movies/presentation/providers/movies_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.moviesController});

  final MoviesController? moviesController;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final MoviesController _moviesController =
      widget.moviesController ?? MoviesDependencies.controller;
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  List<Movie> _movies = const [];
  String _activeQuery = '';
  String? _errorMessage;
  bool _isLoading = false;
  int _requestId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    final requestId = ++_requestId;

    if (query.isEmpty) {
      setState(() {
        _activeQuery = '';
        _movies = const [];
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 450),
      () => _search(query, requestId),
    );
  }

  Future<void> _search(String query, int requestId) async {
    if (!mounted || requestId != _requestId) return;
    setState(() {
      _activeQuery = query;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final page = await _moviesController.listMovies(
        MovieListQuery(limit: 20, queryTerm: query, sortBy: MovieSortBy.rating),
      );
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _movies = page.movies;
        _isLoading = false;
      });
    } on MovieFailure catch (failure) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _movies = const [];
        _errorMessage = failure.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _movies = const [];
        _errorMessage = 'Something went wrong while searching movies.';
        _isLoading = false;
      });
    }
  }

  void _retry() {
    if (_activeQuery.isEmpty) return;
    final requestId = ++_requestId;
    _search(_activeQuery, requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = AppLayout.scaleForWidth(constraints.maxWidth);
            final bottomPadding = AppLayout.bottomContentPadding(
              context,
              scale,
            );
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16 * scale,
                    16 * scale,
                    16 * scale,
                    20 * scale,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      key: const Key('movie_search_field'),
                      controller: _searchController,
                      onChanged: _onQueryChanged,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        hintText: 'Search movies',
                        hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.accent,
                        ),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, _) {
                            if (value.text.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return IconButton(
                              onPressed: () {
                                _searchController.clear();
                                _onQueryChanged('');
                              },
                              icon: const Icon(Icons.close),
                            );
                          },
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12 * scale),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12 * scale),
                          borderSide: const BorderSide(color: AppColors.accent),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  )
                else if (_errorMessage != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TextButton(
                            onPressed: _retry,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_activeQuery.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('Search for a movie by title.')),
                  )
                else if (_movies.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No movies found for “$_activeQuery”.'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      16 * scale,
                      0,
                      16 * scale,
                      bottomPadding,
                    ),
                    sliver: SliverGrid.builder(
                      itemCount: _movies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12 * scale,
                        crossAxisSpacing: 12 * scale,
                        childAspectRatio: 189 / 279,
                      ),
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ExploreMovieCard(
                          key: Key('search_movie_${movie.id}'),
                          movie: movie,
                          index: index,
                          scale: scale,
                          onTap: () => context.push('/movie/${movie.id}'),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
