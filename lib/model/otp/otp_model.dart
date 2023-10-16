class OtpDTO {
  OtpDTO(
      {this.usrIC,
      this.usrPhone,
      this.status,
      this.message,
      this.errcode,
      this.refCode,
      this.otpcode,
      this.success});

  String? status;
  String? message;
  String? errcode;
  bool? success;
  int? otpcode;
  String? usrIC;
  String? usrPhone;
  String? refCode;

  OtpDTO.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    json['Msg'] != null ? message = json['Msg'] : message = json['message'];

    success = json['success'];
    errcode = json['errCode'];
    usrIC = json["UsrIC"];
    usrPhone = json["UsrPhone"];
    otpcode = json["OTPCode"];
    refCode = json["RefCode"];
  }

  // Map<String, dynamic> toJson() => {
  //       "UsrIC": usrIC,
  //       "UsrPhone": usrPhone,

  //     };
}
