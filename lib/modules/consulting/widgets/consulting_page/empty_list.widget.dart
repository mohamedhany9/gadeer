import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  const EmptyListWidget(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Get.width * .7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                FontAwesomeIcons.exclamationCircle,
                size: 150,
                color: Colors.grey[100],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              title,
              style: TextStyles.subTitle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
