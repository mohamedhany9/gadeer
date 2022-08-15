import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notification_helper.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/call/service/call.service.dart';
import 'package:gadeer/modules/chat/controller/chat_controller.dart';
import 'package:gadeer/modules/chat/service/chat_service.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/home/service/home.service.dart';
import 'package:gadeer/modules/login/service/login.service.dart';
import 'package:gadeer/modules/meeting/bloc/meeting_controller.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:gadeer/modules/notifications/controller/notifications_controller.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:gadeer/modules/search_consultants/controller/search_consultants.controller.dart';
import 'package:gadeer/modules/show_associations/controller/show_associations.controller.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

Future<void> _callHandler(RemoteMessage message) async {
  if (message.data["type"] != "call") {
    return;
  }
  await Firebase.initializeApp();

  print("Handling a background message: ${message.data}");
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    //services
    Get.put(ApiService(), permanent: true);
    Get.put(HiveService(), permanent: true);

    Get.lazyPut(() => DataService(), fenix: true);
    Get.lazyPut(() => CallService(), fenix: true);

    Get.lazyPut(() => HomeService(), fenix: true);

    Get.lazyPut(() => AccountService(), fenix: true);
    Get.lazyPut(() => ChatService(), fenix: true);
    Get.lazyPut(() => LoginService(), fenix: true);
    Get.lazyPut(() => RegisterService(), fenix: true);
    Get.lazyPut(() => ConsultingService(), fenix: true);
    Get.lazyPut(() => ProfileService(), fenix: true);
    Get.lazyPut(() => MeetingService(), fenix: true);

    //controllers

    Get.lazyPut<NotificationsController>(() => NotificationsController(),
        fenix: true);

    Get.lazyPut<MeetingService>(() => MeetingService(), fenix: true);
    Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);

    //put the blocs

    Get.put(AppBloc(), permanent: true);
    Get.put(AccountBloc(), permanent: true);
    Get.lazyPut(() => ConsultingBloc(), fenix: true);
    Get.lazyPut(() => ProfileBloc(), fenix: true);
    Get.lazyPut(() => RegisterBloc(), fenix: true);

    //perminant controllers
    Get.put<ChatController>(ChatController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<SearchConsultantsController>(SearchConsultantsController(),
        permanent: true);
    Get.put<ShowAssociationsController>(ShowAssociationsController(),
        permanent: true);
  }

  static Future initAsyncDependencies() async {
    await HiveService.init();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: true,
        statusBarColor: AppColors.primary));
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {}

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      NotificationService.handleOnAppOpenedNotification(event);
    });
    Get.put(FirebaseAnalytics(), permanent: true);

    FirebaseMessaging.onBackgroundMessage(_callHandler);

    Get.put(FirebaseAnalytics(), permanent: true);
  }
}
