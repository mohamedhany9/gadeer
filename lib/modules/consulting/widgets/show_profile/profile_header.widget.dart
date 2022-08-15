import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/hours_widget.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget(this.profile, this.isSelectable, {Key? key})
      : super(key: key);
  final bool isSelectable;
  final ProfileModel? profile;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Center(child: Icon(Icons.arrow_back_ios)),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      CachedNetworkImageProvider(profile?.photo ?? ""),
                ),
                IconButton(
                    icon: Center(child: Icon(Icons.arrow_back_ios)),
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    onPressed: () {
                      Get.back();
                    }),
              ],
            ),
            Text(
              profile?.name ?? "",
              style: TextStyles.title.copyWith(color: Colors.white),
            ),
            if (profile?.jobTitle != null)
              Text(
                profile?.jobTitle ?? "",
                style: TextStyles.subTitle
                    .copyWith(color: Colors.white, fontSize: 12),
              ),
            SizedBox(
              height: 5,
            ),
            if (profile?.membershipType == "consultant")
              ShowRatingWidget(profile?.rate?.toDouble()),
            HoursWidget(
              accountType: profile?.membershipType != "consultant"
                  ? AccountType.association
                  : AccountType.consultant,
              consultingSeconds: profile?.consultingSeconds,
              meetingSeconds: profile?.meetingSeconds,
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
