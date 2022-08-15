import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gadeer/data/request/consulting/add_consulting.request.dart';
import 'package:gadeer/data/request/consulting/add_offline_time.request.dart';
import 'package:gadeer/data/request/consulting/add_rate.request.dart';
import 'package:gadeer/data/request/consulting/search_consult.request.dart';
import 'package:gadeer/data/request/consulting/update_consulting.request.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/data/response/consulting/all_consulting.response.dart';
import 'package:gadeer/data/response/consulting/consulting_action.response.dart';
import 'package:gadeer/data/response/consulting/consultant_search.response.dart';
import 'package:gadeer/data/response/consulting/delete_consulting.response.dart';
import 'package:gadeer/data/response/consulting/show_consulting.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class ConsultingService {
  final ApiService apiService = Get.find();
  final HiveService hiveService = Get.find();

  Future<AddConsultingResponse> addConsult(
      AddConsultRequest addConsultRequest) async {
    var response = await apiService
        .post("consulting/create", data: addConsultRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });

    return AddConsultingResponse.fromJson(response);
  }

  Future<AllConsultingResponse> getAllConsults() async {
    var response = await apiService.get("v2/consulting", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });

    return AllConsultingResponse.fromJson(response);
  }

  Future<ShowConsultingResponse> showConsult(int? id) async {
    var response = await apiService.get("consulting/$id", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return ShowConsultingResponse.fromJson(response);
  }

  Future<DeleteConsultingResponse> deleteConsulting(int? id) async {
    var response = await apiService.delete("consulting/$id/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return DeleteConsultingResponse.fromJson(response);
  }

  Future<AddConsultingResponse> updateConsulting(
      int? id, UpdateConsultingRequest updateConsultingRequest) async {
    var response = await apiService.put("consulting/$id/update",
        data: updateConsultingRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });

    return AddConsultingResponse.fromJson(response);
  }

  Future<ConsultantSearchResponse> searchConsulting(
      ConsultingSearchRequest consultingSearchRequest) async {
    print(consultingSearchRequest.toJson());
    var response = await apiService.post("user/profile/search",
        data: consultingSearchRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });

    return ConsultantSearchResponse.fromJson(response);
  }

  Future<ConsultingActionResponse> acceptConsulting(int? id) async {
    var response =
        await apiService.post("consulting/$id/action/accepted", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });

    ConsultingActionResponse actionResponse =
        ConsultingActionResponse.fromJson(response);
    if (actionResponse.status == 1) {
      Get.find<FirebaseAnalytics>()
          .logEvent(name: "accept_consulting", parameters: {
        "category_title": actionResponse.consulting!.categories!.first.title,
        "type": actionResponse.consulting!.type
      });
    }
    return actionResponse;
  }

  Future<ConsultingActionResponse> rejectConsulting(int? id) async {
    var response =
        await apiService.post("consulting/$id/action/rejected", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });

    ConsultingActionResponse actionResponse =
        ConsultingActionResponse.fromJson(response);
    if (actionResponse.status == 1) {
      Get.find<FirebaseAnalytics>()
          .logEvent(name: "reject_consulting", parameters: {
        "category_title": actionResponse.consulting!.categories!.first.title,
        "type": actionResponse.consulting!.type
      });
    }
    return actionResponse;
  }

  Future<ConsultingActionResponse> addRate(
      int? id, AddRateRequest addRateRequest) async {
    var response = await apiService
        .post("consulting/$id/rate", data: addRateRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return ConsultingActionResponse.fromJson(response);
  }

  Future<ConsultingActionResponse> addOfflineTime(
      int? id, AddOfflineTimeRequest addOfflineTimeRequest) async {
    print(addOfflineTimeRequest.toJson());
    var response = await apiService.post("consulting/$id/calls",
        data: addOfflineTimeRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ConsultingActionResponse.fromJson(response);
  }

  Future<ConsultingActionResponse> editOfflineTime(
      int? id, int callId, AddOfflineTimeRequest addOfflineTimeRequest) async {
    print(addOfflineTimeRequest.toJson());
    print(id);
    var response = await apiService.post("consulting/$id/calls/$callId/update",
        data: addOfflineTimeRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    return ConsultingActionResponse.fromJson(response);
  }

  Future<ConsultingActionResponse> deleteOfflineTime(
      int? id, int callId) async {
    var response =
        await apiService.post("consulting/$id/calls/$callId/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    return ConsultingActionResponse.fromJson(response);
  }
}
