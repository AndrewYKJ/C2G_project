import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/login.dart';
import 'package:jpan_flutter/dio/api/auth/user.dart';
import 'package:jpan_flutter/model/district/district_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../model/user_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  final icNoController = TextEditingController();
  final passController = TextEditingController();
  bool signInButtonActive = false;

  final _formKey = GlobalKey<FormState>();

  List<DistrictDataDTO> data = [];
  @override
  void initState() {
    checkText();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsLoginScreen);

    super.initState();
  }

  @override
  void dispose() {
    icNoController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<UserDTO> login(
    BuildContext context,
    String ic,
    String pwd,
  ) async {
    LoginApi loginApi = LoginApi(context);
    return loginApi.login(pwd, ic, await AppCache.getStringValue('fcm'));
  }

  Future<UserDTO> getProfile(
      BuildContext context, String ic, String usrRef) async {
    UserApi userApi = UserApi(context);
    return userApi.getUserProfile(ic, usrRef);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              //   margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: AppColors.appWhite(),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loginScreenImage(),
                  signInForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInForm(BuildContext c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: AppColors.appWhite(),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: AppColors.appBlack30(),
              offset: Offset(0, 0),
            ),
            BoxShadow(
              color: AppColors.appWhite(),
              blurRadius: 4,
              offset: const Offset(0, 10),
            )
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            Utils.getTranslated(context, 'landing_sign_in'),
            style: AppFont.helvBold(26,
                color: AppColors.appBlack(), decoration: TextDecoration.none),
          ),
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
                pwdInputForm(),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          forgotPwButton(c),
          const SizedBox(
            height: 60,
          ),
          AppButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                await login(c, icNoController.text, passController.text)
                    .then((data) async {
                  if (data.status!.toLowerCase().contains('success')) {
                    await getProfile(c, icNoController.text, AppCache.usrRef!)
                        .then((value) async {
                      EasyLoading.dismiss();
                      if (value.status!.toLowerCase().contains('success')) {
                        await AppCache.setString(
                                AppCache.USER_IC, icNoController.text)
                            .then((value) => Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.baseRoute,
                                (route) => false));
                      } else {
                        String errorMsg = '';
                        EasyLoading.dismiss();

                        switch (value.errcode) {
                          case "900001":
                            errorMsg = Utils.getTranslated(
                                context, "getUserProf_api_error_01");
                            break;
                          case "900002":
                            errorMsg = Utils.getTranslated(
                                context, "getUserProf_api_error_02");
                            break;
                          case "900003":
                            errorMsg = Utils.getTranslated(
                                context, "getUserProf_api_error_03");
                            break;
                          case "900004":
                            errorMsg = Utils.getTranslated(
                                context, "getUserProf_api_error_04");
                            break;
                          default:
                            errorMsg =
                                Utils.getTranslated(context, "api_other_error");
                            break;
                        }
                        Utils.showAlertDialog(
                            context,
                            Utils.getTranslated(context, "api_error_tittle"),
                            errorMsg);
                      }
                    });
                  } else {
                    String errorMsg = '';
                    EasyLoading.dismiss();

                    switch (data.errcode) {
                      case "900001":
                        errorMsg =
                            Utils.getTranslated(context, "login_api_error_01");
                        break;
                      case "900002":
                        errorMsg =
                            Utils.getTranslated(context, "login_api_error_02");
                        break;
                      case "900003":
                        errorMsg =
                            Utils.getTranslated(context, "login_api_error_03");
                        break;
                      case "900004":
                        errorMsg =
                            Utils.getTranslated(context, "login_api_error_04");
                        break;
                      default:
                        errorMsg =
                            Utils.getTranslated(context, "api_other_error");
                        break;
                    }
                    Utils.showAlertDialog(
                        context,
                        Utils.getTranslated(context, "api_error_tittle"),
                        errorMsg);
                  }
                });
              }
            },
            isDisabled: signInButtonActive,
            isGradient: true,
            text: Utils.getTranslated(context, 'landing_sign_in'),
          ),
          const SizedBox(
            height: 20,
          ),
          registerAccButton(c),
        ],
      ),
    );
  }

  Align forgotPwButton(BuildContext ctx) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(ctx, AppRoutes.sendOtpScreenRoute);
          },
          child: Text(
            Utils.getTranslated(context, 'login_forget_password'),
            style: AppFont.helvBold(14,
                color: AppColors.appPrimaryBlue(),
                decoration: TextDecoration.none),
          )),
    );
  }

  Widget registerAccButton(ctx) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Utils.getTranslated(context, 'login_new_user'),
            style: AppFont.helvMed(14,
                color: AppColors.appPrimaryBlue(),
                decoration: TextDecoration.none),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    ctx, AppRoutes.registerScreenRoute);
              },
              child: Text(
                Utils.getTranslated(context, 'login_register_account'),
                style: AppFont.helvBold(14,
                    color: AppColors.appPrimaryBlue(),
                    decoration: TextDecoration.none),
              )),
        ],
      ),
    );
  }

  Column pwdInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'login_password_title'),
          style: AppFont.helvMed(14,
              color: AppColors.appPrimaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          maxLines: 1,
          maxLength: 30,
          textInputAction: TextInputAction.done,
          obscureText: hidePassword,
          controller: passController,
          validator: (value) {
            if (value!.length < 8) {
              return Utils.getTranslated(
                  context, 'password_too_short_error_text');
            }

            return null;
          },
          style: AppFont.helvBold(14,
              color: AppColors.appBlack(), spacing: hidePassword ? 2 : 0),
          decoration: InputDecoration(
              counterText: '',
              hintText:
                  Utils.getTranslated(context, 'signup_password_placeholder'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none,
                  spacing: 0),
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

  Column icInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'formfield_ic_name'),
          style: AppFont.helvMed(14,
              color: AppColors.appPrimaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          //onChanged: checkText(),
          maxLines: 1,
          maxLength: 12,
          style: AppFont.helvBold(
            14,
            color: AppColors.appBlack(),
          ),
          validator: (value) {
            final RegExp icRegex = RegExp(r'^\d{12}$');
            if (!icRegex.hasMatch(value!)) {
              return Utils.getTranslated(
                  context, 'invalid_ic_format_error_text');
            }

            return null;
          },
          textInputAction: TextInputAction.done,
          obscureText: false,
          controller: icNoController,
          decoration: InputDecoration(
              counterText: '',
              hintText:
                  Utils.getTranslated(context, 'formfield_ic_placeholder'),
              hintStyle: AppFont.helvMed(14,
                  color: AppColors.appDisabledGray(),
                  decoration: TextDecoration.none),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray())),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appDisabledGray()))),
        ),
      ],
    );
  }

  Widget loginScreenImage() {
    return Container(
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
      child: Center(
        //   padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          Constants.assetImages + 'c2g_logo.png',
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.3,
          width: 200,
        ),
      ),
    );
  }

  checkText() {
    icNoController.addListener(() {
      if (icNoController.text.isNotEmpty && passController.text.isNotEmpty) {
        setState(() {
          signInButtonActive = true;
        });
      } else {
        setState(() {
          signInButtonActive = false;
        });
      }
    });
    passController.addListener(() {
      if (icNoController.text.isNotEmpty && passController.text.isNotEmpty) {
        setState(() {
          signInButtonActive = true;
        });
      } else {
        setState(() {
          signInButtonActive = false;
        });
      }
    });
  }
}
