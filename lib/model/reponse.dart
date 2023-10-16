class ResponseStatusDTO {
  String? status;
  String? message;
  String? errcode;
  bool? success;

  ResponseStatusDTO({this.status, this.message, this.errcode, this.success});

  ResponseStatusDTO.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    json['Msg'] != null ? message = json['Msg'] : message = json['message'];

    success = json['success'];
    errcode = json['errCode'];
  }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['Status'] = status;
  //   data['statusMessage'] = message;
  //   return data;
  // }
}
