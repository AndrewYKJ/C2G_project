import 'package:flutter/material.dart';

class AppFont {
  static TextStyle thin(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w100,
        color: color,
        decoration: decoration);
  }

  static TextStyle light(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: color,
        decoration: decoration);
  }

  static TextStyle regular(double size,
      {Color? color, double? height, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        height: height,
        decoration: decoration);
  }

  static TextStyle medium(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color,
        decoration: decoration);
  }

  static TextStyle semibold(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        decoration: decoration);
  }

  static TextStyle bold(double size,
      {Color? color, double? height, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        height: height,
        decoration: decoration);
  }

  static TextStyle black(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: color,
        decoration: decoration);
  }

  static TextStyle italic(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'Lato',
        fontSize: size,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: color,
        decoration: decoration);
  }

  static TextStyle helvMed(double size,
      {Color? color,
      TextDecoration? decoration,
      double? spacing,
      double? lineHeight}) {
    return TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: size,
        fontWeight: FontWeight.w500,
        letterSpacing: spacing ?? 0,
        color: color,
        height: lineHeight,
        decoration: decoration);
  }

  static TextStyle helvBold(double size,
      {Color? color,
      TextDecoration? decoration,
      double? spacing,
      double? lineHeight}) {
    return TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: spacing ?? 0,
        height: lineHeight,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfArabicSemi(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SF Arabic',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfUIRegular(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SFUIText',
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        decoration: decoration);
  }

  static TextStyle sfUISemi(double size,
      {Color? color, TextDecoration? decoration}) {
    return TextStyle(
        fontFamily: 'SFUIText',
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        decoration: decoration);
  }
}
