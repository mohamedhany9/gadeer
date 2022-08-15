import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class LoginResponse with BaseResponse {
  String? accessToken;
  UserModel? user;
  LoginResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    accessToken = json['access_token'];
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
  }
}
