import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/packages/bottom_navy_bar.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

class MasterLayout extends StatefulWidget {
  final Widget? body;
  final EdgeInsets contentPadding;
  const MasterLayout(
      {Key? key, this.body, this.contentPadding = const EdgeInsets.all(20)})
      : super(key: key);

  @override
  _MasterLayoutState createState() => _MasterLayoutState();
}

class _MasterLayoutState extends State<MasterLayout> {
  bool isDialogShowed = false;
  final AppBloc _appBloc = Get.find();
  Future<bool> onWillPop() async {
    final AppBloc appBloc = Get.find();
    if (appBloc.state.currentPage != 0) {
      appBloc.changePage(0);
      return false;
    }
    Notifications.confirmDialog(
        title: 'تنبيه!',
        content: 'هل تريد الخروج من التطبيق؟',
        cancelText: 'نعم',
        confirmText: 'لا',
        onCancel: () {
          SystemNavigator.pop();
        });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: _appBloc.state.currentPage,
            backgroundColor: Colors.white,
            onItemSelected: (index) => _appBloc.changePage(index),
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text('الرئيسية'),
                  inactiveColor: Colors.blueGrey,
                  activeColor: Colors.white,
                  activeBackgroundColor: AppColors.primary),
              BottomNavyBarItem(
                  icon: Icon(FontAwesomeIcons.commentDots),
                  title: Text("الاستشارات"),
                  inactiveColor: Colors.blueGrey,
                  activeColor: Colors.white,
                  activeBackgroundColor: AppColors.primary),
              BottomNavyBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  title: FittedBox(
                    child: AutoSizeText(
                      "الملف الشخصي",
                      maxFontSize: 16,
                      style: TextStyles.subTitle.copyWith(color: Colors.white),
                      minFontSize: 10,
                    ),
                  ),
                  inactiveColor: Colors.blueGrey,
                  activeColor: Colors.white,
                  activeBackgroundColor: AppColors.primary),
              BottomNavyBarItem(
                  icon: Icon(Icons.account_box),
                  title: Text("حسابي"),
                  inactiveColor: Colors.blueGrey,
                  activeColor: Colors.white,
                  activeBackgroundColor: AppColors.primary),
            ],
          ),
          body: UpgradeAlert(
            messages: UpgraderMessages(code: 'ar'),
            showIgnore: false,
            durationToAlertAgain: Duration(hours: 6),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: widget.body,
            ),
          )),
    );
  }
}
