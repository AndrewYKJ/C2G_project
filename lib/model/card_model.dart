import 'package:jpan_flutter/model/user_model.dart';

class ReportModel {
  String? id;
  String? updatedDate;
  String? creadtedDate;
  List<Status>? status;
  String? type;
  String? currentStatus;
  String? subCat;
  String? district;
  String? subCatCode;
  String? catCode;
  String? remark;
  User? sender;

  ReportModel(
      {this.id,
      this.creadtedDate,
      this.district,
      this.remark,
      this.catCode,
      this.subCatCode,
      this.sender,
      this.status,
      this.currentStatus,
      this.subCat,
      this.type,
      this.updatedDate});

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creadtedDate = json['createdDate'];
    district = json['district'];
    remark = json['remark'];
    sender = json['sender'];
    currentStatus = json['currentStatus'];
    subCat = json['subCat'];
    type = json['type'];
    updatedDate = json['updatedDate'];
    if (json['status'] != null) {
      status = [];
      json['status'].forEach((v) {
        status!.add(Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdDate'] = creadtedDate;
    data['district'] = district;
    data['remark'] = remark;
    data['sender'] = sender;
    data['status'] = status;
    data['subCat'] = subCat;
    data['type'] = type;
    data['updatedDate'] = updatedDate;
    return data;
  }
}

class Status {
  String? timestamp;
  String? status;
  Status({this.timestamp, this.status});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['timestamp'] = timestamp;

    return data;
  }
}
