import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';

class ErrorTextWidget extends StatelessWidget {
  const ErrorTextWidget(this.title, this.onTap, {Key? key}) : super(key: key);
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        margin: EdgeInsets.all(16),
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.subTitle.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
