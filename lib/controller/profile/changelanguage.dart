import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/language_model.dart';

import '../../const/app_font.dart';
import '../../const/constants.dart';
import '../../main.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  List<LanguageCode> languageList = [
    LanguageCode(code: 'en', isSelected: false, displayName: 'English'),
    LanguageCode(code: 'id', isSelected: false, displayName: 'Bahasa Malaysia'),
    //   LanguageCode(code: 'zh', isSelected: false, displayName: '简体中文'),
  ];
  bool isLoading = true;
  late String currentLanguage;
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsChangeLanguageScreen);

    initLanguage();
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
    // await AppCache.getLocale()
    //     .then((value) => print('current :' + value.toString()));
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : Scaffold(
            appBar: header(context),
            body: Container(
              color: AppColors.appWhite(),
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pageSubTitle(),
                    for (var element in languageList)
                      languageItem(context, element)
                  ]),
            )); //
  }

  Container pageSubTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        Utils.getTranslated(context, "setting_language_subtitle"),
        style: AppFont.helvBold(16, color: AppColors.appSecondaryBlue()),
      ),
    );
  }

  Widget languageItem(BuildContext context, LanguageCode i) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: InkWell(
            onTap: () async {
              final confirm = await Utils.confirmationDialog(
                  context,
                  Utils.getTranslated(context, 'btn_confirm'),
                  Utils.getTranslated(context, 'change_language_subtitle'),
                  width,
                  false,
                  Utils.getTranslated(context, 'btn_confirm'));

              if (confirm != null && confirm) {
                changeLanguage(i.code);
              }
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
        const Divider(),
      ],
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appWhite(),
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        Utils.getTranslated(context, "setting_language"),
        style: AppFont.helvBold(18,
            color: AppColors.appBlack(), decoration: TextDecoration.none),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 11),
              child: Image.asset(Constants.assetImages + 'left arrow_icon.png'),
            ),
            Text(
              Utils.getTranslated(context, "back_text"),
              style: AppFont.helvBold(14, color: AppColors.appPrimaryBlue()),
            )
          ],
        ),
      ),
      leadingWidth: 80,
    );
  }
}
