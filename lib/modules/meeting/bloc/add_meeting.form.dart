import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/request/meeting/add_meeting.request.dart';
import 'package:gadeer/data/response/meeting/add_meeting.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';

class MeetingCreateFormBloc extends FormBloc<AddMeetingResponse, Object>
    with FormValidateErrors {
  int? consultingId;

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

  MeetingCreateFormBloc(int? consultingId) : super() {
    addFieldBlocs(fieldBlocs: [title, description, date, time]);
    this.consultingId = consultingId;
  }

  @override
  void onSubmitting() async {
    AddMeetingRequest addMeetingRequest = AddMeetingRequest(
      title: title.value,
      date: date.value,
      time: time.value,
      description: description.value,
      consultingId: consultingId,
    );

    await Get.find<MeetingService>()
        .addMeeting(addMeetingRequest)
        .then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);

        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response, canSubmitAgain: true);
        Get.find<FirebaseAnalytics>().logEvent(
            name: "add_meeting_success",
            parameters: addMeetingRequest.toJson());
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
    Get.back();
    Notifications.success(state.successResponse!.message);
    this.clear();
  }

  void onFailure(_, FormBlocFailure<AddMeetingResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }
}
