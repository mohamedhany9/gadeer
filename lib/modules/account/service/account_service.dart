import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:gadeer/data/request/account/change_password.request.dart';
import 'package:gadeer/data/request/account/update_account.request.dart';
import 'package:gadeer/data/response/account/change_password.response.dart';
import 'package:gadeer/data/response/account/get_account.response.dart';
import 'package:gadeer/data/response/account/update_account.response.dart';
import 'package:gadeer/data/response/auth/verify_email.response.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class AccountService {
  final HiveService _hiveService = Get.find();
  final ApiService _apiService = Get.find();

  AccountService();

  Future<GetAccountResponse> getAccount() async {
    var response = await _apiService.get(
      "user/account",
    );

    return GetAccountResponse.fromJson(response);
  }

  Future<VerifyEmailResponse> verifyEmail(String code) async {
    var response = await _apiService.post(
      'user/verify-email',
      data: {"code": int.parse(code)},
    );
    return VerifyEmailResponse.fromJson(response);
  }

  Future<VerifyEmailResponse> resendCode() async {
    var response = await _apiService.post(
      'user/send-verify-email',
    );
    return VerifyEmailResponse.fromJson(response);
  }

  Future<UpdateAccountResponse> updateAccount(
      UpdateAccountRequest updateAccountRequest) async {
    var response = await _apiService.put("user/account/update",
        data: updateAccountRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });

    return UpdateAccountResponse.fromJson(response);
  }

  Future<ChangePasswordResponse> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    var response = await _apiService.put("user/change-password",
        data: changePasswordRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });

    return ChangePasswordResponse.fromJson(response);
  }

  Future logOut() async {
    await _apiService.post("user/logout", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    }).catchError((e) async {
      print(e.toString());
      await _hiveService.put<bool>(
          Constants.gaderBox, Constants.isLoggedIn, false);
      await _hiveService.put<String?>(
          Constants.gaderBox, Constants.token, null);
    });
    await _hiveService.put<bool>(
        Constants.gaderBox, Constants.isLoggedIn, false);
    await _hiveService.put<String?>(Constants.gaderBox, Constants.token, null);
  }

  //user/profile/change-avatar

  Future<ProfileResponse> changeAvatar(File image) async {
    String fileName = image.path.split('/').last;
    var response = await _apiService.post("user/profile/change-avatar",
        data: dio.FormData.fromMap({
          "image":
              await dio.MultipartFile.fromFile(image.path, filename: fileName),
        }),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });

    return ProfileResponse.fromJson(response);
  }
}
