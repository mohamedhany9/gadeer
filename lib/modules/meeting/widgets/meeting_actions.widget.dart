import 'package:flutter/material.dart';
import 'package:gadeer/component/action_icon.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'edit_meeting.widget.dart';

class MeetingActionsWidget extends StatelessWidget {
  const MeetingActionsWidget(this.meetingModel, this.consultingId, {Key? key})
      : super(key: key);
  final MeetingModel? meetingModel;
  final int? consultingId;

  @override
  Widget build(BuildContext context) {
    return Get.find<AccountBloc>().state.accountType == AccountType.consultant
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (meetingModel!.status == "pending")
                  ActionIcon(
                    icon: Icons.edit,
                    onTap: () {
                      Get.to(EditMeetingWidget(consultingId, meetingModel));
                    },
                    color: Colors.grey,
                  ),
                SizedBox(
                  width: 16,
                ),
                if (meetingModel!.status == "pending")
                  ActionIcon(
                    icon: Icons.delete,
                    onTap: () {
                      Notifications.confirmDialog(
                          title: "حذف الاجتماع",
                          content: "هل انت متأكد من رغبتك بعمل الحذف",
                          confirmText: "تأكيد",
                          cancelText: "الغاء",
                          onConfirm: () {
                            Get.find<ConsultingBloc>()
                                .deleteMeeting(meetingModel?.id ?? 0);
                          });
                    },
                    color: Colors.red,
                  ),
              ],
            ),
          )
        : Container(
            height: 1,
          );
  }
}
