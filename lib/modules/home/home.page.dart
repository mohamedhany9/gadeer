import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/account_status.widget.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/home/widgets/add_consulting_button.dart';
import 'package:gadeer/modules/home/widgets/consultings_list.widget.dart';
import 'package:gadeer/modules/home/widgets/home_header.widget.dart';
import 'package:gadeer/modules/home/widgets/pie_chart.widget.dart';
import 'package:gadeer/modules/home/widgets/top_users.dart';
import 'package:gadeer/modules/home/widgets/verify_email.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'widgets/error_text.widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();

  final AppBloc _appBloc = Get.find();
  final AccountBloc _accountBloc = Get.find();
  final String? status = Get.find<AccountBloc>().state.user!.status;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (home) {
      return Scaffold(
        floatingActionButton:
            _accountBloc.state.accountType == AccountType.association || _accountBloc.state.accountType == AccountType.user
                ? AddConsultingButton("home")
                : null,
        body: RefreshIndicator(
          onRefresh: () async {
            await _homeController.getHome();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                collapsedHeight: 90,
                pinned: true,
                elevation: 0,
                floating: true,
                expandedHeight: 230,
                flexibleSpace: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          repeat: ImageRepeat.repeat,
                          image: AssetImage(Constants.background3)),
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: SafeArea(
                        child: HomeHeaderWidget(_homeController.homeResponse))),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 8,
                ),
              ),
              if (status != "approved")
                SliverToBoxAdapter(child: AccountStatusWidget()),
              if (status == "approved")
                SliverToBoxAdapter(
                    child: Column(
                  children: [

                    if (_homeController.hourPriceNotSet == true)
                      _accountBloc.state.accountType == AccountType.user ? Container() :
                      ErrorTextWidget("برجاء تحديد سعر ساعه الاستشاره", () {
                        Get.find<AppBloc>().changePage(2);
                      }),
                    if (_accountBloc.state.user?.assosiationUncomplete == true)
                      ErrorTextWidget("برجاء استكمال بيانات حسابك", () {
                        Get.toNamed(Routes.editAccount);
                      }),
                    if (_homeController.isVerified == false)
                      ErrorTextWidget(
                          "برجاء الضغط هنا لتأكيد بريدك الالكتروني  ${_accountBloc.state.user?.email}",
                          () {
                        Get.dialog(Dialog(
                          child: VerifyEmailWidget(),
                        ));
                      }),
                    if (_homeController.homeResponse != null &&
                        _homeController.homeResponse?.isCompleted == false)
                      _accountBloc.state.accountType == AccountType.user ? Container() :
                        ErrorTextWidget(
                          "لكي تتمكن من الاستفادة من مميزات التطبيق برحاء استكمال بيانات الملف الشخصي",
                          () {
                        _appBloc.changePage(2);
                      }),
                    if (_homeController.homeResponse != null &&
                        _homeController.homeResponse?.consultingStates
                                ?.where((element) => element.value! > 0)
                                .length !=
                            0)
                      PieChartWidget(
                        chartPoints: _homeController
                                .homeResponse?.consultingStates
                                ?.map<ChartXPoint>((state) {
                              return ChartXPoint(
                                  state.label ?? "", state.value, state.color);
                            }).toList() ??
                            [],
                      ),
                    if (_homeController.homeResponse != null)
                      TopUsers(
                          profiles: _homeController.homeResponse?.profiles),
                    SizedBox(
                      height: 16,
                    ),
                    ConsultingListWidget(
                      consultings: _homeController.homeResponse?.newConsultings,
                      title: "الاستشارات الجديده",
                      status: "pending",
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ConsultingListWidget(
                      consultings:
                          _homeController.homeResponse?.inProgressConsultings,
                      title: "استشارات قيد التنفيذ",
                      status: "in progress",
                    ),
                    SizedBox(
                      height: 48,
                    ),
                  ],
                ))
            ],
          ),
        ),
      );
    });
  }
}
