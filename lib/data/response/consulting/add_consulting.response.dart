import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class AddConsultingResponse with BaseResponse {
  ConsultingModel? consulting;
  AddConsultingResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["consulting"] != null) {
      consulting = ConsultingModel.fromJson(json["consulting"]);
    }
  }
}
