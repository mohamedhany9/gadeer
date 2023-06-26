// To parse this JSON data, do
//
//     final productCategoryModel = productCategoryModelFromJson(jsonString);

import 'dart:convert';

ProductCategoryModel productCategoryModelFromJson(String str) => ProductCategoryModel.fromJson(json.decode(str));

String productCategoryModelToJson(ProductCategoryModel data) => json.encode(data.toJson());

class ProductCategoryModel {
  String file;

  ProductCategoryModel({
    required this.file,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "file": file,
  };
}
