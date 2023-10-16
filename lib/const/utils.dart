// ignore_for_file: unnecessary_new

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/localization.dart';

import 'constants.dart';

class Utils {
  static printInfo(Object object) {
    if (Constants.isDebug) {
      print(object);
    }
  }

  static bool isNotEmpty(String? text) {
    return text != null && text.isNotEmpty;
  }

  static void setFirebaseAnalyticsCurrentScreen(String curScreenName) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: curScreenName);
  }

  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }

  static String capitalizeEveryWord(String input) {
    return input.split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      } else {
        return word;
      }
    }).join(' ');
  }

  static confirmationDialog(BuildContext context, String title, String message,
      double width, bool isWarning, String buttonText) {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      title,
                      style: AppFont.helvBold(18,
                          color: AppColors.appBlack(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 12),
                  child: Center(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppFont.helvMed(14,
                          color: AppColors.appSecondaryBlue(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(false),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: width * 0.32,
                          decoration: BoxDecoration(
                              color: AppColors.appWhite(),
                              border: Border.all(
                                color: AppColors.appPrimaryBlue(),
                              ),
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            Utils.getTranslated(
                                context, 'alert_dialog_cancel_text'),
                            style: AppFont.helvBold(16,
                                color: AppColors.appPrimaryBlue(),
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogContext, true),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: width * 0.32,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [
                                    0,
                                    1
                                  ],
                                  colors: [
                                    isWarning
                                        ? AppColors.gradientRed1()
                                        : AppColors.gradientBlue1(),
                                    isWarning
                                        ? AppColors.gradientRed2()
                                        : AppColors.gradientBlue2(),
                                  ]),
                              color: AppColors.appRed(),
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            buttonText,
                            style: AppFont.helvBold(16,
                                color: AppColors.appWhite(),
                                decoration: TextDecoration.none),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  static void showSubCatAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(dialogContext);
            },
          ),
        ],
      ),
    );
  }

  static Locale mylocale(String languageCode) {
    switch (languageCode) {
      case Constants.languageCodeBM:
        return const Locale(Constants.indonesia);
      case Constants.languageCodeEn:
        return const Locale(Constants.english);

      default:
        return const Locale(Constants.english);
    }
  }

  static String appLanguage(BuildContext context, String languageCode) {
    switch (languageCode) {
      case Constants.english:
        return getTranslated(context, "setting_language_en");
      case Constants.indonesia:
        return getTranslated(context, "setting_language_id");
      case Constants.chinese:
        return getTranslated(context, "setting_language_zh");

      default:
        return "";
    }
  }

  static String getTranslated(
      BuildContext context, String pageKey, String textKey) {
    return MyLocalization.of(context).translate(pageKey, textKey);
  }
}
