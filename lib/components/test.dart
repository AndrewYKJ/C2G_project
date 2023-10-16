import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';

class Component {
  static Widget appButton(
      BuildContext context,
      Function() onPressed,
      bool isDisabled,
      bool isGradient,
      String text,
      Gradient? gradient,
      TextStyle? textStyle,
      Color? color) {
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
                          stops: const [
                            0,
                            1
                          ],
                          colors: [
                            AppColors.appPrimaryBlue(),
                            const Color.fromARGB(255, 78, 6, 130)
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
                AppFont.bold(16,
                    color: AppColors.appWhite(),
                    decoration: TextDecoration.none),
          )),
    );
  }
}
