import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gadeer/data/request/meeting/add_meeting.request.dart';
import 'package:gadeer/data/response/meeting/add_meeting.response.dart';
import 'package:gadeer/data/response/meeting/all_meeting.response.dart';
import 'package:gadeer/data/response/meeting/delete_meeting.response.dart';
import 'package:gadeer/data/response/meeting/show_meeting.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class MeetingService {
  final ApiService _apiService = Get.find<ApiService>();
  final HiveService _hiveService = Get.find<HiveService>();

  Future<AllMeetingResponse> getMeetings() async {
    var response = await _apiService.get("meetings", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });

    return AllMeetingResponse.fromJson(response);
  }

  Future<AddMeetingResponse> addMeeting(
      AddMeetingRequest addMeetingRequest) async {
    var response = await _apiService
        .post("meetings", data: addMeetingRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });

    return AddMeetingResponse.fromJson(response);
  }

  Future<AddMeetingResponse> updateMeeting(
      int? id, AddMeetingRequest addMeetingRequest) async {
    var response = await _apiService
        .put("meetings/$id", data: addMeetingRequest.toJson(), headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });

    return AddMeetingResponse.fromJson(response);
  }

  Future<DeleteMeetingResponse> deleteMeeting(int? id) async {
    var response = await _apiService.delete("meetings/$id/delete", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    return DeleteMeetingResponse.fromJson(response);
  }

  Future<ShowMeetingResponse> showMeeting(int? id) async {
    var response = await _apiService.get("meetings/$id/show");
    return ShowMeetingResponse.fromJson(response);
  }

  Future<ShowMeetingResponse> startMeeting(int? id) async {
    var response =
        await _apiService.post("meetings/$id/action/started", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    ShowMeetingResponse show = ShowMeetingResponse.fromJson(response);
    if (show.status == 1) {
      print("should start meeting");
      Get.find<FirebaseAnalytics>().logEvent(name: "start_meeting");
    }
    return show;
  }

  Future<ShowMeetingResponse> endMeeting(
      int? id, int duration, String type) async {
    var response = await _apiService.post("meetings/$id/action/ended", data: {
      "duration": duration,
      "type": type
    }, headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    });
    ShowMeetingResponse show = ShowMeetingResponse.fromJson(response);
    if (show.status == 1) {
      print("should end meeting");
    }
    return show;
  }
}
