import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:jpan_flutter/cache/appcache.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/dio/api/feedback/feedback.dart';
import 'package:http/http.dart' as http;
import 'package:jpan_flutter/dio/dio_repo.dart';
import 'package:jpan_flutter/model/feedback/feedback_timeline_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';
import '../const/app_colors.dart';
import '../const/app_font.dart';
import '../model/card_model.dart';
import '../model/feedback/feedback_comment_model.dart';
import 'package:measure_size/measure_size.dart';

class ReportDetails extends StatefulWidget {
  final ReportModel data;
  const ReportDetails({Key? key, required this.data}) : super(key: key);

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  Uint8List? photo;
  File? decodedimgfile;
  bool isLoading = true;
  List<Status> timeLine = [];
  List<GlobalKey> listKey = [];

  Size oldSize = Size(0, 0);

  Future<FeedbackTimelineDTO> getFeedbackTimeline(
    BuildContext context,
  ) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.getFeedbackTimeline(
      await AppCache.getStringValue(
        AppCache.USER_IC,
      ),
      widget.data.id!,
    );
  }

  Future<FeedbackCommentDTO> getFeedbackTaskComment(
      BuildContext context, String taskID) async {
    FeedBackApi feedBackApi = FeedBackApi(context);
    return feedBackApi.getFeedbackTaskComment(
      await AppCache.getStringValue(
        AppCache.USER_IC,
      ),
      taskID,
    );
  }

  @override
  void initState() {
    getTimeline();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getTimeline() async {
    await getFeedbackTimeline(context).then((data) async {
      if (data.status!.toLowerCase().contains('success')) {
        if (data.data!.isNotEmpty) {
          for (var element in data.data!) {
            if (element.taskId != null && element.taskId != '') {
              await getFeedbackTaskComment(context, element.taskId!)
                  .then((value) {
                if (value.status!.toLowerCase().contains('success')) {
                  if (value.data != null) {
                    if (value.data!.length > 1) {
                      for (var element in value.data!) {
                        timeLine.add(Status(
                            timestamp: DateFormat('dd/MM/yyyy @h:mm a').format(
                                DateFormat('MMMM, dd yyyy HH:mm:ss')
                                    .parse(element.timeLine!)),
                            status: element.remarks));
                      }
                    } else {
                      timeLine.add(
                        Status(
                            timestamp: DateFormat('dd/MM/yyyy @h:mm a').format(
                                DateFormat('MMMM, dd yyyy HH:mm:ss')
                                    .parse(value.data!.first.timeLine!)),
                            status: value.data!.first.remarks),
                      );
                    }
                  }
                }
              }).whenComplete(() {
                List<GlobalKey> keyCap = List<GlobalKey>.generate(
                    timeLine.length, (index) => GlobalKey(),
                    growable: false);
                listKey = keyCap;
                timeLine.sort((a, b) {
                  return DateFormat('dd/MM/yyyy @h:mm a')
                      .parse(b.timestamp!)
                      .compareTo(
                          DateFormat('dd/MM/yyyy @h:mm a').parse(a.timestamp!));
                });
                setState(() {});
              });
            }
          }
        }
      }
    }).whenComplete(() => getDetails());
  }

  getDetails() async {
    var headers = {
      'Authorization':
          await AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF),
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=065FF7019159D5A9037F6D84E026F785.cfusion'
    };

    var request =
        http.Request('GET', Uri.parse(DioRepo.production + '/getFbPht'));
    request.body = json.encode({
      "UsrID": Constants.agmoID,
      "PublicIC": await AppCache.getStringValue(
        AppCache.USER_IC,
      ),
      "CaseID": "${widget.data.id}"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      photo = await response.stream.toBytes();

      decodedimgfile = await File.fromRawPath(photo!);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Utils.showAlertDialog(
          context,
          Utils.getTranslated(context, "api_error_tittle"),
          Utils.getTranslated(context, "api_other_error"));
    }
  }

  void postFrameCallback(_) {
    listKey.forEach((element) {
      var context = element;
      if (context == null) return;

      var newSize = context.currentContext!.size!;
      if (oldSize == newSize || newSize == null) return;

      setState(() {
        oldSize = newSize;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Scaffold(
        appBar: header(context),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      status(context),

                      reportSummary(context),
                      if (timeLine.isNotEmpty) const Divider(),

                      if (timeLine.isNotEmpty)
                        const SizedBox(
                          height: 16,
                        ),

                      if (timeLine.isNotEmpty)
                        for (int i = 0; i < timeLine.length; i++)
                          transition(context, i, timeLine[i]),
                      if (timeLine.isNotEmpty) const SizedBox(height: 16),

                      //DO NOT REMOVE, TEMP HIDE
                      // widget.data.sender != null
                      //     ? senderDetail(context)
                      //     : const SizedBox(),
                    ],
                  ),
                ),
              ));
  }

  Widget senderDetail(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(Utils.getTranslated(ctx, "report_details_applicant"),
                style: AppFont.helvBold(16, color: AppColors.appBlack())),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utils.getTranslated(ctx, "report_details_name"),
                    style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
                Text(
                    widget.data.sender != null
                        ? widget.data.sender!.name ?? '-'
                        : '-',
                    style: AppFont.helvBold(14, color: AppColors.appBlack())),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IC',
                    style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
                Text(
                    widget.data.sender != null
                        ? widget.data.sender!.ic ?? '-'
                        : '-',
                    style: AppFont.helvBold(14, color: AppColors.appBlack())),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Utils.getTranslated(ctx, 'setting_about_us_contact_number'),
                  style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
              Text(
                  widget.data.sender!.mobileNo != null
                      ? '+0' + widget.data.sender!.mobileNo!
                      : '-',
                  style: AppFont.helvBold(14, color: AppColors.appBlack())),
            ],
          )
        ],
      ),
    );
  }

  Widget reportSummary(BuildContext context) {
    //var _image = MemoryImage(photo);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Utils.getTranslated(context, "report_details_report_summary"),
                style: AppFont.helvMed(16, color: AppColors.appBlack())),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 80,
              width: 80,
              child: InkWell(
                onTap: () => {
                  Navigator.pushNamed(
                      context, AppRoutes.enlargeImageScreenRoute,
                      arguments: photo)
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: photo != null
                      ? Image.memory(
                          photo!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          Constants.assetImages + 'placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                  Utils.getTranslated(context, "report_details_incident_type"),
                  style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(widget.data.type ?? '-',
                  style: AppFont.helvBold(14, color: AppColors.appBlack())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                  Utils.getTranslated(context, "report_details_sub_cat"),
                  style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                  widget.data.subCat != null ? widget.data.subCat! : "-",
                  style: AppFont.helvBold(14, color: AppColors.appBlack())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                  Utils.getTranslated(context, "report_details_district"),
                  style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(widget.data.district ?? '-',
                  style: AppFont.helvBold(14, color: AppColors.appBlack())),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(Utils.getTranslated(context, "report_details_remark"),
                  style: AppFont.helvMed(14, color: AppColors.appBlueGray())),
            ),
            Text(widget.data.remark ?? '-',
                style: AppFont.helvBold(14, color: AppColors.appBlack())),
          ]),
    );
  }

  Widget transition(BuildContext context, int i, Status current) {
    var date = current.timestamp!.split('@');
    final widgetKey = GlobalKey();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date[0],
                    textAlign: TextAlign.left,
                    style: AppFont.helvMed(12, color: AppColors.appBlack())),
                Text(date[1],
                    textAlign: TextAlign.left,
                    style: AppFont.helvMed(12, color: AppColors.appBlack())),
              ],
            ),
          ),
          Container(
            width: 30,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 3,
                  width: 1,
                  color:
                      i != 0 ? AppColors.appDisabledGray() : Colors.transparent,
                ),
                Container(
                  height: i != 0 ? 8 : 12,
                  width: i != 0 ? 8 : 12,
                  decoration: BoxDecoration(
                      color: i != 0
                          ? AppColors.appDisabledGray()
                          : AppColors.appPrimaryBlue(),
                      borderRadius: BorderRadius.circular(8)),
                ),
                Container(
                  height: (i + 1 == timeLine.length) ? 0 : oldSize.height + 3,
                  width: 1,
                  color: AppColors.appDisabledGray(),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100 - 64,
            key: listKey[i],
            child: Text(current.status ?? '-',
                // Utils.getTranslated(context, "report_details_report") +
                //     Utils.getTranslated(
                //       context,
                //       "report_details_" +
                //           widget.data.status![i].status!.toLowerCase(),
                //     ),
                style: AppFont.helvMed(14,
                    color: i != 0
                        ? AppColors.appDisabledGray()
                        : AppColors.appPrimaryBlue())),
          )
        ],
      ),
    );
  }

  Container status(BuildContext context) {
    Color? color;
    if (widget.data.currentStatus != null) {
      if (widget.data.currentStatus!.toLowerCase().contains('approved')) {
        color = AppColors.appRed();
      } else if (widget.data.currentStatus!
          .toLowerCase()
          .contains('completed')) {
        color = Colors.green;
      } else {
        color = AppColors.appPrimaryBlue();
      }
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      color: color,
      child: Text(
          widget.data.currentStatus != null
              ? Utils.capitalize(Utils.getTranslated(context,
                  'report_card_' + widget.data.currentStatus!.toLowerCase()))
              : '-',
          style: AppFont.helvBold(16, color: AppColors.appWhite())),
    );
  }

  AppBar header(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      title: Text(Utils.getTranslated(context, "report_details_title"),
          style: AppFont.helvBold(18, color: AppColors.appBlack())),
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
}
