import 'package:gadeer/data/response/base.response.dart';

class VerifyPhoneResponse with BaseResponse {
  int? phoneId;
  VerifyPhoneResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    phoneId = json['phone_id'];
  }
}
