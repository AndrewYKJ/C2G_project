import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/resetpw.dart';
import 'package:jpan_flutter/model/reponse.dart';

import '../../const/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool hidePassword = true;
  bool hideCfmPassword = true;
  final passController = TextEditingController();
  final cfmpassController = TextEditingController();
  bool resetPwdButtonActive = false;
  final _formKey = GlobalKey<FormState>();
  late String _password;

  Future<ResponseStatusDTO> changePWD(
      BuildContext context, String pwd, String cfmpwd, String usrRef) async {
    ResetPWDApi resetPWD = ResetPWDApi(context);
    return resetPWD.changePWD(pwd, cfmpwd, usrRef);
  }

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsChangePasswordScreen);

    checkText();
    super.initState();
  }

  @override
  void dispose() {
    passController.dispose();
    cfmpassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appHeader(ctx),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
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
                      Utils.getTranslated(ctx, 'setting_change_password_title'),
                      style:
                          AppFont.helvBold(26, decoration: TextDecoration.none),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      Utils.getTranslated(
                          ctx, 'setting_reset_password_description'),
                      style:
                          AppFont.helvMed(14, decoration: TextDecoration.none),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: saveButton(ctx),
    );
  }

  AppBar appHeader(BuildContext ctx) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      leading: InkWell(
        onTap: () {
          Navigator.pop(ctx);
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

  Widget saveButton(BuildContext ctx) {
    return AppButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          changePWD(ctx, passController.text, cfmpassController.text,
                  AppCache.usrRef!)
              .then(
            (value) {
              if (value.status!.toLowerCase().contains('success')) {
                EasyLoading.dismiss();
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: Text(
                            Utils.getTranslated(context, "saved_changes"),
                            style: AppFont.helvBold(14,
                                color: AppColors.appSecondaryBlue(),
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: AppButton(
                          isGradient: true,
                          isDisabled: true,
                          text: 'Okay',
                          onPressed: () async {
                            Navigator.pop(ctx);
                            Navigator.pop(ctx);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                EasyLoading.dismiss();
                String errorMsg = '';

                switch (value.errcode) {
                  case "900001":
                    errorMsg =
                        Utils.getTranslated(context, "logout_api_error_01");
                    break;
                  case "900002":
                    errorMsg =
                        Utils.getTranslated(context, "logout_api_error_02");
                    break;
                  case "900003":
                    errorMsg =
                        Utils.getTranslated(context, "logout_api_error_03");
                    break;
                  case "900004":
                    errorMsg =
                        Utils.getTranslated(context, "logout_api_error_04");
                    break;
                  case "900005":
                    errorMsg =
                        Utils.getTranslated(context, "logout_api_error_05");
                    break;
                  default:
                    errorMsg = Utils.getTranslated(context, "api_other_error");
                    break;
                }
                Utils.showAlertDialog(context,
                    Utils.getTranslated(context, "api_error_tittle"), errorMsg);
              }
            },
          );
        }
      },
      isDisabled: resetPwdButtonActive,
      isGradient: true,
      text: Utils.getTranslated(ctx, 'btn_submit'),
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
