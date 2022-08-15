class MeetingModel {
  String? title;
  String? description;
  String? date;
  String? time;
  int? id;
  String? link;
  int? userId;
  String? statusText;
  String? status;
  String? statusColor;
  int? duration;

  MeetingModel(
      {this.title,
      this.description,
      this.date,
      this.time,
      this.duration,
      this.id,
      this.statusText});

  MeetingModel.fromJson(Map<String, dynamic> json) {
    duration = json["duration"];
    statusColor = json["status_color"];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    userId = json["user_id"];
    time = json['time'];
    id = json['id'];
    link = json["link"];
    status = json["status"];
    statusText = json["status_text"];
  }
}
