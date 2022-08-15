import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/data/request/profile/profile_work.request.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

import '../profile.bloc.dart';

class WorkEditFormBloc extends FormBloc<ProfileResponse, Object>
    with FormValidateErrors {
  final ProfileService _profileService = Get.find();
  int? id;
  final title = TextFieldBloc(
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

  WorkEditFormBloc(WorkExperienceModel workExperienceModel)
      : super(isLoading: true) {
    addFieldBlocs(
      fieldBlocs: [title, description, place, from, to],
    );
    loadInitialValues(workExperienceModel);
  }

  void loadInitialValues(WorkExperienceModel workExperienceModel) {
    id = workExperienceModel.id;
    title.updateInitialValue(workExperienceModel.title);
    description.updateInitialValue(workExperienceModel.description);
    place.updateInitialValue(workExperienceModel.place);
    DateFormat dateFormat = DateFormat.yMd();
    try {
      from.updateInitialValue(dateFormat.parse(workExperienceModel.from!));
      to.updateInitialValue(dateFormat.parse(workExperienceModel.to!));
    } catch (e) {
      print(e.toString());
    }

    emitLoaded();
  }

  @override
  void onSubmitting() {
    ProfileWorkRequest profileWorkRequest = ProfileWorkRequest(
      title: title.value,
      description: description.value,
      place: place.value,
      from: from.value?.toString(),
      to: to.value?.toString(),
    );
    _profileService.editWorkExperience(id, profileWorkRequest).then((response) {
      if (response.status == 0) {
               handleValidateErrors(state, response.errors);

        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response);
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
  }

  void onFailure(_, FormBlocFailure<ProfileResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }

  @override
  Future<void> close() {
    title.close();
    description.close();
    place.close();
    from.close();
    to.close();
    return super.close();
  }
}
