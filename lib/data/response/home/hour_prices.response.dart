import 'package:gadeer/data/response/base.response.dart';

class HourPricesResponse with BaseResponse {
  List<int> prices = [];
  HourPricesResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    if (json["prices"] != null) {
      json["prices"].forEach((price) {
        prices.add(price);
      });
    }
  }
}
