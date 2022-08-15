import 'dart:io';

class CommentModel {
  static const sentState = 1;
  static const pendingState = 0;

  String? id;
  String? userId;
  String? message;
  String? image;
  String? fileName;
  String? fileExtension;
  String? filePath;
  File? imageFileInternal;
  File? fileInternal;
  int? status;

  CommentModel(
      {this.id,
      this.userId,
      this.message,
      this.image,
      this.status,
      this.imageFileInternal,
      this.fileInternal,
      this.fileName,
      this.fileExtension,
      this.filePath});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    status = json["status"] ?? 1;
    message = json['message'] ?? "";
    image = json['image'] ?? "";
    fileName = json['file_name'] ?? "";
    fileExtension = json['file_extension'] ?? "";
    filePath = json['file_path'] ?? "";
    if (message!.isEmpty) {
      message = null;
    }
    if (image!.isEmpty) {
      image = null;
    }
    if (fileName!.isEmpty) {
      fileName = null;
    }
    if (filePath!.isEmpty) {
      filePath = null;
    }
  }
}
