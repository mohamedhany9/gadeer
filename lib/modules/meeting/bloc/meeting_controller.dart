import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/meeting/pages/show_meeting.page.dart';
import 'package:get/get.dart';

class MeetingController extends GetxController {
  MeetingModel? current;

  showMeeting(int? consultingId, MeetingModel? meetingModel) {
    current = meetingModel;
    Get.to(ShowMeetingPage(consultingId, meetingModel));
  }

  updateMeeting(MeetingModel meetingModel) {
    current = meetingModel;
    update();
    Get.back();
  }
}
