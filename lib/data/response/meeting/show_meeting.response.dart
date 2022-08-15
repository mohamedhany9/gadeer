import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/response/base.response.dart';

import '../base.response.dart';

class ShowMeetingResponse with BaseResponse {
  MeetingModel? meetingModel;
  ShowMeetingResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["meeting"] != null) {
      meetingModel = MeetingModel.fromJson(json["meeting"]);
    }
  }
}
