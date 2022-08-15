import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notification_helper.dart';
import 'package:gadeer/modules/account/account.page.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/app/bloc/app.state.dart';
import 'package:gadeer/modules/consulting/consulting.page.dart';
import 'package:gadeer/modules/home/home.page.dart';
import 'package:gadeer/modules/profile/profile.page.dart';
import 'package:get/get.dart';

import 'master.layout.dart';

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final AppBloc _appBloc = Get.find<AppBloc>();
  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then((event) async {
      if (event != null) {
        NotificationService.handleOnAppOpenedNotification(event);
      }
    });

    FirebaseMessaging.onMessage.listen((event) async {
      String? routeName = ModalRoute.of(context)!.settings.name;
      NotificationService.handleOnMessageNotification(event, routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      bloc: _appBloc,
      buildWhen: (p, c) => p.currentPage != c.currentPage,
      builder: (context, state) => MasterLayout(
        body: BlocBuilder<AppBloc, AppState>(
            bloc: _appBloc,
            buildWhen: (p, c) => p.currentPage != c.currentPage,
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
                  child: IndexedStack(
                    index: state.currentPage,
                    children: [
                      HomePage(),
                      ConsultingPage(),
                      ProfilePage(),
                      AccountPage(),
                    ],
                  ),
                )),
      ),
    );
  }
}
