// To parse this JSON data, do
//
//     final SubCatRoutingDTO = SubCatRoutingDTOFromJson(jsonString);

import 'dart:convert';

class SubCatRoutingDTO {
  SubCatRoutingDTO({
    this.msg,
    this.status,
    this.errcode,
    this.data,
  });

  String? msg;
  String? status;
  String? errcode;
  List<SubCatRoutingDataDTO>? data;

  factory SubCatRoutingDTO.fromRawJson(String str) =>
      SubCatRoutingDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCatRoutingDTO.fromJson(Map<String, dynamic> json) =>
      SubCatRoutingDTO(
        msg: json["Msg"],
        status: json["Status"],
        errcode: json["errCode"],
        data: json["data"] == null
            ? []
            : List<SubCatRoutingDataDTO>.from(
                json["data"]!.map((x) => SubCatRoutingDataDTO.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Msg": msg,
        "Status": status,
        "errcode": errcode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SubCatRoutingDataDTO {
  SubCatRoutingDataDTO({
    this.disCode,
    this.deptCode,
    this.secCode,
  });

  String? disCode;
  String? deptCode;
  String? secCode;

  factory SubCatRoutingDataDTO.fromRawJson(String str) =>
      SubCatRoutingDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCatRoutingDataDTO.fromJson(Map<String, dynamic> json) =>
      SubCatRoutingDataDTO(
        disCode: json["DisCode"],
        deptCode: json["DeptCode"],
        secCode: json["SecCode"],
      );

  Map<String, dynamic> toJson() => {
        "DisCode": disCode,
        "DeptCode": deptCode,
        "SecCode": secCode,
      };
}
