import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/dio/api/category/getCategory.dart';
import 'package:jpan_flutter/model/argument/submit_reportArg.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../../const/constants.dart';
import '../../const/utils.dart';
import '../../model/category/category_model.dart';

class IncidentRoute extends StatefulWidget {
  final SubmitReportArg? data;

  const IncidentRoute({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<IncidentRoute> createState() => _IncidentRouteState();
}

class _IncidentRouteState extends State<IncidentRoute> {
  String? title;
  bool isLoading = false;
  CategoryDTO? catDTO;
  List<CategoryDataDTO>? catDataDTO;
  Future<CategoryDTO> getCategory(BuildContext context, String ic,
      String genInc, String floodWrn, String sos) async {
    GetCategory getSubCat = GetCategory(context);
    return getSubCat.getCategory(ic, genInc, floodWrn, sos);
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  getDetails() async {
    String errorMsg = '';
    String genInc = "";
    String floodWrn = "";
    String sos = "";

    switch (widget.data!.from) {
      case "general":
        genInc = "Y";
        break;
      case "flood":
        floodWrn = "Y";
        break;
      case "sos":
        sos = "Y";
        break;
      default:
        genInc = "Y";
    }
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    await getCategory(
            context,
            await AppCache.getStringValue(
              AppCache.USER_IC,
            ),
            genInc,
            floodWrn,
            sos)
        .then((value) {
      EasyLoading.dismiss();
      if (value.status.toString().toLowerCase().contains('fail')) {
        switch (value.errcode) {
          case "900001":
            errorMsg = Utils.getTranslated(context, "missingField_api_error");
            break;
          case "900003":
            errorMsg = Utils.getTranslated(context, "unexpected_api_error");
            break;
          case "900004":
            errorMsg = Utils.getTranslated(context, "accessDenied_api_error");
            break;
          case "900002":
            errorMsg = Utils.getTranslated(context, "recordNotFound_api_error");
            break;

          default:
            errorMsg = Utils.getTranslated(context, "api_other_error");
            break;
        }
        Utils.showAlertDialog(context,
            Utils.getTranslated(context, "api_error_tittle"), errorMsg);
      } else {
        if (value.data != null) {
          catDataDTO = (jsonDecode(value.data!) as List)
              .map((e) => CategoryDataDTO.fromJson(e))
              .toList();
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: isLoading
          ? Center(
              child: Container(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      Utils.getTranslated(context, "home_category"),
                      style: AppFont.helvBold(18,
                          color: AppColors.appBlack(),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  catDataDTO != null
                      ? Wrap(runSpacing: 12, spacing: 12, children: [
                          for (var i = 0; i < catDataDTO!.length; i++)
                            routeItem(catDataDTO![i])
                        ])
                      : emptyList(),
                ],
              ),
            ),
    );
  }

  Widget emptyList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Text(
          Utils.getTranslated(context, "no_category_list"),
          style: AppFont.helvBold(14,
              color: AppColors.appBlack30(), decoration: TextDecoration.none),
        ),
      ),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
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

  Widget routeItem(CategoryDataDTO i) {
    Color? color;
    switch (widget.data!.from) {
      case "general":
        color = AppColors.bluetagBackground();
        break;
      case "flood":
        color = AppColors.pupletagBackground();
        break;
      case "sos":
        color = AppColors.redtagBackground();
        break;
      default:
        color = AppColors.bluetagBackground();
    }

    var title = AppCache.language == "en" ? i.catDescEn : i.catDescBm;

    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, AppRoutes.incidentSubTypeScreenRoute,
          arguments: SubmitReportArg(
              catDescBm: i.catDescBm,
              catDescEn: i.catDescEn,
              catCode: i.catCode,
              from: widget.data!.from)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 130,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        width: MediaQuery.of(context).size.width * 0.5 - 22,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.network(
                    i.catIconUrl!.trim(),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(Constants.assetImages + "placeholder.png"),
                  )),
            ),
            Text(
              title!,
              style: AppFont.helvBold(16,
                  color: AppColors.appWhite(), decoration: TextDecoration.none),
            ),
          ],
        ),
      ),
    );
  }
}
