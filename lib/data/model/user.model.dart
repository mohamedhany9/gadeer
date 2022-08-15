import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/time_line.model.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

class UserModel {
  int? id;
  String? idNumber;
  String? firstName = "";
  String? emailVerifiedAt;
  String? number;
  String? establishDate;
  String? lastName = "";
  String? fullName = "";
  String? email = "";
  int? section;
  String? membershipType = "";
  String? jobTitle = "";
  String? phone = "";
  String? gender = "";
  String? photo = "";
  num? rate = 0.0;
  CityModel? area = CityModel(title: "");
  CityModel? city = CityModel(title: "");
  List<TimeLineModel>? timeLines;
  int? meetingSeconds;
  bool? isActive;
  String? status;
  int? consultingSeconds;

  bool get assosiationUncomplete {
    return membershipType == AccountType.association.toShortString() &&
        (section == null || idNumber == null || establishDate == null);
  }

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.membershipType,
    this.number,
    this.isActive,
    this.status,
    this.consultingSeconds,
    this.idNumber,
    this.emailVerifiedAt,
    this.jobTitle,
    this.section,
    this.phone,
    this.rate,
    this.gender,
    this.area,
    this.fullName,
    this.timeLines,
    this.establishDate,
    this.city,
    this.photo,
    this.meetingSeconds,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json["rate"];
    number = json["number"]?.toString();
    emailVerifiedAt = json["email_verified_at"];
    idNumber = json["id_number"];
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    fullName = json["full_name"];
    isActive = json["is_active"];
    status = json["status"];
    section = json["section"];
    establishDate = json["establish_date"];
    email = json['email'] ?? "";
    membershipType =
        json['membership_type'] ?? AccountType.consultant.toString();
    jobTitle = json['job_title'] ?? "";
    phone = json['phone'] ?? "";
    gender = json['gender'] ?? "";
    photo = json['photo'] ?? "";
    area = json['area'] != null ? new CityModel.fromJson(json['area']) : null;
    city = json['city'] != null ? new CityModel.fromJson(json['city']) : null;
    meetingSeconds = json["meeting_seconds"] ?? 0;
    consultingSeconds = json["consulting_seconds"] ?? 0;

    if (json["consulting_time_line"] != null) {
      timeLines = <TimeLineModel>[];
      json['consulting_time_line'].forEach((item) {
        timeLines!.add(TimeLineModel.fromJson(item));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['membership_type'] = this.membershipType;
    data['job_title'] = this.jobTitle;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    if (this.area != null) {
      data['area'] = this.area!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}
