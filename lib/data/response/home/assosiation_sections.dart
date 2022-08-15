import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/response/base.response.dart';

class AssosiatiosSectionsResponse with BaseResponse<AssosiationSection> {
  AssosiatiosSectionsResponse.fromJson(Map<String, dynamic> json) {
    super.fromJson(json, builder: (item) => AssosiationSection.fromJson(item));
  }
}
