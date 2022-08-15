import 'package:flutter/material.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:get/get.dart';

class PreviewCardDetails extends StatelessWidget {
  const PreviewCardDetails(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel? profileModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DetailsColumn("ساعات التطوع", profileModel?.workHours),
        _DetailsColumn(
            "الاستشارات",
            Get.find<HomeController>()
                    .homeResponse
                    ?.consultingCount
                    .toString() ??
                "0"),
        _DetailsColumn(
            "الجمعيات",
            Get.find<HomeController>().homeResponse?.userCount?.toString() ??
                "0"),
      ],
    );
  }
}

class _DetailsColumn extends StatelessWidget {
  const _DetailsColumn(this.title, this.subTitle, {Key? key}) : super(key: key);
  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Text(
            subTitle ?? "",
            style: TextStyles.subTitle
                .copyWith(color: Colors.white.withOpacity(.9)),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                TextStyles.hint.copyWith(color: Colors.white.withOpacity(.9)),
          ),
        ],
      ),
    );
  }
}
