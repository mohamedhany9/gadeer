import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/data/request/account/update_token.request.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/app/bloc/app.state.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/meeting/meeting_call/meeting_call.page.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';

class AppBloc extends Cubit<AppState> {
  final HiveService hiveService = Get.find();

  AppBloc()
      : super(AppState(
          isLogin: true,
          currentPage: 0,
        ));

  initApp() async {
    UserModel? user;
    bool isLogin = await this.hiveService.get<bool>(
              Constants.gaderBox,
              Constants.isLoggedIn,
            ) ??
        false;
    print("reach $isLogin");
    if (isLogin) {
      print("reach here");
      await Get.find<AccountService>().getAccount().then((value) async {
        user = value.user;
        FirebaseCrashlytics.instance.setUserIdentifier(user?.phone ?? "");
        Get.find<FirebaseAnalytics>().setUserId((user?.phone ?? ""));
        Get.find<FirebaseAnalytics>()
            .setUserProperty(name: "name", value: user?.fullName ?? "");

        Get.find<FirebaseAnalytics>().logEvent(name: "init_app");

        Get.find<DataService>().refreshToken(
            UpdateTokenRequest(await FirebaseMessaging.instance.getToken()));
      }).catchError((e) {
        print(e.toString());
      });
    }

    if (user == null) {
      this
          .hiveService
          .put<bool>(Constants.gaderBox, Constants.isLoggedIn, false);
      this.hiveService.put<String?>(Constants.gaderBox, Constants.token, null);
    }
    MeetingModel? meetingModel = await initDynamicLinks();
    if (user?.isActive == false) {
      user = null;
      Get.find<AccountService>().logOut();
      Notifications.error("نأسف لقد تم حظر حسابك مؤقتا");
    }
    Get.find<AccountBloc>().initAccount(user);
    emit(state.copyWith(isLogin: user != null, meetingModel: meetingModel));
  }

  changePage(int index) async {
    emit(state.copyWith(currentPage: index));
  }

  successLogin(LoginResponse? response) async {
    await this
        .hiveService
        .put<bool>(Constants.gaderBox, Constants.isLoggedIn, true);
    await this.hiveService.put<String?>(
        Constants.gaderBox, Constants.token, response!.accessToken);
    Get.find<DataService>().refreshToken(
        UpdateTokenRequest(await FirebaseMessaging.instance.getToken()));

    FirebaseCrashlytics.instance.setUserIdentifier(response.user!.phone!);
    Get.find<FirebaseAnalytics>().setUserId((response.user!.phone));

    emit(state.copyWith(
      isLogin: true,
      accessToken: response.accessToken,
      currentPage: 0,
    ));

    Get.find<AccountBloc>().initAccount(response.user);
    await Get.find<HomeController>().getHome();
    await Get.find<HomeController>().getDependencies();
    Notifications.hideLoading();
    Get.offAllNamed(Routes.main);
  }

  logout() async {
    Get.find<AccountService>().logOut();
    Get.offAllNamed(Routes.login);
  }

  Future<MeetingModel?> initDynamicLinks() async {
    MeetingModel? meetingModel;
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      print("link from success");
      final Uri? deepLink = dynamicLink?.link;
      int id = int.parse(deepLink?.path.split("/").last ?? "0");

      await Get.find<MeetingService>().showMeeting(id).then((value) {
        meetingModel = value.meetingModel;
        if (value.meetingModel!.status == "started") {
          Get.to(MeetingCallPage(value.meetingModel));
        } else if (value.meetingModel!.status == "pending") {
          Get.defaultDialog(
              title: "تنبيه",
              content: Text("برجاء الانتظار لحين بدء الاجتماع من جهه الخبير"));
        } else {
          Get.defaultDialog(
              title: "تنبيه", content: Text("تم الانتهاء من الاجتماع"));
        }
      });
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    PendingDynamicLinkData? data;
    try {
      data = await FirebaseDynamicLinks.instance.getInitialLink();
    } catch (e) {}

    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print("link from get initial link");
      int id = int.parse(deepLink.path.split("/").last);

      await Get.find<MeetingService>().showMeeting(id).then((value) {
        meetingModel = value.meetingModel;
        if (value.meetingModel!.status == "started") {
          Get.to(MeetingCallPage(value.meetingModel));
        } else {
          Get.defaultDialog(
              title: "تنبيه",
              content: Text("برجاء الانتظار لحين بدء الاجتماع من جهه الخبير"));
        }
      });
    }
    return meetingModel;
  }
}
