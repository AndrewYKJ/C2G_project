// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:jpan_flutter/model/category/category_code_color_model.dart';
import 'package:jpan_flutter/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/otp/otp_model.dart';

class AppCache {
  static const String ACCESS_TOKEN_PREF = "ACCESS_TOEKN_PREF";
  static const String languageCode = "LANGUAGE_CODE_PREF";

  static const String USER_IC = "USER_IC";
  static UserDTO me = UserDTO();
  static OtpDTO otp = OtpDTO();
  static String? language;
  static String? usrRef;
  static List<CategoryCodeModel>? catCodeCache;
  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String data = pref.getString(key) ?? "";
    return data;
  }

  static void removeValues(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(AppCache.languageCode, languageCode);
    return Locale(languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(AppCache.languageCode) ?? "en";
    return Locale(languageCode);
  }

  static void setAuthToken(String accessToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(ACCESS_TOKEN_PREF, accessToken);
  }

  static void removeAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN_PREF);
  }
}
