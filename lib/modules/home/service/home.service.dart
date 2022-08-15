import 'package:gadeer/data/response/consulting/get_users.response.dart';
import 'package:gadeer/data/response/home/home.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class HomeService {
  final ApiService apiService = Get.find();
  final HiveService hiveService = Get.find();

  Future<GetUsersResponse> getUsers() async {
    var response = await apiService.get("users", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return GetUsersResponse.fromJson(response);
  }

  Future<HomeResponse> getHome() async {
    var response = await apiService.get("v2/home", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return HomeResponse.fromJson(response);
  }
}
