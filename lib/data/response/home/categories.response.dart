import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class CategoriesResponse with BaseResponse<CategoryModel> {
  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => CategoryModel.fromJson(item));
  }
}
