import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/category/category_model.dart';
import 'package:jpan_flutter/model/category/subcategory_model.dart';

import '../../../model/district/district_model.dart';
import '../../dio_repo.dart';

class GetCategory extends DioRepo {
  GetCategory(BuildContext context) {
    dioContext = context;
  }

  Future<CategoryDTO> getCategory(
    String userIC,
    String genInc,
    String floodWrn,
    String sos,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "GeneralInc": genInc,
      "FloodWrn": floodWrn,
      "SOS": sos
    };

    try {
      Response response = await mDio.post('getFbCat2', data: params);
      CategoryDTO data = CategoryDTO.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<SubCategoryDTO> getSubCategory(
    String userIC,
    String catCode,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "CatCode": catCode,
    };

    try {
      Response response = await mDio.post('getFbSbCat', data: params);
      SubCategoryDTO data = SubCategoryDTO.fromJson(response.data);

      return data;
    } catch (e) {
      throw e;
    }
  }

  Future<CategoryDTO> getSubCategoryRouting(
    String userIC,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
    };

    try {
      Response response = await mDio.post('getFbCat', data: params);
      CategoryDTO data = CategoryDTO.fromJson(response.data);

      return data;
    } catch (e) {
      throw e;
    }
  }
}
