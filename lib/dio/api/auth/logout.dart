import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/user_model.dart';

import '../../dio_repo.dart';

class LogOutApi extends DioRepo {
  LogOutApi(BuildContext context) {
    dioContext = context;
  }

  Future<UserDTO> signOut(
    String ic,
    String usrRef,

//       String gender, String mobileNo, String name, String icNo
  ) async {
    var params = {"UsrID": Constants.agmoID, "PublicIC": ic, "UsrRef": usrRef};

    Utils.printInfo(">>> Logout  : " + params.toString());
    try {
      Response response = await mDio.post("logoutPortal", data: params);
      if (response.data['Status'] == 'Success') {
        Utils.printInfo('LogOut Success');
      }
      return UserDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
