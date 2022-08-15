import 'package:gadeer/data/model/profile.model.dart';

import '../base.response.dart';

class ConsultantSearchResponse with BaseResponse<ProfileModel> {
  ConsultantSearchResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => ProfileModel.fromJson(item));
  }
}
