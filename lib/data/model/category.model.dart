class CategoryModel {
  int? id;
  String? title;
  String? image;
  List<CategoryModel>? children = [];

  CategoryModel({this.id, this.title, this.children});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image=json["image"];
    if (json['children'] != null) {
      children = <CategoryModel>[];
      json['children'].forEach((v) {
        children!.add(new CategoryModel.fromJson(v));
      });
    }
  }
}
