import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/section.model.dart';
import 'package:gadeer/data/request/profile/section.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

class SelectionButtomSheet extends StatefulWidget {
  final SectionModel? sectionModel;
  SelectionButtomSheet({this.sectionModel});

  @override
  _SelectionButtomSheetState createState() => _SelectionButtomSheetState();
}

class _SelectionButtomSheetState extends State<SelectionButtomSheet> {
  bool? edit;

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    if (widget.sectionModel == null) {
      edit = false;
    } else {
      edit = true;
      title.text = widget.sectionModel!.title!;
      description.text = widget.sectionModel!.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .5,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ListView(
        children: [
          Center(
            child: Text(
              edit! ? "تعديل بيانات القسم" : "اضافة قسم جديد",
              style: TextStyles.title,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          TextField(
            controller: title,
            decoration: inputDecoration(label: "العنوان", borderRadius: 10),
          ),
          SizedBox(
            height: 16,
          ),
          TextField(
            controller: description,
            maxLines: 3,
            decoration: inputDecoration(label: "الوصف", borderRadius: 10.0),
          ),
          SizedBox(
            height: 40,
          ),
          CustomButton("تأكيد", () async {
            await _addSection();
          })
        ],
      ),
    );
  }

  Future _addSection() async {
    if (title.text.isEmpty || description.text.isEmpty) {
      Notifications.error("برجاء اكمال البيانات");
      return;
    }

    Notifications.showLoading();
    if (edit == false) {
      await Get.find<ProfileService>()
          .addSection(
              SectionRequest(title: title.text, description: description.text))
          .then((response) {
        Notifications.hideLoading();
        if (response.status == 1) {
          Get.back();

          Get.find<ProfileBloc>().updateProfile(response.profile);
          Notifications.success("تم تحديث بياناتك بنجاح");
        } else {
          Notifications.error(Constants.netError);
        }
      }).catchError((e) {
        Notifications.hideLoading();
        print(e.toString());
        Notifications.error(Constants.netError);
      });
    } else {
      await Get.find<ProfileService>()
          .editSection(widget.sectionModel!.id,
              SectionRequest(title: title.text, description: description.text))
          .then((response) {
        Notifications.hideLoading();
        if (response.status == 1) {
          Get.find<ProfileBloc>().updateProfile(response.profile);
          Get.back();

          Notifications.success("تم تحديث بياناتك بنجاح");
        } else {
          Notifications.error(Constants.netError);
        }
      }).catchError((e) {
        print(e.toString());
        Notifications.hideLoading();
        Notifications.error(Constants.netError);
      });
    }
  }
}
