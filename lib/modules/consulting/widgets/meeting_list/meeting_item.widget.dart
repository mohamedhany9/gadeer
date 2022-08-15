import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/meeting/bloc/meeting_controller.dart';
import 'package:get/get.dart';

class MeetingItemWidget extends StatelessWidget {
  MeetingItemWidget(this.meeting, {Key? key}) : super(key: key);
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();
  final MeetingModel meeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Get.find<MeetingController>()
              .showMeeting(consultingBloc.state.current!.id, meeting);
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidCalendar,
                            color: AppColors.primary,
                            size: 60,
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Text(
                              meeting.date!.split("-").last,
                              style: TextStyles.title
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meeting.title!, style: TextStyles.subTitleBold),
                          Row(
                            children: [
                              Text(meeting.date!),
                              SizedBox(
                                width: 10,
                              ),
                              Text(meeting.time!)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Text(meeting.description!),
                SizedBox(
                  height: 4,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(int.parse("0xff" + meeting.statusColor!)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    meeting.statusText!,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
