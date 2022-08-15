import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gadeer/data/request/consulting/end_consulting.request.dart';
import 'package:gadeer/data/response/consulting/consulting_action.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class CallService {
  final ApiService apiService = Get.find();
  final HiveService hiveService = Get.find();
  Future<ConsultingActionResponse> startConsulting(
      int? id, String video) async {
    var response =
        await apiService.post('consulting/$id/action/started', data: {
      'video': video
    }, headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    ConsultingActionResponse actionResponse =
        ConsultingActionResponse.fromJson(response);
    if (actionResponse.status == 1) {
      Get.find<FirebaseAnalytics>()
          .logEvent(name: "start_consulting", parameters: {
        "category_title": actionResponse.consulting!.categories!.first.title,
        "type": actionResponse.consulting!.type,
      });
    }
    return actionResponse;
  }

  Future<ConsultingActionResponse> endConsulting(
      int id, EndConsultingRequest endConsultingRequest) async {
    print("ending");
    print(endConsultingRequest.toJson());
    var response = await apiService.post('consulting/$id/action/ended',
        data: endConsultingRequest.toJson(),
        headers: {
          Constants.authorization: Constants.bearer +
              (await hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        });
    ConsultingActionResponse actionResponse =
        ConsultingActionResponse.fromJson(response);
    if (actionResponse.status == 1) {
      Get.find<FirebaseAnalytics>()
          .logEvent(name: "end_consulting", parameters: {
        "category_title": actionResponse.consulting!.categories!.first.title,
        "duration": endConsultingRequest.duration.toString(),
        "type": actionResponse.consulting!.type
      });
    }
    return actionResponse;
  }

  Future<ConsultingActionResponse> callRejected(String? id) async {
    var response =
        await apiService.post('consulting/$id/action/reject_call', headers: {
      Constants.authorization: Constants.bearer +
          (await hiveService.get<String>(Constants.gaderBox, Constants.token) ??
              "")
    });
    Get.find<FirebaseAnalytics>()
        .logEvent(name: "reject_call", parameters: {"consulting_id": id});
    return ConsultingActionResponse.fromJson(response);
  }
}
