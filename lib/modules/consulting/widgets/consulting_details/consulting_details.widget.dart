import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/action_icon.dart';
import 'package:gadeer/component/details_item.widget.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/request/consulting/add_consulting_switch.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class ConsultingDetailsWidget extends StatefulWidget {
  final ConsultingDetailsModel? consultingDetailsModel;
  ConsultingDetailsWidget(this.consultingDetailsModel);

  @override
  State<ConsultingDetailsWidget> createState() => _ConsultingDetailsWidgetState();
}

class _ConsultingDetailsWidgetState extends State<ConsultingDetailsWidget> {
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;

  bool _switchValue=true;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsItem(
              title: "تفاصيل الاستشارة",
              icon: Icons.description,
              body: widget.consultingDetailsModel!.description,
            ),
            SizedBox(
              height: 8,
            ),
            widget.consultingDetailsModel!.date == null ? Container() :
            DetailsItem(
              title: "تاريخ الاستشارة",
              icon: Icons.calendar_today,
              body: widget.consultingDetailsModel!.date,
            ),
            SizedBox(
              height: 8,
            ),
            widget.consultingDetailsModel!.time == null ? Container():
            DetailsItem(
              title: "وقت الاستشارة",
              icon: FontAwesomeIcons.stopwatch,
              body: widget.consultingDetailsModel!.time,
            ),
            SizedBox(
              height: 8,
            ),
            DetailsItem(
              title: "نوع الاستشارة",
              icon: Icons.link,
              body:
                  widget.consultingDetailsModel!.type == "_private" ? "خاصة" : "عامة",
            ),
            SizedBox(
              height: 8,
            ),
            DetailsItem(
                title: "مده الاستشارة",
                icon: Icons.timer,
                body: "${widget.consultingDetailsModel?.estimationTime}"),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(
                        int.parse("0xff" + widget.consultingDetailsModel!.statusColor!)),
                    border: Border.all(
                        color: Color(int.parse(
                            "0xff" + widget.consultingDetailsModel!.statusColor!))),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    widget.consultingDetailsModel!.statusText!,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
                accountType == AccountType.consultant &&
                    consultingBloc.state.current!.status == "in progress" ?Row(
                      children: [
                        Text("تفعيل التقيم",style: TextStyle(fontSize: 10),),
                        SizedBox(width: 6,),
                        CupertinoSwitch(
                  value: widget.consultingDetailsModel!.rateStatus,
                  onChanged: (value) {
                        if(value == true){
                          print(value);
                          AddConsultingSwitch addConsultRequest = AddConsultingSwitch(
                              consultingid: widget.consultingDetailsModel!.id,
                              status: "on"
                          );
                          consultingBloc.switchConsulting(addConsultRequest);
                        }else
                        {
                          print(value);
                            AddConsultingSwitch addConsultRequest = AddConsultingSwitch(
                                consultingid: widget.consultingDetailsModel!.id,
                                status: "off"
                            );
                            consultingBloc.switchConsulting(addConsultRequest);
                          }

                        setState(() {
                          widget.consultingDetailsModel!.rateStatus = value;
                        });
                  },
                ),
                      ],
                    ) :Container(),
              ],
            ),
            if (accountType == AccountType.consultant ||
                consultingBloc.state.current!.status != "pending")
              Container(
                height: 1,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionIcon(
                    icon: Icons.edit,
                    onTap: () {
                      Get.toNamed(
                        Routes.consultingEdit,
                      );
                    },
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  ActionIcon(
                    icon: Icons.delete,
                    onTap: () {
                      Notifications.confirmDialog(
                          title: "حذف الاستشارة",
                          content: "هل انت متأكد من رغبتك بعمل الحذف",
                          confirmText: "تأكيد",
                          cancelText: "الغاء",
                          onConfirm: () {
                            consultingBloc.deleteConsulting(
                                consultingBloc.state.current!.id ?? 0);
                          });
                    },
                    color: Colors.red,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }


}
