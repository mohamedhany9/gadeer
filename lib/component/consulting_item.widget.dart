import 'package:flutter/material.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ConsultingItemWidget extends StatelessWidget {
  ConsultingItemWidget(this.consulting, {Key? key}) : super(key: key);
  final ConsultingModel consulting;
  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 4),
      child: InkWell(
        onTap: () {
          Get.find<ConsultingBloc>()
              .showConsulting(consulting.id??0);
        },
        child: Container(
          // color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: AppColors.primary),
                    image: new DecorationImage(
                      image: new NetworkImage(accountType ==
                              AccountType.consultant
                          ? consulting.association!.photo!
                          : consulting.consultant == null
                              ? 'https://www.w3schools.com/howto/img_avatar.png'
                              : consulting.consultant!.photo!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  accountType == AccountType.consultant
                      ? consulting.association!.name!
                      : consulting.consultant == null
                          ? "لم يحدد بعد"
                          : consulting.consultant!.name!,
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Row(
                  children: [
                    consulting.date == null ? Container():Text(
                      consulting.date!,
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    consulting.time == null ? Container() : Text(
                      consulting.time!,
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 10,
                      ),
                    ),
                    consulting.created_at == null ? Container() : Text(
                      DateFormat('yyyy-MM-dd – kk:mm').format(consulting.created_at!),
                      style: TextStyle(
                        color: Colors.blueGrey[300],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(consulting.title!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 12,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      accountType == AccountType.association
                          ? consulting.association!.name!
                          : consulting.consultant == null
                              ? "لم يحدد بعد"
                              : consulting.consultant!.name!,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (consulting.categories != null)
                      Text(
                        consulting.categories!.isNotEmpty
                            ? consulting.categories!.last.title!
                            : "",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            Color(int.parse("0xff" + consulting.statusColor!)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        consulting.statusText!,
                        style: TextStyle(
                            fontSize: 12, color: Colors.white, height: 1.4),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
