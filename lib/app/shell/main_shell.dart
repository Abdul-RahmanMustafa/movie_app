import 'package:flutter/material.dart';

import '../../core/widgets/app_bottom_navigation_bar.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/movies/presentation/providers/movies_controller.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/watchlist/presentation/providers/watchlist_controller.dart';

/// Hosts the four main tabs and overlays the shared bottom navigation bar.
///
/// The bar is drawn on top of the pages, matching the Figma Home frame where
/// the navigation bar overlaps the bottom of the content.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.moviesController, this.watchlistController});

  final MoviesController? moviesController;
  final WatchlistController? watchlistController;

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

  // Pages are kept alive by IndexedStack so scrolling position is preserved.
  // Tab order matches the bottom bar: home, search, explore, profile.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        moviesController: widget.moviesController,
        onExploreRequested: () => _showExploreGenre('Action'),
      ),
      SearchScreen(moviesController: widget.moviesController),
      ExploreScreen(
        key: _exploreKey,
        moviesController: widget.moviesController,
      ),
      ProfileScreen(
        key: _profileKey,
        watchlistController: widget.watchlistController,
        autoLoadData: false,
      ),
    ];
  }

  /// Handles a bottom-bar tap and rebuilds only the selected tab.
  void _onTabTap(int index) {
    if (index == AppBottomNavigationBar.profileIndex) {
      _profileKey.currentState?.refreshProfile();
    }
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  void _showExploreGenre(String genre) {
    _exploreKey.currentState?.showGenre(genre);
    _onTabTap(AppBottomNavigationBar.exploreIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // The active page fills the whole screen behind the nav bar.
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: _pages),
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
