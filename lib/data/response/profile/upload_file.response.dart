class UploadFileResponse {
  int? status;
  String? message;
  File? file;

  UploadFileResponse({this.status, this.message, this.file});

  UploadFileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    file = json['file'] != null ? new File.fromJson(json['file']) : null;
  }
}

class File {
  String? name;
  String? path;

  File({this.name, this.path});

  File.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }
}
