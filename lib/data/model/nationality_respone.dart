import 'package:gadeer/data/model/naitionality_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class NationalityResponse with BaseResponse<NationalityModel> {
  NationalityResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => NationalityModel.fromJson(item));
  }
}
