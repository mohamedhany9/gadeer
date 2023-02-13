import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gadeer/data/model/comment_model.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/call/pages/call_page.dart' as call;
import 'package:gadeer/modules/call/pages/call_page.dart';
import 'package:gadeer/modules/call/service/call.service.dart';
import 'package:gadeer/modules/chat/controller/chat_controller.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'notifications.dart';

class NotificationService {
  static Future handleOnMessageNotification(
      RemoteMessage event, String? routeName) async {
    if (event.data['type'] == 'call') {
      if (call.inCall == false) {
        showCallDialog(event);
      } else {
        await Get.find<CallService>().callRejected(event.data['id']);
      }
    } else if (event.data['type'] == 'call_rejected') {
      Get.back();
      Notifications.error("تم رفض المكالمه");
    } else if (event.data["type"] == "comment") {
      if (Get.currentRoute != "/chatPage") {
        Notifications.fromRemoteNotification(
            event.notification!.title!, event.notification!.body!, onTap: () {
          Get.toNamed(Routes.chatPage, arguments: event.data["consulting_id"]);
        });
      } else {
        NotificationService.chatMessageRecieved(event);
      }
    } else if (event.data['type'] == 'consulting') {
      Notifications.fromRemoteNotification("اشعار", "تم اضافة استشارة جديدة");
      Get.find<ConsultingBloc>().getAllConsultantings();
    } else if (event.data['type'] == 'consulting_action') {
      if (event.data["action"] == "accepted") {
        Notifications.fromRemoteNotification("اشعار", "تم قبول الاستشارة");
      } else {
        Notifications.fromRemoteNotification("اشعار", "تم رفض الاستشارة");
      }
    } else if (event.data['type'] == 'rate') {
      Notifications.fromRemoteNotification(
          event.notification!.title ?? "", event.notification!.body!);
    } else if (event.data['type'] == 'meeting_started') {
      Notifications.fromRemoteNotification(
          event.notification!.title ?? "", event.notification!.body!);
    } else if (event.data["type"] == "account") {
      if (event.data["status"] == "not_active") {
        Get.find<AppBloc>().logout();
      } else {
        Get.find<AccountBloc>().updateAccountAsync();
      }
      Notifications.fromRemoteNotification(
          event.notification!.title ?? "", event.notification!.body!);
    }
  }

  static Future handleOnAppOpenedNotification(RemoteMessage event) async {
    if (event.data["type"] == "call") {
      Get.to(
        call.CallPage(event.data),
      );
    } else if (event.data["type"] == "comment") {
      Get.toNamed(Routes.chatPage, arguments: event.data["consulting_id"]);
    }
    // else if (event.data["type"] == "consulting") {
    //   print("hany");
    //   print(event.data);
    //   print(event.data["id"]);
    //   Get.toNamed(Routes.consultingDetails, arguments: event.data["id"]);
    // }


    // else if (event.data['type'] == 'meeting_started') {
    //   Get.to(MeetingCallPage(int.parse(event.data["id"]), false));
    // }
  }

  static void chatMessageRecieved(RemoteMessage message) async {
    if (message.data["type"] == "comment") {
      print("remote message");
      print("firebase notification recieved");
      Get.find<ChatController>()
          .addCommentFromNotification(CommentModel.fromJson(message.data));
    }
  }

  static void showCallDialog(RemoteMessage event) async {
    final player = AudioPlayer();
    await player.setAsset('assets/audios/call_tone.mp3');
    player.play();

    print(event.data);
    Notifications.confirmDialog(
        title: "مكالمة واردة",
        content: "الرد علي المكالمة",
        cancelText: "لا",
        confirmText: "نعم",
        dismissible: false,
        onCancel: () async {
          await player.stop();
          await Get.find<CallService>().callRejected(event.data['id']);
          player.dispose();
        },
        onConfirm: () async {
          await player.stop();
          player.dispose();
          Get.find<FirebaseAnalytics>().logEvent(
              name: "accept_call",
              parameters: {"consulting_id": event.data['id']});
          Get.to(CallPage(event.data));
        });

    await Future.delayed(Duration(seconds: 20), () async {
      await player.stop();
      player.dispose();
    });
  }
}
