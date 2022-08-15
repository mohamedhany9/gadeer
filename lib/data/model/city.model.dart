class CityModel {
  int? id;
  String? title;

  CityModel({this.id, this.title});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  toJson() {
    return {"id": this.id, "title": this.title};
  }
}
