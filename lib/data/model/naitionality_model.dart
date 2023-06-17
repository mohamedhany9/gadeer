class NationalityModel {
  int? id;
  String? name;

  NationalityModel({this.id, this.name});

  NationalityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  toJson() {
    return {"id": this.id, "name": this.name};
  }
}