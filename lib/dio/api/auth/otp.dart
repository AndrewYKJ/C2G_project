import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/reponse.dart';

import '../../../model/district/district_model.dart';
import '../../../model/otp/otp_model.dart';
import '../../dio_repo.dart';

class OtpApi extends DioRepo {
  OtpApi(BuildContext context) {
    dioContext = context;
  }

  Future<OtpDTO> generateOtp(
    String userIC,
    String userPhone,
//       String gender, String mobileNo, String name, String icNo
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "UsrIC": userIC,
      "UsrPhone": userPhone,
      "UsrOType": Constants.usr0TypePrefix,
      "UsrSys": Constants.usrSysPrefix,
    };

    Utils.printInfo(">>> Generate OTP : " + params.toString());
    try {
      Response response = await mDio.post("genOTP", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Generate OTP SUCCESS');
      }
      return OtpDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<OtpDTO> validateOtp(
    String otpCode,
    String refCode,
//       String gender, String mobileNo, String name, String icNo
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "RefCode": refCode,
      "OTPCode": otpCode,
      "UsrOType": Constants.usr0TypePrefix,
      "UsrSys": Constants.usrSysPrefix,
    };

    Utils.printInfo(">>> Validate OTP : " + params.toString());
    try {
      Response response = await mDio.post("valOTP", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Validate OTP SUCCESS');
      }
      return OtpDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
