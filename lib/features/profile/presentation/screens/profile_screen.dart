import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/layout/app_layout.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/domain/auth_failure.dart';
import '../../../authentication/presentation/providers/auth_controller.dart';
import '../../../authentication/presentation/utils/auth_failure_localization.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../watchlist/domain/watchlist_failure.dart';
import '../../../watchlist/presentation/providers/watchlist_controller.dart';
import '../../../watchlist/presentation/utils/watchlist_failure_localization.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/profile_failure.dart';
import '../models/profile_list_entry.dart';
import '../profile_section.dart';
import '../providers/profile_controller.dart';
import '../utils/profile_failure_localization.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_list.dart';
import '../widgets/profile_stat.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.watchlistController,
    this.profileController,
    this.authController,
    this.autoLoadData = true,
  });

  final WatchlistController? watchlistController;
  final ProfileController? profileController;
  final AuthController? authController;
  final bool autoLoadData;

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  static const Color _panelBackground = Color(0xFF212121);
  static const Color _danger = Color(0xFFE53935);

  late final WatchlistController _watchlistController =
      widget.watchlistController ?? WatchlistDependencies.controller;
  late final ProfileController _profileController =
      widget.profileController ?? ProfileDependencies.controller;
  late final AuthController _authController =
      widget.authController ?? AuthController.firebase();

  StreamSubscription<List<Movie>>? _watchlistSubscription;
  StreamSubscription<UserProfile>? _profileSubscription;
  List<Movie> _watchlist = const [];
  UserProfile? _profile;
  ProfileSection _section = ProfileSection.watchList;
  String? _watchlistError;
  String? _profileError;
  bool _watchlistLoading = true;
  bool _profileLoading = true;
  bool _dataStarted = false;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoLoadData) refreshProfile();
  }

  @override
  void dispose() {
    unawaited(_watchlistSubscription?.cancel());
    unawaited(_profileSubscription?.cancel());
    super.dispose();
  }

  void refreshProfile({bool force = false}) {
    if (_dataStarted && !force) return;
    _dataStarted = true;
    _observeProfile();
    _observeWatchlist();
  }

  void _observeProfile() {
    unawaited(_profileSubscription?.cancel());
    setState(() {
      _profileLoading = true;
      _profileError = null;
    });
    _profileSubscription = _profileController.observeProfile().listen(
      (profile) {
        if (!mounted) return;
        setState(() {
          _profile = profile;
          _profileLoading = false;
          _profileError = null;
        });
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _profileLoading = false;
          _profileError = error is ProfileFailure
              ? localizedProfileFailure(context.l10n, error)
              : context.l10n.errorLoadProfile;
        });
      },
    );
  }

  void _observeWatchlist() {
    unawaited(_watchlistSubscription?.cancel());
    setState(() {
      _watchlistLoading = true;
      _watchlistError = null;
    });
    _watchlistSubscription = _watchlistController.observeWatchlist().listen(
      (movies) {
        if (!mounted) return;
        setState(() {
          _watchlist = movies;
          _watchlistLoading = false;
          _watchlistError = null;
        });
      },
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _watchlistLoading = false;
          _watchlistError = error is WatchlistFailure
              ? localizedWatchlistFailure(context.l10n, error)
              : context.l10n.errorLoadWatchList;
        });
      },
    );
  }

  Future<void> _openEditProfile() async {
    await context.push<bool>('/edit-profile');
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      await _authController.signOut();
      if (!mounted) return;
      context.go('/login');
    } on AuthFailure catch (failure) {
      if (!mounted) return;
      _showMessage(localizedAuthFailure(context.l10n, failure));
    } catch (_) {
      if (!mounted) return;
      _showMessage(context.l10n.errorSignOut);
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w400),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = AppLayout.scaleForWidth(constraints.maxWidth);
            return Column(
              children: [
                _buildHeader(scale),
                _buildTabs(scale),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16 * scale,
                      14 * scale,
                      16 * scale,
                      82 * scale + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _buildSectionContent(scale),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    final profile = _profile;
    return Container(
      color: _panelBackground,
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        22 * scale,
        20 * scale,
        14 * scale,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 130 * scale,
                child: Column(
                  children: [
                    if (_profileLoading)
                      SizedBox(
                        width: 82 * scale,
                        height: 82 * scale,
                        child: const CircularProgressIndicator(
                          color: AppColors.accent,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      ProfileAvatar(
                        avatarIndex: profile?.avatarIndex ?? 0,
                        size: 118 * scale,
                      ),
                    SizedBox(height: 8 * scale),
                    Text(
                      profile?.name.isNotEmpty == true ? profile!.name : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'Roboto',
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ProfileStat(
                scale: scale,
                top: 0,
                centerX: 0,
                number: '${_watchlist.length}',
                label: context.l10n.profileWishList,
                positioned: false,
              ),
              SizedBox(width: 30 * scale),
              ProfileStat(
                scale: scale,
                top: 0,
                centerX: 0,
                number: '0',
                label: context.l10n.profileHistory,
                positioned: false,
              ),
              SizedBox(width: 8 * scale),
            ],
          ),
          if (_profileError != null) ...[
            SizedBox(height: 6 * scale),
            TextButton(
              onPressed: _observeProfile,
              child: Text(
                _profileError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.accent),
              ),
            ),
          ],
          SizedBox(height: 12 * scale),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: _profileLoading ? null : _openEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                    ),
                    child: Text(
                      context.l10n.profileEdit,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: SizedBox(
                  height: 48 * scale,
                  child: ElevatedButton.icon(
                    onPressed: _isSigningOut ? null : _signOut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _danger,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * scale),
                      ),
                    ),
                    icon: _isSigningOut
                        ? SizedBox(
                            width: 16 * scale,
                            height: 16 * scale,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Icon(Icons.logout, size: 18 * scale),
                    label: Text(
                      _isSigningOut ? '' : context.l10n.profileExit,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20 * scale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(double scale) {
    return Container(
      color: _panelBackground,
      height: 72 * scale,
      child: Row(
        children: [
          _profileTab(
            scale: scale,
            section: ProfileSection.watchList,
            icon: Icons.list,
            label: context.l10n.profileWatchList,
          ),
          _profileTab(
            scale: scale,
            section: ProfileSection.history,
            icon: Icons.folder,
            label: context.l10n.profileHistory,
          ),
        ],
      ),
    );
  }

  Widget _profileTab({
    required double scale,
    required ProfileSection section,
    required IconData icon,
    required String label,
  }) {
    final selected = _section == section;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _section = section),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.accent : Colors.transparent,
                width: 2.5 * scale,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.accent : AppColors.white,
                size: 28 * scale,
              ),
              SizedBox(height: 4 * scale),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'Roboto',
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent(double scale) {
    switch (_section) {
      case ProfileSection.watchList:
        return ProfileList(
          key: const ValueKey('watch-list'),
          scale: scale,
          title: context.l10n.profileWatchList,
          badge: context.l10n.profileSavedCount(_watchlist.length),
          icon: Icons.bookmark,
          emptyMessage: '',
          emptyAsset: AppAssets.profilePopcorn,
          showHeader: false,
          items: _watchlist.map(_watchlistEntry).toList(growable: false),
          isLoading: _watchlistLoading,
          errorMessage: _watchlistError,
          onRetry: _observeWatchlist,
          onItemTap: (entry) => context.push('/movie/${entry.movieId}'),
        );
      case ProfileSection.history:
        return ProfileList(
          key: const ValueKey('history'),
          scale: scale,
          title: context.l10n.profileHistory,
          badge: context.l10n.profileWatchedCount(0),
          icon: Icons.history,
          emptyMessage: '',
          emptyAsset: AppAssets.profilePopcorn,
          showHeader: false,
          items: const [],
        );
      case ProfileSection.none:
        return const SizedBox.shrink(key: ValueKey('empty-profile-section'));
    }
  }

  ProfileListEntry _watchlistEntry(Movie movie) {
    final details = <String>[
      if (movie.year > 0) '${movie.year}',
      if (movie.rating > 0) 'IMDb ${movie.rating.toStringAsFixed(1)}',
    ];
    return ProfileListEntry(
      movieId: movie.id,
      posterUrl: movie.mediumPosterUrl,
      title: movie.title,
      subtitle: details.join('  •  '),
      trailingIcon: Icons.chevron_right,
    );
  }
}
