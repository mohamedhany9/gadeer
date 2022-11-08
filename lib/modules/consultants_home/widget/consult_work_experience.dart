import 'package:flutter/material.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/pages/work_create.page.dart';
import 'package:gadeer/modules/profile/pages/work_edit.page.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

class ConsultWorkexperienceView extends StatelessWidget {
  final List<WorkExperienceModel>? workExperiences;
  final bool editable;
  ConsultWorkexperienceView(this.workExperiences, {this.editable = false});
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
              Text("الخبرات العمليه",
                  style: TextStyles.subTitleBold.copyWith(
                    color: AppColors.primary,
                  )),
            ],
          ),
        ),
        workExperiences == null
            ? Container(
          height: 1,
        )
            : workExperiences!.isEmpty
            ? Center(
          child: _buildEmptyExperience(),
        )
            : Column(
          children: [
            ...workExperiences
                ?.map((workExperience) =>
                _WorkExperienceItem(workExperience, editable))
                .toList() ??
                [],
          ],
        )
      ],
    );
  }

  _buildEmptyExperience() {
    return Text(
      "لم تضف خبراتك العملية بعد",
      style: TextStyles.subTitle.copyWith(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    );
  }
}

// tiny widgets

class _WorkExperienceItem extends StatelessWidget {
  const _WorkExperienceItem(this.workExperienceModel, this.editable, {Key? key})
      : super(key: key);
  final WorkExperienceModel workExperienceModel;
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
                workExperienceModel.title ?? "",
                style:
                TextStyles.subTitle.copyWith(color: Colors.blueGrey[700]),
              ),
              if (editable) Spacer(),
            ],
          ),
          Text(
            workExperienceModel.place ?? "",
            style: TextStyles.hint.copyWith(color: Colors.grey),
          ),
          Row(
            children: [
              Text(
                "من:",
                style: TextStyles.subTitleBold.copyWith(color: Colors.blueGrey),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                workExperienceModel.from ?? "",
                style: TextStyles.subTitle.copyWith(color: Colors.grey),
              ),
              Spacer(),
              if (workExperienceModel.to != null)
                Text(
                  "الى:",
                  style:
                  TextStyles.subTitleBold.copyWith(color: Colors.blueGrey),
                ),
              SizedBox(
                width: 4,
              ),
              Text(
                workExperienceModel.to ?? "",
                style: TextStyles.subTitle.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _deleteWork(int? id) async {
    Notifications.showLoading();
    await Get.find<ProfileService>()
        .deleteWorkExperience(id)
        .then((value) async {
      Notifications.hideLoading();

      if (value.status == 1) {
        Get.find<ProfileBloc>().updateProfile(value.profile);
      } else {
        Notifications.error("فشل العملية");
      }
    }).catchError((e) {
      print(e.toString());
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }
}
