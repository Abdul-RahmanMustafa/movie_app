// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'أفلام';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get commonTryAgain => 'إعادة المحاولة';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonFinish => 'إنهاء';

  @override
  String get commonExploreNow => 'استكشف الآن';

  @override
  String get commonOr => 'أو';

  @override
  String get onboardingTitle1 => 'اعثر على فيلمك المفضل القادم هنا';

  @override
  String get onboardingDescription1 =>
      'استمتع بمكتبة ضخمة من الأفلام التي تناسب جميع الأذواق، وستجد بالتأكيد ما يعجبك.';

  @override
  String get onboardingTitle2 => 'اكتشف الأفلام';

  @override
  String get onboardingDescription2 =>
      'استكشف مجموعة واسعة من الأفلام بمختلف الأنواع والجودات، واعثر بسهولة على فيلمك المفضل القادم.';

  @override
  String get onboardingTitle3 => 'استكشف جميع الأنواع';

  @override
  String get onboardingDescription3 =>
      'اكتشف أفلامًا من كل الأنواع وبالجودات المتاحة، واعثر كل يوم على شيء جديد وممتع لمشاهدته.';

  @override
  String get onboardingTitle4 => 'أنشئ قائمة المشاهدة';

  @override
  String get onboardingDescription4 =>
      'احفظ الأفلام في قائمة المشاهدة لتتذكر ما ترغب في مشاهدته لاحقًا، واستمتع بأفلام متنوعة الأنواع والجودات.';

  @override
  String get onboardingTitle5 => 'قيّم وشارك وتعرّف';

  @override
  String get onboardingDescription5 =>
      'شارك رأيك في الأفلام التي شاهدتها، وتعرّف على تفاصيلها وساعد الآخرين في اكتشاف أفلام رائعة من خلال مراجعاتك.';

  @override
  String get onboardingTitle6 => 'ابدأ المشاهدة الآن';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get avatar => 'الصورة الرمزية';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordQuestion => 'هل نسيت كلمة المرور؟';

  @override
  String get verifyEmail => 'تحقق من البريد';

  @override
  String get loginWithGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createOne => 'أنشئ حسابًا';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get validationEmailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get validationPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validationPasswordLength => 'استخدم 8 أحرف على الأقل';

  @override
  String get validationConfirmPassword => 'أكّد كلمة المرور';

  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validationPhoneInvalid => 'أدخل رقم هاتف صحيحًا';

  @override
  String get validationNameRequired => 'يرجى إدخال اسمك';

  @override
  String passwordResetPrivacyMessage(String email) {
    return 'إذا كان هناك حساب مرتبط بالبريد $email، فقد أرسلنا رسالة لإعادة تعيين كلمة المرور. تحقق من صندوق الوارد والرسائل غير المرغوب فيها.';
  }

  @override
  String get homeAction => 'أكشن';

  @override
  String get homeSeeMore => 'عرض المزيد';

  @override
  String get homeNoActionMovies => 'لا توجد أفلام أكشن.';

  @override
  String get homeNoFeaturedMovies => 'لا توجد أفلام مميزة.';

  @override
  String get homeAvailableNow => 'متاح الآن';

  @override
  String get homeWatchNow => 'شاهد الآن';

  @override
  String get searchMovies => 'ابحث عن أفلام';

  @override
  String searchNoResults(String query) {
    return 'لم نعثر على أفلام تطابق «$query».';
  }

  @override
  String exploreNoResults(String genre) {
    return 'لا توجد أفلام ضمن تصنيف $genre.';
  }

  @override
  String get movieWatch => 'مشاهدة';

  @override
  String get movieScreenshots => 'لقطات من الفيلم';

  @override
  String get movieNoScreenshots => 'لا تتوفر لقطات لهذا الفيلم.';

  @override
  String get movieSimilar => 'أفلام مشابهة';

  @override
  String get movieNoSimilar => 'لا تتوفر أفلام مشابهة.';

  @override
  String get movieSummary => 'الملخص';

  @override
  String get movieNoSummary => 'لا يتوفر ملخص لهذا الفيلم.';

  @override
  String get movieCast => 'طاقم التمثيل';

  @override
  String get movieNoCast => 'لا تتوفر معلومات عن طاقم التمثيل.';

  @override
  String get movieGenres => 'التصنيفات';

  @override
  String get movieNoGenres => 'لا تتوفر تصنيفات لهذا الفيلم.';

  @override
  String get movieUnavailable => 'هذا الفيلم غير متاح.';

  @override
  String get profileWatchList => 'قائمة المشاهدة';

  @override
  String get profileWishList => 'قائمة الرغبات';

  @override
  String get profileHistory => 'السجل';

  @override
  String get profileEdit => 'تعديل الملف الشخصي';

  @override
  String get profileExit => 'خروج';

  @override
  String profileSavedCount(int count) {
    return '$count محفوظ';
  }

  @override
  String profileWatchedCount(int count) {
    return '$count مُشاهد';
  }

  @override
  String get profilePickAvatar => 'اختر صورة رمزية';

  @override
  String get profileResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get profileDeleteAccount => 'حذف الحساب';

  @override
  String get profileUpdateData => 'تحديث البيانات';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get profileNoEmail => 'لا يتوفر بريد إلكتروني لهذا الحساب.';

  @override
  String get profileResetSent =>
      'أُرسلت رسالة إعادة تعيين كلمة المرور. تحقق من صندوق الوارد والرسائل غير المرغوب فيها.';

  @override
  String get profileDeleteUnavailable => 'حذف الحساب غير متاح حاليًا.';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSearch => 'البحث';

  @override
  String get navExplore => 'استكشاف';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get errorUnexpected => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errorLoadMovies => 'تعذر تحميل الأفلام. يرجى المحاولة مرة أخرى.';

  @override
  String get errorSearchMovies =>
      'تعذر البحث عن الأفلام. يرجى المحاولة مرة أخرى.';

  @override
  String get errorLoadMovie => 'تعذر تحميل هذا الفيلم. يرجى المحاولة مرة أخرى.';

  @override
  String get errorWatchList => 'حدث خطأ في قائمة المشاهدة.';

  @override
  String get errorLoadProfile => 'تعذر تحميل ملفك الشخصي.';

  @override
  String get errorLoadWatchList => 'تعذر تحميل قائمة المشاهدة.';

  @override
  String get errorUpdateProfile =>
      'تعذر تحديث ملفك الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get errorResetEmail =>
      'تعذر إرسال رسالة إعادة التعيين. يرجى المحاولة مرة أخرى.';

  @override
  String get errorSignOut => 'تعذر تسجيل الخروج بأمان. يرجى المحاولة مرة أخرى.';

  @override
  String get authInvalidEmail => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get authInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authEmailInUse => 'يوجد حساب مرتبط بهذا البريد الإلكتروني بالفعل.';

  @override
  String get authWeakPassword => 'يرجى اختيار كلمة مرور أقوى.';

  @override
  String get authNetwork => 'لا يوجد اتصال بالشبكة. يرجى المحاولة مرة أخرى.';

  @override
  String get authTooManyRequests =>
      'عدد المحاولات كبير جدًا. انتظر قليلًا ثم حاول مرة أخرى.';

  @override
  String get authUserDisabled => 'تم تعطيل هذا الحساب. يرجى التواصل مع الدعم.';

  @override
  String get authCancelled => 'تم إلغاء تسجيل الدخول باستخدام Google.';

  @override
  String get authAccountConflict =>
      'يوجد حساب لهذا البريد باستخدام طريقة دخول مختلفة. استخدم البريد الإلكتروني وكلمة المرور.';

  @override
  String get authProviderConfiguration =>
      'إعداد تسجيل الدخول باستخدام Google غير مكتمل. يرجى التواصل مع الدعم.';

  @override
  String get authPermissionDenied =>
      'تعذر حفظ ملفك الشخصي بسبب صلاحيات الوصول. حاول مرة أخرى أو تواصل مع الدعم.';

  @override
  String get authProfileCreationFailed =>
      'الحساب جاهز، لكن تعذرت مزامنة ملفك الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get movieErrorNetwork =>
      'لا يوجد اتصال بالشبكة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get movieErrorTimeout =>
      'استغرق الطلب وقتًا أطول من اللازم. يرجى المحاولة مرة أخرى.';

  @override
  String get movieErrorApi => 'تعذر على خدمة الأفلام إكمال هذا الطلب.';

  @override
  String get movieErrorInvalidResponse =>
      'أعادت خدمة الأفلام استجابة غير صالحة.';

  @override
  String get profileErrorUnauthenticated =>
      'يرجى تسجيل الدخول لإدارة ملفك الشخصي.';

  @override
  String get profileErrorPermission =>
      'ليس لديك صلاحية لتحديث هذا الملف الشخصي.';

  @override
  String get profileErrorNetwork =>
      'تعذر الوصول إلى ملفك الشخصي. تحقق من اتصالك.';

  @override
  String get profileErrorInvalidData => 'تعذر تحميل بيانات ملفك الشخصي.';

  @override
  String get watchlistErrorUnauthenticated =>
      'يرجى تسجيل الدخول لاستخدام قائمة المشاهدة.';

  @override
  String get watchlistErrorPermission =>
      'ليس لديك صلاحية لتحديث قائمة المشاهدة.';

  @override
  String get watchlistErrorNetwork =>
      'تعذر الوصول إلى قائمة المشاهدة. تحقق من اتصالك.';

  @override
  String get watchlistErrorInvalidData => 'تعذر تحميل أحد الأفلام المحفوظة.';

  @override
  String get genreAction => 'أكشن';

  @override
  String get genreAdventure => 'مغامرة';

  @override
  String get genreAnimation => 'رسوم متحركة';

  @override
  String get genreBiography => 'سيرة ذاتية';

  @override
  String get genreComedy => 'كوميديا';

  @override
  String get genreCrime => 'جريمة';

  @override
  String get genreDocumentary => 'وثائقي';

  @override
  String get genreDrama => 'دراما';

  @override
  String get genreFamily => 'عائلي';

  @override
  String get genreFantasy => 'فانتازيا';

  @override
  String get genreHistory => 'تاريخي';

  @override
  String get genreHorror => 'رعب';

  @override
  String get genreMusic => 'موسيقى';

  @override
  String get genreMusical => 'استعراضي';

  @override
  String get genreMystery => 'غموض';

  @override
  String get genreRomance => 'رومانسي';

  @override
  String get genreSciFi => 'خيال علمي';

  @override
  String get genreSport => 'رياضي';

  @override
  String get genreThriller => 'إثارة';

  @override
  String get genreWar => 'حربي';

  @override
  String get genreWestern => 'غربي';
}
