import 'package:gadeer/data/model/notification.model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  List<NotificationModel>? notifications;
  DataService _dataService = Get.find<DataService>();

  Future getNotifications() async {
    await _dataService.getNotifications().then((value) {
      notifications = value.data;
    }).catchError((e) {
      print(e.toString());
      Notifications.error(Constants.netError);
    });

    update();
  }
}
