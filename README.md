# movie_app
Movie App - Route Graduation Project

## Shared Android development signing

The Android debug build supports an optional shared **development-only**
certificate. This lets approved teammates and mentors use one Firebase Android
OAuth identity for Google Sign-In. It is separate from production/release
signing and its secret files are intentionally excluded from Git.

When `android/development-signing.properties` is absent, Gradle keeps Flutter's
standard per-machine debug signing configuration. This makes the shared setup
optional and preserves the normal fallback for contributors who do not need
Google Sign-In.

### Create the shared certificate once

Only the designated project owner should run:

```sh
./tool/create_android_development_keystore.sh
```

The script creates these ignored files, generates strong random credentials,
and prints only the certificate fingerprints:

- `android/keystores/movie-app-development.jks`
- `android/development-signing.properties`

Do not run the script independently on every machine. Each run creates a
different certificate and therefore different Firebase fingerprints. Store
the two generated files together in the team's password manager or another
encrypted file-sharing channel. Never send their contents in chat, email, an
issue, or a pull request.

### Configure a teammate or mentor machine

1. Clone the repository and check out the intended development branch.
2. Obtain the two shared files from the project owner through the approved
   encrypted channel.
3. Place them at the exact paths listed above. The properties file refers to
   the keystore using `keystores/movie-app-development.jks`.
4. Restrict local access where supported:

   ```sh
   chmod 600 android/development-signing.properties \
     android/keystores/movie-app-development.jks
   ```

5. Build or run the debug application normally. Gradle detects the local
   properties file and signs debug builds with the shared certificate.

To inspect the certificate without putting a password in shell history, run
the following command and enter the shared store password when prompted:

```sh
keytool -list -v \
  -alias movie-app-development \
  -keystore android/keystores/movie-app-development.jks
```

The shared SHA-1 and SHA-256 fingerprints must be registered on the Android
app (`com.example.movie_app`) in the Firebase project. After registration,
download the refreshed `google-services.json` and replace
`android/app/google-services.json` in a reviewed change. No teammate-specific
fingerprint is needed while everyone uses this exact shared keystore.

This development certificate must never be reused for Play Store or other
production signing.

## Performance and responsive layout

- `AppLayout` provides shared, clamped scaling for the 430px Figma frames and
  reserves space for system gesture insets.
- Main tabs are created on first visit and retained afterwards. Hidden tabs
  disable tickers so the Home carousel does not animate off-screen.
- Home, Explore, and Search support responsive content padding; Home and
  Explore also support pull-to-refresh.
- YTS list, details, and suggestion results use a short in-memory cache to
  avoid duplicate requests during tab switches and movie-detail revisits.
- Poster decoding is capped to the rendered width to reduce memory pressure.
- System text scaling is bounded to keep fixed-frame layouts readable without
  disabling accessibility scaling.

Responsive widget coverage lives in
`test/responsive/screens_responsive_test.dart` and exercises compact phones,
tablets, landscape layouts, and increased text scale.

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

