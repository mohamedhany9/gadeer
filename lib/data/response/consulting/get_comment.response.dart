import 'package:gadeer/data/model/comment_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class GetCommentResponse with BaseResponse<CommentModel?> {
  GetCommentResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => CommentModel.fromJson(item));
  }
}
