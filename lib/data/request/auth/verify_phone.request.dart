import 'package:gadeer/data/model/city.model.dart';

class VerifyPhoneRequest {
  String? phone;
  String? code;
  String? area;
  String? city;
  String? first_name;
  String? last_name;
  String? gender;
  String? email;
  String? new_phone;


  VerifyPhoneRequest({this.phone, this.code,this.email,this.area,this.city,this.first_name,this.gender
  ,this.last_name,this.new_phone});

  Map<String, String?> toMap() {
    final Map<String, String?> data = new Map<String, String?>();
    data['phone'] = this.phone;
    data['code'] = this.code;
    data['area_id'] = this.area ;
    data['city_id'] = this.city ;
    data['first_name'] = this.first_name;
    data['last_name'] = this.last_name;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['new_phone'] = this.new_phone;
    return data;
  }
}
