import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/app/bloc/app.state.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/meeting/meeting_call/meeting_call.page.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final AppBloc _appBloc = Get.find<AppBloc>();
  @override
  void initState() {
    super.initState();
    _appBloc.initApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      bloc: _appBloc,
      listener: (context, state) {
        Future.delayed(Duration(seconds: 1), () async {
          if (state.meetingModel != null) {
            if (Get.find<AccountBloc>().state.user?.id ==
                state.meetingModel!.userId) {
              if (state.meetingModel!.status == "pending") {
                Get.find<MeetingService>()
                    .startMeeting(state.meetingModel!.id)
                    .then((value) async {
                  if (value.status == 1) {
                    await Get.to(MeetingCallPage(state.meetingModel))!
                        .then((value) {
                      SystemNavigator.pop();
                    });
                  }
                });
              }
            } else {
              if (state.meetingModel!.status == "started") {
                await Get.to(MeetingCallPage(state.meetingModel))!
                    .then((value) {
                  SystemNavigator.pop();
                });
              } else {
                await Get.defaultDialog(
                        title: "تنبيه",
                        content: Text(
                            "برجاء الانتظار لحين بدء الاجتماع من جهه الخبير"))
                    .then((value) {
                  SystemNavigator.pop();
                });
              }
            }
          } else {
            if (state.isLogin == true) {
              await Get.find<HomeController>().getHome();
              await Get.find<HomeController>().getDependencies();
              Get.offNamed(
                Routes.main,
              );
            } else {
              Get.offNamed(Routes.login);
            }
          }
        });
      },
      builder: (context, state) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Constants.logoFull,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(
                height: 30,
              ),
              SpinKitSquareCircle(
                color: AppColors.primary,
                size: 50.0,
                duration: Duration(milliseconds: 1200),
                // controller: AnimationController(
                //     vsync: this,
                //     duration: const Duration(milliseconds: 1200)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
