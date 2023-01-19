import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gadeer/data/request/profile/add_category_request.dart';
import 'package:gadeer/data/request/profile/profile_work.request.dart';
import 'package:gadeer/data/request/profile/section.request.dart';
import 'package:gadeer/data/request/profile/update_hour_price.request.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/data/response/profile/upload_file.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class ProfileService {
  final ApiService _apiService = Get.find();
  final HiveService _hiveService = Get.find();

  Future<ProfileResponse> getProfile() async {
    var response = await _apiService.get("user/profile", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> workCreate(
      ProfileWorkRequest profileWorkRequest) async {
    var response = await _apiService.post("user/profile/work-experience",
        data: profileWorkRequest.toMap(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> educationCreate(
      ProfileWorkRequest profileWorkRequest) async {
    var response = await _apiService.post("user/profile/education",
        data: profileWorkRequest.toMap(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> deleteEducation(int? id) async {
    var response =
        await _apiService.delete("user/profile/education/$id/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> deleteWorkExperience(int? id) async {
    var response = await _apiService
        .delete("user/profile/work-experience/$id/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> deleteCategory(int? id) async {
    var response =
        await _apiService.delete("user/profile/categories/delete", data: {
      "category": id
    }, headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> editEducation(
      int? id, ProfileWorkRequest profileWorkRequest) async {
    print(profileWorkRequest.toMap());
    var response = await _apiService.put("user/profile/education/$id",
        data: profileWorkRequest.toMap(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> editWorkExperience(
      int? id, ProfileWorkRequest profileWorkRequest) async {
    var response = await _apiService.put("user/profile/work-experience/$id",
        data: profileWorkRequest.toMap(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> editCategory(
      AddCategoryRequest addCategoryRequest) async {
    var response = await _apiService.post("user/profile/categories",
        data: addCategoryRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> addSection(SectionRequest sectionRequest) async {
    var response = await _apiService
        .post("user/profile/section", data: sectionRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> editSection(
      int? id, SectionRequest sectionRequest) async {
    var response = await _apiService.put("user/profile/section/$id",
        data: sectionRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> updateHourPrice(
      UpdateHourPriceRequest updateHourPriceRequest) async {
    var response = await _apiService.post("user/update-hour-price",
        data: updateHourPriceRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ProfileResponse.fromJson(response);
  }

  Future<ProfileResponse> deleteSection(int? id) async {
    var response =
        await _apiService.delete("user/profile/section/$id/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return ProfileResponse.fromJson(response);
  }

  Future<UploadFileResponse?> uploadFile(String key, PlatformFile file) async {
    var response = await _apiService.post("user/profile/upload-file",
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
                  ""),
        },
        data: dio.FormData.fromMap({
          "key": key,
          "file": await dio.MultipartFile.fromFile(file.path ?? "",
              filename: file.name)
        }));
    return UploadFileResponse.fromJson(response);
  }
}
