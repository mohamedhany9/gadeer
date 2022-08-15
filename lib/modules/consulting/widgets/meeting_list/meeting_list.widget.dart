import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_page/empty_list.widget.dart';
import 'package:gadeer/modules/meeting/widgets/add_meeting.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'meeting_item.widget.dart';

class MeetingListWidget extends StatelessWidget {
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;
  final List<MeetingModel?>? meetings;
  MeetingListWidget(this.meetings);
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await consultingBloc.refreshConsultingEvent();
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        children: [
          SizedBox(
            height: 8,
          ),
          if (meetings?.isEmpty == true)
            Center(child: EmptyListWidget("لا يوجد اجتماعات لهذه الاستشاره")),
          ...meetings?.map((meeting) {
                return Column(
                  children: [
                    MeetingItemWidget(meeting!),
                    Divider(
                    )
                  ],
                );
              }) ??
              [],
          SizedBox(
            height: 8,
          ),
          if ((consultingBloc.state.current!.status == "accepted" ||
                  consultingBloc.state.current!.status == "in progress") &&
              accountType == AccountType.consultant)
            CustomButton("اضافة اجتماع", () {
              Get.to(AddMeetingWidget(consultingBloc.state.current!.id));
            })
        ],
      ),
    );
  }
}
