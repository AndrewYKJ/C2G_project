import 'dart:convert';

class User {
  String? ic;
  String? name;
  String? mobileNo;
  String? language;

  User({this.ic, this.name, this.mobileNo, this.language});

  User.fromJson(Map<String, dynamic> json) {
    ic = json['ic'];
    name = json['name'];
    language = json['language'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['ic'] = ic;
    data['name'] = name;
    data['language'] = language;
    data['mobileNo'] = mobileNo;
    return data;
  }
}

class UserDTO {
  String? status;
  String? message;
  String? errcode;
  bool? success;
  String? usrRef;
  List<UserDataDTO>? data;

  UserDTO({this.status, this.message, this.errcode, this.success});

  UserDTO.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    json['Msg'] != null ? message = json['Msg'] : message = json['message'];
    usrRef = json['UsrRef'];
    success = json['success'];
    errcode = json['errCode'];
    if (json['data'] != null) {
      data = [];
      jsonDecode(json['data']).forEach((v) {
        data!.add(UserDataDTO.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['Status'] = status;
  //   data['statusMessage'] = message;
  //   return data;
  // }
}

class UserDataDTO {
  UserDataDTO({
    this.usrState,
    this.usrContactNo,
    this.usrPostCode,
    this.usrCountry,
    this.usrFName,
    this.usrCity,
    this.usrIdentity,
    this.usrAddress1,
    this.usrEmail,
    this.usrAddress2,
  });

  String? usrState;
  String? usrContactNo;
  String? usrPostCode;
  String? usrCountry;
  String? usrFName;
  String? usrCity;
  String? usrIdentity;
  String? usrAddress1;
  String? usrEmail;
  String? usrAddress2;

  factory UserDataDTO.fromJson(Map<String, dynamic> json) => UserDataDTO(
        usrState: json["UsrState"],
        usrContactNo: json["UsrContactNo"],
        usrPostCode: json["UsrPostCode"],
        usrCountry: json["UsrCountry"],
        usrFName: json["UsrFName"],
        usrCity: json["UsrCity"],
        usrIdentity: json["UsrIdentity"],
        usrAddress1: json["UsrAddress1"],
        usrEmail: json["UsrEmail"],
        usrAddress2: json["UsrAddress2"],
      );

  Map<String, dynamic> toJson() => {
        "UsrState": usrState,
        "UsrContactNo": usrContactNo,
        "UsrPostCode": usrPostCode,
        "UsrCountry": usrCountry,
        "UsrFName": usrFName,
        "UsrCity": usrCity,
        "UsrIdentity": usrIdentity,
        "UsrAddress1": usrAddress1,
        "UsrEmail": usrEmail,
        "UsrAddress2": usrAddress2,
      };
}
