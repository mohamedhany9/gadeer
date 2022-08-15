class AddCategoryRequest {
  AddCategoryRequest({this.categories});

  List<int?>? categories;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categories'] = this.categories;
    return data;
  }
}
