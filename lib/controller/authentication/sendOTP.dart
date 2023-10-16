import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/resetpw.dart';
import 'package:jpan_flutter/model/otp_model.dart';
import 'package:jpan_flutter/model/reponse.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../const/app_font.dart';
import '../../const/constants.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({Key? key}) : super(key: key);

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  final icNoController = TextEditingController();

  final emailController = TextEditingController();
  bool sendOtpButtonActive = false;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    checkText();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsResetPwdScreen);

    super.initState();
  }

  @override
  void dispose() {
    icNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<ResponseStatusDTO> resetPWD(
    BuildContext context,
    String email,
    String ic,
  ) async {
    ResetPWDApi resetPwdApi = ResetPWDApi(context);
    return resetPwdApi.resetPWD(email, ic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sendOTPDescription(),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          icInputForm(),
                          const SizedBox(
                            height: 30,
                          ),
                          emailInputForm(),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: sendOtpButton(context)
        //Component.appButton(
        //     context,
        //     () => Navigator.pushNamedAndRemoveUntil(
        //         context, AppRoutes.otpverfiyScreenRoute, (route) => false),
        //     sendOtpButtonActive,
        //     true,
        //     'Send OTP',
        //     null,
        //     null,
        //     null),
        );
  }

  Column icInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'formfield_ic_name'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          //  onChanged: checkText(),
          maxLines: 1,
          maxLength: 12,
          textInputAction: TextInputAction.done,
          style: AppFont.helvBold(14, color: AppColors.appBlack()),
          obscureText: false,
          controller: icNoController,
          validator: (value) {
            final RegExp icRegex = RegExp(r'^\d{12}$');
            if (!icRegex.hasMatch(value!)) {
              return Utils.getTranslated(
                  context, 'invalid_ic_format_error_text');
            }
            return null;
          },
          decoration: InputDecoration(
              counterText: '',
              hintText:
                  Utils.getTranslated(context, 'formfield_ic_placeholder'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none,
                  spacing: 0),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray()))),
        ),
      ],
    );
  }

  Column emailInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'email_address'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          //  onChanged: checkText(),
          maxLines: 1,

          textInputAction: TextInputAction.done,
          style: AppFont.helvBold(14, color: AppColors.appBlack()),
          obscureText: false,
          controller: emailController,
          validator: (value) {
            RegExp emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

            if (!emailValid.hasMatch(value!)) {
              return Utils.getTranslated(
                  context, 'invalid_email_format_error_text');
            }

            return null;
          },
          decoration: InputDecoration(
              counterText: '',
              hintText:
                  Utils.getTranslated(context, 'email_address_placeholder'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none,
                  spacing: 0),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray()))),
        ),
      ],
    );
  }

  checkText() {
    icNoController.addListener(() {
      if (icNoController.text.isNotEmpty && emailController.text.isNotEmpty) {
        setState(() {
          sendOtpButtonActive = true;
        });
      } else {
        setState(() {
          sendOtpButtonActive = false;
        });
      }
    });
    emailController.addListener(() {
      if (icNoController.text.isNotEmpty && emailController.text.isNotEmpty) {
        setState(() {
          sendOtpButtonActive = true;
        });
      } else {
        setState(() {
          sendOtpButtonActive = false;
        });
      }
    });
  }

  Widget sendOTPDescription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'setting_reset_password_title'),
          style: AppFont.helvMed(26, decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          Utils.getTranslated(context, 'setting_reset_password_subtitle'),
          style: AppFont.helvMed(14,
              decoration: TextDecoration.none, lineHeight: 1.5),
        ),
      ],
    );
  }

  Widget sendOtpButton(BuildContext ctx) {
    return AppButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          await resetPWD(
            ctx,
            emailController.text,
            icNoController.text,
          ).then((value) async {
            EasyLoading.dismiss();
            if (value.status!.toLowerCase().contains('success')) {
              Navigator.pushNamedAndRemoveUntil(context,
                  AppRoutes.resetcompleteScreenRoute, (route) => false);
            } else {
              String errorMsg = '';

              switch (value.errcode) {
                case "900001":
                  errorMsg =
                      Utils.getTranslated(context, "resetPwd_api_error_01");
                  break;
                case "900002":
                  errorMsg =
                      Utils.getTranslated(context, "resetPwd_api_error_02");
                  break;
                case "900003":
                  errorMsg =
                      Utils.getTranslated(context, "resetPwd_api_error_03");
                  break;
                case "900004":
                  errorMsg =
                      Utils.getTranslated(context, "resetPwd_api_error_04");
                  break;
                case "900005":
                  errorMsg =
                      Utils.getTranslated(context, "resetPwd_api_error_04");
                  break;
                default:
                  errorMsg = Utils.getTranslated(context, "api_other_error");
                  break;
              }
              Utils.showAlertDialog(context,
                  Utils.getTranslated(context, "api_error_tittle"), errorMsg);
            }
          });
          ;
          // Navigator.pushNamedAndRemoveUntil(
          //     ctx, AppRoutes.otpverfiyScreenRoute, (route) => false,
          //     arguments: OtpModel(
          //         title: Utils.getTranslated(
          //             context, 'setting_reset_password_title'),
          //         fromResetPW: true));
        }
      },
      isDisabled: sendOtpButtonActive,
      isGradient: true,
      text: Utils.getTranslated(context, 'btn_sendemail'),
    );
  }

  AppBar header(BuildContext ctx) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () {
          Navigator.popAndPushNamed(
            ctx,
            AppRoutes.loginScreenRoute,
          );
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
}
