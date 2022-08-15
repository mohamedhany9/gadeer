import 'package:gadeer/data/model/call.model.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/model/profile.model.dart';

import 'category.model.dart';

class ConsultingDetailsModel {
  int? id;
  ProfileModel? consultant;
  ProfileModel? association;
  String? title;
  String? description;
  String? estimationTime;
  String? date;
  List<CategoryModel>? categories;
  List<MeetingModel>? meetings;
  List<CallModel>? calls;

  String? time;
  String? status;
  String? statusText;
  String? startAt;
  String? endAt;
  String? type;
  String? statusColor;

  ConsultingDetailsModel(
      {this.id,
      this.consultant,
      this.statusText,
      this.association,
      this.type,
      this.title,
      this.statusColor,
      this.meetings,
      this.description,
      this.date,
      this.categories,
      this.time,
      this.status,
      this.startAt,
      this.endAt});

  ConsultingDetailsModel.fromJson(Map<String, dynamic> json) {
    statusColor = json["status_color"];
    print("xx" + json["status_color"]);
    estimationTime = json["estimation_time"];

    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((item) {
        categories!.add(CategoryModel.fromJson(item));
      });
    }

    if (json['calls'] != null) {
      calls = <CallModel>[];
      json['calls'].forEach((item) {
        calls!.add(CallModel.fromJson(item));
      });
    }
    if (json['meetings'] != null) {
      meetings = <MeetingModel>[];
      json['meetings'].forEach((item) {
        meetings!.add(MeetingModel.fromJson(item));
      });
    }
    statusText = json["status_text"];
    print("passed cats");
    type = json["type"];
    print("passed type");

    id = json['id'];
    print("passed id");

    consultant = json['consultant'] != null
        ? new ProfileModel.fromJson(json['consultant'])
        : null;
    print("passed consultant");

    association = json['association'] != null
        ? new ProfileModel.fromJson(json['association'])
        : null;
    print("passed association");

    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    print("passed times");
    print(json['status']);
    status = json['status'];
    print("passed status");

    startAt = json['start_at'];
    endAt = json['end_at'];
    print("passed model");
  }
}
