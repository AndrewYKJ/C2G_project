import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/otp.dart';
import 'package:jpan_flutter/dio/api/auth/register.dart';
import 'package:jpan_flutter/dio/dio_repo.dart';
import 'package:jpan_flutter/model/auth/register_model.dart';
import 'package:jpan_flutter/model/otp/otp_model.dart';
import 'package:jpan_flutter/model/reponse.dart';
import 'package:jpan_flutter/routes/app_route.dart';
import 'package:pinput/pinput.dart';

import '../../components/app_button.dart';
import '../../const/constants.dart';

class OtpVerify extends StatefulWidget {
  final String title;
  final bool isResetPW;
  final RegisterModel? userData;

  const OtpVerify(
      {Key? key, required this.title, required this.isResetPW, this.userData})
      : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final otpController = TextEditingController();
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 180;

  int currentSeconds = 0;
  bool verifyButtonActive = false;
  bool isResendOtpActive = false;
  bool otpInvalid = false;
  Timer? timer;
  String? refCode;
  OtpDTO? generateOTPdata = OtpDTO();
  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}  ';

  startTimeout() async {
    var duration = interval;
    isResendOtpActive = false;
    currentSeconds = 0;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          isResendOtpActive = true;
        }
      });
    });
  }

  Future<OtpDTO> generateOTP(
    BuildContext context,
    String ic,
    String phoneNo,
  ) async {
    OtpApi otpApi = OtpApi(context);
    return otpApi.generateOtp(ic, phoneNo);
  }

  Future<OtpDTO> validateOTPCode(
    BuildContext context,
  ) async {
    OtpApi otpApi = OtpApi(context);
    return otpApi.validateOtp(otpController.text, generateOTPdata!.refCode!);
  }

  Future<ResponseStatusDTO> callRegisterApi(
    BuildContext context,
  ) async {
    RegisterApi registerApi = RegisterApi(context);
    return registerApi.onRegister(
      widget.userData!.email!,
      widget.userData!.password!,
      widget.userData!.gender!,
      widget.userData!.mobileNo!,
      widget.userData!.name!,
      widget.userData!.ic!,
    );
  }

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsVerifyOtpScreen);

    startTimeout();
    if (!widget.isResetPW) {
      getOTP();
    }

    super.initState();
  }

  getOTP() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await generateOTP(
            context, widget.userData!.ic!, '0${widget.userData!.mobileNo!}')
        .then((value) {
      EasyLoading.dismiss();
      if (value.status!.toLowerCase().contains('success')) {
        setState(() {
          generateOTPdata = value;
        });
      } else {
        String errorMsg = '';

        switch (value.errcode) {
          case "900001":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_01");
            break;
          case "900002":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_02");
            break;
          case "900003":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_03");
            break;
          case "900004":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_04");
            break;
          case "900005":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_05");
            break;
          case "900006":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_06");
            break;
          case "900007":
            errorMsg = Utils.getTranslated(context, "genOTP_api_error_07");
            break;
          default:
            errorMsg = Utils.getTranslated(context, "api_other_error");
            break;
        }
        Utils.showAlertDialog(context,
            Utils.getTranslated(context, "api_error_tittle"), errorMsg);
      }
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: header(ctx),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(ctx);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(ctx).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                otpDescription(),
                const SizedBox(
                  height: 10,
                ),
                userMobileNo(),
                const SizedBox(
                  height: 22,
                ),
                otpFormField(context),
                const SizedBox(
                  height: 30,
                ),
                resendOTPTimer(),
                resendCodeWidget(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: verifyButton(ctx),
    );
  }

  Widget resendOTPTimer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Center(
        child: Text(
          timerText,
          style: AppFont.helvBold(16, color: AppColors.appPrimaryBlue()),
        ),
      ),
    );
  }

  Widget verifyButton(BuildContext ctx) {
    return AppButton(
      onPressed: () async {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        await validateOTPCode(ctx).then((value) async {
          if (value.status!.toLowerCase().contains('success')) {
            await callRegisterApi(ctx).then((res) {
              if (res.status!.toLowerCase().contains('success')) {
                EasyLoading.dismiss();
                Navigator.pushNamedAndRemoveUntil(ctx,
                    AppRoutes.registercompleteScreenRoute, (route) => false);
              } else {
                String errorMsg = '';
                EasyLoading.dismiss();
                switch (res.errcode) {
                  case "900001":
                    errorMsg =
                        Utils.getTranslated(context, "regis_api_error_01");
                    break;
                  case "900002":
                    errorMsg =
                        Utils.getTranslated(context, "regis_api_error_02");
                    break;
                  case "900003":
                    errorMsg =
                        Utils.getTranslated(context, "regis_api_error_03");
                    break;
                  case "900005":
                    errorMsg =
                        Utils.getTranslated(context, "regis_api_error_05");
                    break;
                  default:
                    errorMsg = Utils.getTranslated(context, "api_other_error");
                    break;
                }

                Utils.showAlertDialog(context,
                    Utils.getTranslated(context, "api_error_tittle"), errorMsg);
              }
            });
            // Navigator.pushNamedAndRemoveUntil(
            //     ctx, AppRoutes.registercompleteScreenRoute, (route) => false);
          } else {
            String errorMsg = '';
            EasyLoading.dismiss();
            switch (value.errcode) {
              case "900001":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_01");
                break;
              case "900002":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_02");
                break;
              case "900003":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_03");
                break;
              case "900004":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_04");
                break;
              case "900005":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_05");
                break;
              case "900006":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_06");
                break;
              case "900007":
                errorMsg = Utils.getTranslated(context, "valOTP_api_error_07");
                break;
              default:
                errorMsg = Utils.getTranslated(context, "api_other_error");
                break;
            }
            Utils.showAlertDialog(context,
                Utils.getTranslated(context, "api_error_tittle"), errorMsg);
          }
        });
        // await validateOTP();
        // if (!otpInvalid) {
        //   widget.isResetPW
        //       ? Navigator.pushNamedAndRemoveUntil(
        //           ctx, AppRoutes.resetpasswordScreenRoute, (route) => false)
        //       : Navigator.pushNamedAndRemoveUntil(
        //           ctx, AppRoutes.registercompleteScreenRoute, (route) => false);
        // }
      },
      isDisabled: verifyButtonActive,
      isGradient: true,
      text: Utils.getTranslated(context, 'btn_verify'),
    );
  }

  AppBar header(BuildContext ctx) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () {
          Navigator.pop(ctx);
          // Navigator.pushNamedAndRemoveUntil(
          //     ctx, AppRoutes.registerScreenRoute, (route) => false);
        },
        child: Container(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 11),
                child:
                    Image.asset(Constants.assetImages + 'left arrow_icon.png'),
              ),
              Text(
                Utils.getTranslated(context, "back_text"),
                style: AppFont.helvBold(14, color: AppColors.appPrimaryBlue()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userMobileNo() {
    return Text(
      widget.userData!.mobileNo != null
          ? '+60' +
              widget.userData!.mobileNo!.replaceRange(
                  (widget.userData!.mobileNo!.length - 4), null, '****.')
          : '-',
      style: AppFont.helvMed(14, decoration: TextDecoration.none),
    );
  }

  Widget otpDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppFont.helvBold(26, decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          Utils.getTranslated(context, "setting_verfiy_otp_subtitle"),
          style: AppFont.helvMed(14, decoration: TextDecoration.none),
        ),
      ],
    );
  }

  Widget resendCodeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, "setting_label_did_not_received"),
          style: AppFont.helvMed(16, decoration: TextDecoration.none),
        ),
        const SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () async {
            if (isResendOtpActive) {
              setState(() {
                otpInvalid = false;
                otpController.text = '';
              });
              startTimeout();
            }
          },
          child: Text(
            Utils.getTranslated(context, "setting_resend_otp_btn"),
            style: AppFont.helvBold(16,
                color: isResendOtpActive
                    ? AppColors.appPrimaryBlue()
                    : AppColors.appDisabledGray(),
                decoration: TextDecoration.none),
          ),
        ),
      ],
    );
  }

  Widget otpFormField(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: 80,
      constraints: const BoxConstraints.expand(width: 80, height: 76),
      textStyle: AppFont.helvBold(25,
          color: otpInvalid ? AppColors.appRed() : AppColors.appPrimaryBlue()),
      decoration: BoxDecoration(
        border: Border.all(
            color: otpInvalid
                ? AppColors.appRed()
                : const Color.fromARGB(91, 0, 0, 0)),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith();

    final submittedPinTheme = defaultPinTheme.copyWith();
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              separator: Container(
                //margin: EdgeInsets.fromLTRB(-1, 0, 0, 0),

                width: 0,
              ),

              submittedPinTheme: submittedPinTheme,
              // validator: (s) {
              //   return s == '2222' ? null : 'Pin is incorrect';
              // },
              controller: otpController,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => setState(() {
                verifyButtonActive = true;
              }),
              onChanged: (value) {
                if (value.length != 6 && verifyButtonActive) {
                  setState(() {
                    verifyButtonActive = false;
                  });
                }
              },
            ),
          ),
          otpInvalid
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: Text(
                      Utils.getTranslated(context, 'otp_validator_error_text'),
                      textAlign: TextAlign.left,
                      style: AppFont.helvMed(
                        12,
                        color: AppColors.appRed(),
                      )),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  validateOTP() {
    setState(() {
      otpInvalid = false;
    });
  }
}
