import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_card.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/argument/submit_reportArg.dart';
import 'package:jpan_flutter/model/card_model.dart';
import 'package:jpan_flutter/model/category/category_code_color_model.dart';
import 'package:jpan_flutter/model/category/category_model.dart';
import 'package:jpan_flutter/model/enum/routeenum.dart';
import 'package:jpan_flutter/model/feedback/feedback_model.dart';
import 'package:jpan_flutter/model/user_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../const/app_font.dart';
import '../../dio/api/category/getCategory.dart';
import '../../dio/api/feedback/feedback.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  bool isLoading = true;
  List<ReportModel> history = [];
  List<CategoryCodeModel> colorCode = [];
  Future<FeedBackDTO> getFeedbackList(
    BuildContext context,
  ) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.getFeedbackList(await AppCache.getStringValue(
      AppCache.USER_IC,
    ));
  }

  Future<CategoryDTO> getCategory(BuildContext context, String ic,
      String genInc, String floodWrn, String sos) async {
    GetCategory getSubCat = GetCategory(context);
    return getSubCat.getCategory(ic, genInc, floodWrn, sos);
  }

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsHomeScreen);
    AppCache.catCodeCache != null ? getHistory() : getDetails();
    super.initState();
  }

  getDetails() async {
    Color? catColor;
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    for (var i = 0; i < 3;) {
      String errorMsg = '';
      String genInc = "";
      String floodWrn = "";
      String sos = "";
      switch (i) {
        case 0:
          genInc = "Y";
          catColor = AppColors.bluetagText();
          break;
        case 1:
          floodWrn = "Y";
          catColor = AppColors.pupletagText();
          break;
        case 2:
          sos = "Y";
          catColor = AppColors.redtagText();
          break;
        default:
          genInc = "Y";
          catColor = AppColors.bluetagText();
      }

      await getCategory(
              context,
              await AppCache.getStringValue(
                AppCache.USER_IC,
              ),
              genInc,
              floodWrn,
              sos)
          .then((value) {
        if (value.status.toString().toLowerCase().contains('fail')) {
          if (value.errcode != '900002') {
            switch (value.errcode) {
              case "900001":
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

              default:
                errorMsg = Utils.getTranslated(context, "api_other_error");
                break;
            }
            Utils.showAlertDialog(context,
                Utils.getTranslated(context, "api_error_tittle"), errorMsg);
          }
        } else {
          if (value.data != null) {
            List<String> itemCode = [];
            (jsonDecode(value.data!) as List)
                .map((e) => CategoryDataDTO.fromJson(e))
                .forEach((element) {
              itemCode.add(element.catCode!);
            });

            colorCode.add(
                CategoryCodeModel(colorCode: catColor, codeList: itemCode));
          }
        }
      }).whenComplete(() {
        i++;
      }).catchError((error, stackTrace) {
        throw error;
      });
    }

    AppCache.catCodeCache = colorCode;
    setState(() {});
    getHistory();
  }

  getHistory() async {
    if (!EasyLoading.isShow) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
    }
    String errorMsg = '';
    await getFeedbackList(context).then((data) async {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }

      if (data.status.toString().toLowerCase().contains('fail') &&
          data.errcode != '900005') {
        switch (data.errcode) {
          case "900002":
            errorMsg = Utils.getTranslated(context, "missingField_api_error");
            break;
          case "900003":
            errorMsg = Utils.getTranslated(context, "unexpected_api_error");
            break;
          case "900004":
            errorMsg = Utils.getTranslated(context, "accessDenied_api_error");
            break;
          case "900005":
            errorMsg = Utils.getTranslated(context, "recordNotFound_api_error");
            break;

          default:
            errorMsg = Utils.getTranslated(context, "api_other_error");
            break;
        }
        Utils.showAlertDialog(context,
            Utils.getTranslated(context, "api_error_tittle"), errorMsg);
      } else {
        if (data.data != null) {
          List<FeedBackDataDTO> value = data.data!.toList();
          value.sort((a, b) {
            return DateFormat('MMMM, dd yyyy HH:mm:ss')
                .parse(b.timeLine!)
                .compareTo(
                    DateFormat('MMMM, dd yyyy HH:mm:ss').parse(a.timeLine!));
          });

          for (var element = 0; element < value.length; element++) {
            if (element < 3 && element < value.length) {
              history.add(ReportModel(
                  id: value[element].caseId,
                  updatedDate: value[element].timeLine,
                  currentStatus: value[element].status,
                  district: value[element].disDesc,
                  remark: value[element].remarks,
                  catCode: value[element].catCode,
                  subCatCode: value[element].subCatCode,
                  type: AppCache.language != "en"
                      ? value[element].catDescBm
                      : value[element].catDescEng,
                  subCat: AppCache.language != "en"
                      ? value[element].catSubDescBm
                      : value[element].catSubDescEng,
                  status: [],
                  sender: User(
                      ic: await AppCache.getStringValue(
                        AppCache.USER_IC,
                      ),
                      name: AppCache.me.data![0].usrFName,
                      mobileNo: AppCache.me.data![0].usrContactNo)));
              continue;
            }
            break;
          }
        }
      }
    }).whenComplete(() {
      getName();
      isLoading = false;
      setState(() {});
    });
  }

  getName() async {
    setState(() {
      name = AppCache.me.data!.first.usrFName!;
    });
  }

  _refreshData(BuildContext context) async {
    history = [];
    setState(() {
      isLoading = true;
    });
    getDetails();
    setState(() {
      isLoading = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center()
        : SafeArea(
            child: RefreshIndicator(
            displacement: MediaQuery.of(context).size.height / 2.5,
            onRefresh: () {
              return _refreshData(context);
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height + 200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    reportIncidentRoute(context),
                    recentReport()
                  ],
                ),
              ),
            ),
          ));
  }

  Widget recentReport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 16),
          child: Text(
            Utils.getTranslated(context, "home_lastest_submitted_report"),
            style: AppFont.helvBold(16,
                color: AppColors.appBlack(), decoration: TextDecoration.none),
          ),
        ),
        history.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: history
                    .map((e) => HistoryItem(
                          history: e,
                        ))
                    .toList())
            : emptyList()
      ],
    );
  }

  Widget emptyList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Text(
          Utils.getTranslated(context, "empty_list"),
          style: AppFont.helvBold(14,
              color: AppColors.appBlack30(), decoration: TextDecoration.none),
        ),
      ),
    );
  }

  Widget reportIncidentRoute(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: [
        InkWell(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.incidentTypeScreenRoute,
                  arguments: SubmitReportArg(
                    from: "general",
                  )),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.bluetagBackground(),
                borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(Constants.assetImages +
                      imagesIcon[IncidentType.general]!),
                ),
                Text(
                  Utils.getTranslated(context,
                      incidentTypeName[IncidentType.general]!.toLowerCase()),
                  style: AppFont.helvBold(16,
                      color: AppColors.appWhite(),
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.incidentTypeScreenRoute,
                  arguments: SubmitReportArg(
                    from: "flood",
                  )),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 120,
            width: (MediaQuery.of(context).size.width * .5) - 21,
            decoration: BoxDecoration(
                color: AppColors.pupletagBackground(),
                borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                      Constants.assetImages + imagesIcon[IncidentType.flood]!),
                ),
                Text(
                  Utils.getTranslated(context,
                      incidentTypeName[IncidentType.flood]!.toLowerCase()),
                  style: AppFont.helvBold(16,
                      color: AppColors.appWhite(),
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.incidentTypeScreenRoute,
                  arguments: SubmitReportArg(
                    from: "sos",
                  )),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 120,
            width: (MediaQuery.of(context).size.width * .5) - 21,
            decoration: BoxDecoration(
                color: AppColors.redtagBackground(),
                borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                      Constants.assetImages + imagesIcon[IncidentType.sos]!),
                ),
                Text(
                  Utils.getTranslated(context,
                      incidentTypeName[IncidentType.sos]!.toLowerCase()),
                  style: AppFont.helvBold(16,
                      color: AppColors.appWhite(),
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslated(context, "home_hello"),
            style: AppFont.helvBold(16,
                color: AppColors.appBlack(), decoration: TextDecoration.none),
          ),
          Text(
            name!,
            style: AppFont.helvBold(26,
                color: AppColors.appPrimaryBlue(),
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
