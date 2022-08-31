// To parse this JSON data, do
//
//     final userType = userTypeFromJson(jsonString);

import 'dart:convert';

UserType userTypeFromJson(String str) => UserType.fromJson(json.decode(str));

String userTypeToJson(UserType data) => json.encode(data.toJson());

class UserType {
  UserType({
    required this.data,
  });

  List<UserTypeData> data;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    data: List<UserTypeData>.from(json["data"].map((x) => UserTypeData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class UserTypeData {
  UserTypeData({
    required this.id,
    required this.title,
    required this.value,
    required this.isActive,
  });

  int id;
  String title;
  String value;
  bool isActive;

  factory UserTypeData.fromJson(Map<String, dynamic> json) => UserTypeData(
    id: json["id"],
    title: json["title"],
    value: json["value"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "value": value,
    "is_active": isActive,
  };
}
