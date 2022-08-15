import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/details_item.widget.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/meeting/bloc/meeting_controller.dart';

class MeetingDetailsWidget extends StatelessWidget {
  const MeetingDetailsWidget(this._meetingController, this.meetingModel,
      {Key? key})
      : super(key: key);
  final MeetingController _meetingController;
  final MeetingModel? meetingModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsItem(
            title: "تفاصيل الاجتماع",
            icon: Icons.description,
            body: _meetingController.current!.description,
          ),
          SizedBox(
            height: 8,
          ),
          DetailsItem(
            title: "تاريخ الاجتماع",
            icon: Icons.calendar_today,
            body: _meetingController.current!.date,
          ),
          SizedBox(
            height: 8,
          ),
          DetailsItem(
            title: "وقت الاجتماع",
            icon: FontAwesomeIcons.stopwatch,
            body: _meetingController.current!.time,
          ),
          SizedBox(
            height: 8,
          ),
          DetailsItem(
            title: "رابط الاجتماع",
            icon: Icons.link,
            body: _meetingController.current!.link,
          ),
          SizedBox(
            height: 8,
          ),
          DetailsItem(
              title: "مده الاجتماع",
              icon: Icons.timer,
              body: Duration(seconds: _meetingController.current!.duration!)
                      .inMinutes
                      .toString() +
                  "     دقيقه"),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              meetingModel!.statusText!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
