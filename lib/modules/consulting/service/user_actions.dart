import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/request/consulting/add_comment.request.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/call/pages/call_page.dart';
import 'package:gadeer/modules/call/service/call.service.dart';
import 'package:gadeer/modules/chat/controller/chat_controller.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'consulting_service.dart';

class UserActions {
  static final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  static final AccountType accountType =
      Get.find<AccountBloc>().state.accountType!;


  static final ChatController chatController = Get.find();


  static Future acceptConsulting(int? id) async {
    Notifications.showLoading();
    await Get.find<ConsultingService>().acceptConsulting(id).then((value) async {
      Notifications.hideLoading();
      if (value.status == 1) {
        Notifications.success("تم قبول الاستشارة");
        //consultingBloc.updateSyncConsulting(value.consulting!);

        AddCommentRequest addCommentRequest =
        AddCommentRequest(message: "السلام عليكم ورحمة الله ,  أسعدني التواصل معك , تفضل باستشارتك الآن");

        chatController.addComment(consultingBloc.state.current!.id.toString(), addCommentRequest).then((value){

          Get.toNamed(
            Routes.chatPage,
            arguments: consultingBloc.state.current!.id.toString(),
          );

        });
      } else {
        Notifications.error(value.message ?? "");
      }
    }).catchError((e) {
      print(e.toString());
      Notifications.hideLoading();
      Notifications.error(Constants.netError);
    });
  }

  static Future rejectConsulting(int? id) async {
    Notifications.showLoading();
    await Get.find<ConsultingService>().rejectConsulting(id).then((value) {
      Notifications.hideLoading();
      if (value.status == 1) {
        Notifications.success("تم رفض الاستشارة");
        consultingBloc.updateSyncConsulting(value.consulting!);
      } else {
        Notifications.error(value.message ?? "");
      }
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }

  static Future startConsulting(bool video) async {
    Notifications.showLoading();
    String? toShow = accountType == AccountType.association
        ? consultingBloc.state.current!.consultant!.name
        : consultingBloc.state.current!.association!.name;
    await Get.find<CallService>()
        .startConsulting(consultingBloc.state.current!.id, video ? "1" : "0")
        .then((value) {
      Notifications.hideLoading();

      if (value.status == 1) {
        Get.to(
          CallPage({
            "id": consultingBloc.state.current?.id.toString(),
            "association_photo":
                consultingBloc.state.current?.association?.photo,
            "consultant_photo": consultingBloc.state.current?.consultant?.photo,
            "video": video ? "1" : "0"
          }),
        );
        Notifications.success(' تم بدء المكالمة وفي انتظار رد $toShow');
      } else {
        Notifications.error(value.message ?? "");
      }
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }
}
