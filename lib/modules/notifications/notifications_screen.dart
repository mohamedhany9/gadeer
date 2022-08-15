import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/notification.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

import 'controller/notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  final NotificationsController notificationsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar("الاشعارات"),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(
                Constants.background1,
              ),
            ),
          ),
          child: GetBuilder<NotificationsController>(initState: (_) {
            notificationsController.getNotifications();
          }, builder: (_) {
            if (notificationsController.notifications == null) {
              return Center(
                child: SpinKitFadingCube(
                  color: AppColors.primary,
                  size: 30.0,
                  duration: Duration(milliseconds: 1000),
                ),
              );
            } else {
              if (notificationsController.notifications!.isEmpty) {
                return _buildEmptyText();
              } else {
                return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: notificationsController.notifications!.length,
                    itemBuilder: (c, i) {
                      return _buildNotificationItem(
                          notificationsController.notifications![i]);
                    });
              }
            }
          }),
        ));
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Center(
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(notification.message!),
    );
  }

  _buildEmptyText() {
    return Center(
      child: SizedBox(
        width: Get.width * .6,
        child: Text(
          "لا يوجد لديك اشعارات",
          textAlign: TextAlign.center,
          style: TextStyles.subTitle,
        ),
      ),
    );
  }
}
