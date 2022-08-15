import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class AllMeetingResponse with BaseResponse<MeetingModel?> {
  AllMeetingResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => MeetingModel.fromJson(item));
  }
}
