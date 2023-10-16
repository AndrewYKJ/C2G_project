import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/main.dart';
import 'package:jpan_flutter/model/user_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../dio/api/auth/login.dart';
import '../dio/api/auth/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  UserDTO? userDTO;
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsSplashScreen);
    super.initState();
    startTimer();
  }

  Future<UserDTO> getProfile(
      BuildContext context, String ic, String usrRef) async {
    UserApi userApi = UserApi(context);
    return userApi.getUserProfile(ic, usrRef);
  }

  // Future<UserDTO> login(
  //   BuildContext context,
  //   String ic,
  //   String pwd,
  // ) async {
  //   LoginApi loginApi = LoginApi(context);
  //   return loginApi.login(pwd, ic, await AppCache.getStringValue('fcm'));
  // }

  startTimer() {
    Future.delayed(const Duration(seconds: 2), () async {
      await getUser(context);
    });
  }

  getUser(c) async {
    await AppCache.getLocale().then((value) {
      MyApp.setLocale(context, value);
      AppCache.language = value.toString();
    });

    final String storedIC = await AppCache.getStringValue('usrIC');
    final String storedRef = await AppCache.getStringValue('usrRef');
    if (storedIC.isNotEmpty && storedRef.isNotEmpty) {
      String errorMsg = '';
      await getProfile(c, storedIC, storedRef).then((value) {
        AppCache.usrRef = storedRef;

        userDTO = value;
      }).whenComplete(() {
        userDTO ??= UserDTO(status: 'fail', errcode: '123');
        if (userDTO!.status!.toLowerCase().contains('success')) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.baseRoute, (route) => false);
          // AppCache.setString('IC', AppCache.me.data!.first.usrFName!)
          //     .then((value) => Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         AppRoutes.baseRoute,
          //         (route) => false));
        } else {
          errorMsg = '';

          switch (userDTO!.errcode) {
            case "900001":
              errorMsg = Utils.getTranslated(c, "getUserProf_api_error_01");
              break;
            case "900002":
              errorMsg = Utils.getTranslated(c, "getUserProf_api_error_02");
              break;
            case "900003":
              errorMsg = Utils.getTranslated(c, "getUserProf_api_error_03");
              break;
            case "900004":
              errorMsg = Utils.getTranslated(c, "getUserProf_api_error_04");
              break;
            default:
              errorMsg = Utils.getTranslated(c, "api_other_error");
              break;
          }
          Utils.showAlertDialog(
              c, Utils.getTranslated(c, "api_error_tittle"), errorMsg);
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.landingScreenRoute, (route) => false);
        }
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.landingScreenRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 1],
            colors: <Color>[
              AppColors.gradientBackGround1(),
              AppColors.gradientBackGround2(),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        child: Center(
          child: SizedBox(
            width: 200,
            child: Image.asset(
              Constants.assetImages + 'c2g_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
