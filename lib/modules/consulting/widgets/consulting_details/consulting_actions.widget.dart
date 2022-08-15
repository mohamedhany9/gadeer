import 'package:flutter/material.dart';
import 'package:gadeer/component/action_icon.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/user_actions.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'add_rate.widget.dart';

class ConsultingActionsWidget extends StatelessWidget {
  ConsultingActionsWidget({Key? key}) : super(key: key);
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();
  final AccountType accountType =
      Get.find<AccountBloc>().state.accountType!;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (consultingBloc.state.current?.status == "completed")
            ActionIcon(
              icon: Icons.message,
              onTap: () {
                Get.toNamed(
                  Routes.chatPage,
                  arguments: consultingBloc.state.current!.id.toString(),
                );
              },
              color: AppColors.primary,
            ),
          if (consultingBloc.state.current?.status == "accepted" ||
              consultingBloc.state.current?.status == "in progress")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionIcon(
                  icon: Icons.message,
                  onTap: () {
                    Get.toNamed(
                      Routes.chatPage,
                      arguments: consultingBloc.state.current!.id.toString(),
                    );
                  },
                  color: AppColors.primary,
                ),
                SizedBox(
                  width: 12,
                ),
                ActionIcon(
                  icon: Icons.call,
                  onTap: () {
                    UserActions.startConsulting(false);
                  },
                  color: AppColors.primary,
                ),
                SizedBox(
                  width: 12,
                ),
                ActionIcon(
                  icon: Icons.video_call,
                  onTap: () {
                    UserActions.startConsulting(true);
                  },
                  color: AppColors.primary,
                ),
                if ((consultingBloc.state.current!.status == "accepted" ||
                        consultingBloc.state.current!.status ==
                            "in progress") &&
                    accountType == AccountType.association)
                  _buildRateButton(),
              ],
            ),
        ],
      ),
    );
  }

  _buildRateButton() {
    return Row(
      children: [
        SizedBox(
          width: 12,
        ),
        ActionIcon(
          icon: Icons.star,
          onTap: () {
            Get.bottomSheet(AddRateWidget(), backgroundColor: Colors.white);
          },
          color: AppColors.primary,
        ),
      ],
    );
  }
}
