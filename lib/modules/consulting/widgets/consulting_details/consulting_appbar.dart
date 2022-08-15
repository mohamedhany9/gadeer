import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class ConsultingAppBar extends StatelessWidget {
  const ConsultingAppBar(this.consulting, {Key? key}) : super(key: key);
  final ConsultingDetailsModel? consulting;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only()),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 64.0, vertical: 4),
                  child: Text(
                    consulting?.title ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyles.titleBold.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    text: "تفاصيل الاستشاره",
                    icon: Icon(FontAwesomeIcons.commentDots),
                  ),
                  Tab(
                    text: "الاجتماعات",
                    icon: Icon(FontAwesomeIcons.users),
                  ),
                  Tab(
                    text: "اوقات الاستشاره",
                    icon: Icon(FontAwesomeIcons.clock),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
