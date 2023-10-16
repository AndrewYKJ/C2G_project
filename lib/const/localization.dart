import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalization {
  MyLocalization(this.locale);

  final Locale locale;
  static MyLocalization of(BuildContext context) {
    return Localizations.of<MyLocalization>(context, MyLocalization)!;
  }

  late Map<String, String> _localizedValues;

  // Future<void> load() async {
  //   String jsonStringValues = await rootBundle
  //       .loadString('assets/locale/${locale.languageCode}.json');
  //   Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
  //   _localizedValues =
  //       mappedJson.map((key, value) => MapEntry(key, value.toString()));
  // }
  // Future<void> load2() async {
  //   String jsonStringValues = await rootBundle
  //       .loadString('assets/locale/${locale.languageCode}.json');
  //   Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

  //   String settingLanguage = mappedJson['PAGE2']['setting_language'];

  //   _localizedValues =
  //       mappedJson.map((key, value) => MapEntry(key, value.toString()));
  // }

  // String translate(String pageKey, String textKey) {
  //   return _localizedValues[pageKey][textKey];
  // }
  Future<void> load() async {
    String jsonStringValues = await rootBundle
        .loadString('assets/locale/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, Map<String, String>.from(value).toString());
      } else {
        return MapEntry(key, value.toString());
      }
    });
  }

  String translate(String pageKey, String textKey) {
    if (_localizedValues.containsKey(pageKey)) {
      dynamic pageData = _localizedValues[pageKey];
      if (pageData is Map<String, String> && pageData.containsKey(textKey)) {
        return pageData[textKey]!;
      }
    }
    return '';
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<MyLocalization> delegate =
      _MyLocalizationsDelegate();
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalization> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<MyLocalization> load(Locale locale) async {
    MyLocalization localization = MyLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyLocalization> old) => false;
}
