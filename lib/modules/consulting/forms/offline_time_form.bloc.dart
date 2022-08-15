import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/call.model.dart';
import 'package:gadeer/data/request/consulting/add_offline_time.request.dart';
import 'package:gadeer/data/response/consulting/consulting_action.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:get/get.dart';

class OfflineTimeForm extends FormBloc<ConsultingActionResponse, String>
    with FormValidateErrors {
  final ConsultingService consultingService = Get.find();
  final ConsultingBloc consultingBloc = Get.find();

  Duration? duration;

  final date = InputFieldBloc<DateTime, Object>(
    name: 'date',
  );

  final type = SelectFieldBloc(
      name: "type", initialValue: "phone", items: ["phone", "other"]);

  final other = TextFieldBloc(name: "other");
  late final CallModel? callModel;

  OfflineTimeForm(this.callModel) {
    addFieldBlocs(fieldBlocs: [date, type]);

    type.onValueChanges(onData: (_, __) async* {
      if (type.value == "phone") {
        removeFieldBloc(fieldBloc: other);
        other.clear();
      } else {
        addFieldBloc(fieldBloc: other);
      }
    });

    if (callModel != null) {
      if (callModel?.type != "phone") {
        type.updateValue("other");
        addFieldBloc(fieldBloc: other);
        other.updateValue(callModel?.typeText ?? "");
      } else {
        type.updateValue(type.value);
      }
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      if (callModel?.date != null) {
        date.updateInitialValue(dateFormat.parse(callModel?.date ?? ""));
      }
    }
  }

  @override
  void onSubmitting() async {
    if (type.value == null) {
      emitFailure(failureResponse: "يجب عليك اختيار نوع الاستشاره");
      return;
    }

    if (type.value == "other" && ((other.value?.isEmpty ?? false) == true)) {
      emitFailure(failureResponse: "يجب عليك تحديد نوع الاستشاره");
      return;
    }

     if (date.value==null) {
      emitFailure(failureResponse: "يجب عليك تحديد تاريخ الاستشاره");
      return;
    }

     if (duration?.inSeconds==0) {
      emitFailure(failureResponse: "يجب عليك تحديد مده الاستشاره");
      return;
    }


    if (callModel == null) {
      await _createOfflineTime();
    } else {
      _updateOfflineTime();
    }
  }

  Future<void> _createOfflineTime() async {
    await consultingService
        .addOfflineTime(
            consultingBloc.state.current?.id,
            AddOfflineTimeRequest(
                seconds: duration?.inSeconds ?? 0,
                date: date.value,
                type: type.value,
                other: other.value))
        .then((value) {
      if (value.status == 1) {
        emitSuccess(successResponse: value, canSubmitAgain: true);
      } else {
        handleValidateErrors(state, value.errors);
        emitFailure(failureResponse: "خطأ في اضافه الوقت");
      }
    }).catchError((e) {
      emitFailure(failureResponse: Constants.netError);
    });
  }

  Future<void> _updateOfflineTime() async {
    await consultingService
        .editOfflineTime(
            consultingBloc.state.current?.id ?? 0,
            callModel?.id ?? 0,
            AddOfflineTimeRequest(
                seconds: duration?.inSeconds ?? 0,
                date: date.value,
                type: type.value,
                other: other.value))
        .then((value) {
      if (value.status == 1) {
        emitSuccess(successResponse: value, canSubmitAgain: true);
      } else {
        emitFailure(failureResponse: "خطأ في تعديل البيانات");
        handleValidateErrors(state, value.errors);
      }
    }).catchError((e) {
      emitFailure(failureResponse: Constants.netError);
    });
  }

  void onSuccess(_, FormBlocSuccess<ConsultingActionResponse, Object> state) {
    consultingBloc.updateSyncConsulting(state.successResponse!.consulting!);
    Notifications.hideLoading();
    Get.back();
    if (callModel == null) {
      Notifications.success("تم اضافه الوقت");
    } else {
      Notifications.success("تم تعديل الوقت");
    }
    this.clear();
  }

  void onFailure(_, FormBlocFailure<ConsultingActionResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse.toString());
  }
}
