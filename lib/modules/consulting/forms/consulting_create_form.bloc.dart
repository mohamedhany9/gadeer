import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/request/consulting/add_consulting.request.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:get/get.dart';

class ConsultingCreateFormBloc extends FormBloc<AddConsultingResponse, Object>
    with FormValidateErrors {
  final ConsultingService _consultingService = Get.find();
  ProfileModel? consultant;
  final title = TextFieldBloc(
    name: 'title',
  );

  final description = TextFieldBloc(
    name: 'description',
  );

  // final date = InputFieldBloc<DateTime, Object>(
  //   name: 'date',
  // );

  // final time = InputFieldBloc<TimeOfDay, Object>(
  //   name: 'time',
  // );

  final category = SelectFieldBloc<CategoryModel, Object>(name: 'category');
  final subCategory =
      SelectFieldBloc<CategoryModel, Object>(name: 'subCategory');

  ConsultingCreateFormBloc() {
    addFieldBlocs(
      fieldBlocs: [title, description, category],
    );
    initData();
  }

  void initializeConsultant(ProfileModel? pro) {
    this.consultant = pro;
  }

  void updateConsultant(ProfileModel pro) {
    this.consultant = pro;
  }

  void initData() {
    final HomeController _homeController = Get.find();

    category.updateItems(_homeController.categories);

    category.onValueChanges(onData: (p, current) async* {
      if (current.value != null) {
        if (current.value!.children!.isEmpty) {
          this.removeFieldBloc(fieldBloc: this.subCategory);
        } else {
          this.addFieldBloc(fieldBloc: this.subCategory);
          subCategory.updateItems(current.value!.children);
        }
      }
    });
  }

  @override
  void onSubmitting() async {
    List<int?> selctedCats = [];
    if (category.value != null) {
      selctedCats.add(category.value?.id);
      if (subCategory.value != null) {
        selctedCats.add(subCategory.value?.id);
      }
    } else {
      emitFailure(failureResponse: "يجب عليك اختيار مجال الاستشاره");
      return;
    }
    print(category.value?.title);
    // if (category.value?.id != 16 && consultant == null) {
    //   emitFailure(
    //       failureResponse: "يجب اختيار الاستشاري");
    //   return;
    // }

    if (category.value?.id != 16) {
      emitFailure(
          failureResponse: "يجب اختيار الاستشاري");
      return;
    }

    AddConsultRequest addConsultRequest = AddConsultRequest(
      title: title.value,
      categories: selctedCats,
      consultantId: consultant?.id,
      description: description.value,
      type: "_private",
    );
    print(addConsultRequest.toJson());

    await _consultingService
        .addConsult(addConsultRequest)
        .then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);

        emitFailure(failureResponse: response.message);
      } else {
        Get.find<FirebaseAnalytics>()
            .logEvent(name: "create_consulting", parameters: {
          "category_title": addConsultRequest.title,
          "type": addConsultRequest.type,
          "consultant_id": consultant?.id.toString() ?? "private"
        });
        emitSuccess(successResponse: response, canSubmitAgain: true);
      }
    }).catchError((error) {
      emitFailure(failureResponse: error.toString());
    });
  }

  void onSuccess(_, FormBlocSuccess<AddConsultingResponse, Object> state) {
    Notifications.hideLoading();
    Get.find<ConsultingBloc>().getAllConsultantings();
    Get.back();
    if (consultant != null) {
      Get.back();
    }
    Notifications.success(state.successResponse!.message);
    this.clear();
  }

  void onFailure(_, FormBlocFailure<AddConsultingResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }
}
