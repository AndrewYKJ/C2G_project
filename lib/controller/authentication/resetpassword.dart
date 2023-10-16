import 'package:flutter/material.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/otp_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../const/constants.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool hidePassword = true;
  bool hideCfmPassword = true;
  final passController = TextEditingController();
  final cfmpassController = TextEditingController();
  bool resetPwdButtonActive = false;

  final _formKey = GlobalKey<FormState>();
  late String _password;
  @override
  void initState() {
    checkText();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appHeader(ctx),
      body: SingleChildScrollView(
        child: Container(
          height: height - kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslated(ctx, 'setting_reset_password_title'),
                    style:
                        AppFont.helvBold(26, decoration: TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    Utils.getTranslated(
                        ctx, 'setting_reset_password_description'),
                    style: AppFont.helvMed(14, decoration: TextDecoration.none),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        pwdInputForm(),
                        const SizedBox(
                          height: 30,
                        ),
                        cfmPwdInputForm(),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: resetButton(ctx),
    );
  }

  AppBar appHeader(BuildContext ctx) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () {
          Navigator.popAndPushNamed(
            ctx,
            AppRoutes.otpverfiyScreenRoute,
            arguments: OtpModel(title: 'Reset Password', fromResetPW: true),
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

  Widget resetButton(BuildContext ctx) {
    return AppButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          Navigator.pushNamedAndRemoveUntil(
              ctx, AppRoutes.resetcompleteScreenRoute, (route) => false);
        }
      },
      isDisabled: resetPwdButtonActive,
      isGradient: true,
      text: Utils.getTranslated(ctx, 'btn_verify'),
    );
  }

  Column pwdInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'setting_change_password_new_pass'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          maxLines: 1,
          maxLength: 30,
          //  onChanged: checkText(),
          style: AppFont.helvBold(14,
              color: AppColors.appBlack(), spacing: hidePassword ? 2 : 0),
          textInputAction: TextInputAction.done,
          obscureText: hidePassword,
          controller: passController,
          validator: (value) {
            _password = value!;
            if (value.length < 8) {
              return Utils.getTranslated(
                  context, 'password_too_short_error_text');
            }
            if (!isStrongPassword(value)) {
              return Utils.getTranslated(
                  context, 'password_invalid_format_error_text');
            }

            return null;
          },

          decoration: InputDecoration(
              errorMaxLines: 2,
              counterText: '',
              hintText: Utils.getTranslated(
                  context, 'setting_reset_password_description'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              suffixIcon: InkWell(
                onTap: () {
                  if (passController.text.isNotEmpty) {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  }
                },
                child: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.appPrimaryBlue(),
                ),
              )),
        ),
      ],
    );
  }

  Column cfmPwdInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'setting_change_password_confirm_pass'),
          style: AppFont.helvMed(16,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          maxLines: 1,
          //  onChanged: checkText(),
          style: AppFont.helvBold(14,
              color: AppColors.appBlack(), spacing: hideCfmPassword ? 2 : 0),
          textInputAction: TextInputAction.done,
          obscureText: hideCfmPassword,
          controller: cfmpassController,
          validator: (value) {
            if (_password != value) {
              return Utils.getTranslated(
                  context, 'password_not_match_error_text');
            }
            if (value!.length < 8) {
              return Utils.getTranslated(
                  context, 'password_too_short_error_text');
            }
            if (!isStrongPassword(value)) {
              return Utils.getTranslated(
                  context, 'password_invalid_format_error_text');
            }

            return null;
          },
          decoration: InputDecoration(
              errorMaxLines: 2,
              hintText: Utils.getTranslated(
                  context, 'setting_change_password_confirm_pass_placholder'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              suffixIcon: InkWell(
                onTap: () {
                  if (cfmpassController.text.isNotEmpty) {
                    setState(() {
                      hideCfmPassword = !hideCfmPassword;
                    });
                  }
                },
                child: Icon(
                  hideCfmPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.appPrimaryBlue(),
                ),
              )),
        ),
      ],
    );
  }

  bool isStrongPassword(String value) {
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasNumber = RegExp(r'\d');
    return hasUppercase.hasMatch(value) &&
        hasLowercase.hasMatch(value) &&
        hasNumber.hasMatch(value);
  }

  checkText() {
    cfmpassController.addListener(() {
      if (cfmpassController.text.isNotEmpty) {
        setState(() {
          hideCfmPassword = true;
        });
      }
      if (passController.text.isNotEmpty && cfmpassController.text.isNotEmpty) {
        setState(() {
          resetPwdButtonActive = true;
        });
      } else {
        setState(() {
          resetPwdButtonActive = false;
        });
      }
    });
    passController.addListener(() {
      if (passController.text.isNotEmpty) {
        setState(() {
          hidePassword = true;
        });
      }
      if (passController.text.isNotEmpty && cfmpassController.text.isNotEmpty) {
        setState(() {
          resetPwdButtonActive = true;
        });
      } else {
        setState(() {
          resetPwdButtonActive = false;
        });
      }
    });
  }
}
