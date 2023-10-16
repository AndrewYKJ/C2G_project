import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/logout.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../model/user_model.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? name;
  String? phoneNo;
  bool isLoading = true;
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsProfileScreen);

    getName();
    super.initState();
  }

  Future<UserDTO> signOut(
      BuildContext context, String ic, String usrRef) async {
    LogOutApi signOutApi = LogOutApi(context);
    return signOutApi.signOut(ic, usrRef);
  }

  getName() async {
    setState(() {
      name = AppCache.me.data![0].usrFName;
//print(name);
      phoneNo = "+60${AppCache.me.data![0].usrContactNo}";

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Container(
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userDetail(),
                    profileFeatures(context),
                    signOutButton(context, width)
                  ],
                ),
              ),
            ),
          );
  }

  Widget signOutButton(BuildContext context, double width) {
    return InkWell(
      onTap: () async {
        final confirm = await Utils.confirmationDialog(
          context,
          Utils.getTranslated(context, 'setting_logout'),
          Utils.getTranslated(context, 'setting_logout_description'),
          width,
          true,
          Utils.getTranslated(context, 'setting_logout'),
        );
        //  print(confirm);
        if (confirm != null && confirm) {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          signOut(
                  context,
                  await AppCache.getStringValue(
                    AppCache.USER_IC,
                  ),
                  AppCache.usrRef!)
              .then((value) {
            EasyLoading.dismiss();
            if (value.status!.toLowerCase().contains('success')) {
              // AppCache.removeValues(AppCache.languageCode);
              AppCache.removeValues('usrRef');
              AppCache.removeValues('usrIC');
              AppCache.removeValues('fcm');
              AppCache.removeValues(AppCache.USER_IC);
              setState(() {
                Navigator.pushReplacementNamed(
                    context, AppRoutes.splashScreenRoute);
              });
            } else {
              String errorMsg = '';

              switch (value.errcode) {
                case "900001":
                  errorMsg =
                      Utils.getTranslated(context, "logout_api_error_01");
                  break;
                case "900002":
                  errorMsg =
                      Utils.getTranslated(context, "logout_api_error_02");
                  break;
                case "900003":
                  errorMsg =
                      Utils.getTranslated(context, "logout_api_error_03");
                  break;
                case "900004":
                  errorMsg =
                      Utils.getTranslated(context, "logout_api_error_04");
                  break;
                case "900005":
                  errorMsg =
                      Utils.getTranslated(context, "logout_api_error_05");
                  break;
                default:
                  errorMsg = Utils.getTranslated(context, "api_other_error");
                  break;
              }
              Utils.showAlertDialog(context,
                  Utils.getTranslated(context, "api_error_tittle"), errorMsg);
            }
          });
        }
      },
      child: Text(
        Utils.getTranslated(context, 'setting_logout'),
        style: AppFont.helvBold(16, color: AppColors.appRed()),
      ),
    );
  }

  Widget profileFeatures(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          editUserDetailRoute(context),
          aboutUsRoute(context),
          faqRoute(context),
          changeLanguageRoute(context),
        ],
      ),
    );
  }

  Widget changeLanguageRoute(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.changeLanguageScreenRoute);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.getTranslated(context, 'setting_language'),
                style: AppFont.helvMed(14, color: AppColors.appPrimaryBlue()),
              ),
              Image.asset(
                Constants.assetImages + 'right arrow_icon.png',
                height: 17,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget faqRoute(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.faqListScreenRoute);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.getTranslated(context, 'setting_faq'),
                style: AppFont.helvMed(14, color: AppColors.appPrimaryBlue()),
              ),
              Image.asset(
                Constants.assetImages + 'right arrow_icon.png',
                height: 17,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget aboutUsRoute(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.aboutUsScreenRoute);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.getTranslated(context, 'setting_about_us'),
                style: AppFont.helvMed(14, color: AppColors.appPrimaryBlue()),
              ),
              Image.asset(
                Constants.assetImages + 'right arrow_icon.png',
                height: 17,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget editUserDetailRoute(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          AppRoutes.editProfileScreenRoute,
        );
        if (result != null && result is bool) {
          getName();
        }
      },
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.getTranslated(context, 'setting_edit_profile_title'),
                style: AppFont.helvMed(14, color: AppColors.appPrimaryBlue()),
              ),
              Image.asset(
                Constants.assetImages + 'right arrow_icon.png',
                height: 17,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget userDetail() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 11, bottom: 22),
        child: Column(children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                color: AppColors.appDisabledGray(),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(30)),
            child: Image.asset(
              Constants.assetImages + 'user_Icon.png',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name ?? '-',
              style: AppFont.helvBold(26, color: AppColors.appBlack()),
            ),
          ),
          Text(
            phoneNo ?? '-',
            style: AppFont.helvMed(12, color: AppColors.phoneGray()),
          ),
        ]),
      ),
    );
  }
}
