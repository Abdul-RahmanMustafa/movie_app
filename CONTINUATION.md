# Continuation handoff — movie_app

_Last updated: 2026-11-21_

## Current state

- Repo: `movie_app`
- Branch: `leftanic_dev3`
- Git: working tree clean, latest commit `2a2708c Explore UI DONE`
- Verification:
  - `flutter analyze` → **No issues found!**
  - `flutter test` → **7/7 tests passed**

## Objective

Restore the Figma-correct Home hero/carousel, add Explore placeholders for a
future database, and make the Explore top-bar buttons clickable.

Figma reference: `Movies (Copy)`
<https://www.figma.com/design/Bs51kMcbmuJRNTUnGqbhUt/Movies--Copy-?node-id=47-1248>

- Home frame: `47:1248`
- Explore/Browse frame: `50:462` (layer named `Browse`)

The Figma file was inspected in the user's personal browser. The temporary tab
was closed and the accessibility setting (“Adapt content for screen readers”)
was restored to its original state.

## Decisions

- Home hero is `640` design px plus the top safe inset; its background and
  gradient are full-bleed behind the status bar.
- The carousel lives inside `HomeHero`; `Group 7.png` overlays it at
  `left: 38*scale`, `top: 7*scale`, `width: 354*scale`, `height: 632*scale`,
  `BoxFit.fill`, wrapped in `IgnorePointer`.
- `Group 7.png` already contains the hero typography and CTA. No duplicate
  “Available Now” text or “Watch Now” button is drawn in code.
- Kept five carousel assets: `homeCardCenter`, `homePoster`, `homeCardLeft`,
  `homeCardRight`, `homeActionCard1`.
- `carousel_slider` is retained. Dots use a `ValueNotifier<int>` so page changes
  do not rebuild/reset the slider.
- Home widgets are split into separate files under
  `lib/features/home/presentation/widgets/`.
- The Figma `Browse` frame is the app’s Explore tab; `Search` remains a separate
  generic `PlaceholderTab`.
- Explore top genre buttons are interactive: tapping one moves the accent
  border via `_ExploreScreenState._selectedGenreIndex`. Actual card filtering
  is intentionally deferred until database data exists.

## Completed

### Home

- Replaced the old custom `PageView`/`Timer` carousel with
  `CarouselSlider.builder`.
- Split Home into `HomeHero`, `HomeCarousel`, `SectionHeading`, `MovieRow`.
- Removed duplicated hero text/button and restored full-bleed hero layering.
- `HomeScreen` stacks `HomeHero`, `SectionHeading`, and `MovieRow`.
- Home tests cover hero geometry, carousel presence, and no duplicate text.

### Explore

- Created `lib/features/explore/presentation/screens/explore_screen.dart`.
- Created split widgets:
  - `lib/features/explore/presentation/widgets/explore_genre_chip.dart`
  - `lib/features/explore/presentation/widgets/explore_movie_card.dart`
- `MainShell` mounts `ExploreScreen` at `AppBottomNavigationBar.exploreIndex`
  (`2`); Search still uses `PlaceholderTab`.
- Four horizontally scrollable genre buttons:
  `Action`, `Adventure`, `Animation`, `Biography`.
- 2×2 placeholder movie grid with keyed slots:
  - `explore_movie_slot_<index>` — whole card
  - `explore_rating_slot_<index>` — rating badge
- Visible `Poster slot`, `DB: posterUrl`, and `Title slot` markers.
- Top genre buttons are now clickable and update the selected highlight.
- Tests:
  - `test/features/home/presentation/screens/home_screen_test.dart`
  - `test/features/explore/presentation/screens/explore_screen_test.dart`
  - `test/app/shell/main_shell_test.dart`
- `README.md` documents both the Home layout and the Explore placeholders.

## File map

| Path | Purpose |
| --- | --- |
| `lib/app/shell/main_shell.dart` | Owns tab `IndexedStack` and shared bottom nav |
| `lib/core/widgets/app_bottom_navigation_bar.dart` | Defines tab indices |
| `lib/features/home/presentation/screens/home_screen.dart` | Figma Home composition |
| `lib/features/home/presentation/widgets/home_hero.dart` | Hero/overlay/CarouselSlider |
| `lib/features/home/presentation/widgets/home_carousel.dart` | Carousel dots |
| `lib/features/explore/presentation/screens/explore_screen.dart` | Explore state + placeholder lists |
| `lib/features/explore/presentation/widgets/explore_genre_chip.dart` | Clickable top button |
| `lib/features/explore/presentation/widgets/explore_movie_card.dart` | Poster/rating/title slots |
| `test/features/explore/presentation/screens/explore_screen_test.dart` | Placeholder + tap tests |
| `test/app/shell/main_shell_test.dart` | Verifies Explore is wired into the shell |
| `README.md` | User-facing implementation notes |

## Database / API hand-off points

- In `ExploreScreen`:
  - `_genreLabels` → queried genre names.
  - `_genreWidths` → derived widths from measured genre names.
  - `_movieSlots` → movie DTOs from the database/API.
  - `_selectedGenreIndex` → lift into a controller/repository when filtering is
    implemented.
- In `ExploreMovieCard`:
  - Replace the grey `Poster slot` with `Image.network(movie.posterUrl)`.
  - Replace hard-coded `7.7` with `movie.voteAverage.toStringAsFixed(1)`.
  - Replace `Title slot` with `movie.title`.

## Next move when continuing

1. Add a data source/repository for genres and movies.
2. Feed `_genreLabels` and `_movieSlots` from that source.
3. Use the selected genre to filter the 2×2 grid (or add pagination).
4. Replace placeholder card slots with real poster/rating/title widgets.
5. Build the still-generic Search tab.
6. Re-run `flutter analyze` and `flutter test`.

## Commands

```bash
flutter analyze
flutter test
```
