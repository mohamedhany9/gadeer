import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class CallUsWidget extends StatelessWidget {
  const CallUsWidget({Key? key}) : super(key: key);

  openWhatsapp() async {
    var whatsapp = "+966545879659";
    var whatsAndroid = "whatsapp://send?phone=$whatsapp";
    var whatsIos = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatsIos)) {
        await launch(whatsIos, forceSafariVC: false);
      } else {
        Notifications.error("whatsapp no installed");
      }
    } else {
      // android , web
      if (await canLaunch(whatsAndroid)) {
        await launch(whatsAndroid);
      } else {
        Notifications.error("whatsapp no installed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12),
      child: InkWell(
        onTap: () {
          openWhatsapp();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "اتصل بنا",
                style: TextStyles.subTitleBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
