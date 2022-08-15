import 'package:gadeer/data/model/profile.model.dart';

import '../base.response.dart';

class GetUsersResponse with BaseResponse<ProfileModel> {
  GetUsersResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => ProfileModel.fromJson(item));
  }
}
