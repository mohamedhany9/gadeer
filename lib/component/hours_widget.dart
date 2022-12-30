import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

class HoursWidget extends StatefulWidget {
  final int? meetingSeconds;
  final int? consultingSeconds;
  final AccountType accountType;

  HoursWidget(
      {required this.accountType,
      required this.consultingSeconds,
      required this.meetingSeconds});

  @override
  _HoursWidgetState createState() => _HoursWidgetState();
}

class _HoursWidgetState extends State<HoursWidget> {
  int? consultingSeconds, meetingSeconds;
  @override
  void initState() {
    consultingSeconds = widget.consultingSeconds ?? 0;
    meetingSeconds = widget.meetingSeconds ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: widget.accountType == AccountType.association
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        Duration(hours: meetingSeconds ?? 0)
                            .inHours
                            .toString(),
                        style:
                            TextStyles.subTitle.copyWith(color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "ساعات الاجتماعات",
                      style: TextStyles.subTitle.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        Duration(hours: consultingSeconds ?? 0)
                            .inHours
                            .toString(),
                        style:
                            TextStyles.subTitle.copyWith(color: Colors.white)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "ساعات الاستشارات",
                      style: TextStyles.subTitle.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ساعات التطوع: ",
                  style: TextStyles.subTitle.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Text(
                  Duration(
                          hours:
                              meetingSeconds ?? 0 + (consultingSeconds ?? 0))
                      .inHours
                      .toString(),
                  style: TextStyles.subTitle.copyWith(color: Colors.white),
                )
              ],
            ),
    );
  }
}
