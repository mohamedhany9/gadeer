import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateConsultingRequest {
  String? title;
  String? description;
  DateTime? date;
  TimeOfDay? time;

  UpdateConsultingRequest({this.title, this.description, this.date, this.time});

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

    return data;
  }
}
