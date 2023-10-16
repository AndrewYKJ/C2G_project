import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jpan_flutter/cache/appcache.dart';

import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/model/card_model.dart';
import 'package:jpan_flutter/model/category/category_code_color_model.dart';
import 'package:jpan_flutter/routes/app_route.dart';

import '../const/app_font.dart';

class HistoryItem extends StatefulWidget {
  final ReportModel history;

  const HistoryItem({Key? key, required this.history}) : super(key: key);

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, AppRoutes.historyDetailsScreenRoute,
          arguments: widget.history),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.appDisabledGray()),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context),
              Container(
                margin: EdgeInsets.only(
                    top: 8, bottom: widget.history.subCat != null ? 15 : 0),
                child: Text(
                  widget.history.type != null ? widget.history.type! : '',
                  style: AppFont.helvBold(26,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
              ),
              widget.history.subCat != null
                  ? tagItem(context, widget.history)
                  // Wrap(
                  //     direction: Axis.horizontal,
                  //     alignment: WrapAlignment.start,
                  //     spacing: 5,
                  //     children: history.subCat!
                  //         .map((e) => tagItem(context, e, AppColors.appBlack()))
                  //         .toList(),
                  //   )
                  : const SizedBox(height: 0),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: widget.history.subCat != null ? 14 : 0),
                child: Text(
                  Utils.getTranslated(context, "report_card_remark") +
                      (widget.history.remark ?? ''),
                  style: AppFont.helvMed(12,
                      color: AppColors.appBlack(),
                      decoration: TextDecoration.none),
                ),
              ),
            ]),
      ),
    );
  }

  Widget header(BuildContext ctx) {
    Color? color;
    if (widget.history.currentStatus != null) {
      if (widget.history.currentStatus!.toLowerCase().contains('pending')) {
        color = AppColors.appPrimaryBlue();
      } else if (widget.history.currentStatus!
          .toLowerCase()
          .contains('completed')) {
        color = AppColors.appGreen();
      } else {
        color = AppColors.appRed();
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              child: Text(
                'ID:' + (widget.history.id ?? '-'),
                softWrap: true,
                style: AppFont.helvMed(12,
                    color: AppColors.appBlack30(),
                    decoration: TextDecoration.none),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              widget.history.updatedDate != null
                  ? DateFormat('dd MMM yyyy, h:mm a').format(
                      DateFormat('MMMM, dd yyyy HH:mm:ss')
                          .parse(widget.history.updatedDate!))
                  : '-',
              style: AppFont.helvMed(12,
                  color: AppColors.appBlack30(),
                  decoration: TextDecoration.none),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 11,
              width: 11,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              widget.history.currentStatus != null
                  ? Utils.getTranslated(
                      ctx,
                      'report_card_' +
                          widget.history.currentStatus!.toLowerCase())
                  : '',
              style: AppFont.helvBold(12,
                  color: color, decoration: TextDecoration.none),
            ),
          ],
        )
      ],
    );
  }

  Widget tagItem(ctx, ReportModel e) {
    Color color = AppCache.catCodeCache != null
        ? getTagColor(AppCache.catCodeCache!, e.catCode ?? "")
        : AppColors.appBlack();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            e.subCat!.toUpperCase(),
            style: AppFont.helvBold(12,
                color: color, decoration: TextDecoration.none),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3)),
    );
  }

  getTagColor(List<CategoryCodeModel> e, String catCode) {
    Color result = AppColors.appBlack();
    for (var element in e) {
      String codeList = element.codeList!.toString();
      if (element.codeList!.contains(catCode)) {
        result = element.colorCode!;
        break;
      }
    }
    return result;
  }
}
