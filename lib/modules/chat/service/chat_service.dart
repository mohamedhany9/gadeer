import 'package:dio/dio.dart' as dio;
import 'package:gadeer/data/request/consulting/add_comment.request.dart';
import 'package:gadeer/data/response/consulting/add_comment.response.dart';
import 'package:gadeer/data/response/consulting/get_comment.response.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:get/get.dart';

class ChatService {
  ApiService _apiService = Get.find<ApiService>();
  HiveService _hiveService = Get.find<HiveService>();

//get comments

  Future<GetCommentResponse> getComments(String? id) async {
    var response = await _apiService.get("consulting/$id/comments", headers: {
      Constants.authorization: Constants.bearer +
          (await _hiveService.get<String>(
                  Constants.gaderBox, Constants.token) ??
              "")
    }).catchError((e) {
      Notifications.error(Constants.netError);
    });

    return GetCommentResponse.fromJson(response);
  }

//add comment
  Future<AddCommentResponse> addComment(
      String? id, AddCommentRequest addComment) async {
    var response = await _apiService.post("consulting/$id/comments/create",
        data: dio.FormData.fromMap(await addComment.toJson()),
        headers: {
          Constants.authorization: Constants.bearer +
              (await _hiveService.get<String>(
                      Constants.gaderBox, Constants.token) ??
                  "")
        }).catchError((e) {
      Notifications.error(Constants.netError);
    });
    return AddCommentResponse.fromJson(response);
  }
}
