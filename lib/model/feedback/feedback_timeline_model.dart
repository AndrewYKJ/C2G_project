// To parse this JSON data, do
//
//     final FeedbackTimelineDTO = FeedbackTimelineDTOFromJson(jsonString);

import 'dart:convert';

class FeedbackTimelineDTO {
  FeedbackTimelineDTO({
    this.msg,
    this.status,
    this.errcode,
    this.data,
  });

  String? msg;
  String? status;
  String? errcode;
  List<FeedbackTimelineDataDTO>? data;

  factory FeedbackTimelineDTO.fromRawJson(String str) =>
      FeedbackTimelineDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  FeedbackTimelineDTO.fromJson(Map<String, dynamic> json) {
    msg = json["Msg"];
    status = json["Status"];
    errcode = json["errCode"];
    if (json["data"] != null) {
      data = (jsonDecode(json["data"]) as List)
          .map((e) => FeedbackTimelineDataDTO.fromJson(e))
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

class FeedbackTimelineDataDTO {
  FeedbackTimelineDataDTO({
    this.taskId,
    this.secDesc,
    this.disDesc,
    this.deptDesc,
    this.timeLine,
  });

  String? taskId;
  String? secDesc;
  String? disDesc;
  String? deptDesc;
  String? timeLine;

  factory FeedbackTimelineDataDTO.fromRawJson(String str) =>
      FeedbackTimelineDataDTO.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackTimelineDataDTO.fromJson(Map<String, dynamic> json) =>
      FeedbackTimelineDataDTO(
        taskId: json["TaskID"],
        secDesc: json["SecDesc"],
        disDesc: json["DisDesc"],
        deptDesc: json["DeptDesc"],
        timeLine: json["TimeLine"],
      );

  Map<String, dynamic> toJson() => {
        "TaskID": taskId,
        "SecDesc": secDesc,
        "DisDesc": disDesc,
        "DeptDesc": deptDesc,
        "TimeLine": timeLine,
      };
}
