import 'package:flutter/material.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/routes/app_route.dart';

class SubmitComplete extends StatefulWidget {
  const SubmitComplete({Key? key}) : super(key: key);

  @override
  State<SubmitComplete> createState() => _SubmitCompleteState();
}

class _SubmitCompleteState extends State<SubmitComplete> {
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsSubmitSuccessfulScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 88),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                  height: 100,
                  child: Image.asset(
                    Constants.assetImages + 'success_icon.png',
                    fit: BoxFit.fill,
                  )),
              const SizedBox(
                height: 34,
              ),
              SizedBox(
                width: width * 0.6,
                child: Text(
                  Utils.getTranslated(context, "report_completed_title"),
                  textAlign: TextAlign.center,
                  style: AppFont.helvBold(22,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 180,
                child: Text(
                  Utils.getTranslated(context, "report_completed_subtitle"),
                  textAlign: TextAlign.center,
                  style: AppFont.helvMed(14,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
              ),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: doneButton(context),
    );
  }

  Widget doneButton(BuildContext context) {
    return AppButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.baseRoute, (route) => false);
      },
      isDisabled: true,
      isGradient: true,
      text: Utils.getTranslated(context, "btn_done"),
    );
  }
}
