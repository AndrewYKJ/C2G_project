import 'package:flutter/material.dart';

class AppColors {
  static Color appPrimaryBlue() {
    return HexColor('#1E3674');
  }

  static Color appSecondaryBlue() {
    return HexColor('#1E3674').withOpacity(0.6);
  }

  static Color appDisabledGray() {
    return HexColor('#BFBFBF');
  }

  static Color appFilterDrawerCat() {
    return HexColor('#1a2751').withOpacity(.5);
  }

  static Color appBlueGray() {
    return HexColor('#1e3674').withOpacity(0.6);
  }

  static Color appWhite() {
    return HexColor('#ffffff');
  }

  static Color appBlack() {
    return HexColor('#000000');
  }

  static Color appBlack30() {
    return HexColor('#000000').withOpacity(.3);
  }

  static Color appRed() {
    return HexColor('#AF4038');
  }

  static Color appGreen() {
    return HexColor('#1F9039');
  }

  static Color gradientBlue1() {
    return HexColor('#511089');
  }

  static Color gradientBlue2() {
    return HexColor('#153778');
  }

  static Color gradientBackGround1() {
    return HexColor('#ffffff').withOpacity(0.3);
  }

  static Color gradientBackGround2() {
    return HexColor('#6fe5ff').withOpacity(0);
  }

  static Color gradientRed1() {
    return HexColor('#AF4038');
  }

  static Color gradientRed2() {
    return HexColor('#DD4E44');
  }

  static Color bluetagBackground() {
    return HexColor('#2976f2').withOpacity(0.6);
  }

  static Color bluetagText() {
    return HexColor('#0B4CB9');
  }

  static Color pupletagBackground() {
    return HexColor('#b771f2').withOpacity(0.6);
  }

  static Color pupletagText() {
    return HexColor('#8944C4');
  }

  static Color redtagBackground() {
    return HexColor('#e24237').withOpacity(0.6);
  }

  static Color redtagText() {
    return HexColor('#C92B43');
  }

  static Color greentagBackground() {
    return HexColor('#24c6a2').withOpacity(0.6);
  }

  static Color greentagText() {
    return HexColor('#168970');
  }

  static Color orangetagBackground() {
    return HexColor('#f78b51').withOpacity(0.6);
  }

  static Color orangetagText() {
    return HexColor('#F78B51');
  }

  static Color tealtagBackground() {
    return HexColor('#2cb2db').withOpacity(0.6);
  }

  static Color tealtagText() {
    return HexColor('#2989A5');
  }

  static Color phoneGray() {
    return HexColor('#BBBDC0');
  }

  static Color districtGray() {
    return HexColor('#979393');
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
