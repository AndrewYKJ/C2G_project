import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/reponse.dart';

import '../../dio_repo.dart';

class RegisterApi extends DioRepo {
  RegisterApi(BuildContext context) {
    dioContext = context;
  }

  Future<ResponseStatusDTO> onRegister(String email, String password,
      String gender, String mobileNo, String name, String icNo) async {
    var params = {
      "UsrID": Constants.agmoID,
      "Password": password,
      "UserMyKadNo": icNo,
      "UserName": name,
      "UserEmail": email,
      "UserPhoneNo": mobileNo,
      "Gender": gender
    };

    try {
      Response response = await mDio.post("regInd", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Register UP SUCCESS');
      }
      return ResponseStatusDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
