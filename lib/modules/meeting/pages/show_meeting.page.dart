import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/meeting/bloc/meeting_controller.dart';
import 'package:gadeer/modules/meeting/meeting_call/meeting_call.page.dart';
import 'package:gadeer/modules/meeting/service/meeting_service.dart';
import 'package:gadeer/modules/meeting/widgets/meeting_actions.widget.dart';
import 'package:gadeer/modules/meeting/widgets/meeting_details.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:share_plus/share_plus.dart';

class ShowMeetingPage extends StatelessWidget {
  final MeetingModel? meetingModel;
  final int? consultingId;
  final MeetingController _meetingController = Get.find();
  ShowMeetingPage(this.consultingId, this.meetingModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child: GetBuilder<MeetingController>(
          builder: (_) {
            return Column(
              children: [
                buildAppBar(_meetingController.current!.title!, actions: [
                  IconButton(
                      onPressed: () {
                        Share.share(meetingModel!.link!);
                        Get.find<FirebaseAnalytics>().logEvent(
                            name: "share_meeting",
                            parameters: {
                              "meeting_id": meetingModel!.id.toString()
                            });
                      },
                      icon: Icon(Icons.share))
                ]),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        MeetingDetailsWidget(_meetingController, meetingModel),
                        SizedBox(
                          height: 16,
                        ),
                        if (Get.find<ConsultingBloc>().state.current?.status !=
                            "completed")
                          MeetingActionsWidget(meetingModel, consultingId),
                        SizedBox(
                          height: 20,
                        ),
                        if (Get.find<ConsultingBloc>().state.current?.status !=
                            "completed")
                          Get.find<AccountBloc>().state.accountType ==
                                  AccountType.consultant
                              ? CustomButton("بدء الاجتماع", () {
                                  Get.find<MeetingService>()
                                      .startMeeting(meetingModel!.id)
                                      .then((value) {
                                    if (value.status == 1) {
                                      Get.to(MeetingCallPage(meetingModel));
                                    }
                                  });
                                })
                              : CustomButton("حضور الاجتماع", () async {
                                  Get.find<MeetingService>()
                                      .showMeeting(meetingModel!.id)
                                      .then((value) async {
                                    if (value.status == 1) {
                                      if (value.meetingModel!.status ==
                                          "started") {
                                        await Get.to(MeetingCallPage(
                                            value.meetingModel));
                                      } else {
                                        await Notifications.error(
                                            "برجاء الانتظار لحين بدء الاجتماع من جهه الخبير");
                                      }
                                    }
                                  });
                                }),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
