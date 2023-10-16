import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/reponse.dart';

import '../../dio_repo.dart';

class ResetPWDApi extends DioRepo {
  ResetPWDApi(BuildContext context) {
    dioContext = context;
  }

  Future<ResponseStatusDTO> resetPWD(
    String email,
    String ic,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": ic, 
      "PublicEmail": email 
    };
    try {
      Response response = await mDio.post("rstPwdPortal", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Reset Password Success');
      }
      return ResponseStatusDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseStatusDTO> changePWD(
    String password,
    String confirmPasssord,
    String usrRef,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "Password": password,
      "ConfirmPassword": confirmPasssord,
      "UsrRef": usrRef,
    };
    try {
      Response response = await mDio.post("resPwd", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Reset Password Success');
      }
      return ResponseStatusDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
