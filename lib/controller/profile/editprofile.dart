import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/routes/app_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:device_info/device_info.dart';

import '../../const/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final mobileNoController = TextEditingController();
  final fullNameController = TextEditingController();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String prefix = '+60';
  bool isLoading = true;
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'deviceVersion': data.systemVersion,
      'model': data.model,
      'isPhysicalDevice': data.isPhysicalDevice,
      'uuid': data.identifierForVendor
    };
  }

// ···

  emailLaunchUri(BuildContext context) async {
    String emailSubject = "";
    String emailBody = "";
    String emailUrl = "";
    String emailAddr = Constants.deleteAccountEmail;
    List<String> specialVersionList = [
      '14.4',
      '14.4.1',
      '14.4.2',
      '14.5',
      '14.5.1',
      '14.6',
      '14.7',
      '14.7.1',
      '14.8',
      '14.8.1'
    ];

    if (Platform.isIOS) {
      if (_deviceData != null) {
        if (specialVersionList
            .contains(_deviceData['deviceVersion'].toString())) {
          emailSubject =
              Utils.getTranslated(context, "request_delete_account_subject");
          emailBody = '''
${Utils.getTranslated(context, "request_delete_account_body")}
${Utils.getTranslated(context, "request_delete_account_body_name")}: ${fullNameController.text}
${Utils.getTranslated(context, "request_delete_account_body_ic")}: ${await AppCache.getStringValue(
            AppCache.USER_IC,
          )}
${Utils.getTranslated(context, "request_delete_account_body_no")}:${mobileNoController.text}
''';

          final Uri params = Uri(
              scheme: 'mailto',
              path: emailAddr,
              query: encodeQueryParameters(<String, String>{
                'subject': emailSubject,
                'body': emailBody
              }));
          emailUrl = params.toString();
        } else {
          emailSubject =
              Utils.getTranslated(context, "request_delete_account_subject");
          emailBody = '''
${Utils.getTranslated(context, "request_delete_account_body")}<br>
${Utils.getTranslated(context, "request_delete_account_body_name")}: ${fullNameController.text}<br>
${Utils.getTranslated(context, "request_delete_account_body_ic")}: ${await AppCache.getStringValue(
            AppCache.USER_IC,
          )}<br>
${Utils.getTranslated(context, "request_delete_account_body_no")}:${mobileNoController.text}
''';

          final Uri params = Uri(
              scheme: 'mailto',
              path: emailAddr,
              query: encodeQueryParameters(<String, String>{
                'subject': emailSubject,
                'body': emailBody
              }));

          emailUrl =
              params.toString().replaceAll("%3Cbr%3E%0A", "%0D%0A%0D%0A");
        }
      }
    } else {
      emailSubject =
          Utils.getTranslated(context, "request_delete_account_subject");
      emailBody = '''
${Utils.getTranslated(context, "request_delete_account_body")}<br>
${Utils.getTranslated(context, "request_delete_account_body_name")}: ${fullNameController.text}<br>
${Utils.getTranslated(context, "request_delete_account_body_ic")}: ${await AppCache.getStringValue(
        AppCache.USER_IC,
      )}<br>
${Utils.getTranslated(context, "request_delete_account_body_no")}:${mobileNoController.text}
''';

      final Uri params = Uri(
          scheme: 'mailto',
          path: emailAddr,
          query: encodeQueryParameters(
              <String, String>{'subject': emailSubject, 'body': emailBody}));

      emailUrl = params.toString().replaceAll("%3Cbr%3E%0A", "%0D%0A%0D%0A");
    }
    Utils.printInfo(emailUrl);

    if (await canLaunchUrlString(emailUrl)) {
      await launchUrlString(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  // Future emailLaunchUri() async {
  //   String toEmail = Constants.deleteAccountEmail;
  //   String subject = 'Request to Delete Account';
  //   String messaage =
  //       //"Request to Delete Account under:
  //       // Name: {user full name}
  //       // IC: {user IC}
  //       // Mobile Number: {user mobile} "
  //       'Request to Delete Account under "${fullNameController.text}"';

  //   List<String> specialVersionList = [
  //     '14.4',
  //     '14.4.1',
  //     '14.4.2',
  //     '14.5',
  //     '14.5.1',
  //     '14.6',
  //     '14.7',
  //     '14.7.1',
  //     '14.8',
  //     '14.8.1'
  //   ];

  //   final url =
  //       'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(messaage)}';

  //   if (await canLaunchUrlString(url)) {
  //     await launchUrlString(url);
  //   } else {
  //     print("Email failed to send");
  //   }
  // }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsEditProfileScreen);

    getUserDetail();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserDetail() async {
    setState(() {
      fullNameController.text = AppCache.me.data!.first.usrFName!;
      mobileNoController.text =
          (prefix + AppCache.me.data!.first.usrContactNo!);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    double height = MediaQuery.of(ctx).size.height;
    double width = MediaQuery.of(ctx).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
        : Scaffold(
            appBar: appHeader(ctx),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    fullNameInputForm(),
                    const SizedBox(
                      height: 30,
                    ),
                    mobileNoInputForm(ctx),
                    const SizedBox(
                      height: 30,
                    ),
                    changePW(ctx),
                    const SizedBox(
                      height: 24,
                    ),
                    deleteAccountDialog(width, height)
                  ],
                ),
              ),
            ),
          );
  }

  InkWell changePW(BuildContext ctx) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.changePasswordScreenRoute),
      child: Text(
        Utils.getTranslated(ctx, 'setting_change_password_title'),
        style: AppFont.helvBold(14,
            color: AppColors.appPrimaryBlue(), decoration: TextDecoration.none),
      ),
    );
  }

  AppBar appHeader(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        centerTitle: true,
        title: Text(
          Utils.getTranslated(context, 'setting_edit_profile_title'),
          style: AppFont.helvBold(18,
              color: AppColors.appBlack(), decoration: TextDecoration.none),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Container(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 11),
                  child: Image.asset(
                      Constants.assetImages + 'left arrow_icon.png'),
                ),
                Text(
                  Utils.getTranslated(context, "back_text"),
                  style:
                      AppFont.helvBold(14, color: AppColors.appPrimaryBlue()),
                )
              ],
            ),
          ),
        ));
  }

  Widget fullNameInputForm() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(
            context, AppRoutes.changeUsernameScreenRoute,
            arguments: fullNameController.text);

        if (result != null && result is String) {
          setState(() {
            fullNameController.text = AppCache.me.data!.first.usrFName!;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, 'setting_edit_profile_fullname'),
            style: AppFont.helvMed(14,
                color: AppColors.appSecondaryBlue(),
                decoration: TextDecoration.none),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            keyboardType: TextInputType.number,
            //onChanged: checkText(),
            maxLines: 1,
            enabled: false,
            obscuringCharacter: "*",
            textInputAction: TextInputAction.done,

            obscureText: false,
            controller: fullNameController,
            style: AppFont.helvBold(14,
                color: AppColors.appBlack(), decoration: TextDecoration.none),
            decoration: InputDecoration(
                hintText: "Enter Your Full Name",
                hintStyle: AppFont.helvMed(14,
                    color: AppColors.appBlack(),
                    decoration: TextDecoration.none),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.appDisabledGray())),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.appDisabledGray()))),
          ),
        ],
      ),
    );
  }

  Widget mobileNoInputForm(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(ctx, 'setting_about_us_contact_number'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextField(
          keyboardType: TextInputType.number,
          enabled: false,
          //onChanged: checkText(),
          maxLines: 1,
          style: AppFont.helvBold(14,
              color: AppColors.appDisabledGray(),
              decoration: TextDecoration.none),
          obscuringCharacter: "*",
          textInputAction: TextInputAction.done,
          obscureText: false,
          controller: mobileNoController,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray()))),
        ),
      ],
    );
  }

  Widget deleteAccountDialog(double width, double height) {
    return InkWell(
      onTap: () async {
        final confirm = await Utils.confirmationDialog(
          context,
          Utils.getTranslated(context, 'setting_delete_account'),
          Utils.getTranslated(context, 'setting_delete_account_description'),
          width,
          true,
          Utils.getTranslated(context, 'setting_delete'),
        );
        //  print(confirm);
        if (confirm != null && confirm) {
          // AppCache.removeValues('IC');
          // AppCache.removeValues(AppCache.languageCode);
          // setState(() {
          //   Navigator.pushReplacementNamed(
          //       context, AppRoutes.splashScreenRoute);
          // });

          await emailLaunchUri(context);
        }
      },
      child: Text(
        Utils.getTranslated(context, 'setting_delete_account_permenantly'),
        style: AppFont.helvBold(14,
            color: AppColors.appRed(), decoration: TextDecoration.none),
      ),
    );
  }
}
