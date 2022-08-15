import 'package:gadeer/data/model/user.model.dart';

import '../base.response.dart';

class GetAccountResponse with BaseResponse {
  UserModel? user;

  GetAccountResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["user"] != null) {
      user = UserModel.fromJson(json["user"]);
    }
  }
}
