import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/user_model.dart';

import '../../dio_repo.dart';

class LoginApi extends DioRepo {
  LoginApi(BuildContext context) {
    dioContext = context;
  }

  Future<UserDTO> login(
    String pwd,
    String ic,
    String fcmToken,

//       String gender, String mobileNo, String name, String icNo
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": ic,
      "PublicPwd": pwd,
      "Fbtoken": fcmToken,
    };

    Utils.printInfo(">>> Login : " + params.toString());
    try {
      Response response = await mDio.post("logPortal", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('Login Success');
        await AppCache.setString('usrIC', ic);
        await AppCache.setString(
            'usrRef', UserDTO.fromJson(response.data).usrRef!);
        AppCache.usrRef = UserDTO.fromJson(response.data).usrRef;
      }
      return UserDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
