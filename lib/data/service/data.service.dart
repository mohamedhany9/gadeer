import 'package:gadeer/data/request/account/update_token.request.dart';
import 'package:gadeer/data/response/home/assosiation_sections.dart';
import 'package:gadeer/data/response/home/categories.response.dart';
import 'package:gadeer/data/response/home/cities.response.dart';
import 'package:gadeer/data/response/home/hour_prices.response.dart';
import 'package:gadeer/data/response/notifications.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class DataService {
  final ApiService apiService = Get.find();
  final HiveService hiveService = Get.find();

  Future<CategoriesResponse> getCategories() async {
    var response = await apiService.get('categories');
    return CategoriesResponse.fromJson(response);
  }

  Future<CitiesResponse> getAreas() async {
    var response = await apiService.get('areas');
    return CitiesResponse.fromJson(response);
  }
   Future<HourPricesResponse> getHourPrices() async {
    var response = await apiService.get('user/hour-prices');
    return HourPricesResponse.fromJson(response);
  }

  Future<AssosiatiosSectionsResponse> getSections() async {
    var response = await apiService.get('sections');
    return AssosiatiosSectionsResponse.fromJson(response);
  }


  Future<CitiesResponse> getCities({int? areaId}) async {
    var response = await apiService.get('areas/$areaId/cities');
    return CitiesResponse.fromJson(response);
  }

  Future<NotificationsResponse> getNotifications() async {
    var response = await apiService.get('user/notifications', headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return NotificationsResponse.fromJson(response);
  }

  Future refreshToken(UpdateTokenRequest updateTokenRequest) async {
    await apiService
        .put("user/fcm-token", data: updateTokenRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
  }

  
}
