import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';

import 'app_colors.dart';

class EnlargeImage extends StatelessWidget {
  final Uint8List imageName;
  const EnlargeImage({Key? key, required this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.appBlack(),
        child: Center(
          child: Image.memory(
            imageName,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.appBlack(),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 11),
                child: Image.asset(Constants.assetImages + 'close_icon.png'),
              ),
              Text(
                Utils.getTranslated(context, 'alert_dialog_cancel_text'),
                style: AppFont.helvBold(14, color: AppColors.appWhite()),
              )
            ],
          ),
        ),
      ),
      leadingWidth: 250,
    );
  }
}
