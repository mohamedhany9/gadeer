import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class PartnersResponse with BaseResponse<PartnersModel> {
  PartnersResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => PartnersModel.fromJson(item));
  }
}
