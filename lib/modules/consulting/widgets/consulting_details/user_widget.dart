import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/pages/show_profile_page.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/consultant_actions.widget.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/user_tile.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'consulting_actions.widget.dart';

class UserWidget extends StatelessWidget {
  final ProfileModel? user;
  UserWidget(this.user);
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;
  @override
  Widget build(BuildContext context) {
    if (accountType == AccountType.association && user?.id == null) {
      return Container(
        height: 1,
      );
    } else {
      return InkWell(
        onTap: () {
          Get.to(
            ShowProfilePage(user),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                _buildTitle(),
                SizedBox(
                  height: 8,
                ),
                UserTileWidget(user),
                ConsultingActionsWidget(),
                SizedBox(
                  height: 8,
                ),
                if (consultingBloc.state.current!.status == "pending" &&
                    accountType == AccountType.consultant)
                  ConsultantActionsWidget(),
                SizedBox(
                  height: 8,
                ),
                if (consultingBloc.state.current!.status == "in progress" &&
                    accountType == AccountType.consultant) Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton("إتمام الاستشارة", () {
                        Notifications.success("سوف يتم تحويل حاله الاستشاره الي مكتمله بعد ٢٤ ساعه من الان");
                      })) else Container(),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary)),
      child: Text(
        user!.membershipType == "association" ? "الجمعية" : user!.membershipType == "user" ? "فرد" : "الإستشاري",
        style: TextStyles.subTitleBold.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
