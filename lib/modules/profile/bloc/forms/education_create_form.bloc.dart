import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/request/profile/profile_work.request.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

import '../profile.bloc.dart';

class EducationCreateFormBloc extends FormBloc<ProfileResponse, Object>
    with FormValidateErrors {
  final ProfileService _profileService = Get.find();
  final title = SelectFieldBloc<String, Object>(
    name: 'title',
  );

  final description = TextFieldBloc(
    name: 'description',
  );

  final place = TextFieldBloc(
    name: 'place',
  );

  final from = InputFieldBloc<DateTime, Object>(
    name: 'from',
  );
  final to = InputFieldBloc<DateTime, Object>(
    name: 'to',
  );

  EducationCreateFormBloc() : super() {
    addFieldBlocs(
      fieldBlocs: [title, description, place, from, to],
    );
    title.addItem("إبتدائي");
    title.addItem("متوسط");
    title.addItem("ثانوي");
    title.addItem("دبلوم");
    title.addItem("بكالوريوس");
    title.addItem("ماجستير");
    title.addItem("دكتوراة");
  }

  @override
  void onSubmitting() async {
    ProfileWorkRequest profileEducationRequest = ProfileWorkRequest(
      title: title.value,
      description: description.value,
      place: place.value,
      from: from.value?.toString(),
      to: to.value?.toString(),
    );
    await _profileService
        .educationCreate(profileEducationRequest)
        .then((response) {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);
        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response, canSubmitAgain: true);
        Get.find<ProfileBloc>().updateProfile(response.profile);
      }
    }).catchError((error) {
      emitFailure(failureResponse: error.toString());
    });
  }

  void onSuccess(_, FormBlocSuccess<ProfileResponse, Object> state) {
    Notifications.hideLoading();
    Get.back();
    Notifications.success(state.successResponse!.message);
    this.clear();
  }

  void onFailure(_, FormBlocFailure<ProfileResponse, Object> state) {
    print("should hide loading");
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }
}
