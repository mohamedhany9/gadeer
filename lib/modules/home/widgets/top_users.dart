import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/pages/show_profile_page.dart';
import 'package:gadeer/modules/show_associations/show_assosiations.page.dart';
import 'package:gadeer/modules/search_consultants/search_consultants.page.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class TopUsers extends StatelessWidget {
  final List<ProfileModel>? profiles;
  TopUsers({Key? key, this.profiles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: Get.width,
        child: Material(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (Get.find<AccountBloc>().state.accountType ==
                        AccountType.association) {
                      Get.to(() => SearchConsultantsPage());
                    } else {
                      Get.to(ShowAssosiationPage());
                    }
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            Get.find<AccountBloc>().state.accountType ==
                                    AccountType.association
                                ? 'الخبراء'
                                : 'الجمعيات',
                            style: TextStyles.subTitleBold),
                        Text(
                          "عرض المزيد",
                          style: TextStyles.hint
                              .copyWith(color: AppColors.primary),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                profiles?.isEmpty == true
                    ? Text(
                        Get.find<AccountBloc>().state.accountType ==
                                AccountType.association
                            ? "لا يوجد لديك اي خبراء في حسابك"
                            : "لا يوجة لديك اي جميعات في حسابك ",
                        style: TextStyles.subTitle.copyWith(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: 70,
                            child: LayoutBuilder(builder: (c, constrains) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: profiles?.length ?? 0,
                                  itemBuilder: (c, i) {
                                    return _PersonItem(
                                        profiles![i], constrains.maxWidth / 4);
                                  });
                            }))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//tiny widgets

class _PersonItem extends StatelessWidget {
  const _PersonItem(this.profile, this.width, {Key? key}) : super(key: key);
  final ProfileModel profile;
  final double width;

  @override
  Widget build(BuildContext context) {
    return profile.id == null
        ? Container()
        : InkWell(
            onTap: () {
              Get.to(ShowProfilePage(
                profile,
              ));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 3),
              height: width,
              width: width,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(profile.photo!))),
            ),
          );
  }
}
