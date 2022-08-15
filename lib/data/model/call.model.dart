import 'package:gadeer/data/model/profile.model.dart';

class CallModel {
  int? id;
  String? type;
  String? typeText;
  int? duration;
  String? date;
  ProfileModel? user;

  CallModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeText = json['type_text'];
    duration = json['duration'];
    date = json['date'];
    user = json["user"] == null ? null : ProfileModel.fromJson(json["user"]);
  }
}
