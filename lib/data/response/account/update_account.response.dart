import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class UpdateAccountResponse with BaseResponse {
  UserModel? user;

  UpdateAccountResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["user"] != null) {
      user = UserModel.fromJson(json["user"]);
    }
  }
}
