import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';

import '../../../model/district/district_model.dart';
import '../../dio_repo.dart';

class GetDistrict extends DioRepo {
  GetDistrict(BuildContext context) {
    dioContext = context;
  }

  Future<GetDistrictDTO> getDist() async {
    var params = {
      "UsrID": Constants.agmoID,
      "UsrIC": Constants.agmoID,
      "DisCode": "",
      "DisDesc": ""
    };
    try {
      Response response = await mDio.post('GetDist3', data: params);
      GetDistrictDTO data = GetDistrictDTO.fromJson(response.data);

      return data;
    } catch (e) {
      throw e;
    }
  }
}
