import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/time_line.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineDialog extends StatelessWidget {
  final List<TimeLineModel>? timeLines =
      Get.find<AccountBloc>().state.user?.timeLines;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('مواعيد الاستشارات'),
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
        child: timeLines!.isEmpty
            ? _buildEmptyText()
            : ListView.builder(
                itemCount: timeLines!.length,
                itemBuilder: (c, i) {
                  return ConsultingTileWidget(
                    timeLine: timeLines![i],
                    isFirst: timeLines!.indexOf(timeLines![i]) == 0,
                    isLast: timeLines!.indexOf(timeLines![i]) ==
                        timeLines!.length - 1,
                  );
                }),
      ),
    );
  }

  _buildEmptyText() {
    return Center(
      child: SizedBox(
        width: Get.width * .6,
        child: Text(
          "لا يوجد لديك استشارات قادمة",
          textAlign: TextAlign.center,
          style: TextStyles.subTitle,
        ),
      ),
    );
  }
}

class ConsultingTileWidget extends StatelessWidget {
  const ConsultingTileWidget(
      {Key? key,
      required this.isFirst,
      required this.isLast,
      required this.timeLine})
      : super(key: key);
  final TimeLineModel timeLine;
  final bool isLast;
  final bool isFirst;
  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      lineXY: .35,
      alignment: TimelineAlign.manual,
      isLast: isLast,
      isFirst: isFirst,
      afterLineStyle: LineStyle(color: AppColors.primary),
      beforeLineStyle: LineStyle(color: AppColors.primary),
      indicatorStyle: IndicatorStyle(
        width: 50,
        height: 50,
        indicator: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(timeLine.user!.photo!),
        ),
      ),
      startChild: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeLine.date!,
            style: TextStyles.hint,
          ),
          Text(
            timeLine.time!.substring(0, 5),
            style: TextStyles.hint,
          ),
        ],
      ),
      endChild: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        title: Text(
          timeLine.user!.name!,
          style: TextStyles.subTitle,
        ),
        subtitle: Text(
          timeLine.title!,
          style: TextStyles.hint.copyWith(color: Colors.blueGrey),
        ),
      ),
    );
  }
}
