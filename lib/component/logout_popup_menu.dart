import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:get/get.dart';

enum Actions { logout }

class LogoutPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Actions>(
      onSelected: handleMenuActions,
      offset: Offset(0, 40),
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: Actions.logout,
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.powerOff,
                  color: Colors.blueGrey[300],
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        ];
      },
    );
  }

  void handleMenuActions(Actions action) {
    if (action == Actions.logout) {
      Notifications.confirmDialog(
          title: "تسجيل الخروج",
          content: "هل أنت متأكد من رغبتك بتسجيل الخروج",
          cancelText: "تأكيد",
          confirmText: "إلغاء",
          onCancel: () {
            Get.find<AppBloc>().logout();
          });
    }
  }
}
