import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/consultants_home/widget/show_profile_page2.dart';
import 'package:gadeer/modules/consulting/pages/show_profile_page.dart';
import 'package:get/get.dart';

class SelectableConsultantItemWidget2 extends StatelessWidget {
  const SelectableConsultantItemWidget2(this.consultant, this.select,
      {this.selected = false, Key? key})
      : super(key: key);
  final ProfileModel consultant;
  final ValueChanged<int?> select;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          image: AssetImage(
            Constants.background1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          var consultx = await Get.to(ShowProfilePage2(
            consultant,
            isSelectable: true,
          ));

          if (consultx != null) {
            Get.back(result: consultant);
          }
        },
        child: Material(
          borderRadius: BorderRadius.circular(15),
          shadowColor: Colors.white,
          child: ListTile(
            title: Text(
              consultant.name!,
              style: TextStyles.title.copyWith(color: AppColors.primary),
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(
                consultant.photo!,
              ),
            ),
            subtitle: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consultant.jobTitle ?? ""),
                  ShowRatingWidget(
                    consultant.rate?.toDouble(),
                    size: 15,
                    isCenter: false,
                  )
                ],
              ),
            ),
            trailing: InkWell(
              onTap: () {
                if (selected) {
                  select(null);
                } else {
                  select(consultant.id ?? 0);
                }
              },
              child: CircleAvatar(
                backgroundColor: selected ? AppColors.primary : Colors.grey.shade400,
                radius: 15,
                child: Center(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
