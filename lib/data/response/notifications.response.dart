import 'package:gadeer/data/model/notification.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class NotificationsResponse with BaseResponse<NotificationModel> {
  NotificationsResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => NotificationModel.fromJson(item));
  }
}
