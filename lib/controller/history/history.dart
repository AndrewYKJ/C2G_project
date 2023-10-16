import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/components/app_card.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/historydrawerstate.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/card_model.dart';
import 'package:jpan_flutter/model/feedback/feedback_model.dart';
import 'package:jpan_flutter/model/filterselection_model.dart';
import 'package:jpan_flutter/model/user_model.dart';
import 'package:provider/provider.dart';

import '../../dio/api/feedback/feedback.dart';

class ReportHistory extends StatefulWidget {
  const ReportHistory({Key? key}) : super(key: key);

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Map<FilterType?, List<ReportModel>> preferredCategoryListMap;
  late Map<SubCategory?, List<ReportModel>> preferredSubCategoryListMap;

  void _openEndDrawer() {
    // Provider.of<DrawerState>(context, listen: false).setState(true);
    if (subCat != null) {
      _scaffoldKey.currentState!.openEndDrawer();
    }
  }

  void _changeDrawerState(bool isOpened) {
    if (datahistory.isNotEmpty) {
      if (isOpened) {
        Provider.of<DrawerState>(context, listen: false).setState(true);
      } else {
        Provider.of<DrawerState>(context, listen: false).setState(false);
      }
    }
  }

  String? _selectedStatus = '';
  String? _selectedIncident = '';
  String? _selectedSubCat = '';

  bool isLoading = true;
  FilterType? subCat;
  List<FilterType> status = [
    FilterType(key: 'all', isSelected: true, displayName: 'All'),
    FilterType(key: 'pending', isSelected: false, displayName: 'Pending'),
    FilterType(key: 'completed', isSelected: false, displayName: 'Completed'),
  ];
  List<FilterType> incident = [];
  List<ReportModel> history = [];
  List<ReportModel> datahistory = [];

