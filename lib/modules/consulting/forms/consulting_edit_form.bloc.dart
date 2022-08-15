import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/request/consulting/update_consulting.request.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:get/get.dart';

class ConsultingEditFormBloc extends FormBloc<AddConsultingResponse, Object>
    with FormValidateErrors {
  final ConsultingService _consultingService = Get.find();
  int? id;
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

  ConsultingEditFormBloc(ConsultingDetailsModel consultingDetailsModel)
      : super() {
    addFieldBlocs(
      fieldBlocs: [title, description, date, time],
    );
    loadInitialValues(consultingDetailsModel);
  }

  loadInitialValues(ConsultingDetailsModel consulting) {
    id = consulting.id;
    title.updateInitialValue(consulting.title);
    description.updateInitialValue(consulting.description);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    date.updateInitialValue(dateFormat.parse(consulting.date!));
    DateFormat timeF = DateFormat("hh:mm:ss");
    DateTime timeX = timeF.parse(consulting.time!);

    time.updateInitialValue(TimeOfDay(hour: timeX.hour, minute: timeX.minute));

    emitLoaded();
  }

  @override
  void onSubmitting() async {
    UpdateConsultingRequest updateConsultingRequest = UpdateConsultingRequest(
      title: title.value,
      date: date.value,
      time: time.value,
      description: description.value,
    );

    print(updateConsultingRequest.toJson());

    await _consultingService
        .updateConsulting(id, updateConsultingRequest)
        .then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);
        emitFailure(failureResponse: response.message);
      } else {
        Get.find<ConsultingBloc>().updateConsulting(response);
        emitSuccess(successResponse: response);
      }
    }).catchError((error) {
      emitFailure(failureResponse: error.toString());
    });
  }

  void onSuccess(_, FormBlocSuccess<AddConsultingResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.success(state.successResponse!.message);
  }

  void onFailure(_, FormBlocFailure<AddConsultingResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }

  @override
  Future<void> close() {
    title.close();
    description.close();
    date.close();

    time.close();
    return super.close();
  }
}
