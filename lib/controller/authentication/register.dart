import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/auth/register.dart';
import 'package:jpan_flutter/model/auth/register_model.dart';
import 'package:jpan_flutter/model/otp_model.dart';
import 'package:jpan_flutter/model/reponse.dart';
import 'package:jpan_flutter/routes/app_route.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  final icNoController = TextEditingController();
  final passController = TextEditingController();
  final mobileNoController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  bool registerButtonActive = false;
  bool termNcondition = false;
  bool _agreeTerms = false;
  Object _value = '0';

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    checkText();
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsRegisterScreen);

    super.initState();
  }

  @override
  void dispose() {
    icNoController.dispose();
    passController.dispose();
    mobileNoController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<ResponseStatusDTO> callRegisterApi(
    BuildContext context,
  ) async {
    RegisterApi registerApi = RegisterApi(context);
    return registerApi.onRegister(
      emailController.text,
      passController.text,
      _value.toString(),
      mobileNoController.text,
      fullNameController.text,
      icNoController.text,
    );
  }

  @override
  Widget build(BuildContext ctx) {
    double height = MediaQuery.of(ctx).size.height;
    return Scaffold(
      appBar: appHeader(ctx),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(ctx);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslated(ctx, 'login_register_account'),
                  style: AppFont.helvBold(26, color: AppColors.appBlack()),
                ),
                const SizedBox(
                  height: 30,
                ),
                registerForm(ctx),
                agreeTermWidget(),
                SizedBox(
                  height: height * 0.1,
                ),
                registerButton(ctx),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fullNameInputForm(),
          const SizedBox(
            height: 30,
          ),
          icInputForm(),
          const SizedBox(
            height: 30,
          ),
          emailInputForm(),
          const SizedBox(
            height: 30,
          ),
          mobileNoInputForm(context),
          const SizedBox(
            height: 30,
          ),
          pwdInputForm(),
          const SizedBox(
            height: 30,
          ),
          selectGender(context),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget selectGender(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(ctx, 'select_description'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(ctx).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.appBlack30(), width: 1),
                top: BorderSide.none,
                left: BorderSide.none,
                right: BorderSide.none),
          ),
          child: DropdownButton(
            isExpanded: true,
            underline: Container(),
            onChanged: (value) {
              if (value != "0") {
                _value = value!;

                if (_agreeTerms &&
                    _value != "0" &&
                    icNoController.text.isNotEmpty &&
                    passController.text.isNotEmpty &&
                    mobileNoController.text.isNotEmpty &&
                    fullNameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  setState(() {
                    registerButtonActive = true;
                  });
                } else {
                  setState(() {
                    registerButtonActive = false;
                  });
                }
              }
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: _value != "0"
                  ? AppColors.appBlack()
                  : AppColors.appDisabledGray(),
            ),
            value: _value,
            items: [
              DropdownMenuItem(
                value: "0",
                child: Text(
                  Utils.getTranslated(ctx,
                      'select_placeholder'), //  Utils.getTranslated(ctx, 'login_register_account'),
                  style:
                      AppFont.helvMed(16, color: AppColors.appDisabledGray()),
                ),
              ),
              DropdownMenuItem(
                value: "1",
                child: Text(
                  Utils.getTranslated(ctx, 'male'),
                  style: AppFont.helvMed(16, color: AppColors.appBlack()),
                ),
              ),
              DropdownMenuItem(
                value: "2",
                child: Text(
                  Utils.getTranslated(ctx, 'female'),
                  style: AppFont.helvMed(16, color: AppColors.appBlack()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppButton registerButton(BuildContext ctx) {
    return AppButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          Navigator.pushNamedAndRemoveUntil(
              ctx, AppRoutes.otpverfiyScreenRoute, (route) => true,
              arguments: OtpModel(
                  title: Utils.getTranslated(context, 'otp_screen_title'),
                  userData: RegisterModel(
                      email: emailController.text,
                      mobileNo: mobileNoController.text,
                      ic: icNoController.text,
                      gender: _value.toString(),
                      password: passController.text,
                      name: fullNameController.text),
                  fromResetPW: false));
        }
      },
      isDisabled: registerButtonActive,
      isGradient: true,
      text: Utils.getTranslated(context, 'btn_register'),
    );
  }

  AppBar appHeader(BuildContext ctx) {
    return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                ctx, AppRoutes.loginScreenRoute, (route) => false);
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

  Widget agreeTermWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customRadio(_agreeTerms),
        const SizedBox(
          width: 18,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.70,
          padding: const EdgeInsets.only(top: 5),
          child: Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            children: [
              Text(
                Utils.getTranslated(context, 'tnp_first_segment'),
                style: AppFont.helvMed(14, decoration: TextDecoration.none),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.htmlLoaderScreenRoute,
                    arguments: 'terms.html'),
                child: Text(
                  Utils.getTranslated(context, 'tnp_second_segment'),
                  style: AppFont.helvBold(14,
                      color: AppColors.appPrimaryBlue(),
                      decoration: TextDecoration.none),
                ),
              ),
              Text(
                Utils.getTranslated(context, 'tnp_third_segment'),
                style: AppFont.helvMed(14, decoration: TextDecoration.none),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.htmlLoaderScreenRoute,
                    arguments: 'privacy.html'),
                child: Text(
                  Utils.getTranslated(context, 'tnp_fourth_segment'),
                  style: AppFont.helvBold(14,
                      color: AppColors.appPrimaryBlue(),
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget customRadio(bool agreeTnc) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _agreeTerms = !_agreeTerms;
          if (_agreeTerms &&
              _value != "0" &&
              icNoController.text.isNotEmpty &&
              passController.text.isNotEmpty &&
              mobileNoController.text.isNotEmpty &&
              fullNameController.text.isNotEmpty) {
            registerButtonActive = true;
          } else {
            registerButtonActive = false;
          }
          agreeTnc = _agreeTerms;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(
            width: 20,
            height: 20,
            child: agreeTnc
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white),
                    child: Image.asset(
                      Constants.assetImages + 'tick_icon.png',
                      fit: BoxFit.contain,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey),
                        color: Colors.white),
                  )),
      ),
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

  Column fullNameInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'signup_icname_title'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextField(
          keyboardType: TextInputType.text,
          //onChanged: checkText(),
          maxLines: 1,
          maxLength: 100,
          style: AppFont.helvBold(
            14,
            color: AppColors.appBlack(),
          ),
          textInputAction: TextInputAction.done,
          obscureText: false,
          controller: fullNameController,
          decoration: InputDecoration(
              counterText: '',
              hintText:
                  Utils.getTranslated(context, 'signup_icname_placeholder'),
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

  Column mobileNoInputForm(BuildContext ctx) {
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
        TextFormField(
          keyboardType: TextInputType.number,
          //onChanged: checkText(),
          maxLines: 1,
          obscuringCharacter: "*",
          textInputAction: TextInputAction.done,
          obscureText: false,
          controller: mobileNoController,
          style: AppFont.helvBold(
            14,
            color: AppColors.appBlack(),
          ),
          validator: (value) {
            if (!isMobileNumber(value!)) {
              return Utils.getTranslated(
                  context, 'invalid_mobile_number_error_text');
            }

            return null;
          },

          decoration: InputDecoration(
              errorMaxLines: 2,
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '+60',
                  style: AppFont.helvBold(14, decoration: TextDecoration.none),
                ),
              ),
              hintText: "123456789",
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

  Widget pwdInputForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslated(context, 'login_password_title'),
          style: AppFont.helvMed(14,
              color: AppColors.appSecondaryBlue(),
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.done,
          obscureText: hidePassword,
          controller: passController,
          validator: (value) {
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
          style: AppFont.helvBold(14,
              color: AppColors.appBlack(), spacing: hidePassword ? 2 : 0),
          maxLength: 30,
          decoration: InputDecoration(
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
            ),
            errorMaxLines: 2,
            counterText: '',
          ),
        ),
      ],
    );
  }

  bool isMobileNumber(String value) {
    final mobileNumber = RegExp(r'^1[012346789]\d{7,8}$');
    return mobileNumber.hasMatch(value);
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
    emailController.addListener(() {
      if (_agreeTerms &&
          _value != "0" &&
          icNoController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          mobileNoController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty) {
        setState(() {
          registerButtonActive = true;
        });
      } else {
        setState(() {
          registerButtonActive = false;
        });
      }
    });
    icNoController.addListener(() {
      if (_agreeTerms &&
          _value != "0" &&
          icNoController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          mobileNoController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty) {
        setState(() {
          registerButtonActive = true;
        });
      } else {
        setState(() {
          registerButtonActive = false;
        });
      }
    });
    passController.addListener(() {
      if (_agreeTerms &&
          _value != "0" &&
          icNoController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          mobileNoController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty) {
        setState(() {
          registerButtonActive = true;
        });
      } else {
        setState(() {
          registerButtonActive = false;
        });
      }
    });
    mobileNoController.addListener(() {
      if (_agreeTerms &&
          _value != "0" &&
          icNoController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          mobileNoController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty) {
        setState(() {
          registerButtonActive = true;
        });
      } else {
        setState(() {
          registerButtonActive = false;
        });
      }
    });
    fullNameController.addListener(() {
      if (_agreeTerms &&
          _value != "0" &&
          icNoController.text.isNotEmpty &&
          passController.text.isNotEmpty &&
          mobileNoController.text.isNotEmpty &&
          fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty) {
        setState(() {
          registerButtonActive = true;
        });
      } else {
        setState(() {
          registerButtonActive = false;
        });
      }
    });
  }
}
