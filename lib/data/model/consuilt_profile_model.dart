// To parse this JSON data, do
//
//     final consuitProfileModel = consuitProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:gadeer/data/model/profile.model.dart';

ConsuitProfileModel consuitProfileModelFromJson(String str) => ConsuitProfileModel.fromJson(json.decode(str));

String consuitProfileModelToJson(ConsuitProfileModel data) => json.encode(data.toJson());

class ConsuitProfileModel {
  ConsuitProfileModel({
    required this.status,
    required this.message,
    required this.profile,
  });

  int status;
  String message;
  ProfileModel profile;

  factory ConsuitProfileModel.fromJson(Map<String, dynamic> json) => ConsuitProfileModel(
    status: json["status"],
    message: json["message"],
    profile: ProfileModel.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "profile": profile,
  };
}

