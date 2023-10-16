import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/dio/api/category/getCategory.dart';
import 'package:jpan_flutter/model/argument/submit_reportArg.dart';
import 'package:jpan_flutter/model/category/subcategory_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';
import '../../const/constants.dart';
import '../../const/utils.dart';

class IncidentSubRoute extends StatefulWidget {
  final SubmitReportArg? data;

  const IncidentSubRoute({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<IncidentSubRoute> createState() => _IncidentSubRouteState();
}

class _IncidentSubRouteState extends State<IncidentSubRoute> {
  String? title;
  bool isLoading = false;
  SubCategoryDTO? subCatDTO;
  List<SubCategoryDataDTO>? subCatDataDTO;
  Future<SubCategoryDTO> getSubCategory(
      BuildContext context, String ic, String subCode) async {
    GetCategory getSubCat = GetCategory(context);
    return getSubCat.getSubCategory(ic, subCode);
  }

  @override
  void initState() {
    setState(() {
      title = AppCache.language == "en"
          ? widget.data!.catDescEn
          : widget.data!.catDescBm;
    });
    getDetails();
    super.initState();
  }

  getDetails() async {
    String errorMsg = '';
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await getSubCategory(
            context,
            await AppCache.getStringValue(
              AppCache.USER_IC,
            ),
            widget.data!.catCode!)
        .then((value) {
      if (value.status.toString().toLowerCase().contains('fail')) {
        if (value.errcode != "900002") {
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
              errorMsg =
                  Utils.getTranslated(context, "recordNotFound_api_error");
              break;

            default:
              errorMsg = Utils.getTranslated(context, "api_other_error");
              break;
          }
          Utils.showAlertDialog(context,
              Utils.getTranslated(context, "api_error_tittle"), errorMsg);
        } else {
          errorMsg = Utils.getTranslated(context, "recordNotFound_api_error");
          Utils.showSubCatAlertDialog(context,
              Utils.getTranslated(context, "api_error_tittle"), errorMsg);
        }
      } else {
        if (value.data != null) {
          setState(() {
            subCatDataDTO = (jsonDecode(value.data!) as List)
                .map((e) => SubCategoryDataDTO.fromJson(e))
                .toList();
          });
        }
      }
    });

    EasyLoading.dismiss();
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
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        title!,
                        style: AppFont.helvBold(18,
                            color: AppColors.appBlack(),
                            decoration: TextDecoration.none),
                      ),
                    ),
                    subCatDataDTO != null
                        ? Wrap(runSpacing: 12, spacing: 12, children: [
                            for (var i = 0; i < subCatDataDTO!.length; i++)
                              routeItem(subCatDataDTO![i])
                          ])
                        : emptyList(),
                  ],
                ),
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

  Widget routeItem(SubCategoryDataDTO i) {
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

    var title = AppCache.language == "en" ? i.subCatDescEn : i.subCatDescBm;

    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, AppRoutes.submitReportScreenRoute,
          arguments: SubmitReportArg(
              catDescBm: widget.data!.catDescBm,
              catDescEn: widget.data!.catDescEn,
              subCatDescBm: i.subCatDescBm,
              subCatDescEn: i.subCatDescEn,
              catCode: widget.data!.catCode,
              subCatCode: i.subCatCode!)),
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
                child: i.subCatIconUrl != null
                    ? Image.network(
                        i.subCatIconUrl!.trim(),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                                Constants.assetImages + "placeholder.png"),
                      )
                    : Image.asset(Constants.assetImages + "placeholder.png"),
              ),
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
