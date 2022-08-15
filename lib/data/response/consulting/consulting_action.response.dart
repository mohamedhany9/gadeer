import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/response/base.response.dart';

class ConsultingActionResponse with BaseResponse {
  ConsultingDetailsModel? consulting;
  ConsultingActionResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["consulting"] != null) {
      consulting = ConsultingDetailsModel.fromJson(json["consulting"]);
    }
  }
}
