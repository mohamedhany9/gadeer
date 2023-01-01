import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/helper_methods.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/widgets/image_fullscreen.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';


class PermissionConsultView extends StatelessWidget {
  final String licensefile;
  final bool editable;
  PermissionConsultView(this.licensefile, {this.editable = false});

  final HiveService _hiveService = Get.find();

  Future<FormData> imageData(File image) async {
    String fileName = image.path.split('/').last;
    return FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: fileName),
    });
  }


  Future AddImage(File image) async {
    Notifications.showLoading();
    Response response =
    await Dio().post("https://gadeer.org/api/users/files",
        data: await imageData(image),
        options: Options(
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            'Content-Type': 'multipart/form-data',
            Constants.authorization: Constants.bearer +
                (await _hiveService.get<String>(
                    Constants.gaderBox, Constants.token) ??
                    "")
          },
        ));

    if(response.statusCode == 200)
    {
      Notifications.hideLoading();
      print("added");
      Get.find<ProfileBloc>().initProfile();
    }
    else if(response.statusCode == 422)
    {
      Notifications.hideLoading();
      print("Fail");

    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 8),
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: !editable
                ? null
                : () async{
              File? image = await HelperMethods.pickImage();
              if (image != null) {
                AddImage(image);
              }
            },
            child: Row(
              mainAxisAlignment: editable
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text("رخصة الأستشارة",
                    style: TextStyles.subTitleBold.copyWith(
                      color: AppColors.primary,
                    )),
                if (editable)
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add,
                      color: AppColors.primary,
                    ),
                  )
              ],
            ),
          ),
        ),
        licensefile == null
            ? Container(
          height: 1,
        )
            : licensefile.isEmpty
            ? Center(
          child: _buildEmptyExperience(),
        )
            :
        GestureDetector(
          onTap: (){
            Get.to(ImageFullScreen(
              image: "https://gadeer.org/storage/$licensefile",
            ));
          },
          child: Container(
            alignment: Alignment.center,
            child: Image.network("https://gadeer.org/storage/$licensefile"
              ,height: 40,width: 40,),
          ),
        )
      ],
    );
  }

  _buildEmptyExperience() {
    return Text(
      "لم تضف رخصتك الأستشارية بعد",
      style: TextStyles.subTitle.copyWith(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    );
  }
}

