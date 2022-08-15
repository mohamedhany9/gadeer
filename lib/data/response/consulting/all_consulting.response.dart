import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/response/home/home.response.dart';

class AllConsultingResponse {
  List<ConsultingModel>? consultings = [];
  List<ConsultingStatusModel>? consultingStates = [];
  AllConsultingResponse.fromJson(Map<String, dynamic> json) {
    if (json["statuses"] != null) {
      consultingStates = [];
      List bad = json["statuses"];
      bad.forEach((element) {
        consultingStates?.add(ConsultingStatusModel.fromJson(element));
      });
    }

    if (json["consultancies"] != null) {
      consultings = [];
      List bad = json["consultancies"];
      bad.forEach((element) {
        consultings?.add(ConsultingModel.fromJson(element));
      });
    }
  }
}
