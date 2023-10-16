import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';

import '../../const/app_font.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsAboutUsScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Container(
        color: AppColors.appWhite(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vision(),
              // mission(),
              // whoarewe(),
              // history(),
            ]),
      ),
    );
  }

  Column history() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our History',
          style: AppFont.helvBold(18, color: AppColors.appSecondaryBlue()),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras enim magna, hendrerit rhoncus enim sed, bibendum aliquam nisl. Nunc eleifend lacus eu porta.',
          style: AppFont.helvMed(14, color: AppColors.appBlack()),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Column whoarewe() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who Are We?',
          style: AppFont.helvBold(18, color: AppColors.appSecondaryBlue()),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          style: AppFont.helvBold(14, color: AppColors.appBlack()),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras enim magna, hendrerit rhoncus enim sed, bibendum aliquam nisl. Nunc eleifend lacus eu porta.',
          style: AppFont.helvMed(14, color: AppColors.appBlack()),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Column mission() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mission',
          style: AppFont.helvBold(18, color: AppColors.appSecondaryBlue()),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras enim magna, hendrerit rhoncus enim sed, bibendum aliquam nisl. Nunc eleifend lacus eu porta.',
          style: AppFont.helvMed(14, color: AppColors.appBlack()),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Column vision() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   Utils.getTranslated(context, "aboutus_title"),
        //   style: AppFont.helvBold(18, color: AppColors.appSecondaryBlue()),
        // ),
        // const SizedBox(
        //   height: 24,
        // ),
        Text(
          Utils.getTranslated(context, "aboutus_content"),
          style: AppFont.helvMed(14, color: AppColors.appBlack()),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appWhite(),
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        Utils.getTranslated(context, "setting_about_us_title"),
        style: AppFont.helvBold(18, color: AppColors.appBlack()),
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
