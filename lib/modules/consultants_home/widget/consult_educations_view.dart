import 'package:flutter/material.dart';
import 'package:gadeer/data/model/education.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/pages/education_create.page.dart';
import 'package:gadeer/modules/profile/pages/education_edit.page.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

class ConsultEducationsView extends StatelessWidget {
  final List<EducationModel>? educations;
  final bool editable;
  ConsultEducationsView(this.educations, {this.editable = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 8),
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: editable
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Text(
                "التعليم",
                style: TextStyles.title.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        educations == null
            ? Container(
          height: 1,
        )
            : educations?.isEmpty == true
            ? Center(
          child: _buildEmptyEducation(),
        )
            : Column(
          children: [
            ...educations
                ?.map((education) =>
                _EducationItem(education, editable))
                .toList() ??
                [],
          ],
        )
      ],
    );
  }

  _buildEmptyEducation() {
    return Text(
      "لم تضف شهاداتك العلميه بعد",
      style: TextStyles.subTitle.copyWith(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    );
  }
}

//tiny widgets

class _EducationItem extends StatelessWidget {
  const _EducationItem(this.education, this.editable, {Key? key})
      : super(key: key);
  final EducationModel education;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                education.title!,
                style:
                TextStyles.subTitle.copyWith(color: Colors.blueGrey[700]),
              ),
              if (editable) Spacer(),
            ],
          ),
          Text(
            education.place!,
            style: TextStyles.hint.copyWith(color: Colors.grey),
          ),
          // Row(
          //   children: [
          //     Text(
          //       "من:",
          //       style: TextStyles.subTitleBold.copyWith(color: Colors.blueGrey),
          //     ),
          //     SizedBox(
          //       width: 4,
          //     ),
          //     Text(
          //       education.from!,
          //       style: TextStyles.subTitle.copyWith(color: Colors.grey),
          //     ),
          //     Spacer(),
          //     if (education.to != null)
          //       Text(
          //         "الى:",
          //         style:
          //         TextStyles.subTitleBold.copyWith(color: Colors.blueGrey),
          //       ),
          //     SizedBox(
          //       width: 4,
          //     ),
          //     Text(
          //       education.to ?? "",
          //       style: TextStyles.subTitle.copyWith(color: Colors.grey),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

}
