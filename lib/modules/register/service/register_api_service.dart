import 'package:dio/dio.dart';
import 'package:gadeer/data/model/consuilt_profile_model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/model/user_type_model.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:get/instance_manager.dart';

import '../../../helper/constants.dart';

class ServiceApi{

  final HiveService _hiveService = Get.find();

  List<UserTypeData> usertypeList = [] ;
  late ProfileModel consuiltdata ;

  Future<void> getUsertype() async {
    String url = "${Constants.baseUrl}users/types";
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

  Future<void> getConsultProfile(int id) async {
    String url = "${Constants.baseUrl}consultants/$id";
    Response response = await Dio().get(url,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            'Content-Type': 'multipart/form-data',
        Constants.authorization: Constants.bearer +
        (await _hiveService.get<String>(
        Constants.gaderBox, Constants.token) ?? "")
          },
        )
    );
    ConsuitProfileModel data = new ConsuitProfileModel.fromJson(response.data);
    consuiltdata = data.profile ;
  }

 }