class AssosiationSection {
  int? id;
  String? title;

  AssosiationSection({this.id, this.title});

  AssosiationSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  toJson() {
    return {"id": this.id, "title": this.title};
  }
}
