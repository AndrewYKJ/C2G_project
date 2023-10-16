import 'package:jpan_flutter/model/auth/register_model.dart';

class OtpModel {
  String title;
  String? description;

  bool fromResetPW;
  RegisterModel? userData;
  OtpModel(
      {required this.title,
      this.description,
      this.userData,
      required this.fromResetPW});
}
