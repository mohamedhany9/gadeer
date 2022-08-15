import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/request/meeting/add_meeting.request.dart';
import 'package:gadeer/data/response/meeting/add_meeting.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/meeting/bloc/meeting_controller.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';

class MeetingEditFormBloc extends FormBloc<AddMeetingResponse, Object>
    with FormValidateErrors {
  int? consultingId;
  late MeetingModel meetingModel;

  final title = TextFieldBloc(
    name: 'title',
  );

  final description = TextFieldBloc(
    name: 'description',
  );

  final date = InputFieldBloc<DateTime, Object>(
    name: 'date',
  );

  final time = InputFieldBloc<TimeOfDay, Object>(
    name: 'time',
  );

  MeetingEditFormBloc(int? consultingId, MeetingModel meetingModel) : super() {
    addFieldBlocs(fieldBlocs: [title, description, date, time]);
    updateInitialValues(meetingModel);
    this.meetingModel = meetingModel;
    this.consultingId = consultingId;
  }

  updateInitialValues(MeetingModel meetingModel) {
    title.updateInitialValue(meetingModel.title);
    description.updateInitialValue(meetingModel.description);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    date.updateInitialValue(dateFormat.parse(meetingModel.date!));
    DateFormat timeF = DateFormat("hh:mm:ss");
    DateTime timeX = timeF.parse(meetingModel.time!);
    time.updateInitialValue(TimeOfDay(hour: timeX.hour, minute: timeX.minute));

    emitLoaded();
  }

  @override
  void onSubmitting() async {
    AddMeetingRequest addMeetingRequest = AddMeetingRequest(
      title: title.value,
      date: date.value,
      time: time.value,
      description: description.value,
    );

    await Get.find<MeetingService>()
        .updateMeeting(meetingModel.id, addMeetingRequest)
        .then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);

        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response, canSubmitAgain: true);
      }
    }).catchError((error) {
      emitFailure(failureResponse: error.toString());
    });
  }

  void onSuccess(_, FormBlocSuccess<AddMeetingResponse, Object> state) async {
    if (consultingId != null) {
      await Get.find<ConsultingBloc>().updateAsyncConsulting();
    }
    Notifications.hideLoading();

    Get.find<MeetingController>()
        .updateMeeting(state.successResponse!.meeting!);

    Notifications.success(state.successResponse!.message);
    this.clear();
  }

  void onFailure(_, FormBlocFailure<AddMeetingResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }
}
