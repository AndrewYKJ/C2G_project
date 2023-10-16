class Constants {
  static const bool isDebug = false;

  static const String languageCodeEn = "EN";
  static const String languageCodeBM = "BM";
  static const String english = 'en';
  static const String indonesia = "id";
  static const String chinese = 'zh';

  static const String assetImages = "assets/images/";

  //analyics key
  static const String analyticsSplashScreen = "SPLASH_SCREEN";
  static const String analyticsLoginScreen = "LOGIN_SCREEN";
  static const String analyticsOnboardLanguageScreen =
      "ONBOARD_LANGUAGE_SCREEN";
  static const String analyticsRegisterScreen = "REGISTER_SCREEN";
  static const String analyticsRegisterSuccessScreen =
      "REGISTER_SUCCESS_SCREEN";
  static const String analyticsResetPwdScreen = "RESET_PWD_SCREEN";
  static const String analyticsResetPwdSuccessScreen =
      "RESET_PWD_SUCCES_SCREEN";
  static const String analyticsVerifyOtpScreen = "VERiFY_OTP_SCREEN";
  static const String analyticsLandingScreen = "LANDING_SCREEN";
  static const String analyticsHomeScreen = "HOME_SCREEN";
  static const String analyticsSubmitReportScreen = "SUBMIT_REPORT_SCREEN";
  static const String analyticsSubmitSuccessfulScreen =
      "SUBMIT_COMPLETE_SCREEN";
  static const String analyticsHistoryScreen = "HISTORY_SCREEN";
  static const String analyticsTermScreen = "TERMS&CONDITIONS_SCREEN";
  static const String analyticsPolicyScreen = "POLICYS_SCREEN";
  static const String analyticsAboutUsScreen = "ABOUT_US_SCREEN";
  static const String analyticsFaqListScreen = "FAQ_LIST_SCREEN";
  static const String analyticsFaqDetailsScreen = "FAQ_DETAILS_SCREEN";
  static const String analyticsProfileScreen = "USER_PROFILE_SCREEN";
  static const String analyticsEditProfileScreen = "EDIT_PROFILE_SCREEN";
  static const String analyticsChangeLanguageScreen = "CHANGE_LANGUAGE_SCREEN";
  static const String analyticsChangePasswordScreen = "CHANGE_PASSWORD_SCREEN";
  static const String analyticsChangeUsernameScreen = "CHANGE_USERNAME_SCREEN";
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
