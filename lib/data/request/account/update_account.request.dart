import 'package:intl/intl.dart';

class UpdateAccountRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? jobTitle;
  int? areaId;
  int? cityId;
  int? sectionId;
  String? gender;
  String? idNumber;
  String? phoneNumber;
  DateTime? establishDate;
  int? partnerid;
  String? partnername;


  UpdateAccountRequest(
      {this.firstName,
      this.lastName,
      this.email,
      this.jobTitle,
      this.areaId,
      this.establishDate,
      this.sectionId,
      this.cityId,
      this.gender,
      this.phoneNumber,
      this.partnerid,
      this.partnername,
      this.idNumber});

  Map<String, dynamic> toJson() {
    DateFormat dt = DateFormat("yyyy-MM-dd");

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['job_title'] = this.jobTitle;
    data['area_id'] = this.areaId;
    data['city_id'] = this.cityId;
    data['gender'] = this.gender;
    data['id_number'] = this.idNumber;
    data['phone'] = this.phoneNumber;
    data['partner_id'] = this.partnerid;
    data['partner_name'] = this.partnername;
    data["v"] = 2;

    data["section"] = sectionId;
    if (establishDate != null) {
      data["establish_date"] = dt.format(establishDate ?? DateTime.now());
    }
    print(data);
    return data;
  }
}
