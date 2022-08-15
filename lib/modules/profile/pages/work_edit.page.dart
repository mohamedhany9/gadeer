import 'package:flutter/material.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/profile/widgets/work_edit_form.widget.dart';
import 'package:get/get.dart';

class WorkEditPage extends StatelessWidget {
  final WorkExperienceModel workExperienceModel;
  WorkEditPage(this.workExperienceModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('نعديل بيانات مرحلة العمل'),
        centerTitle: true,
      ),
      body: Container(
        height:Get.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: WorkEditFormWidget(
            workExperienceModel: workExperienceModel,
          ),
        ),
      ),
    );
  }
}
