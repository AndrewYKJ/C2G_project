import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/utils.dart';

import '../../../cache/appcache.dart';
import '../../dio_repo.dart';

class GenerateTokenApi extends DioRepo {
  GenerateTokenApi(BuildContext context) {
    dioContext = context;
  }

  Future<bool> getToken(String userId, String userPw) async {
    var params = {
      "UsrID": userId,
      "UsrPass": userPw,
    };

    try {
      Response response = await mDio.post('GenToken', data: params);

      if (response.data != null) {
        var accessToken;
        if (response.data['success'] == true) {
          if (response.data['token'] != null) {
            accessToken = response.data['token'];
          }

          AppCache.setAuthToken(accessToken);
        } else {
          Utils.printInfo('Error message: ${response.data['message']}');
        }
      }
      return response.data['success'];
    } catch (e) {
      throw e;
    }
  }
}
