import 'package:gadeer/data/request/auth/login.request.dart';
import 'package:gadeer/data/request/auth/send_reset_password.request.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/data/response/auth/send_reset_password.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:get/get.dart';

class LoginService {
 final ApiService apiService=Get.find();

  Future<LoginResponse> login({required LoginRequest request}) async {
    var response = await this.apiService.post(
          'login',
          data: request.toMap(),
        );
    return LoginResponse.fromJson(response);
  }

  Future<SendResetPasswordResponse> resetPassword(
      {required SendResetRequest request}) async {
    var response = await apiService.post(
      'reset-password',
      data: request.toMap(),
    );
    return SendResetPasswordResponse.fromJson(response);
  }
}
