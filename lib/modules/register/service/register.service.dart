import 'package:gadeer/data/request/auth/register.request.dart';
import 'package:gadeer/data/request/auth/send_verify_phone.request.dart';
import 'package:gadeer/data/request/auth/verify_phone.request.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/data/response/auth/privacy_policy.response.dart';
import 'package:gadeer/data/response/auth/verify_phone.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class RegisterService {
  final ApiService apiService = Get.find();
  final HiveService hiveService = Get.find();

  Future<VerifyPhoneResponse> sendVerifyCode(
      {required SendVerifyPhoneRequest request}) async {
    var response = await apiService.post(
      'send-verify-code',
      data: request.toMap(),
    );
    return VerifyPhoneResponse.fromJson(response);
  }

  Future<VerifyPhoneResponse> verifyPhone(
      {required VerifyPhoneRequest request}) async {
    var response = await apiService.post(
      'verify-phone-number',
      data: request.toMap(),
    );
    return VerifyPhoneResponse.fromJson(response);
  }

  Future<PrivacyPolicyResponse> showPage(String slug) async {
    var response = await apiService.get(
      'pages/$slug',
    );
    return PrivacyPolicyResponse.fromJson(response);
  }

  Future<LoginResponse> register({required RegisterRequest request}) async {
    var response = await apiService.post(
      'register',
      data: request.toMap(),
    );
    return LoginResponse.fromJson(response);
  }

  Future<void> saveAccountType(AccountType type) async =>
      await this.hiveService.put<AccountType>(
            Constants.gaderBox,
            'account_type',
            type,
          );

  Future<AccountType?> getAccountType() async =>
      await this.hiveService.get<AccountType>(
            Constants.gaderBox,
            'account_type',
          );
}
