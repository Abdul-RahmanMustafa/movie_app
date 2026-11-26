import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get commonFinish;

  /// No description provided for @commonExploreNow.
  ///
  /// In en, this message translates to:
  /// **'Explore Now'**
  String get commonExploreNow;

  /// No description provided for @commonOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get commonOr;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Find Your Next Favorite Movie Here'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Get access to a huge library of movies to suit all tastes. You will surely like it.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Discover Movies'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Explore All Genres'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.'**
  String get onboardingDescription3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Create Watchlists'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDescription4.
  ///
  /// In en, this message translates to:
  /// **'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.'**
  String get onboardingDescription4;

  /// No description provided for @onboardingTitle5.
  ///
  /// In en, this message translates to:
  /// **'Rate, Review, and Learn'**
  String get onboardingTitle5;

  /// No description provided for @onboardingDescription5.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.'**
  String get onboardingDescription5;

  /// No description provided for @onboardingTitle6.
  ///
  /// In en, this message translates to:
  /// **'Start Watching Now'**
  String get onboardingTitle6;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login With Google'**
  String get loginWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create One'**
  String get createOne;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get validationPasswordLength;

  /// No description provided for @validationConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get validationConfirmPassword;

  /// No description provided for @validationPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsMismatch;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get validationNameRequired;

  /// No description provided for @passwordResetPrivacyMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a password reset email has been sent. Check your inbox and spam folder.'**
  String passwordResetPrivacyMessage(String email);

  /// No description provided for @homeAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get homeAction;

  /// No description provided for @homeSeeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get homeSeeMore;

  /// No description provided for @homeNoActionMovies.
  ///
  /// In en, this message translates to:
  /// **'No Action movies found.'**
  String get homeNoActionMovies;

  /// No description provided for @homeNoFeaturedMovies.
  ///
  /// In en, this message translates to:
  /// **'No featured movies found.'**
  String get homeNoFeaturedMovies;

  /// No description provided for @homeAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get homeAvailableNow;

  /// No description provided for @homeWatchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get homeWatchNow;

  /// No description provided for @searchMovies.
  ///
  /// In en, this message translates to:
  /// **'Search movies'**
  String get searchMovies;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No movies found for “{query}”.'**
  String searchNoResults(String query);

  /// No description provided for @exploreNoResults.
  ///
  /// In en, this message translates to:
  /// **'No {genre} movies found.'**
  String exploreNoResults(String genre);

  /// No description provided for @movieWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get movieWatch;

  /// No description provided for @movieScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Screen Shots'**
  String get movieScreenshots;

  /// No description provided for @movieNoScreenshots.
  ///
  /// In en, this message translates to:
  /// **'No screenshots are available.'**
  String get movieNoScreenshots;

  /// No description provided for @movieSimilar.
  ///
  /// In en, this message translates to:
  /// **'Similar Movies'**
  String get movieSimilar;

  /// No description provided for @movieNoSimilar.
  ///
  /// In en, this message translates to:
  /// **'No similar movies are available.'**
  String get movieNoSimilar;

  /// No description provided for @movieSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get movieSummary;

  /// No description provided for @movieNoSummary.
  ///
  /// In en, this message translates to:
  /// **'No summary is available.'**
  String get movieNoSummary;

  /// No description provided for @movieCast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get movieCast;

  /// No description provided for @movieNoCast.
  ///
  /// In en, this message translates to:
  /// **'No cast information is available.'**
  String get movieNoCast;

  /// No description provided for @movieGenres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get movieGenres;

  /// No description provided for @movieNoGenres.
  ///
  /// In en, this message translates to:
  /// **'No genres are available.'**
  String get movieNoGenres;

  /// No description provided for @movieUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This movie is unavailable.'**
  String get movieUnavailable;

  /// No description provided for @profileWatchList.
  ///
  /// In en, this message translates to:
  /// **'Watch List'**
  String get profileWatchList;

  /// No description provided for @profileWishList.
  ///
  /// In en, this message translates to:
  /// **'Wish List'**
  String get profileWishList;

  /// No description provided for @profileHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profileHistory;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get profileExit;

  /// No description provided for @profileSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String profileSavedCount(int count);

  /// No description provided for @profileWatchedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} watched'**
  String profileWatchedCount(int count);

  /// No description provided for @profilePickAvatar.
  ///
  /// In en, this message translates to:
  /// **'Pick Avatar'**
  String get profilePickAvatar;

  /// No description provided for @profileResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get profileResetPassword;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccount;

  /// No description provided for @profileUpdateData.
  ///
  /// In en, this message translates to:
  /// **'Update Data'**
  String get profileUpdateData;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdated;

  /// No description provided for @profileNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email address is available for this account.'**
  String get profileNoEmail;

  /// No description provided for @profileResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox and spam folder.'**
  String get profileResetSent;

  /// No description provided for @profileDeleteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not available yet.'**
  String get profileDeleteUnavailable;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorLoadMovies.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading movies.'**
  String get errorLoadMovies;

  /// No description provided for @errorSearchMovies.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while searching movies.'**
  String get errorSearchMovies;

  /// No description provided for @errorLoadMovie.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading this movie.'**
  String get errorLoadMovie;

  /// No description provided for @errorWatchList.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with your Watch List.'**
  String get errorWatchList;

  /// No description provided for @errorLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your profile.'**
  String get errorLoadProfile;

  /// No description provided for @errorLoadWatchList.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your Watch List.'**
  String get errorLoadWatchList;

  /// No description provided for @errorUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not update your profile. Please try again.'**
  String get errorUpdateProfile;

  /// No description provided for @errorResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not send the reset email. Please try again.'**
  String get errorResetEmail;

  /// No description provided for @errorSignOut.
  ///
  /// In en, this message translates to:
  /// **'Could not sign out safely. Please try again.'**
  String get errorSignOut;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authInvalidEmail;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email address.'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get authWeakPassword;

  /// No description provided for @authNetwork.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please try again.'**
  String get authNetwork;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get authTooManyRequests;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Please contact support.'**
  String get authUserDisabled;

  /// No description provided for @authCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In was cancelled.'**
  String get authCancelled;

  /// No description provided for @authAccountConflict.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email using a different sign-in method. Please use your email and password.'**
  String get authAccountConflict;

  /// No description provided for @authProviderConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not configured correctly. Please contact support.'**
  String get authProviderConfiguration;

  /// No description provided for @authPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Access to save your profile was denied. Please try again or contact support.'**
  String get authPermissionDenied;

  /// No description provided for @authProfileCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready, but your profile could not be synchronized. Please try again.'**
  String get authProfileCreationFailed;

  /// No description provided for @movieErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Check your connection and try again.'**
  String get movieErrorNetwork;

  /// No description provided for @movieErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get movieErrorTimeout;

  /// No description provided for @movieErrorApi.
  ///
  /// In en, this message translates to:
  /// **'The movie service could not complete this request.'**
  String get movieErrorApi;

  /// No description provided for @movieErrorInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'The movie service returned an invalid response.'**
  String get movieErrorInvalidResponse;

  /// No description provided for @profileErrorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to manage your profile.'**
  String get profileErrorUnauthenticated;

  /// No description provided for @profileErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to update this profile.'**
  String get profileErrorPermission;

  /// No description provided for @profileErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach your profile. Check your connection.'**
  String get profileErrorNetwork;

  /// No description provided for @profileErrorInvalidData.
  ///
  /// In en, this message translates to:
  /// **'Your profile data could not be loaded.'**
  String get profileErrorInvalidData;

  /// No description provided for @watchlistErrorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to use your Watch List.'**
  String get watchlistErrorUnauthenticated;

  /// No description provided for @watchlistErrorPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to update this Watch List.'**
  String get watchlistErrorPermission;

  /// No description provided for @watchlistErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach your Watch List. Check your connection.'**
  String get watchlistErrorNetwork;

  /// No description provided for @watchlistErrorInvalidData.
  ///
  /// In en, this message translates to:
  /// **'A saved movie could not be loaded.'**
  String get watchlistErrorInvalidData;

  /// No description provided for @genreAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get genreAction;

  /// No description provided for @genreAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get genreAdventure;

  /// No description provided for @genreAnimation.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get genreAnimation;

  /// No description provided for @genreBiography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get genreBiography;

  /// No description provided for @genreComedy.
  ///
  /// In en, this message translates to:
  /// **'Comedy'**
  String get genreComedy;

  /// No description provided for @genreCrime.
  ///
  /// In en, this message translates to:
  /// **'Crime'**
  String get genreCrime;

  /// No description provided for @genreDocumentary.
  ///
  /// In en, this message translates to:
  /// **'Documentary'**
  String get genreDocumentary;

  /// No description provided for @genreDrama.
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get genreDrama;

  /// No description provided for @genreFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get genreFamily;

  /// No description provided for @genreFantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get genreFantasy;

  /// No description provided for @genreHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get genreHistory;

  /// No description provided for @genreHorror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get genreHorror;

  /// No description provided for @genreMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get genreMusic;

  /// No description provided for @genreMusical.
  ///
  /// In en, this message translates to:
  /// **'Musical'**
  String get genreMusical;

  /// No description provided for @genreMystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get genreMystery;

  /// No description provided for @genreRomance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreSciFi.
  ///
  /// In en, this message translates to:
  /// **'Sci-Fi'**
  String get genreSciFi;

  /// No description provided for @genreSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get genreSport;

  /// No description provided for @genreThriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get genreThriller;

  /// No description provided for @genreWar.
  ///
  /// In en, this message translates to:
  /// **'War'**
  String get genreWar;

  /// No description provided for @genreWestern.
  ///
  /// In en, this message translates to:
  /// **'Western'**
  String get genreWestern;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
