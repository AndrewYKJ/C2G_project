class GetDistrictDTO {
  GetDistrictDTO({
    this.message,
    this.success,
    this.msg,
    this.status,
    this.data,
    this.errCode,
  });

  String? message;
  bool? success;
  String? msg;
  String? status;
  String? data;
  String? errCode;

  factory GetDistrictDTO.fromJson(Map<String, dynamic> json) => GetDistrictDTO(
      message: json["message"],
      success: json["success"],
      msg: json["Msg"],
      status: json["Status"],
      data: json["data"],
      errCode: json["errCode"]);

  Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "Msg": msg,
        "Status": status,
        "data": data,
        "errCode": errCode
      };
}

// class GetDistrictDTO {
//   GetDistrictDTO({
//     this.message,
//     this.success,
//     this.msg,
//     this.status,
//     this.data,
//   });

//   String? message;
//   bool? success;
//   String? msg;
//   String? status;
//   List<DistrictDataDTO>? data;

//   factory GetDistrictDTO.fromJson(Map<String, dynamic> json) => GetDistrictDTO(
//         message: json["message"],
//         success: json["success"],
//         msg: json["Msg"],
//         status: json["Status"],
//         data: json["data"] == null
//             ? []
//             : List<DistrictDataDTO>.from(
//                 json["data"]!.map((x) => DistrictDataDTO.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "success": success,
//         "Msg": msg,
//         "Status": status,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }

class DistrictDataDTO {
  DistrictDataDTO({
    this.distCode,
    this.distDesc,
  });

  String? distCode;
  String? distDesc;

  factory DistrictDataDTO.fromJson(Map<String, dynamic> json) =>
      DistrictDataDTO(
        distCode: json["DistCode"],
        distDesc: json["DistDesc"],
      );

  Map<String, dynamic> toJson() => {
        "DistCode": distCode,
        "DistDesc": distDesc,
      };
}
