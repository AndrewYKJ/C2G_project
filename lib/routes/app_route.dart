import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jpan_flutter/components/report_detail.dart';
import 'package:jpan_flutter/const/enlarge_image.dart';
import 'package:jpan_flutter/controller/authentication/htmlLoader.dart';
import 'package:jpan_flutter/controller/authentication/login.dart';
import 'package:jpan_flutter/controller/authentication/onboardlanguage.dart';
import 'package:jpan_flutter/controller/authentication/register.dart';
import 'package:jpan_flutter/controller/authentication/otpverify.dart';
import 'package:jpan_flutter/controller/authentication/registercomplete.dart';
import 'package:jpan_flutter/controller/authentication/resetcomplete.dart';
import 'package:jpan_flutter/controller/authentication/resetpassword.dart';
import 'package:jpan_flutter/controller/authentication/sendotp.dart';
import 'package:jpan_flutter/controller/history/history.dart';
import 'package:jpan_flutter/controller/home/home.dart';
import 'package:jpan_flutter/controller/home/incidentcategory.dart';
import 'package:jpan_flutter/controller/home/incidentsubcategory.dart';
import 'package:jpan_flutter/controller/home/submitreport.dart';
import 'package:jpan_flutter/controller/home/submitcomplete.dart';
import 'package:jpan_flutter/controller/homebase.dart';
import 'package:jpan_flutter/controller/landing.dart';
import 'package:jpan_flutter/controller/profile/aboutus.dart';
import 'package:jpan_flutter/controller/profile/changelanguage.dart';
import 'package:jpan_flutter/controller/profile/changepassword.dart';
import 'package:jpan_flutter/controller/profile/changeusername.dart';
import 'package:jpan_flutter/controller/profile/editprofile.dart';
import 'package:jpan_flutter/controller/profile/faqdetail.dart';
import 'package:jpan_flutter/controller/profile/faqlist.dart';
import 'package:jpan_flutter/controller/profile/profile.dart';
import 'package:jpan_flutter/model/card_model.dart';
import 'package:jpan_flutter/model/category/subcategory_model.dart';
import 'package:jpan_flutter/model/faq_model.dart';
import 'package:jpan_flutter/model/otp_model.dart';

import '../controller/splash_screen.dart';
import '../model/argument/submit_reportArg.dart';
import '../model/indicient_model.dart';

class AppRoutes {
  static const String splashScreenRoute = "splash_screen";
  static const String landingScreenRoute = "landing_screen";
  static const String enlargeImageScreenRoute = 'enlargeimage_screen';
  static const String baseRoute = "base_screen";
  static const String homeScreenRoute = "home_screen";
  static const String incidentTypeScreenRoute = "incidenttype_screen";
  static const String incidentSubTypeScreenRoute = "incidentSubtype_screen";
  static const String historyScreenRoute = "history_screen";
  static const String historyDetailsScreenRoute = "historyDetail_screen";
  static const String submitReportScreenRoute = "submitReport_screen";
  static const String submitSuccessfullyScreenRoute =
      'submitsuccessfully_screen';
  //user
  static const String userProfileScreenRoute = "user_screen";
  static const String faqListScreenRoute = "faqlist_screen";
  static const String faqDetailScreenRoute = "faqdetail_screen";
  static const String editProfileScreenRoute = 'editprofile_screen';
  static const String changePasswordScreenRoute = 'changepassword_screen';
  static const String changeUsernameScreenRoute = 'changeuser_screen';
  static const String changeLanguageScreenRoute = 'changelanguage_screen';
  static const String aboutUsScreenRoute = "aboutus_screen";
  //auth
  static const String loginScreenRoute = "login_screen";
  static const String registerScreenRoute = "register_screen";
  static const String sendOtpScreenRoute = "sendOtp_screen";
  static const String otpverfiyScreenRoute = "otpverify_screen";
  static const String resetpasswordScreenRoute = 'resetpassword_screen';
  static const String resetcompleteScreenRoute = 'resetcomplete_screen';
  static const String registercompleteScreenRoute = 'registercomplete_screen';
  static const String htmlLoaderScreenRoute = 'htmloader_screen';
  static const String onboardLanguageScreenRoute = 'onboardlanguage_screen';
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case landingScreenRoute:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      //Auth Route START Here
      case loginScreenRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case registerScreenRoute:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case sendOtpScreenRoute:
        return MaterialPageRoute(builder: (_) => const SendOTP());
      case otpverfiyScreenRoute:
        OtpModel arguments = settings.arguments as OtpModel;
        return MaterialPageRoute(
            builder: (_) => OtpVerify(
                  title: arguments.title,
                  userData: arguments.userData,
                  isResetPW: arguments.fromResetPW,
                ));
      case resetpasswordScreenRoute:
        return MaterialPageRoute(builder: (_) => const ResetPassword());
      case resetcompleteScreenRoute:
        return MaterialPageRoute(builder: (_) => const ResetComplete());
      case registercompleteScreenRoute:
        return MaterialPageRoute(builder: (_) => const RegisterComplete());
      case onboardLanguageScreenRoute:
        return MaterialPageRoute(builder: (_) => const OnboardLanguage());

      //Auth Route END Here
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case faqDetailScreenRoute:
        FaqModel arguments = settings.arguments as FaqModel;
        return MaterialPageRoute(
            builder: (_) => FaqDetail(
                  title: arguments.title,
                  description: arguments.description,
                ));
      case baseRoute:
        return MaterialPageRoute(builder: (_) => const HomeBase());
      case historyScreenRoute:
        return MaterialPageRoute(builder: (_) => const ReportHistory());
      case htmlLoaderScreenRoute:
        String arguments = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => HtmlLoader(
                  htmlfileName: arguments,
                ));
      //Profile Route START Here
      case userProfileScreenRoute:
        return MaterialPageRoute(builder: (_) => const UserProfile());
      case faqListScreenRoute:
        return MaterialPageRoute(builder: (_) => FaqList());
      case incidentTypeScreenRoute:
        SubmitReportArg arguments = settings.arguments as SubmitReportArg;
        return MaterialPageRoute(
            builder: (_) => IncidentRoute(data: arguments));
      case incidentSubTypeScreenRoute:
        SubmitReportArg arguments = settings.arguments as SubmitReportArg;
        return MaterialPageRoute(
            builder: (_) => IncidentSubRoute(data: arguments));
      case editProfileScreenRoute:
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case changePasswordScreenRoute:
        return MaterialPageRoute(builder: (_) => const ChangePassword());
      case changeUsernameScreenRoute:
        String arguments = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ChangeUsername(
                  userName: arguments,
                ));
      case changeLanguageScreenRoute:
        return MaterialPageRoute(builder: (_) => const ChangeLanguage());
      case enlargeImageScreenRoute:
        Uint8List arguments = settings.arguments as Uint8List;
        return MaterialPageRoute(
            builder: (_) => EnlargeImage(
                  imageName: arguments,
                ));
      case aboutUsScreenRoute:
        return MaterialPageRoute(builder: (_) => const AboutUs());
      case submitReportScreenRoute:
        SubmitReportArg arguments = settings.arguments as SubmitReportArg;
        return MaterialPageRoute(
            builder: (_) => SubmitReport(
                  data: arguments,
                ));
      case submitSuccessfullyScreenRoute:
        return MaterialPageRoute(builder: (_) => const SubmitComplete());
      //Profile Route END Here
      case historyDetailsScreenRoute:
        ReportModel arguments = settings.arguments as ReportModel;
        return MaterialPageRoute(
            builder: ((context) => ReportDetails(data: arguments)));
      default:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
    }
  }
}
