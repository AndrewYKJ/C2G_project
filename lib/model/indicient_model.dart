import 'package:flutter/material.dart';

class IncidentModel {
  String title;
  Enum? type;
  bool? isSubCatExist;
  List<dynamic>? routeName;
  Color? color;
  IncidentModel(
      {required this.title,
      this.isSubCatExist,
      this.routeName,
      this.type,
      this.color});
}
