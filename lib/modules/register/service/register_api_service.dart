import 'package:dio/dio.dart';
import 'package:gadeer/data/model/user_type_model.dart';

class ServiceApi{

  List<UserTypeData> usertypeList = [] ;

  Future<void> getUsertype() async {
    String url = "http://178.62.236.151/~gadeer/public/api/users/types";
    Response response = await Dio().get(url,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            'Content-Type': 'multipart/form-data',
          },
        )
    );
    UserType data = new UserType.fromJson(response.data);
    usertypeList = data.data ;
  }

}