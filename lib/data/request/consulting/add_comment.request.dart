import 'dart:io';

import 'package:dio/dio.dart';

class AddCommentRequest {
  File? image;
  File? file;
  String? message;

  AddCommentRequest({this.message, this.file, this.image});

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> json = {};
    if (this.message != null) {
      json["message"] = this.message;
    }
    if (this.file != null) {
      String fileName = this.file!.path.split('/').last;
      json["file"] =
          await MultipartFile.fromFile(this.file!.path, filename: fileName);
    }
    if (this.image != null) {
      String imageName = this.image!.path.split('/').last;
      json["image"] =
          await MultipartFile.fromFile(this.image!.path, filename: imageName);
    }

    return json;
  }
}
