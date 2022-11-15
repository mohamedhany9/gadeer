// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {
  QuestionModel({
    this.data,
  });

  List<QuestionData>? data;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    data: List<QuestionData>.from(json["data"].map((x) => QuestionData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuestionData {
  QuestionData({
    this.id,
    this.question,
    this.answer,
  });

  int? id;
  String? question;
  String? answer;

  factory QuestionData.fromJson(Map<String, dynamic> json) => QuestionData(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
  };
}
