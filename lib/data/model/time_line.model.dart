class TimeLineModel {
  int? id;
  String? title;
  String? description;
  User? user;
  String? date;
  String? time;

  TimeLineModel(
      {this.id, this.title, this.description, this.user, this.date, this.time});

  TimeLineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    time = json['time'];
  }
}

class User {
  String? name;
  String? photo;

  User({this.name, this.photo});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
  }
}
