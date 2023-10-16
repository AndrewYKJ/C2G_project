// To parse this JSON data, do
//
//     final SubCategoryDTO = SubCategoryDTOFromJson(jsonString);

import 'dart:convert';

class SubCategoryDTO {
  SubCategoryDTO({
    this.msg,
    this.status,
    this.errcode,
    this.data,
  });

  String? msg;
  String? status;
  String? errcode;
  String? data;

  factory SubCategoryDTO.fromRawJson(String str) =>
      SubCategoryDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryDTO.fromJson(Map<String, dynamic> json) => SubCategoryDTO(
        msg: json["Msg"],
        status: json["Status"],
        errcode: json["errCode"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg,
        "Status": status,
        "errCode": errcode,
        "data": data,
      };
}

class SubCategoryDataDTO {
  SubCategoryDataDTO({
    this.subCatCode,
    this.subCatIconUrl,
    this.subCatDescEn,
    this.subCatDescBm,
  });

  String? subCatCode;
  String? subCatIconUrl;
  String? subCatDescEn;
  String? subCatDescBm;

  factory SubCategoryDataDTO.fromRawJson(String str) =>
      SubCategoryDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryDataDTO.fromJson(Map<String, dynamic> json) =>
      SubCategoryDataDTO(
        subCatCode: json["SubCatCode"],
        subCatIconUrl: json["SubCatIconFile"],
        subCatDescEn: json["SubCatDescEn"],
        subCatDescBm: json["SubCatDescBm"],
      );

  Map<String, dynamic> toJson() => {
        "SubCatCode": subCatCode,
        "SubCatIconFile": subCatIconUrl,
        "SubCatDescEn": subCatDescEn,
        "SubCatDescBm": subCatDescBm,
      };
}
