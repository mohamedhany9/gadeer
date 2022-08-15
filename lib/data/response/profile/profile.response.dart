import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class ProfileResponse with BaseResponse {
  ProfileModel? profile;
  ProfileResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
  }
}
