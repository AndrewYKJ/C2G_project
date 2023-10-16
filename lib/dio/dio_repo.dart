import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/controller/landing.dart';
import 'package:jpan_flutter/controller/splash_screen.dart';

import '../cache/appcache.dart';
import 'interceptor/logging.dart';

class DioRepo {
  late Dio mDio;
  int retryCount = 0;
  late BuildContext dioContext;

  static String testHost =
      "https://dgdportalcf2018.zuma.com.my/rest/dgdsvrapi/dgdsvrAPI/";

  static String production = "https://epp.sabah.gov.my/rest/dgdsvrapi/dgdsvrAPI/";

  Dio baseConfig() {
    Dio dio = Dio();

    dio.options.baseUrl = production;
    dio.options.connectTimeout = 30000;
    dio.options.receiveTimeout = 30000;
    dio.httpClientAdapter;

    return dio;
  }

  DioRepo() {
    mDio = baseConfig();
    mDio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          mDio.interceptors.requestLock.lock();
          AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF).then((value) {
            if (value.length > 0) {
              options.headers[HttpHeaders.authorizationHeader] = value;
            }
          }).whenComplete(() {
            mDio.interceptors.requestLock.unlock();
          });
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          showErrorDialog("Error", "An error occurred");
          return handler.next(e);
        },
        onResponse: (response, handler) {
          if (response.data is List<int>) {
            return handler.next(response);
          } else if (response.data['errcode'].toString().contains('no-token')) {
            // handler.next(response);
            print(response.data);
            refreshTokenAndRetry(response.requestOptions, handler);
          } else {
            // if (response.data['Status']
            //     .toString()
            //     .toLowerCase()
            //     .contains('fail')) {
            //   if (EasyLoading.isShow) {
            //     EasyLoading.dismiss();
            //   }
            //   showErrorDialog("Error", response.data["Msg"].toString());
            // }
            // print('67534565346346345634563463456346456');
            return handler.next(response);
          }
        },
      ),
      LoggingInterceptors()
    ]);
  }
  Future<void> refreshTokenAndRetry(
      RequestOptions requestOptions, ResponseInterceptorHandler handler) async {
    bool isError = false;
    Dio tokenDio = baseConfig();
    // tokenDio..interceptors.add(LoggingInterceptors());
    var params = {
      "UsrID": Constants.agmoID,
      "UsrPass": Constants.agmoPW,
    };
    try {
      print("!@#@#!@##!@@#!@#!#!@#@!#@! -->>>Get new Token <<<----");
      tokenDio.post('GenToken', data: params).then((res) {
        print(res.data);
        if (res.data['success'] is bool && !res.data['success']) {
          if (retryCount < 3) {
            return refreshTokenAndRetry(requestOptions, handler);
          } else {
            showAlertDialog("Error", "An error occurred");
          }
          retryCount++;
        } else {
          AppCache.removeAuthToken();

          AppCache.setString(AppCache.ACCESS_TOKEN_PREF, res.data['token']);
          mDio.fetch(requestOptions).then((r) {
            //   print('@###@#@#@##@#@#@#@#@#@#@#@');
            handler.next(r);
          });
        }
      }).catchError((error) {
        print("Refresh Token Catch Error : ${error.message}");
        isError = true;

        showAlertDialog("Error", "An error occurred");
      }).whenComplete(() {});
      // return;
    } on DioError catch (e) {
      print("Refresh Token Error : ${e.message}");
      showAlertDialog("Error", "An error occurred");
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: dioContext,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () {
              Navigator.pop(dioContext);
              // AppCache.removeAuthToken();

              // Navigator.pushAndRemoveUntil(
              //     dioContext,
              //     MaterialPageRoute(builder: (context) => LandingScreen()),
              //     (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: dioContext,
      barrierDismissible: false,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () {
              AppCache.removeAuthToken();
              AppCache.removeValues('usrRef');
              AppCache.removeValues('usrIC');
              AppCache.removeValues('fcm');
              Navigator.pushAndRemoveUntil(
                  dioContext,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
