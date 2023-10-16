import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/faq_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../const/constants.dart';

class FaqList extends StatefulWidget {
  FaqList({Key? key}) : super(key: key);

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  final List<FaqModel> faqContents = [
    FaqModel(
        title: "faq_1_quest",
        description:
            "faq_1_ans"),
    FaqModel(
        title: "faq_2_quest",
        description:
            "faq_2_ans"),
    FaqModel(
        title: "faq_3_quest",
        description:
            "faq_3_ans"),
    FaqModel(
        title: "faq_4_quest",
        description:
            "faq_4_ans"),
    FaqModel(
        title: "faq_5_quest",
        description:
            "faq_5_ans"),
    FaqModel(
        title: "faq_6_quest",
        description:
            "faq_6_ans"),
    FaqModel(
        title: "faq_7_quest",
        description: "faq_7_ans"),
    FaqModel(
        title: "faq_8_quest",
        description:
            "faq_8_ans"),
  ];
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsFaqListScreen);
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
              pageTitle(),
              for (var i = 0; i < faqContents.length; i++)
                faqlistitem(context, i)
            ]),
      ),
    );
  }

  Column faqlistitem(BuildContext context, int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(
              context, AppRoutes.faqDetailScreenRoute,
              arguments: FaqModel(
                  title: Utils.getTranslated(context, faqContents[i].title) ,
                  description: Utils.getTranslated(context, faqContents[i].description))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    Utils.getTranslated(context, faqContents[i].title) ,
                    style:
                        AppFont.helvMed(14, color: AppColors.appPrimaryBlue()),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.appPrimaryBlue(),
                  size: 30,
                )
              ]),
        ),
        const SizedBox(
          height: 12,
        ),
        const Divider()
      ],
    );
  }

  Container pageTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 24),
      child: Text(
        'FAQ',
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
