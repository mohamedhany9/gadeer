import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';

class PreviewCardHeader extends StatelessWidget {
  const PreviewCardHeader(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel? profileModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 12,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                CachedNetworkImageProvider(profileModel?.photo ?? ""),
          ),
          Text(
            profileModel?.name ?? "",
            style: TextStyles.subTitleBold.copyWith(color: Colors.white),
          ),
          Text(
            profileModel?.jobTitle ?? "",
            style: TextStyles.subTitleBold.copyWith(color: Colors.white),
          ),
          ShowRatingWidget(
            profileModel?.rate?.toDouble(),
            size: 20,
          ),
          Text(
            profileModel?.categories?.map((cat) => cat.title).join(" - ") ?? "",
            style: TextStyles.subTitleBold.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
