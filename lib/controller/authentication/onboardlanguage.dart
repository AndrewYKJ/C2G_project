import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/main.dart';
import 'package:jpan_flutter/model/language_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

class OnboardLanguage extends StatefulWidget {
  const OnboardLanguage({Key? key}) : super(key: key);

  @override
  State<OnboardLanguage> createState() => _OnboardLanguageState();
}

class _OnboardLanguageState extends State<OnboardLanguage> {
  List<LanguageCode> languageList = [
    LanguageCode(code: 'en', isSelected: false, displayName: 'English'),
    LanguageCode(code: 'id', isSelected: false, displayName: 'Bahasa Malaysia'),
    //  LanguageCode(code: 'zh', isSelected: false, displayName: '简体中文'),
  ];
  bool isLoading = true;
  late String currentLanguage;
  @override
  void initState() {
    initLanguage();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsOnboardLanguageScreen);

    super.initState();
  }

  initLanguage() async {
    await AppCache.getLocale()
        .then((value) => {currentLanguage = value.toString()});

    for (var element in languageList) {
      if (element.code == currentLanguage) {
        setState(() {
          element.isSelected = true;
          isLoading = false;
        });
        break;
      }
    }
  }

  changeLanguage(String code) async {
    MyApp.setLocale(context, Locale(code));
    await AppCache.setLocale(code);

    AppCache.language = code;
    currentLanguage = code;
    for (var element in languageList) {
      if (element.code == currentLanguage.toString()) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  color: AppColors.appWhite(),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      onboardScreenImage(),
                      chooseLanguage(context),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget chooseLanguage(BuildContext c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: AppColors.appWhite(),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: AppColors.appBlack30(),
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: AppColors.appWhite(),
              blurRadius: 4,
              offset: const Offset(0, 10),
            )
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          onboardTitle(),
          pageSubTitle(),
          for (var element in languageList) languageItem(context, element),
          const SizedBox(
            height: 60,
          ),
          saveLang(),
        ],
      ),
    );
  }

  Widget saveLang() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: AppButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.loginScreenRoute, (route) => false);
        },
        isDisabled: currentLanguage.isNotEmpty,
        isGradient: true,
        text: 'OK',
      ),
    );
  }

  Container onboardTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 34),
      child: Text(
        Utils.getTranslated(context, 'onboard_title'),
        style: AppFont.helvBold(26, color: AppColors.appBlack()),
      ),
    );
  }

  Container pageSubTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        Utils.getTranslated(context, "setting_language_subtitle"),
        style: AppFont.helvMed(14, color: AppColors.appSecondaryBlue()),
      ),
    );
  }

  Widget languageItem(BuildContext context, LanguageCode i) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: InkWell(
              onTap: () async {
                await changeLanguage(i.code);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Utils.appLanguage(context, i.code),
                    style: AppFont.helvBold(14, color: AppColors.appBlack()),
                  ),
                  i.isSelected
                      ? Image.asset(
                          Constants.assetImages + 'blue_tick_icon.png',
                          fit: BoxFit.contain,
                          height: 20,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget onboardScreenImage() {
    return Container(
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
      child: Center(
        //   padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          Constants.assetImages + 'c2g_logo.png',
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.3,
          width: 200,
        ),
      ),
    );
  }
}
