class PartnersModel {
  int? id;
  String? title;

  PartnersModel({this.id, this.title});

  PartnersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'];
  }

  toJson() {
    return {"id": this.id, "name": this.title};
  }
}
