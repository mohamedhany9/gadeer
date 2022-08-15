import 'package:flutter/material.dart';
import 'package:gadeer/component/consulting_item.widget.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:get/get.dart';

class ConsultingListWidget extends StatelessWidget {
  ConsultingListWidget(
      {Key? key,
      required this.title,
      required this.consultings,
      required this.status})
      : super(key: key);
  final String title;
  final List<ConsultingModel>? consultings;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  Get.find<AppBloc>().changePage(1);
                  Get.find<ConsultingBloc>().changeIndex(status);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyles.subTitleBold),
                    Text(
                      "عرض المزيد",
                      style: TextStyles.hint.copyWith(color: AppColors.primary),
                    )
                  ],
                ),
              );
            }),
          ),
          if (consultings?.length == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "لا يوجة لديك اي $title ",
                style: TextStyles.subTitle.copyWith(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            ),
          ...consultings?.map<Widget>((consulting) {
                return Column(
                  children: [
                    ConsultingItemWidget(consulting),
                    Divider(
                      thickness: 1,
                    )
                  ],
                );
              }).toList() ??
              [],
        ],
      ),
    );
  }
}
