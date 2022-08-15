import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/consulting/pages/show_profile_page.dart';
import 'package:get/get.dart';

class ConsultantItemWidget extends StatelessWidget {
  const ConsultantItemWidget(this.consultant, {Key? key}) : super(key: key);
  final ProfileModel? consultant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Get.to(
            ShowProfilePage(
              consultant,
            ),
          );
        },
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AutoSizeText(
                  consultant?.name ?? "",
                  maxFontSize: 20,
                  minFontSize: 14,
                  style: TextStyles.title.copyWith(color: AppColors.primary),
                ),
              ),
              SizedBox(
                  height: 20,
                  width: 80,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ShowRatingWidget(
                      consultant?.rate?.toDouble(),
                      size: 15,
                    ),
                  )),
            ],
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(
              consultant?.photo ?? "",
            ),
          ),
          subtitle: Text(consultant?.jobTitle ?? ""),
        ),
      ),
    );
  }
}
