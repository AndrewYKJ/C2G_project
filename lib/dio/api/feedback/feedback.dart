import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/feedback/feedback_comment_model.dart';
import 'package:jpan_flutter/model/feedback/feedback_model.dart';
import 'package:jpan_flutter/model/feedback/feedback_timeline_model.dart';
import 'package:mime/mime.dart';
import '../../dio_repo.dart';
import 'package:image/image.dart' as img;

class FeedBackApi extends DioRepo {
  FeedBackApi(BuildContext context) {
    dioContext = context;
  }

  Future<FeedBackDTO> submitFeedback(
      String userIC,
      String catCode,
      String catSubCode,
      String catDescBm,
      String catDescEng,
      String catSubDescBm,
      String catSubDescEng,
      String disCode,
      String disDesc,
      String latitude,
      String longtitude,
      String remarks) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "CatCode": catCode,
      "CatSubCode": catSubCode,
      "CatDescBm": catDescBm,
      "CatDescEng": catDescEng,
      "CatSubDescBm": catSubDescBm,
      "CatSubDescEng": catSubDescEng,
      "DisCode": disCode,
      "DisDesc": disDesc,
      "Latitude": latitude,
      "Longitute": longtitude,
      "feedRemarks": remarks
    };

    try {
      Response response = await mDio.post('addFbSub', data: params);
      FeedBackDTO data = FeedBackDTO.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedBackDTO> submitFeedbackPhoto(
    String userIC,
    String caseID,
    File photo,
  ) async {
    var resizedImg = await resizeImg(photo);
    try {
      Response response = await mDio.post(
        'addFbSubPhoto/$caseID/${Constants.agmoID}/$userIC',
        data: Stream.fromIterable(img.encodeJpg(resizedImg!).map((e) => [e])),
        // Stream.fromIterable(resizedImg.readAsBytesSync().map((e) => [e])),
        options: Options(
          headers: {
            'Content-Type': lookupMimeType(photo.path),
            'Accept': "*/*",
            'Content-Length': img.encodeJpg(resizedImg).length,
            'Connection': 'keep-alive',
          },
        ),
      );

      FeedBackDTO data = FeedBackDTO.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<img.Image?> resizeImg(File fImg) async {
    var image = img.decodeImage(fImg.readAsBytesSync());
    // final img.Image orientedImage = img.bakeOrientation(image);
    if (image != null) {
      if (image.width > image.height) {
        //image is landscape
        if (image.width > 800) {
          image = img.copyResize(image, width: 800);
        }
      } else if (image.height > image.width) {
        //image is portrait
        if (image.height > 800) {
          image = img.copyResize(image, width: 0, height: 800);
        }
      } else if (image.width == image.height) {
        //image is square
        if (image.width > 800) {
          image = img.copyResize(image, width: 800);
        }
      }
    }

    return image;
  }

  Future<FeedBackDTO> getFeedbackList(
    String userIC,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
    };

    try {
      Response response = await mDio.post('getFbListing', data: params);
      FeedBackDTO data = FeedBackDTO.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedBackDTO> getFeedbackDetails(
    String userIC,
    String caseID,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "CaseID": caseID
    };
    try {
      Response response = await mDio.post('getFbDtl', data: params);
      FeedBackDTO data = FeedBackDTO.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getFeedbackDetailsPhoto(
    String userIC,
    String caseID,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "CaseID": caseID
    };

    try {
      Response response = await mDio.get(
        'getFbPht',
        queryParameters: params,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Content-Type': 'application/json',
            'Accept': "*/*",
            'Connection': 'keep-alive',
          },
        ),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedbackTimelineDTO> getFeedbackTimeline(
    String userIC,
    String caseID,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "CaseID": caseID
    };

    try {
      Response response = await mDio.post(
        'getFbTskList',
        data: params,
      );
      FeedbackTimelineDTO data = FeedbackTimelineDTO.fromJson(response.data);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedbackCommentDTO> getFeedbackTaskComment(
    String userIC,
    String taskID,
  ) async {
    var params = {
      "UsrID": Constants.agmoID,
      "PublicIC": userIC,
      "TaskID": taskID
    };

    try {
      Response response = await mDio.post(
        'getFbTskComList',
        data: params,
      );
      FeedbackCommentDTO data = FeedbackCommentDTO.fromJson(response.data);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
