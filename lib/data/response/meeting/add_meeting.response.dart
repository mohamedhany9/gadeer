import 'package:gadeer/data/model/meeting_model.dart';

import '../base.response.dart';

class AddMeetingResponse with BaseResponse {
  MeetingModel? meeting;
  AddMeetingResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["meeting"] != null) {
      meeting = MeetingModel.fromJson(json["meeting"]);
    }
  }
}
