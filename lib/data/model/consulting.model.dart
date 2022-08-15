import 'package:gadeer/data/model/category.model.dart';

import 'profile.model.dart';

class ConsultingModel {
  int? id;
  ProfileModel? consultant;
  ProfileModel? association;
  List<CategoryModel>? categories;
  String? statusColor;
  String? title;
  String? description;
  String? date;
  String? time;
  String? status;
  String? statusText;
  String? startAt;
  String? endAt;
  String? type;

  ConsultingModel(
      {this.id,
      this.consultant,
      this.association,
      this.title,
      this.description,
      this.date,
      this.time,
      this.statusText,
      this.status,
      this.statusColor,
      this.categories,
      this.type,
      this.startAt,
      this.endAt});

  ConsultingModel.fromJson(Map<String, dynamic> json) {
    statusColor = json["status_color"];
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((item) {
        categories!.add(CategoryModel.fromJson(item));
      });
    }
    id = json['id'];
    statusText = json["status_text"];
    consultant = json['consultant'] != null
        ? new ProfileModel.fromJson(json['consultant'])
        : null;
    association = json['association'] != null
        ? new ProfileModel.fromJson(json['association'])
        : null;
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    type = json["type"];
    status = json['status'];
    startAt = json['start_at'];
    endAt = json['end_at'];
  }
}
