import 'package:flutter/material.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class HomeResponse with BaseResponse {
  List<ProfileModel>? profiles = [];
  List<ConsultingModel>? newConsultings;
  List<ConsultingModel>? inProgressConsultings;

  int? userCount;
  List<ConsultingStatusModel>? consultingStates;

  bool isCompleted = false;
  MeetingModel? meetingModel;

  int get consultingCount {
    return consultingStates
            ?.firstWhere((element) => element.status == "completed")
            .value ??
        0;
  }

  HomeResponse();
  HomeResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["users"] != null) {
      profiles = [];
      List bad = json["users"];
      bad.forEach((element) {
        profiles!.add(ProfileModel.fromJson(element));
      });
    }
    if (json["statuses"] != null) {
      consultingStates = [];
      List bad = json["statuses"];
      bad.forEach((element) {
        consultingStates!.add(ConsultingStatusModel.fromJson(element));
      });
    }

    if (json["in_progress_consulting"] != null) {
      inProgressConsultings = [];
      List bad = json["in_progress_consulting"];
      bad.forEach((element) {
        inProgressConsultings!.add(ConsultingModel.fromJson(element));
      });
    }
    if (json["new_consulting"] != null) {
      newConsultings = [];
      List bad = json["new_consulting"];
      bad.forEach((element) {
        newConsultings!.add(ConsultingModel.fromJson(element));
      });
    }
    //meeting
    if (json["meeting"] != null) {
      meetingModel = MeetingModel.fromJson(json["meeting"]);
    }

    if (json["users_count"] != null) {
      userCount = json["users_count"];
    }
    if (json["is_completed"] != null) {
      isCompleted = json["is_completed"];
    }
  }
}

class ConsultingStatusModel {
  int? value;
  String? status;
  String? label;
  String? colorText;

  Color get color {
    return colorText == null
        ? Colors.transparent
        : Color(int.parse("0xff" + (colorText ?? "000000")));
  }

  ConsultingStatusModel({this.value, this.status});

  ConsultingStatusModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    status = json['status'];
    label = json["label"];
    colorText = json["color"];
  }
}
