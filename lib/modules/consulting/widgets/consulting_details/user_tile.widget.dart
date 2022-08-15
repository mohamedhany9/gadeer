import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class UserTileWidget extends StatelessWidget {
  UserTileWidget(this.user, {Key? key}) : super(key: key);
  final ProfileModel? user;
  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      title: Text(
        user?.name ?? "",
        style: TextStyles.title.copyWith(color: AppColors.primary),
      ),
      leading: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2)),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: CachedNetworkImageProvider(
            user?.photo ?? "",
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user!.jobTitle ?? "",
            style: TextStyles.subTitle.copyWith(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ),
          if (accountType == AccountType.association)
            SizedBox(
                width: 80,
                child: ShowRatingWidget(
                  user!.rate!.toDouble(),
                  size: 15,
                ))
        ],
      ),
    );
  }
}