  Future<FeedBackDTO> getFeedbackList(
    BuildContext context,
  ) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.getFeedbackList(await AppCache.getStringValue(
      AppCache.USER_IC,
    ));
  }

  void groupCategoryType() {
    final groupsCat = groupBy(history, (ReportModel e) {
      return e.catCode;
    });

    groupsCat.forEach((keyCode, value) {
      final groupsSubCat = groupBy(value, (ReportModel e) {
        return e.subCatCode;
      });

      incident.add(
        FilterType(
            key: keyCode,
            isSelected: false,
            displayName: value.first.type,
            subCat: [
              SubCategory(
                  key: 'all',
                  isSelected: true,
                  displayName: Utils.getTranslated(context, 'all')),
              ...List<SubCategory>.generate(
                  groupsSubCat.keys.length,
                  (i) => (SubCategory(
                      isSelected: false,
                      displayName:
                          groupsSubCat.values.elementAt(i).first.subCat,
                      key: groupsSubCat.keys.elementAt(i))))
            ]),
      );
    });

    setState(() {});
  }

  @override
  void initState() {
    Utils.setFirebaseAnalyticsCurrentScreen(Constants.analyticsHistoryScreen);
    getHistory();

    super.initState();
  }

  getSubCat() {
    setState(() {
      subCat = incident.firstWhere((element) => element.isSelected!);
    });
  }

  _refreshData() async {
    setState(() {
      isLoading = true;
      history = [];
      datahistory = [];
    });

    getHistory();
  }

  getHistory() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    String errorMsg = '';
    await getFeedbackList(context)
        .then((value) async {
          EasyLoading.dismiss();
          if (value.status.toString().toLowerCase().contains('fail') &&
              value.errcode != '900005') {
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
                    Utils.getTranslated(context, "recordNotFound_api_error");
                break;

              default:
                errorMsg = Utils.getTranslated(context, "api_other_error");
                break;
            }
            Utils.showAlertDialog(context,
                Utils.getTranslated(context, "api_error_tittle"), errorMsg);
          } else {
            if (value.data != null) {
              List<FeedBackDataDTO> e = value.data!.toList();
              // e.sort((a, b) {
              //   return b.timeLine!.compareTo(a.timeLine!);
              // });
              incident.clear();
              incident.add(
                FilterType(
                    key: 'all',
                    isSelected: true,
                    displayName: Utils.getTranslated(context, 'all'),
                    subCat: [
                      SubCategory(
                          key: 'all',
                          isSelected: true,
                          displayName: Utils.getTranslated(context, 'all')),
                    ]),
              );
              getSubCat();
              for (var element in e) {
                datahistory.add(ReportModel(
                    id: element.caseId,
                    updatedDate: element.timeLine,
                    currentStatus: element.status,
                    type: AppCache.language != "en"
                        ? element.catDescBm
                        : element.catDescEng,
                    subCat: AppCache.language != "en"
                        ? element.catSubDescBm
                        : element.catSubDescEng,
                    catCode: element.catCode,
                    subCatCode: element.subCatCode,
                    district: element.disDesc,
                    remark: element.remarks,
                    status: [],
                    sender: User(
                        ic: await AppCache.getStringValue(
                          AppCache.USER_IC,
                        ),
                        name: AppCache.me.data![0].usrFName,
                        mobileNo: AppCache.me.data![0].usrContactNo)));
              }
              datahistory.sort((a, b) {
                return DateFormat('MMMM, dd yyyy HH:mm:ss')
                    .parse(b.updatedDate!)
                    .compareTo(DateFormat('MMMM, dd yyyy HH:mm:ss')
                        .parse(a.updatedDate!));
              });
              setState(() {
                history = datahistory.toList();
                _selectedIncident = incident.first.key;
                _selectedStatus = status.first.key;
                _selectedSubCat = incident.first.subCat!.first.key;
                groupCategoryType();
              });
            }
          }
        })
        .whenComplete((() => setState(
              () {
                isLoading = false;
              },
            )))
        .catchError((e) {
          Utils.printInfo("ERROR: $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: Container())
        : Scaffold(
            onEndDrawerChanged: ((isOpened) {
              _changeDrawerState(isOpened);
            }),
            endDrawerEnableOpenDragGesture: false,
            key: _scaffoldKey,
            appBar: header(),
            body: RefreshIndicator(
              displacement: MediaQuery.of(context).size.height / 2.15,
              onRefresh: () => _refreshData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: history.isNotEmpty
                      ? history
                          .map((e) => HistoryItem(
                                history: e,
                              ))
                          .toList()
                      : [emptyList()],
                ),
              ),
            ),
            endDrawer: filterDrawer(context),
          );
  }

  Widget emptyList() {
    return Container(
      height: MediaQuery.of(context).size.height - 400,
      margin: const EdgeInsets.only(bottom: 300),
      child: Center(
        child: Text(
          Utils.getTranslated(context, "empty_list"),
          style: AppFont.helvBold(14,
              color: AppColors.appBlack30(), decoration: TextDecoration.none),
        ),
      ),
    );
  }

  AppBar header() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [drawerOnOffButton()],
      centerTitle: true,
      title: Text(
        Utils.getTranslated(context, 'hombase_reporthistory'),
        style: AppFont.helvBold(18,
            color: AppColors.appBlack(), decoration: TextDecoration.none),
      ),
    );
  }

  Widget filterDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: Scaffold(
        body: Container(
          color: AppColors.appWhite(),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom + 80),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 20.0),
                  child: Text(
                    Utils.getTranslated(context, 'search_filter'),
                    style: AppFont.helvBold(18,
                        color: AppColors.appBlack(),
                        decoration: TextDecoration.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(context, "filter_drawer_status"),
                        style: AppFont.helvMed(14,
                            color: AppColors.appFilterDrawerCat(),
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      for (var i = 0; i < status.length; i++)
                        statusItem(context, status[i]),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            context, "filter_drawer_incident_type"),
                        style: AppFont.helvMed(14,
                            color: AppColors.appFilterDrawerCat(),
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      for (var i = 0; i < incident.length; i++)
                        incidentItem(context, incident[i]),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslated(
                            context, "filter_drawer_sub_category"),
                        style: AppFont.helvMed(14,
                            color: AppColors.appFilterDrawerCat(),
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (subCat != null)
                        for (var i = 0; i < subCat!.subCat!.length; i++)
                          subCatItem(context, subCat!.subCat![i]),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 100,
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: filterButton(context),
      ),
    );
  }

  Widget subCatItem(BuildContext context, SubCategory data) {
    return InkWell(
      onTap: () {
        for (var element in subCat!.subCat!) {
          element.isSelected = false;
        }
        setState(() {
          data.isSelected = true;
          _selectedSubCat = data.key;
        });
      },
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                data.displayName ?? '-',
                style: data.isSelected!
                    ? AppFont.helvBold(
                        14,
                        color: AppColors.appPrimaryBlue(),
                      )
                    : AppFont.helvMed(14, color: AppColors.appBlack30()),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            data.isSelected!
                ? Image.asset(
                    Constants.assetImages + 'tick_icon.png',
                    fit: BoxFit.contain,
                    height: 20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget statusItem(BuildContext context, FilterType data) {
    return InkWell(
      onTap: () {
        for (var element in status) {
          element.isSelected = false;
        }
        setState(() {
          data.isSelected = true;
          _selectedStatus = data.key;
        });
      },
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.displayName != null
                  ? Utils.getTranslated(
                      context, data.displayName!.toLowerCase())
                  : '-',
              style: data.isSelected!
                  ? AppFont.helvBold(
                      14,
                      color: AppColors.appPrimaryBlue(),
                    )
                  : AppFont.helvMed(14, color: AppColors.appBlack30()),
            ),
            data.isSelected!
                ? Image.asset(
                    Constants.assetImages + 'tick_icon.png',
                    fit: BoxFit.contain,
                    height: 20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget incidentItem(BuildContext context, FilterType data) {
    return InkWell(
      onTap: () {
        for (var element in incident) {
          element.isSelected = false;
        }
        setState(() {
          data.isSelected = true;
          subCat = data;
          _selectedIncident = data.key;
        });
      },
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                data.displayName ?? "-",
                style: data.isSelected!
                    ? AppFont.helvBold(
                        14,
                        color: AppColors.appPrimaryBlue(),
                      )
                    : AppFont.helvMed(14, color: AppColors.appBlack30()),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            data.isSelected!
                ? Image.asset(
                    Constants.assetImages + 'tick_icon.png',
                    fit: BoxFit.contain,
                    height: 20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget filterButton(BuildContext context) {
    return Container(
      height: 80,
      color: AppColors.appWhite(),
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              filterResetButton(context),
              filterApplyButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget filterApplyButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          if (datahistory.isNotEmpty) {
            history = datahistory.toList();

            if (!_selectedStatus!.contains('all')) {
              history = datahistory
                  .where((element) => element.currentStatus!
                      .toLowerCase()
                      .contains(_selectedStatus!))
                  .toList();
            }
            if (!_selectedIncident!.contains('all')) {
              history.removeWhere(
                  (element) => !element.catCode!.contains(_selectedIncident!));
            }
            if (!_selectedSubCat!.contains('all')) {
              history.removeWhere(
                  (element) => !element.subCatCode!.contains(_selectedSubCat!));
            }

            setState(() {});

            Navigator.pop(context);
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0,
                    1
                  ],
                  colors: [
                    AppColors.gradientBlue1(),
                    AppColors.gradientBlue2(),
                  ]),
              border: Border.all(color: AppColors.appPrimaryBlue()),
              borderRadius: BorderRadius.circular(60)),
          child: Center(
            child: Text(
              Utils.getTranslated(context, "filter_drawer_apply_btn"),
              style: AppFont.helvBold(16,
                  color: AppColors.appWhite(), decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterResetButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        for (var element in incident) {
          element.isSelected = false;
        }
        for (var element in status) {
          element.isSelected = false;
        }
        setState(() {
          incident[0].isSelected = true;
          status[0].isSelected = true;
          subCat = incident[0];
          history = datahistory.toList();

          _selectedIncident = incident.first.key;
          _selectedStatus = status.first.key;
          _selectedSubCat = incident.first.subCat!.first.key;
        });
        Navigator.pop(context);
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          height: 40,
          width: AppCache.language!.toLowerCase() != 'en'
              ? MediaQuery.of(context).size.width * 0.45
              : MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.appPrimaryBlue()),
              borderRadius: BorderRadius.circular(60)),
          child: Center(
              child: Text(
            Utils.getTranslated(context, "filter_drawer_reset_btn"),
            style: AppFont.helvBold(16,
                color: AppColors.appPrimaryBlue(),
                decoration: TextDecoration.none),
          ))),
    );
  }

  Widget drawerOnOffButton() {
    return TextButton(
        onPressed: _openEndDrawer,
        child: Row(
          children: [
            Image.asset(
              Constants.assetImages + 'filter_icon.png',
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 11,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                Utils.getTranslated(context, 'btn_filter'),
                style: AppFont.helvBold(14,
                    color: AppColors.appPrimaryBlue(),
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        ));
  }
}
