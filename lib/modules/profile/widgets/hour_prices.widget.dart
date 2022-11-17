import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/request/profile/update_hour_price.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HourPricesWidget extends StatelessWidget {
  const HourPricesWidget(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel? profileModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(HourPricesBottomSheet(),
              backgroundColor: Colors.white);
        },
        child: Row(
          children: [
            Text(
              "تكلفة ساعة الاستشارة",
              style: TextStyles.subTitle.copyWith(color: Colors.blueGrey[700]),
            ),
            Spacer(),
            Text(
              profileModel?.price != null
                  ? "${profileModel?.price} ريال"
                  : "غير محدد",
              style: TextStyles.subTitle.copyWith(color: Colors.grey),
            ),
            SizedBox(
              width: 4,
            ),
            Icon(
              Icons.edit,
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}

class HourPricesBottomSheet extends StatefulWidget {
  const HourPricesBottomSheet({Key? key}) : super(key: key);

  @override
  State<HourPricesBottomSheet> createState() => _HourPricesBottomSheetState();
}

class _HourPricesBottomSheetState extends State<HourPricesBottomSheet> {
  int? price;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ListView(
        children: [
          Text(
            "تحديد سعر الساعه",
            style: TextStyles.title,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          DropdownButtonFormField<int>(
              style: GoogleFonts.cairo(
                textStyle: TextStyles.subTitle
                    .copyWith(height: 1, color: Colors.blueGrey[600]),
              ),
              decoration: inputDecoration(label: "ساعه الاستشاره"),
              items: [
                ...Get.find<HomeController>().hourPrices.map((pri) {
                  return DropdownMenuItem<int>(
                    child: Text(pri.toString()),
                    value: pri,
                  );
                }).toList()
              ],
              onChanged: (c) {
                price = c;
              }),
          SizedBox(
            height: 16,
          ),
          CustomButton("تأكيد", () {
            _determineHourPrice();
          }),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  _determineHourPrice() async {
    if (price == null) {
      Notifications.error("يجب عليك اختيار سعر الساعه للاستشاره");
      return;
    }

    Notifications.showLoading();
    await Get.find<ProfileService>()
        .updateHourPrice(UpdateHourPriceRequest(price ?? 0))
        .then((response) {
      Notifications.hideLoading();

      if (response.status == 1) {
        Get.back();
        Get.find<ProfileBloc>().updateProfile(response.profile);
        Notifications.success("تم تحديث بياناتك بنجاح");
      } else {
        Notifications.error(Constants.netError);
      }
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }
}
