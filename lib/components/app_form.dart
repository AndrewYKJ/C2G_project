import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';

class AppForm extends StatelessWidget {
  final Function() onChanged;
  final TextEditingController controller;

  final String formName;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboard;
  final String type;
  final Color? color;
  final TextStyle? textStyle;
  final bool? isPassword;
  final bool? hidePassword;
  final bool? hasPrefix;

  const AppForm({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.formName,
    required this.type,
    required this.hintText,
    required this.obscureText,
    required this.keyboard,
    required this.isPassword,
    required this.hasPrefix,
    required this.hidePassword,
    this.textStyle,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formName,
          style: textStyle ??
              AppFont.regular(16,
                  color: AppColors.appPrimaryBlue(),
                  decoration: TextDecoration.none),
        ),
        TextField(
          keyboardType: keyboard,
          onChanged: onChanged(),
          maxLines: 1,
          obscuringCharacter: "*",
          textInputAction: TextInputAction.done,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.appDisabledGray())),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.appDisabledGray())),
            suffix: isPassword!
                ? Icon(
                    hidePassword! ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.appPrimaryBlue(),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
