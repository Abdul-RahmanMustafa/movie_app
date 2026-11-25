# movie_app
Movie App - Route Graduation Project

## Recent changes (Nov 25)

Branch `leftanic_dev3`, uncommitted. The full app (Firebase auth, YTS movies,
watchlist, profile) plus the pass below is applied directly in the working tree.

Performance & responsiveness pass:

- New `lib/core/layout/app_layout.dart`: shared scale based on the 430px Figma
  design width, clamped to `0.8`–`1.25` on small/large screens.
- All tabs in `MainShell` are mounted on first visit; hidden tabs disable
  tickers, so the Home carousel does not keep auto-playing off-screen.
- Pull-to-refresh added to Home, Explore and Search; bottom paddings now
  include the system gesture inset; the bottom nav is inset above gestures.
- `MoviePosterImage` decodes at the rendered width (`cacheWidth`) with a fade
  in and without per-card progress spinners.
- `MoviesRepositoryImpl` caches list/details/suggestions results in memory for
  5 minutes so tab switches and detail re-opens are instant.
- Text scaling is clamped in `app.dart` to keep fixed-frame layouts readable.

Google Sign-In visibility:

- `FirebaseFailureMapper.fromGoogle` maps `unknownError` to a visible
  "Google Sign-In could not be completed" message and logs the failing code
  in debug builds (see `docs/google-sign-in.md`).

## Layout tests

`test/responsive/screens_responsive_test.dart` renders every screen and walks
all `MainShell` tabs at 320x568, 360x640, 375x667, 390x844, 412x915, 430x932,
768x1024, 1024x768 and 844x390, plus a 1.2x text-scale variant, failing on any
layout exception. The tests load the real Roboto font so text metrics match a
device instead of the square Ahem glyphs used by `flutter_test` by default.

## Home screen implementation notes

The Home tab follows Figma `Movies (Copy)`, frame `47:1248`.

- `HomeHero` is 640 design pixels tall (plus the system top inset). Its
  background (`home_bg.png`) and bottom-black / top-clear gradient are drawn
  full-bleed, behind the status bar.
- The carousel and `Group 7.png` overlay live inside `HomeHero`'s `SafeArea`,
  so they clear the notch/camera hole. `Group 7.png` is placed at its native
  `354 x 632` design size and already contains the hero typography and button;
  no duplicate `Text`/`FilledButton` is drawn over it.
- `HomeCarousel` uses `carousel_slider` with an infinite, auto-playing slider.
  Carousel images use `BoxFit.fill` so they fill their cards without being
  cropped. Page dots are driven by a `ValueNotifier` so changing the active
  dot does not rebuild (and reset) `CarouselSlider`.
- Each Home component lives in its own file under
  `lib/features/home/presentation/widgets/`.

## Explore screen placeholders

The Explore tab follows Figma `Movies (Copy)`, frame `50:462` ("Browse").

- `MainShell` now mounts `ExploreScreen` for the Explore tab; only Search still
  uses the generic `PlaceholderTab`.
- The four top genre buttons mirror the Figma groups `Group 9`–`Group 12`
  (`Action`, `Adventure`, `Animation`, `Biography`). They are horizontally
  scrollable, like the design, and tappable: the selected button moves the
  accent border. Card filtering by the selected genre is left for the database
  integration.
- The 2 × 2 card grid mirrors the six poster groups in the frame. Each card is
  a visual placeholder with keyed slots: `explore_movie_slot_<index>` for the
  whole card and `explore_rating_slot_<index>` for the rating badge.
- The static `7.7` rating, `Poster slot` area, and `Title slot` are the intended
  database/API hand-off points. Replace the private lists in `ExploreScreen`
  with queried data and swap the card's poster/rating/title widgets when the
  database is integrated.

