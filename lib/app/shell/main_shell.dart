import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_navigation_bar.dart';
import '../../features/authentication/presentation/providers/auth_controller.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/movies/presentation/providers/movies_controller.dart';
import '../../features/profile/presentation/providers/profile_controller.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/watchlist/presentation/providers/watchlist_controller.dart';

/// Hosts the four main tabs and overlays the shared bottom navigation bar.
///
/// The bar is drawn on top of the pages, matching the Figma Home frame where
/// the navigation bar overlaps the bottom of the content.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.moviesController,
    this.watchlistController,
    this.profileController,
    this.authController,
  });

  final MoviesController? moviesController;
  final WatchlistController? watchlistController;
  final ProfileController? profileController;
  final AuthController? authController;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final GlobalKey<ExploreScreenState> _exploreKey =
      GlobalKey<ExploreScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey =
      GlobalKey<ProfileScreenState>();

  // Index of the currently visible tab. Home is the default.
  int _selectedIndex = AppBottomNavigationBar.homeIndex;

  // Pages are created on first visit and kept alive by IndexedStack so scroll
  // position is preserved. Building all four tabs at startup fired every
  // screen's initial network/stream work at once.
  final List<Widget> _pages = List<Widget>.filled(
    4,
    const SizedBox.shrink(),
    growable: false,
  );
  final Set<int> _createdTabs = <int>{};

  String? _pendingGenre;

  @override
  void initState() {
    super.initState();
    _createTab(_selectedIndex);
  }

  void _createTab(int index) {
    if (!_createdTabs.add(index)) return;
    _pages[index] = switch (index) {
      AppBottomNavigationBar.homeIndex => HomeScreen(
        moviesController: widget.moviesController,
        onExploreRequested: () => _showExploreGenre('Action'),
      ),
      AppBottomNavigationBar.vectorIndex => SearchScreen(
        moviesController: widget.moviesController,
      ),
      AppBottomNavigationBar.exploreIndex => ExploreScreen(
        key: _exploreKey,
        moviesController: widget.moviesController,
      ),
      // Profile loads its own data on first creation. Passing
      // `autoLoadData: false` left the first visit spinning forever because
      // nothing called `refreshProfile()` until the tab was tapped again.
      AppBottomNavigationBar.profileIndex => ProfileScreen(
        key: _profileKey,
        watchlistController: widget.watchlistController,
        profileController: widget.profileController,
        authController: widget.authController,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  /// Handles a bottom-bar tap and rebuilds only the selected tab.
  void _onTabTap(int index) {
    if (index == _selectedIndex) {
      if (index == AppBottomNavigationBar.profileIndex) {
        _profileKey.currentState?.refreshProfile();
      }
      return;
    }
    setState(() {
      _selectedIndex = index;
      _createTab(index);
    });
  }

  void _showExploreGenre(String genre) {
    _pendingGenre = genre;
    if (_selectedIndex != AppBottomNavigationBar.exploreIndex) {
      setState(() {
        _selectedIndex = AppBottomNavigationBar.exploreIndex;
        _createTab(AppBottomNavigationBar.exploreIndex);
      });
    }
    _applyPendingGenre();
  }

  /// Applies a genre requested before Explore was built (for example from the
  /// Home "See More" link on first launch).
  void _applyPendingGenre() {
    final genre = _pendingGenre;
    if (genre == null) return;

    final state = _exploreKey.currentState;
    if (state == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final state = _exploreKey.currentState;
        if (state == null) return;
        final genre = _pendingGenre;
        if (genre == null) return;
        _pendingGenre = null;
        state.showGenre(genre);
      });
      return;
    }

    _pendingGenre = null;
    state.showGenre(genre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // The active page fills the whole screen behind the nav bar.
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                for (var index = 0; index < _pages.length; index++)
                  // Hidden tabs must not animate: the hero carousel would keep
                  // scheduling frames for a page nobody can see.
                  TickerMode(
                    enabled: index == _selectedIndex,
                    child: _pages[index],
                  ),
              ],
            ),
          ),

          // Shared nav bar pinned to the bottom and drawn above the page.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigationBar(
              selectedIndex: _selectedIndex,
              onTap: _onTabTap,
            ),
          ),
        ],
      ),
    );
  }
}
