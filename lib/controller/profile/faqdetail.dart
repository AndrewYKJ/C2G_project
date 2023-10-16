import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';

import '../../const/app_font.dart';

class FaqDetail extends StatefulWidget {
  final String title;

  final String description;
  const FaqDetail({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  State<FaqDetail> createState() => _FaqDetailState();
}

class _FaqDetailState extends State<FaqDetail> {
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsFaqDetailsScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              faqtitle(),
              faqContent(),
            ]),
      ),
    ); //
  }

  Widget faqContent() {
    return Text(
      widget.description,
      style: AppFont.helvMed(14, color: AppColors.appBlack()),
    );
  }

  Container faqtitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 24),
      child: Text(
        widget.title,
        style: AppFont.helvBold(18, color: AppColors.appBlack()),
      ),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appWhite(),
      elevation: 0.0,
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
