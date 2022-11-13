import 'package:gadeer/data/model/add_switch_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class AddConsultingSwitchResponse with BaseResponse {
  ConsultingSwichModel? consulting;
  AddConsultingSwitchResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["data"] != null) {
      consulting = ConsultingSwichModel.fromJson(json["consulting"]);
    }
  }
}