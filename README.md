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
