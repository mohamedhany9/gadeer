// To parse this JSON data, do
//
//     final fileDataModel = fileDataModelFromJson(jsonString);

import 'dart:convert';

FileDataModel fileDataModelFromJson(String str) => FileDataModel.fromJson(json.decode(str));

String fileDataModelToJson(FileDataModel data) => json.encode(data.toJson());

class FileDataModel {
  FileDataModel({
    this.data,
  });

  FileData? data;

  factory FileDataModel.fromJson(Map<String, dynamic> json) => FileDataModel(
    data: FileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class FileData {
  FileData({
    this.userFile,
    this.consultantsFile,
    this.associations,
  });

  String? userFile;
  String? consultantsFile;
  String? associations;

  factory FileData.fromJson(Map<String, dynamic> json) => FileData(
    userFile: json["user_file"],
    consultantsFile: json["consultants_file"],
    associations: json["associations"],
  );

  Map<String, dynamic> toJson() => {
    "user_file": userFile,
    "consultants_file": consultantsFile,
    "associations": associations,
  };
}
