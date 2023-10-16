import 'package:flutter/material.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/landing_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LandingScreen();
  }
}

class _LandingScreen extends State<LandingScreen> {
  int currentIndex = 0;
  late PageController _controller;
  ScrollPhysics? scrollPhysics;
  //dataset
  List<LandingModel> contents = [];

  @override
  void initState() {
    checkController();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsLandingScreen);
    super.initState();
  }

  checkController() {
    _controller = PageController(initialPage: 0);
    // _controller.addListener(() {
    //   setState(() {
    //     if (_controller.position.userScrollDirection ==
    //         ScrollDirection.forward) {
    //       scrollPhysics = const NeverScrollableScrollPhysics();
    //     }

    //     // if (_controller.position.userScrollDirection ==
    //     //     ScrollDirection.forward) {
    //     //   scrollPhysics = const NeverScrollableScrollPhysics();
    //     // } else {
    //     // scrollPhysics = const AlwaysScrollableScrollPhysics();
    //     // }
    //   });
    //   Future.delayed(
    //       const Duration(milliseconds: 200),
    //       () => setState(() {
    //             scrollPhysics = const AlwaysScrollableScrollPhysics();
    //           }));
    //   //  print(_controller.offset);
    //   // if (_controller.page == 2 &&
    //   //     _controller.position.userScrollDirection == ScrollDirection.reverse) {
    //   //   Navigator.pushNamedAndRemoveUntil(
    //   //       context, AppRoutes.onboardLanguageScreenRoute, (route) => false);
    //   // }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getContext(context) {
    setState(() {
      contents = [
        LandingModel(
          title: Utils.getTranslated(context, "general incident"),
          image: Constants.assetImages + 'onboard_img.png',
          discription: Utils.getTranslated(context, "landing_1_description"),
        ),
        LandingModel(
          title: Utils.getTranslated(context, "flood warning"),
          image: Constants.assetImages + 'onboard 2_img.png',
          discription: Utils.getTranslated(context, "landing_2_description"),
        ),
        LandingModel(
          title: Utils.getTranslated(context, "sos flood incident"),
          image: Constants.assetImages + 'onboard 3_img.png',
          discription: Utils.getTranslated(context, "landing_3_description"),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    getContext(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1],
              colors: <Color>[
                AppColors.gradientBackGround1(),
                AppColors.gradientBackGround2(),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      physics: scrollPhysics,
                      controller: _controller,
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (_, i) {
                        return pageViewItem(i, context);
                      },
                    ),
                    currentIndex != 2 ? skipIntroButton(context) : Container(),
                  ],
                ),
              ),
              nextPageButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget nextPageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: AppButton(
        isDisabled: true,
        isGradient: true,
        onPressed: () {
          if (currentIndex == contents.length - 1) {
            _controller.dispose();
            Navigator.pushNamedAndRemoveUntil(context,
                AppRoutes.onboardLanguageScreenRoute, (route) => false);
          }
          _controller.nextPage(
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn,
          );
        },
        text: currentIndex == contents.length - 1
            ? Utils.getTranslated(context, 'btn_getting_started')
            : Utils.getTranslated(context, "btn_next"),
        textStyle: AppFont.helvBold(16,
            color: AppColors.appWhite(), decoration: TextDecoration.none),
      ),
    );
  }

  Widget skipIntroButton(BuildContext context) {
    return Positioned(
      child: TextButton(
        onPressed: () {
          _controller.dispose();
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.onboardLanguageScreenRoute, (route) => false);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                Utils.getTranslated(context, "btn_skip"),
                style: AppFont.helvBold(14,
                    color: AppColors.appPrimaryBlue(),
                    decoration: TextDecoration.none),
              ),
              const SizedBox(width: 16),
              Image.asset(
                Constants.assetImages + 'right arrow_icon.png',
                height: 17,
              ),
            ],
          ),
        ),
      ),
      top: 0.0,
      right: 0.0,
    );
  }

  Widget pageViewItem(int i, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            contents[i].image,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          contents[i].title,
          style: AppFont.helvBold(22,
              color: AppColors.appBlack(), decoration: TextDecoration.none),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.63,
          child: Text(
            contents[i].discription,
            textAlign: TextAlign.center,
            style: AppFont.helvMed(14,
                color: AppColors.appSecondaryBlue(),
                decoration: TextDecoration.none),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) => buildDot(index, context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: currentIndex == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.appPrimaryBlue()),
    );
  }
}
