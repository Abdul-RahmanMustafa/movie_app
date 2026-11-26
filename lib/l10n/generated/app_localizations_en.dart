// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonExploreNow => 'Explore Now';

  @override
  String get commonOr => 'OR';

  @override
  String get onboardingTitle1 => 'Find Your Next Favorite Movie Here';

  @override
  String get onboardingDescription1 =>
      'Get access to a huge library of movies to suit all tastes. You will surely like it.';

  @override
  String get onboardingTitle2 => 'Discover Movies';

  @override
  String get onboardingDescription2 =>
      'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.';

  @override
  String get onboardingTitle3 => 'Explore All Genres';

  @override
  String get onboardingDescription3 =>
      'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.';

  @override
  String get onboardingTitle4 => 'Create Watchlists';

  @override
  String get onboardingDescription4 =>
      'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.';

  @override
  String get onboardingTitle5 => 'Rate, Review, and Learn';

  @override
  String get onboardingDescription5 =>
      'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.';

  @override
  String get onboardingTitle6 => 'Start Watching Now';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get avatar => 'Avatar';

  @override
  String get forgotPassword => 'Forget Password';

  @override
  String get forgotPasswordQuestion => 'Forget Password?';

  @override
  String get verifyEmail => 'Verify Email';

  @override
  String get loginWithGoogle => 'Login With Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createOne => 'Create One';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Enter a valid email';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordLength => 'Use at least 8 characters';

  @override
  String get validationConfirmPassword => 'Confirm your password';

  @override
  String get validationPasswordsMismatch => 'Passwords do not match';

  @override
  String get validationPhoneInvalid => 'Enter a valid phone number';

  @override
  String get validationNameRequired => 'Please enter your name';

  @override
  String passwordResetPrivacyMessage(String email) {
    return 'If an account exists for $email, a password reset email has been sent. Check your inbox and spam folder.';
  }

  @override
  String get homeAction => 'Action';

  @override
  String get homeSeeMore => 'See More';

  @override
  String get homeNoActionMovies => 'No Action movies found.';

  @override
  String get homeNoFeaturedMovies => 'No featured movies found.';

  @override
  String get homeAvailableNow => 'Available Now';

  @override
  String get homeWatchNow => 'Watch Now';

  @override
  String get searchMovies => 'Search movies';

  @override
  String searchNoResults(String query) {
    return 'No movies found for “$query”.';
  }

  @override
  String exploreNoResults(String genre) {
    return 'No $genre movies found.';
  }

  @override
  String get movieWatch => 'Watch';

  @override
  String get movieScreenshots => 'Screen Shots';

  @override
  String get movieNoScreenshots => 'No screenshots are available.';

  @override
  String get movieSimilar => 'Similar Movies';

  @override
  String get movieNoSimilar => 'No similar movies are available.';

  @override
  String get movieSummary => 'Summary';

  @override
  String get movieNoSummary => 'No summary is available.';

  @override
  String get movieCast => 'Cast';

  @override
  String get movieNoCast => 'No cast information is available.';

  @override
  String get movieGenres => 'Genres';

  @override
  String get movieNoGenres => 'No genres are available.';

  @override
  String get movieUnavailable => 'This movie is unavailable.';

  @override
  String get profileWatchList => 'Watch List';

  @override
  String get profileWishList => 'Wish List';

  @override
  String get profileHistory => 'History';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileExit => 'Exit';

  @override
  String profileSavedCount(int count) {
    return '$count saved';
  }

  @override
  String profileWatchedCount(int count) {
    return '$count watched';
  }

  @override
  String get profilePickAvatar => 'Pick Avatar';

  @override
  String get profileResetPassword => 'Reset Password';

  @override
  String get profileDeleteAccount => 'Delete Account';

  @override
  String get profileUpdateData => 'Update Data';

  @override
  String get profileUpdated => 'Profile updated successfully.';

  @override
  String get profileNoEmail =>
      'No email address is available for this account.';

  @override
  String get profileResetSent =>
      'Password reset email sent. Check your inbox and spam folder.';

  @override
  String get profileDeleteUnavailable =>
      'Account deletion is not available yet.';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navExplore => 'Explore';

  @override
  String get navProfile => 'Profile';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorLoadMovies => 'Something went wrong while loading movies.';

  @override
  String get errorSearchMovies =>
      'Something went wrong while searching movies.';

  @override
  String get errorLoadMovie => 'Something went wrong while loading this movie.';

  @override
  String get errorWatchList => 'Something went wrong with your Watch List.';

  @override
  String get errorLoadProfile =>
      'Something went wrong while loading your profile.';

  @override
  String get errorLoadWatchList =>
      'Something went wrong while loading your Watch List.';

  @override
  String get errorUpdateProfile =>
      'Could not update your profile. Please try again.';

  @override
  String get errorResetEmail =>
      'Could not send the reset email. Please try again.';

  @override
  String get errorSignOut => 'Could not sign out safely. Please try again.';

  @override
  String get authInvalidEmail => 'Please enter a valid email address.';

  @override
  String get authInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get authEmailInUse =>
      'An account already exists for this email address.';

  @override
  String get authWeakPassword => 'Please choose a stronger password.';

  @override
  String get authNetwork => 'No network connection. Please try again.';

  @override
  String get authTooManyRequests =>
      'Too many attempts. Please wait and try again.';

  @override
  String get authUserDisabled =>
      'This account has been disabled. Please contact support.';

  @override
  String get authCancelled => 'Google Sign-In was cancelled.';

  @override
  String get authAccountConflict =>
      'An account already exists for this email using a different sign-in method. Please use your email and password.';

  @override
  String get authProviderConfiguration =>
      'Google Sign-In is not configured correctly. Please contact support.';

  @override
  String get authPermissionDenied =>
      'Access to save your profile was denied. Please try again or contact support.';

  @override
  String get authProfileCreationFailed =>
      'Your account is ready, but your profile could not be synchronized. Please try again.';

  @override
  String get movieErrorNetwork =>
      'No network connection. Check your connection and try again.';

  @override
  String get movieErrorTimeout =>
      'The request took too long. Please try again.';

  @override
  String get movieErrorApi =>
      'The movie service could not complete this request.';

  @override
  String get movieErrorInvalidResponse =>
      'The movie service returned an invalid response.';

  @override
  String get profileErrorUnauthenticated =>
      'Please sign in to manage your profile.';

  @override
  String get profileErrorPermission =>
      'You do not have permission to update this profile.';

  @override
  String get profileErrorNetwork =>
      'Could not reach your profile. Check your connection.';

  @override
  String get profileErrorInvalidData =>
      'Your profile data could not be loaded.';

  @override
  String get watchlistErrorUnauthenticated =>
      'Please sign in to use your Watch List.';

  @override
  String get watchlistErrorPermission =>
      'You do not have permission to update this Watch List.';

  @override
  String get watchlistErrorNetwork =>
      'Could not reach your Watch List. Check your connection.';

  @override
  String get watchlistErrorInvalidData => 'A saved movie could not be loaded.';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Adventure';

  @override
  String get genreAnimation => 'Animation';

  @override
  String get genreBiography => 'Biography';

  @override
  String get genreComedy => 'Comedy';

  @override
  String get genreCrime => 'Crime';

  @override
  String get genreDocumentary => 'Documentary';

  @override
  String get genreDrama => 'Drama';

  @override
  String get genreFamily => 'Family';

  @override
  String get genreFantasy => 'Fantasy';

  @override
  String get genreHistory => 'History';

  @override
  String get genreHorror => 'Horror';

  @override
  String get genreMusic => 'Music';

  @override
  String get genreMusical => 'Musical';

  @override
  String get genreMystery => 'Mystery';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreSciFi => 'Sci-Fi';

  @override
  String get genreSport => 'Sport';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genreWar => 'War';

  @override
  String get genreWestern => 'Western';
}
