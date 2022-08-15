import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/response/base.response.dart';

class CitiesResponse with BaseResponse<CityModel> {
  CitiesResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => CityModel.fromJson(item));
  }
}
