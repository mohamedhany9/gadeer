import 'package:gadeer/data/model/comment_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class AddCommentResponse with BaseResponse {
  CommentModel? commentModel;
  AddCommentResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["comment"] != null) {
      commentModel = CommentModel.fromJson(json["comment"]);
    }
  }
}
