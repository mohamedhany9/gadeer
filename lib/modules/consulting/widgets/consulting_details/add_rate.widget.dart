import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/request/consulting/add_rate.request.dart';
import 'package:gadeer/data/response/consulting/consulting_action.response.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:get/get.dart';

class AddRateWidget extends StatefulWidget {
  @override
  _AddRateWidgetState createState() => _AddRateWidgetState();
}

class _AddRateWidgetState extends State<AddRateWidget> {
  TextEditingController message = TextEditingController();
  // ignore: close_sinks
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();
  final ConsultingService consultingService = Get.find<ConsultingService>();

  double rate = 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ListView(
        children: [
          Center(
            child: Text(
              "اضافة تقييم",
              style: TextStyles.title,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          TextField(
            decoration: inputDecoration(label: "اضافه تعليق", hint: "التعليق"),
            controller: message,
          ),
          SizedBox(
            height: 24,
          ),
          Center(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: RatingBar(
                initialRating: rate,
                minRating: 1,
                ignoreGestures: false,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.zero,
                itemSize: 35,
                ratingWidget: RatingWidget(
                    full: Icon(
                      Icons.star,
                      color: Colors.teal[200],
                    ),
                    half: Icon(
                      Icons.star_half,
                      color: Colors.teal[200],
                      textDirection: TextDirection.ltr,
                    ),
                    empty: Icon(
                      Icons.star,
                      color: Colors.grey,
                    )),
                unratedColor: Colors.grey,
                onRatingUpdate: (double value) {
                  rate = value;
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          CustomButton("تأكيد", () async {
            if (message.text.isEmpty) {
              Notifications.error("اكنب تعليقك اولا");

              return;
            }
            Notifications.showLoading();
            ConsultingActionResponse? response;
            await consultingService
                .addRate(consultingBloc.state.current?.id,
                    AddRateRequest(message.text, rate))
                .then((value) {
              Notifications.hideLoading();

              response = value;
            }).catchError((e) {
              Notifications.hideLoading();

              Notifications.error(Constants.netError);
            });
            Get.back();
            if (response?.status == 1) {
              Notifications.success("تم اضافة تعليقك");
              consultingBloc.updateSyncConsulting(response?.consulting);
            } else {
              Notifications.error("خطأ في اضافة التعليق");
            }
          })
        ],
      ),
    );
  }
}
