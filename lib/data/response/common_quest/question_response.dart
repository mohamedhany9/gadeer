import 'package:gadeer/data/model/common_question_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class GetCommonQuestion with BaseResponse {
  QuestionModel? question;

  GetCommonQuestion.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["data"] != null) {
      question = QuestionModel.fromJson(json["data"]);
    }
  }
}