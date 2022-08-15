import 'package:gadeer/data/model/consulting_details_model.dart';

import '../base.response.dart';

class ShowConsultingResponse with BaseResponse {
  ConsultingDetailsModel? consultingDetailsModel;
  ShowConsultingResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["consulting"] != null) {
      consultingDetailsModel =
          ConsultingDetailsModel.fromJson(json["consulting"]);
    }
  }
}
