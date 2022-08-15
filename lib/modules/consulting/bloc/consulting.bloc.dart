import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/data/response/consulting/all_consulting.response.dart';
import 'package:gadeer/data/response/consulting/delete_consulting.response.dart';
import 'package:gadeer/data/response/consulting/show_consulting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.state.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';

class ConsultingBloc extends Cubit<ConsultingState> {
  final ConsultingService _consultingService = Get.find();

  ConsultingBloc() : super(ConsultingState(allConsults: [])) {
    getAllConsultantings();
  }

  Future getAllConsultantings() async {
    AllConsultingResponse allConsultingResponse =
        await _consultingService.getAllConsults().catchError((e) {
      Notifications.error(Constants.netError);
    });

    emit(state.copyWith(
        initialIndex: 0,
        allConsults: allConsultingResponse.consultings ?? [],
        consultingStates: allConsultingResponse.consultingStates ?? []));
  }

  showConsulting(int id, {bool goToPage = true}) async {
    if (id == state.current?.id) {
      Get.toNamed(Routes.consultingDetails);
    } else if (goToPage) {
      Notifications.showLoading();
    }

    ShowConsultingResponse? showConsultingResponse;
    await _consultingService.showConsult(id).then((res) {
      if (id != state.current?.id && goToPage) {
        Notifications.hideLoading();
      }
      showConsultingResponse = res;
    }).catchError((e) {
      if (id != state.current?.id && goToPage) {
        Notifications.hideLoading();
      }

      Notifications.error(Constants.netError);
    });

    Get.find<FirebaseAnalytics>()
        .logEvent(name: "show_consulting", parameters: {
      "category_title":
          // ignore: null_aware_in_condition
          showConsultingResponse
                      ?.consultingDetailsModel?.categories?.isNotEmpty ==
                  true
              ? showConsultingResponse
                  ?.consultingDetailsModel?.categories?.first.title
              : "",
    });

    emit(state.copyWith(
        current: showConsultingResponse!.consultingDetailsModel,
        meetings: showConsultingResponse!.consultingDetailsModel?.meetings));

    if (showConsultingResponse?.status == 1 && goToPage) {
      Get.toNamed(Routes.consultingDetails);
    }
  }

  updateConsulting(AddConsultingResponse updateConsulting) async {
    Notifications.hideLoading();
    ConsultingModel? consultingModel = state.allConsults!.firstWhere(
        (element) => element!.id == updateConsulting.consulting!.id);
    int index = state.allConsults!.indexOf(consultingModel);
    state.allConsults![index] = updateConsulting.consulting;
    emit(state);
    Get.back();
    Get.back();
  }

  deleteConsulting(int id) async {
    Notifications.showLoading();
    DeleteConsultingResponse? deleteConsultingResponse;
    await _consultingService.deleteConsulting(id).then((res) {
      Notifications.hideLoading();
      deleteConsultingResponse = res;
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });

    if (deleteConsultingResponse?.status == 1) {
      print("should delete");
      Get.find<FirebaseAnalytics>()
          .logEvent(name: "delete_consulting", parameters: {
        "type": state.current?.type,
      });
      emit(state.copyWith(
          allConsults: state.allConsults!
            ..removeWhere((element) => element!.id == id)));
      Get.back();
    }
  }

  updateSyncConsulting(ConsultingDetailsModel? consultingDetailsModel) {
    if (consultingDetailsModel != null) {
      emit(state.copyWith(current: consultingDetailsModel));
      Get.find<HomeController>().updateConsulting(state.allConsults!
          .firstWhere((element) => element?.id == state.current?.id)!);
    }
    getAllConsultantings();
  }

  updateAsyncConsulting() async {
    await _consultingService.showConsult(state.current?.id ?? 0).then((value) {
      if (value.status == 1) {
        emit(state.copyWith(current: value.consultingDetailsModel));
      }
    });
  }

  // addMeeting(MeetingModel meetingModel) async {
  //   List<MeetingModel?> meetings = <MeetingModel?>[];
  //   meetings.addAll(this.state.meetings!);
  //   meetings.add(meetingModel);

  //   emit(state.copyWith(meetings: meetings));
  // }

  // editMeeting(MeetingModel? meetingModel) async {
  //   int index = state.meetings!
  //       .indexWhere((element) => element?.id == meetingModel?.id);
  //   List<MeetingModel?> meetings = <MeetingModel?>[];
  //   meetings.addAll(this.state.current?.meetings ?? []);

  //   meetings[index] = meetingModel;

  //   emit(state.copyWith(meetings: meetings));
  // }

  deleteMeeting(int id) async {
    Notifications.showLoading();

    await Get.find<MeetingService>().deleteMeeting(id).then((value) async {
      if (value.status == 1) {
        await updateAsyncConsulting();
      }
      Notifications.hideLoading();
      Get.back();
    }).catchError((e) {
      Notifications.hideLoading();
      print(e.toString());
    });
  }

  refreshConsultingEvent() async {
    Notifications.showLoading();
    ShowConsultingResponse? showConsultingResponse;
    await _consultingService.showConsult(state.current?.id).then((value) {
      Notifications.hideLoading();

      showConsultingResponse = value;
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });

    emit(state.copyWith(
        current: showConsultingResponse?.consultingDetailsModel,
        meetings: showConsultingResponse?.consultingDetailsModel?.meetings));
  }

  changeIndex(String status) async {
    emit(state.copyWith(
        initialIndex: this
                .state
                .consultingStates
                ?.lastIndexWhere((element) => element?.status == status) ??
            0));
  }
}
