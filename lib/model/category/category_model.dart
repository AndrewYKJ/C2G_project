// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

class CategoryDTO {
  CategoryDTO({
    this.msg,
    this.status,
    this.errcode,
    this.data,
  });

  String? msg;
  String? status;
  String? errcode;
  String? data;

  factory CategoryDTO.fromRawJson(String str) =>
      CategoryDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryDTO.fromJson(Map<String, dynamic> json) => CategoryDTO(
        msg: json["Msg"],
        status: json["Status"],
        errcode: json["errCode"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg,
        "Status": status,
        "errcode": errcode,
        "data": data,
      };
}

class CategoryDataDTO {
  CategoryDataDTO({
    this.catIconUrl,
    this.catCode,
    this.catDescEn,
    this.catDescBm,
  });

  String? catIconUrl;
  String? catCode;
  String? catDescEn;
  String? catDescBm;

  factory CategoryDataDTO.fromRawJson(String str) =>
      CategoryDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryDataDTO.fromJson(Map<String, dynamic> json) =>
      CategoryDataDTO(
        catIconUrl: json["CatIconURL"],
        catCode: json["CatCode"],
        catDescEn: json["CatDescEn"],
        catDescBm: json["CatDescBm"],
      );

  Map<String, dynamic> toJson() => {
        "CatIconURL": catIconUrl,
        "CatCode": catCode,
        "CatDescEn": catDescEn,
        "CatDescBm": catDescBm,
      };
}
