import 'package:intl/intl.dart';

class EducationModel {
  int? id;
  String? title;
  String? description;
  String? place;
  String? from;
  String? to;

  EducationModel({
    this.id,
    this.title,
    this.description,
    this.place,
    this.from,
    this.to,
  });

  EducationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    place = json['place'];
    from = json['from'] != null
        ? DateFormat.yMd().format(DateTime.parse(json['from']))
        : null;
    to = json['to'] != null
        ? DateFormat.yMd().format(DateTime.parse(json['to']))
        : null;
  }
}
