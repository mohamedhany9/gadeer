import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/component/account_header.widget.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/bloc/profile.state.dart';
import 'package:gadeer/modules/profile/pages/preview_card.page.dart';
import 'package:gadeer/modules/profile/widgets/categories_view.dart';
import 'package:gadeer/modules/profile/widgets/hour_prices.widget.dart';
import 'package:gadeer/modules/profile/widgets/sections_view.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'widgets/educations_view.dart';
import 'widgets/work_experience_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: Get.find<ProfileBloc>(),
          builder: (context, state) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  repeat: ImageRepeat.repeat,
                  image: AssetImage(
                    Constants.background1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    AccountHeaderWidget(),
                    SizedBox(
                      height: 12,
                    ),
                    if (state.profile?.membershipType ==
                        AccountType.consultant.toShortString())
                      HourPricesWidget(state.profile),
                    state.profile == null
                        ? Container()
                        : state.profile!.membershipType ==
                                AccountType.consultant.toShortString()
                            ? CategoriesView(
                                Get.find<ProfileBloc>()
                                    .state
                                    .profile!
                                    .categories,
                                editable: true,
                              )
                            : Container(
                                height: 1,
                              ),
                    SizedBox(
                      height: 16,
                    ),
                    state.profile == null
                        ? Container()
                        : state.profile!.membershipType ==
                                AccountType.consultant.toShortString()
                            ? Column(
                                children: [
                                  EducationsView(
                                    state.profile?.educations,
                                    editable: true,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  WorkexperienceView(
                                      state.profile?.workExperiences,
                                      editable: true),
                                ],
                              )
                            : SectionsView(state.profile?.sections,
                                editable: true),
                    if (state.profile?.membershipType ==
                        AccountType.consultant.toShortString())
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12),
                        child: Column(
                          children: [
                            CustomButton("بطاقه العضويه", () {
                              Get.to(PreviewCardPage(state.profile));
                            },
                                enabled: (Get.find<HomeController>()
                                            .homeResponse
                                            ?.consultingCount ??
                                        0) >=
                                    6),
                            if ((Get.find<HomeController>()
                                        .homeResponse
                                        ?.consultingCount ??
                                    0) <
                                6)
                              Text(
                                "لكي تستخرج بطاقه عضويه يجب ان تقدم علي الاقل 6 استشارات مكتمله",
                                textAlign: TextAlign.center,
                                style: TextStyles.hint
                                    .copyWith(color: Colors.grey),
                              )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
