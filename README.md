# movie_app
Movie App - Route Graduation Project

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

