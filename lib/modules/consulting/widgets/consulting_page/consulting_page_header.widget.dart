import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/component/logout_popup_menu.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:get/get.dart';

class ConsultingPageHeader extends StatelessWidget {
  const ConsultingPageHeader(this.search, this.tabController, {Key? key})
      : super(key: key);
  final TextEditingController search;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only()),
      width: Get.width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.notificationsPage);
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: TextField(
                      controller: search,
                      decoration: inputDecoration(
                        icon: Icons.search,
                        fontSize: 12.0,
                        hint: 'ابحث عن اي استشارة',
                        enabledBorder: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                LogoutPopupMenu(),
              ],
            ),
            TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              controller: tabController,
              isScrollable: true,
              tabs: [
                ...Get.find<HomeController>()
                        .homeResponse
                        ?.consultingStates
                        ?.map<Tab>((state) {
                      return Tab(
                        child: FittedBox(
                          child: AutoSizeText(
                            state.label ?? "",
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList() ??
                    [],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
