import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/widgets/delete_user_pop.dart';
import 'package:get/instance_manager.dart';


import '../../../helper/app.theme.dart';


class DeleteUserWidget extends StatefulWidget {
  const DeleteUserWidget({Key? key}) : super(key: key);

  @override
  State<DeleteUserWidget> createState() => _DeleteUserWidgetState();
}

class _DeleteUserWidgetState extends State<DeleteUserWidget> {

  final HiveService _hiveService = Get.find();


  Future<FormData> AttachaccessoryData() async {
    return FormData.fromMap({});
  }

  Future AttachLessonMethod() async {
      Response response =
      await Dio().post("${Constants.baseUrl}users/delete",
        data: await AttachaccessoryData(),
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            'Content-Type': 'multipart/form-data',
            // 'Authorization' : 'Bearer $token_apis'
          },
        ),
      );
      if(response.statusCode == 200)
      {

      }
      else{}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12),
      child: InkWell(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DeleteUserPob()));
          await _hiveService.get<String>(
              Constants.gaderBox, Constants.token);
          print(Constants.authorization);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "حذف الحساب",
                style: TextStyles.subTitleBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
