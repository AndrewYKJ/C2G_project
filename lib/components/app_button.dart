import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';

class AppButton extends StatelessWidget {
  final Function() onPressed;
  final bool isDisabled;
  final bool isGradient;
  final Gradient? gradient;
  final Color? color;
  final String text;
  final TextStyle? textStyle;

  const AppButton({
    Key? key,
    required this.onPressed,
    required this.isDisabled,
    required this.isGradient,
    required this.text,
    this.textStyle,
    this.gradient,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          gradient: isDisabled
              ? !isGradient
                  ? null
                  : gradient ??
                      LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.gradientBlue1(),
                            AppColors.gradientBlue2()
                          ])
              : null,
          color: isDisabled
              ? color ?? AppColors.appPrimaryBlue()
              : AppColors.appDisabledGray(),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(25)),
      child: TextButton(
          onPressed: isDisabled ? onPressed : null,
          child: Text(
            text,
            style: textStyle ??
                AppFont.helvBold(16,
                    color: AppColors.appWhite(),
                    decoration: TextDecoration.none),
          )),
    );
  }
}
