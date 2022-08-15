import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/consulting/pages/show_profile_page.dart';
import 'package:get/get.dart';

class AssociationItemWidget extends StatelessWidget {
  const AssociationItemWidget(this.assosiation, {Key? key}) : super(key: key);
  final ProfileModel? assosiation;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Get.to(
            ShowProfilePage(
              assosiation,
            ),
          );
        },
        child: ListTile(
            title: Text(
              assosiation?.name ?? "",
              style: TextStyles.title.copyWith(color: AppColors.primary),
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: CachedNetworkImageProvider(
                assosiation?.photo ?? "",
              ),
            ),
            subtitle: Text(assosiation?.sectionText ?? ""),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
            )),
      ),
    );
  }
}
