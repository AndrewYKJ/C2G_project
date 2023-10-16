import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';

import '../../dio/api/auth/user.dart';
import '../../model/user_model.dart';

class ChangeUsername extends StatefulWidget {
  final String userName;
  const ChangeUsername({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final userNameController = TextEditingController();
  bool changeUserNameButtonActive = true;
  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsChangeUsernameScreen);

    userNameController.text = widget.userName;
    checkText();
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  Future<UserDTO> getProfile(
      BuildContext context, String ic, String usrRef) async {
    UserApi userApi = UserApi(context);
    return userApi.getUserProfile(ic, usrRef);
  }

  Future<UserDTO> updateUsername(
      BuildContext context, String ic, String usrRef, String newUsrName) async {
    UserApi userApi = UserApi(context);
    return userApi.updateUsername(ic, usrRef, newUsrName);
  }

  @override
  Widget build(BuildContext ctx) {
    double height = MediaQuery.of(context).size.height;
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
            height: height - kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                changeUsernameForm(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: changeUsernameButton(ctx),
    );
  }

  AppBar appHeader(BuildContext ctx) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leadingWidth: 100,
      centerTitle: true,
      title: Text(
        Utils.getTranslated(ctx, 'setting_edit_profile_title'),
        style: AppFont.helvBold(18,
            color: AppColors.appBlack(), decoration: TextDecoration.none),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
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

  Widget changeUsernameButton(BuildContext ctx) {
    return AppButton(
      onPressed: () async {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);

        updateUsername(
                ctx,
                await AppCache.getStringValue(
                  AppCache.USER_IC,
                ),
                AppCache.usrRef!,
                userNameController.text)
            .then((value) async {
          if (value.status!.toLowerCase().contains('success')) {
            await getProfile(
                    ctx,
                    await AppCache.getStringValue(
                      AppCache.USER_IC,
                    ),
                    AppCache.usrRef!)
                .then((data) {
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
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(ctx, userNameController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                String errorMsg = '';
                EasyLoading.dismiss();

                switch (data.errcode) {
                  case "900001":
                    errorMsg =
                        Utils.getTranslated(ctx, "getUserProf_api_error_01");
                    break;
                  case "900002":
                    errorMsg =
                        Utils.getTranslated(ctx, "getUserProf_api_error_02");
                    break;
                  case "900003":
                    errorMsg =
                        Utils.getTranslated(ctx, "getUserProf_api_error_03");
                    break;
                  case "900004":
                    errorMsg =
                        Utils.getTranslated(ctx, "getUserProf_api_error_04");
                    break;
                  default:
                    errorMsg = Utils.getTranslated(context, "api_other_error");
                    break;
                }
                Utils.showAlertDialog(ctx,
                    Utils.getTranslated(ctx, "api_error_tittle"), errorMsg);
              }
            });
          } else {
            String errorMsg = '';
            EasyLoading.dismiss();

            switch (value.errcode) {
              case "900001":
                errorMsg =
                    Utils.getTranslated(ctx, "updateUsername_api_error_01");
                break;
              case "900002":
                errorMsg =
                    Utils.getTranslated(ctx, "updateUsername_api_error_02");
                break;
              case "900003":
                errorMsg =
                    Utils.getTranslated(ctx, "updateUsername_api_error_03");
                break;
              case "900004":
                errorMsg =
                    Utils.getTranslated(ctx, "updateUsername_api_error_04");
                break;
              case "900005":
                errorMsg =
                    Utils.getTranslated(ctx, "updateUsername_api_error_05");
                break;
              default:
                errorMsg = Utils.getTranslated(context, "api_other_error");
                break;
            }
            Utils.showAlertDialog(
                ctx, Utils.getTranslated(ctx, "api_error_tittle"), errorMsg);
          }
        });
      },
      isDisabled: changeUserNameButtonActive,
      isGradient: true,
      text: Utils.getTranslated(context, "btn_save"),
    );
  }

  Column changeUsernameForm() {
    return Column(
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
          keyboardType: TextInputType.text,
          //onChanged: checkText(),
          maxLines: 1,

          obscuringCharacter: "*",
          textInputAction: TextInputAction.done,

          obscureText: false,
          controller: userNameController,
          maxLength: 100,
          style: AppFont.helvBold(14,
              color: AppColors.appBlack(), decoration: TextDecoration.none),
          decoration: InputDecoration(
              counterText: '',
              hintText: "Enter Your Full Name",
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

  checkText() {
    userNameController.addListener(() {
      if (userNameController.text.isNotEmpty) {
        setState(() {
          changeUserNameButtonActive = true;
        });
      } else {
        setState(() {
          changeUserNameButtonActive = false;
        });
      }
    });
  }
}
