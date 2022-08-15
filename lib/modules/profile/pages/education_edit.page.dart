import 'package:flutter/material.dart';
import 'package:gadeer/data/model/education.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/profile/widgets/education_edit_form.widget.dart';

class EducationEditPage extends StatelessWidget {
  final EducationModel educationModel;
  EducationEditPage(this.educationModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('تعديل بيانات المرحلة التعليمية'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
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
          child: EducationEditFormWidget(
            educationModel: this.educationModel,
          ),
        ),
      ),
    );
  }
}
