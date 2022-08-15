import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMeetingRequest {
  String? title;
  String? description;
  DateTime? date;
  TimeOfDay? time;
  int? consultingId;

  AddMeetingRequest(
      {this.title, this.description, this.date, this.time, this.consultingId});

  Map<String, dynamic> toJson() {
    DateFormat dt = DateFormat("yyyy-MM-dd");
    DateFormat ti = DateFormat("hh:mm:ss");

    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['description'] = this.description;
    if (this.consultingId != null) {
      data["consulting_id"] = this.consultingId;
    }
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
