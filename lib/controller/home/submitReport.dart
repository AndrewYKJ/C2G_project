import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_button.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/distruct/getDistrict.dart';
import 'package:jpan_flutter/dio/api/feedback/feedback.dart';
import 'package:jpan_flutter/model/district/district_model.dart';
import 'package:jpan_flutter/model/feedback/feedback_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:geolocator/geolocator.dart';

import '../../model/argument/submit_reportArg.dart';

class SubmitReport extends StatefulWidget {
  final SubmitReportArg data;
  const SubmitReport({Key? key, required this.data}) : super(key: key);

  @override
  State<SubmitReport> createState() => _SubmitReportState();
}

class _SubmitReportState extends State<SubmitReport>
    with WidgetsBindingObserver {
  bool submitButtonActive = false;
  bool isfalse = false;
  final remarkController = TextEditingController();
  String? _selectedDistrict;
  List<DistrictDataDTO> districtList = [DistrictDataDTO(distDesc: '-Select-')];
  var imageFiles;
  Position? currentLocation;
  String? caseID;
  final picker = ImagePicker();
  File? imgFile;

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      callGPSDialog();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          EasyLoading.dismiss();
          isfalse = false;
        });
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!isfalse) {
        setState(() {
          EasyLoading.dismiss();
          isfalse = true;
          callLocationDialog();
        });
      }
    }
    currentLocation = await Geolocator.getCurrentPosition();

    return currentLocation;
  }

  Future<GetDistrictDTO> getDistrict(
      BuildContext context, String ic, String usrRef) async {
    GetDistrict districtApi = GetDistrict(context);
    return districtApi.getDist();
  }

  Future<FeedBackDTO> submitFeedback(
      BuildContext context,
      String ic,
      String catCode,
      String catSubCode,
      String catDescBm,
      String catDescEng,
      String catSubDescBm,
      String catSubDescEng,
      String disCode,
      String disDesc,
      String lat,
      String long,
      String remarks) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.submitFeedback(
        ic,
        catCode,
        catSubCode,
        catDescBm,
        catDescEng,
        catSubDescBm,
        catSubDescEng,
        disCode,
        disDesc,
        lat,
        long,
        remarks);
  }

  Future<FeedBackDTO> submitPhoto(
    BuildContext context,
    String ic,
    var photoByte,
  ) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.submitFeedbackPhoto(ic, caseID!, photoByte);
  }

  Future getImage(source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        imageFiles = await pickedFile.readAsBytes();
        imgFile = File(pickedFile.path);
      }
      setState(() {
        if (remarkController.text.isNotEmpty &&
            _selectedDistrict != null &&
            imageFiles != null) {
          submitButtonActive = true;
        } else {
          submitButtonActive = false;
        }
      });
    } catch (error) {
      Utils.showAlertDialog(context, 'Error', 'Something went wrong');
      rethrow;
    }
  }

  @override
  void initState() {
    checkText();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.analyticsSubmitReportScreen);

    _determinePosition();
    callDistrictApi(context);
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    remarkController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (!isfalse) {
          _determinePosition();
        }

        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  callDistrictApi(BuildContext ctx) async {
    List<DistrictDataDTO> list = [];
    String errorMsg = '';
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await getDistrict(
            context,
            await AppCache.getStringValue(
              AppCache.USER_IC,
            ),
            AppCache.usrRef!)
        .then(
      (value) {
        EasyLoading.dismiss();
        if (value.status.toString().toLowerCase().contains('fail')) {
          switch (value.errCode) {
            case "900001":
              errorMsg = Utils.getTranslated(ctx, "getDis_api_error_01");
              break;
            case "900002":
              errorMsg = Utils.getTranslated(ctx, "getDis_api_error_02");
              break;
            case "900003":
              errorMsg = Utils.getTranslated(ctx, "getDis_api_error_03");
              break;
            case "900004":
              errorMsg = Utils.getTranslated(ctx, "getDis_api_error_04");
              break;
            default:
              errorMsg = Utils.getTranslated(context, "api_other_error");
              break;
          }
          Utils.showAlertDialog(
              ctx, Utils.getTranslated(ctx, "api_error_tittle"), errorMsg);
        } else {
          if (value.data != null) {
            list = (jsonDecode(value.data!) as List)
                .map((e) => DistrictDataDTO.fromJson(e))
                .toList();
          }
        }
      },
    );
    setState(() {
      districtList = [...districtList, ...list];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget(context),
              districtWidget(context),
              remarkWidget(),
              submitButton(context)
            ],
          ),
        )),
      ),
    );
  }

  Widget remarkWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(Utils.getTranslated(context, "report_details_remark"),
              style: AppFont.helvMed(14, color: AppColors.appSecondaryBlue())),
        ),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.appDisabledGray(),
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(4)),
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: remarkController,
                maxLines: 5,
                style: AppFont.helvMed(14, color: AppColors.appBlack()),
                maxLength: 500,
                decoration: const InputDecoration(
                    counterText: '', border: InputBorder.none),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Image.asset(
                Constants.assetImages + 'text area_icon.png',
                height: 16,
                width: 16,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }

  Widget districtWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(Utils.getTranslated(context, "report_details_district"),
              style: AppFont.helvMed(14, color: AppColors.appSecondaryBlue())),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: InkWell(
            onTap: () {
              districtSelector(context);
            },
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.appDisabledGray(), width: 1)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDistrict ?? districtList[0].distDesc!,
                          style: AppFont.helvMed(14,
                              color: _selectedDistrict != null
                                  ? AppColors.appBlack()
                                  : AppColors.appDisabledGray())),
                      Image.asset(
                        Constants.assetImages + 'down arrow_icon.png',
                        height: 16,
                        width: 16,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> imageSourceSelector(BuildContext context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  child: Text(Utils.getTranslated(context, "report_camera"),
                      style: AppFont.helvBold(16, color: AppColors.appBlack())),
                  onPressed: () async {
                    Navigator.pop(context);
                    await getImage(ImageSource.camera);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(Utils.getTranslated(context, "report_gallery"),
                      style: AppFont.helvBold(16, color: AppColors.appBlack())),
                  onPressed: () async {
                    Navigator.pop(context);
                    await getImage(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }

  Future<dynamic> districtSelector(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                        Utils.getTranslated(context, "report_details_district"),
                        style: AppFont.helvMed(14,
                            color: AppColors.appSecondaryBlue())),
                  ),
                  for (int i = 0; i < districtList.length; i++)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () {
                              i != 0
                                  ? setState(() {
                                      _selectedDistrict =
                                          districtList[i].distDesc!;

                                      if (remarkController.text.isNotEmpty &&
                                          _selectedDistrict != null &&
                                          imageFiles != null) {
                                        submitButtonActive = true;
                                      } else {
                                        submitButtonActive = false;
                                      }
                                      Navigator.pop(context);
                                    })
                                  : null;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                i != 0
                                    ? Text(districtList[i].distDesc!,
                                        style: AppFont.helvMed(14,
                                            color: _selectedDistrict ==
                                                    districtList[i].distDesc
                                                ? AppColors.appPrimaryBlue()
                                                : AppColors.districtGray()))
                                    : Text(districtList[i].distDesc!,
                                        style: AppFont.helvMed(14,
                                            color:
                                                AppColors.appDisabledGray())),
                                _selectedDistrict == districtList[i].distDesc
                                    ? Image.asset(
                                        Constants.assetImages + 'tick_icon.png',
                                        height: 20,
                                        width: 20,
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        const Divider()
                      ],
                    ),
                ],
              ),
            ));
  }

  Column imageWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            Utils.getTranslated(context, "report_upload_image_desc"),
            style: AppFont.helvMed(14, color: AppColors.appBlack()),
          ),
        ),
        Stack(
          children: [
            imageFiles == null
                ? Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8.0),
                    child: DottedBorder(
                      dashPattern: const [8, 4],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      borderType: BorderType.RRect,
                      color: AppColors.appDisabledGray(),
                      radius: const Radius.circular(5),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: InkWell(
                          onTap: () => imageSourceSelector(context),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.appDisabledGray(),
                          ),
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: (() => Navigator.pushNamed(
                        context, AppRoutes.enlargeImageScreenRoute,
                        arguments: imageFiles)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8.0),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.memory(
                            imageFiles,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            imageFiles != null
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      onTap: () => setState(() {
                        imageFiles = null;
                        if (remarkController.text.isNotEmpty &&
                            _selectedDistrict != null &&
                            imageFiles != null) {
                          submitButtonActive = true;
                        } else {
                          submitButtonActive = false;
                        }
                      }),
                      child: Icon(
                        Icons.cancel,
                        color: AppColors.appPrimaryBlue(),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget submitButton(BuildContext ctx) {
    return AppButton(
      onPressed: () async {
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
        submitFeedback(
          ctx,
          await AppCache.getStringValue(
            AppCache.USER_IC,
          ),
          widget.data.catCode!,
          widget.data.subCatCode!,
          widget.data.catDescBm!,
          widget.data.catDescEn!,
          widget.data.subCatDescBm!,
          widget.data.subCatDescEn!,
          districtList[districtList.indexWhere(
                  (element) => element.distDesc == _selectedDistrict)]
              .distCode!,
          _selectedDistrict!,
          currentLocation != null ? currentLocation!.latitude.toString() : "",
          currentLocation != null ? currentLocation!.longitude.toString() : "",
          remarkController.text,
        ).then((value) async {
          EasyLoading.dismiss();
          if (value.status!.toLowerCase().contains('success')) {
            caseID = value.caseID;
            EasyLoading.show(maskType: EasyLoadingMaskType.black);

            await submitPhoto(
                    ctx,
                    await AppCache.getStringValue(
                      AppCache.USER_IC,
                    ),
                    imgFile!)
                .then((data) {
              if (data.status!.toLowerCase().contains('success')) {
                EasyLoading.dismiss();
                Navigator.pushNamed(
                    ctx, AppRoutes.submitSuccessfullyScreenRoute);
              } else {
                EasyLoading.dismiss();
                String errorMsg = '';

                switch (data.errcode) {
                  case "900002":
                    errorMsg =
                        Utils.getTranslated(context, "missingField_api_error");
                    break;
                  case "900003":
                    errorMsg =
                        Utils.getTranslated(context, "unexpected_api_error");
                    break;
                  case "900004":
                    errorMsg =
                        Utils.getTranslated(context, "accessDenied_api_error");
                    break;
                  case "900005":
                    errorMsg = Utils.getTranslated(
                        context, "attachmentFailed_api_error");
                    break;

                  default:
                    errorMsg = Utils.getTranslated(context, "api_other_error");
                    break;
                }
                Utils.showAlertDialog(context,
                    Utils.getTranslated(context, "api_error_tittle"), errorMsg);
              }
            });
          } else {
            String errorMsg = '';

            switch (value.errcode) {
              case "900002":
                errorMsg =
                    Utils.getTranslated(context, "missingField_api_error");
                break;
              case "900003":
                errorMsg = Utils.getTranslated(context, "unexpected_api_error");
                break;
              case "900004":
                errorMsg =
                    Utils.getTranslated(context, "accessDenied_api_error");
                break;
              case "900005":
                errorMsg =
                    Utils.getTranslated(context, "recordFailCreate_api_error");
                break;

              default:
                errorMsg = Utils.getTranslated(context, "api_other_error");
                break;
            }
            Utils.showAlertDialog(context,
                Utils.getTranslated(context, "api_error_tittle"), errorMsg);
          }
        });
      },
      isDisabled: submitButtonActive,
      isGradient: true,
      text: Utils.getTranslated(context, "btn_submit"),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        AppCache.language == "en"
            ? widget.data.subCatDescEn!
            : widget.data.subCatDescBm!,
        style: AppFont.helvBold(18, color: AppColors.appBlack()),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 11),
              child: Image.asset(Constants.assetImages + 'left arrow_icon.png'),
            ),
            Text(
              Utils.getTranslated(context, "back_text"),
              style: AppFont.helvBold(14, color: AppColors.appPrimaryBlue()),
            )
          ],
        ),
      ),
      leadingWidth: 80,
    );
  }

  checkText() {
    remarkController.addListener(() {
      if (remarkController.text.isNotEmpty &&
          _selectedDistrict != null &&
          imageFiles != null) {
        setState(() {
          submitButtonActive = true;
        });
      } else {
        setState(() {
          submitButtonActive = false;
        });
      }
    });
  }

  callLocationDialog() {
    if (Platform.isAndroid) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  Utils.getTranslated(context, 'get_location_dialog_title'),
                  style: AppFont.helvBold(18,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                content: Text(
                  Utils.getTranslated(context, 'get_location_dialog_subtitle'),
                  textAlign: TextAlign.center,
                  style: AppFont.helvMed(14,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfalse = false;
                      });
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((value) => Geolocator.openAppSettings());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(context, 'report_settings'),
                        style: AppFont.helvBold(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop(false);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            CupertinoAlertDialog(
                          title: Text(Utils.getTranslated(
                              context, 'get_location_error')),
                          content: Text(Utils.getTranslated(
                              context, 'get_location_suberror')),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(
                            context, 'alert_dialog_cancel_text'),
                        style: AppFont.helvMed(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ));
    } else {
      showCupertinoDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) => CupertinoAlertDialog(
                title: Text(
                  Utils.getTranslated(context, 'get_location_dialog_title'),
                  style: AppFont.helvBold(18,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                content: Text(
                  Utils.getTranslated(context, 'get_location_dialog_subtitle'),
                  textAlign: TextAlign.center,
                  style: AppFont.helvMed(14,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfalse = false;
                      });
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((value) => Geolocator.openAppSettings());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(context, 'report_settings'),
                        style: AppFont.helvBold(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop(false);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            CupertinoAlertDialog(
                          title: Text(Utils.getTranslated(
                              context, 'get_location_error')),
                          content: Text(Utils.getTranslated(
                              context, 'get_location_suberror')),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(
                            context, 'alert_dialog_cancel_text'),
                        style: AppFont.helvMed(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ));
    }
  }

  callGPSDialog() {
    if (Platform.isAndroid) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  Utils.getTranslated(context, 'get_gps_dialog_title'),
                  style: AppFont.helvBold(18,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                content: Text(
                  Utils.getTranslated(context, 'get_gps_dialog_subtitle'),
                  textAlign: TextAlign.center,
                  style: AppFont.helvMed(14,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfalse = false;
                      });
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((value) => Geolocator.openLocationSettings());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(context, 'report_settings'),
                        style: AppFont.helvBold(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop(false);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            CupertinoAlertDialog(
                          title: Text(Utils.getTranslated(
                              context, 'get_location_error')),
                          content: Text(Utils.getTranslated(
                              context, 'get_location_suberror')),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(
                            context, 'alert_dialog_cancel_text'),
                        style: AppFont.helvMed(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ));
    } else {
      showCupertinoDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) => CupertinoAlertDialog(
                title: Text(
                  Utils.getTranslated(context, 'get_gps_dialog_title'),
                  style: AppFont.helvBold(18,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                content: Text(
                  Utils.getTranslated(context, 'get_gps_dialog_subtitle'),
                  textAlign: TextAlign.center,
                  style: AppFont.helvMed(14,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfalse = false;
                      });
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500))
                          .then((value) => Geolocator.openLocationSettings());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(context, 'report_settings'),
                        style: AppFont.helvBold(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(dialogContext).pop(false);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext dialogContext) =>
                            CupertinoAlertDialog(
                          title: Text(Utils.getTranslated(
                              context, 'get_location_error')),
                          content: Text(Utils.getTranslated(
                              context, 'get_location_suberror')),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        Utils.getTranslated(
                            context, 'alert_dialog_cancel_text'),
                        style: AppFont.helvMed(16,
                            color: AppColors.appPrimaryBlue(),
                            decoration: TextDecoration.none),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ));
    }
  }
}
