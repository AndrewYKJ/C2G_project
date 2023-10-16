// To parse this JSON data, do
//
//     final FeedBackDTO = FeedBackDTOFromJson(jsonString);

import 'dart:convert';

class FeedBackDTO {
  FeedBackDTO({this.msg, this.status, this.errcode, this.data, this.caseID});

  String? msg;
  String? status;
  String? errcode;
  String? caseID;
  List<FeedBackDataDTO>? data;

  factory FeedBackDTO.fromRawJson(String str) =>
      FeedBackDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  // if (value.data != null) {
  //           list = (jsonDecode(value.data!) as List)
  //               .map((e) => DistrictDataDTO.fromJson(e))
  //               .toList();
  //         }
  FeedBackDTO.fromJson(Map<String, dynamic> json) {
    msg = json["Msg"];
    status = json["Status"];
    errcode = json["errCode"];
    caseID = json["CaseID"];
    if (json["data"] != null) {
      data = (jsonDecode(json["data"]) as List)
          .map((e) => FeedBackDataDTO.fromJson(e))
          .toList();
    } else {
      data = [];
    }
    // data = json["data"] != null
    //     ? []
    //     : List<FeedBackDataDTO>.from(
    //         json["data"]!.map((x) => FeedBackDataDTO.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "Msg": msg,
        "Status": status,
        "errcode": errcode,
        "CaseID": caseID,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FeedBackDataDTO {
  FeedBackDataDTO({
    this.catSubDescBm,
    this.status,
    this.caseId,
    this.disDesc,
    this.catDescEng,
    this.longtitude,
    this.remarks,
    this.catCode,
    this.subCatCode,
    this.latitude,
    this.catSubDescEng,
    this.catDescBm,
    this.timeLine,
  });

  String? catSubDescBm;
  String? status;
  String? caseId;
  String? disDesc;
  String? catCode;
  String? subCatCode;
  String? catDescEng;
  double? longtitude;
  String? remarks;
  double? latitude;
  String? catSubDescEng;
  String? catDescBm;
  String? timeLine;

  factory FeedBackDataDTO.fromRawJson(String str) =>
      FeedBackDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedBackDataDTO.fromJson(Map<String, dynamic> json) =>
      FeedBackDataDTO(
        catSubDescBm: json["CatSubDescBm"],
        status: json["Status"],
        caseId: json["CaseID"],
        disDesc: json["DisDesc"],
        catDescEng: json["CatDescEng"],
        catCode: json["CatCode"],
        subCatCode: json["CatSubCode"],
        longtitude: json["Longtitude"]?.toDouble(),
        remarks: json["Remarks"],
        latitude: json["Latitude"]?.toDouble(),
        catSubDescEng: json["CatSubDescEng"],
        catDescBm: json["CatDescBm"],
        timeLine: json["TimeLine"],
      );

  Map<String, dynamic> toJson() => {
        "CatSubDescBm": catSubDescBm,
        "Status": status,
        "CaseID": caseId,
        "DisDesc": disDesc,
        "CatDescEng": catDescEng,
        "Longtitude": longtitude,
        "Remarks": remarks,
        "Latitude": latitude,
        "CatSubDescEng": catSubDescEng,
        "CatDescBm": catDescBm,
        "TimeLine": timeLine,
      };
}
