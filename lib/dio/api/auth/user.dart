import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/model/user_model.dart';

import '../../dio_repo.dart';

class UserApi extends DioRepo {
  UserApi(BuildContext context) {
    dioContext = context;
  }

  Future<UserDTO> getUserProfile(
    String ic,
    String usrRef,
  ) async {
    var params = {"UsrID": Constants.agmoID, "PublicIC": ic, "UsrRef": usrRef};

    try {
      Response response = await mDio.post("DGDUsrProf", data: params);
      if (response.data['Status'] == 'Success') {
      }
      AppCache.me = UserDTO.fromJson(response.data);
      return UserDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserDTO> updateUsername(
    String ic,
    String usrRef,
    String newUsrName,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": ic,
      "UsrRef": usrRef,
      "UsrFName": newUsrName
    };

    try {
      Response response = await mDio.post("DGDUpUsrFN", data: params);
      if (response.data['Status'] == 'Success') {
      }
      return UserDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
