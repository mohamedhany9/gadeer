import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class RegisterRequest {
  String? firstName;
  String? lastName;
  int? sectionId;
  DateTime? establishDate;
  String? membershipType;
  String? email;
  String? password;
  String? idNumber;
  int? phoneId;
  int? areaId;
  int? cityId;
  int? partnersId;
  int? categoryId;
  int? subcategoryId;
  String? note;
  String? gender;
  String? birthDate;
  String? jobTitle;
  List<int>? categories;
  int? natoinality;
  String? id_image;
  RegisterRequest(
      {this.firstName,
      this.lastName,
      this.membershipType,
      this.email,
      this.password,
      this.phoneId,
      this.areaId,
      this.cityId,
      this.partnersId,
      this.categoryId,
      this.subcategoryId,
      this.note,
      this.establishDate,
      this.sectionId,
      this.idNumber,
      this.gender,
      this.birthDate,
      this.categories,
      this.natoinality,
        this.id_image,
      this.jobTitle});

  Map<String, dynamic> toMap() {
    DateFormat dt = DateFormat("yyyy-MM-dd");

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['membership_type'] = this.membershipType;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone_id'] = this.phoneId;
    data['area_id'] = this.areaId;
    data['city_id'] = this.cityId;
    data['partner_id'] = this.partnersId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subcategoryId;
    data['partner_name'] = this.note;
    data['gender'] = this.gender;
    data["id_number"] = this.idNumber;
    data['birth_date'] = this.birthDate;
    data["v"] = 2;
    data['categories'] = this.categories;
    data["job_title"] = this.jobTitle;
    data["section"] = this.sectionId;
    data["nationality"] = this.natoinality;
    data["id_image"] = this.id_image;
    if (this.establishDate != null) {
      data["establish_date"] = dt.format(this.establishDate!);
    }
    return data;
  }
}
