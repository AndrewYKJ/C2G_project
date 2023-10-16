// To parse this JSON data, do
//
//     final FeedbackCommentDTO = FeedbackCommentDTOFromJson(jsonString);

import 'dart:convert';

class FeedbackCommentDTO {
  FeedbackCommentDTO({
    this.msg,
    this.status,
    this.errcode,
    this.data,
  });

  String? msg;
  String? status;
  String? errcode;
  List<FeedbackCommentDataDTO>? data;

  factory FeedbackCommentDTO.fromRawJson(String str) =>
      FeedbackCommentDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  FeedbackCommentDTO.fromJson(Map<String, dynamic> json) {
    msg = json["Msg"];
    status = json["Status"];
    errcode = json["errCode"];
    if (json["data"] != null) {
      data = (jsonDecode(json["data"]) as List)
          .map((e) => FeedbackCommentDataDTO.fromJson(e))
          .toList();
    } else {
      data = [];
    }
  }

  Map<String, dynamic> toJson() => {
        "Msg": msg,
        "Status": status,
        "errCode": errcode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class FeedbackCommentDataDTO {
  FeedbackCommentDataDTO({
    this.comId,
    this.remarks,
    this.timeLine,
  });

  String? comId;
  String? remarks;
  String? timeLine;

  factory FeedbackCommentDataDTO.fromRawJson(String str) =>
      FeedbackCommentDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackCommentDataDTO.fromJson(Map<String, dynamic> json) =>
      FeedbackCommentDataDTO(
        comId: json["ComID"],
        remarks: json["Remarks"],
        timeLine: json["TimeLine"],
      );

  Map<String, dynamic> toJson() => {
        "ComID": comId,
        "Remarks": remarks,
        "TimeLine": timeLine,
      };
}
