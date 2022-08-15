import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class AddConsultRequest {
  String? title;
  String? description;
  DateTime? date;
  TimeOfDay? time;
  String? type;
  List<int?>? categories;
  String? category;

  int? consultantId;

  AddConsultRequest(
      {this.title,
      this.description,
      this.date,
      this.time,
      this.category,
      this.type,
      this.categories,
      this.consultantId});

  Map<String, dynamic> toJson() {
    DateFormat dt = DateFormat("yyyy-MM-dd");
    DateFormat ti = DateFormat("hh:mm:ss");

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['description'] = this.description;

    if (this.date != null) {
      data['date'] = dt.format(this.date!);
    }
    if (this.time != null) {
      data['time'] =
          ti.format(DateTime(2020, 1, 1, this.time!.hour, this.time!.minute, 0));
    }
    data["category"] = this.category;

    data['type'] = this.type;
    data['categories'] = this.categories;
    if (this.consultantId != null) {
      data['consultant_id'] = this.consultantId;
    }
    return data;
  }
}
