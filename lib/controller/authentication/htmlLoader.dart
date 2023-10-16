import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlLoader extends StatefulWidget {
  final String htmlfileName;
  const HtmlLoader({Key? key, required this.htmlfileName}) : super(key: key);

  @override
  State<HtmlLoader> createState() => _HtmlLoaderState();
}

class _HtmlLoaderState extends State<HtmlLoader> {
  late WebViewController _controller;

  @override
  void initState() {
    analyticsCall();
    super.initState();
  }

  analyticsCall() {
    if (widget.htmlfileName.toLowerCase().contains('term')) {
      Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsTermScreen);
    } else {
      {
        Utils.setFirebaseAnalyticsCurrentScreen(
            Constants.analyticsPolicyScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: header(context),
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          color: Colors.white,
          child: WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets(widget.htmlfileName);
            },
          ),
        ),
      ),
    );
  }

  _loadHtmlFromAssets(String htmlfileName) async {
    String fileText =
        await rootBundle.loadString('assets/html/' + htmlfileName);
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appWhite(),
      elevation: 0.0,
      // centerTitle: true,
      // title: Text(
      //   'About Us',
      //   style: AppFont.helvBold(18, color: AppColors.appBlack()),
      // ),
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
