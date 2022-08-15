class NotificationModel {
  String? id;
  String? message;
  String? createdAt;

  NotificationModel({this.id, this.message, this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['created_at'];
  }
}
