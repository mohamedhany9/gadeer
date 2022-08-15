import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.state.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_page/consulting_list.widget.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/home/widgets/add_consulting_button.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'widgets/consulting_page/consulting_page_header.widget.dart';

class ConsultingPage extends StatefulWidget {
  @override
  _ConsultingPageState createState() => _ConsultingPageState();
}

class _ConsultingPageState extends State<ConsultingPage>
    with TickerProviderStateMixin {
  final consultingBloc = Get.find<ConsultingBloc>();
  TextEditingController search = TextEditingController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    search.addListener(() {
      setState(() {});
    });

    _tabController = TabController(
        vsync: this,
        length:
            Get.find<HomeController>().homeResponse?.consultingStates?.length ??
                1,
        initialIndex: 0);

    _tabController?.addListener(() {
      consultingBloc.changeIndex(Get.find<HomeController>()
              .homeResponse
              ?.consultingStates?[_tabController?.index ?? 0]
              .status ??
          "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsultingBloc, ConsultingState>(
        bloc: consultingBloc,
        listener: (c, s) {
          _tabController?.animateTo(s.initialIndex ?? 0);
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: Get.find<AccountBloc>().state.accountType ==
                    AccountType.association
                ? AddConsultingButton("consulting")
                : null,
            backgroundColor: Colors.white,
            body: Column(
              children: [
                ConsultingPageHeader(search, _tabController!),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ...List.generate(
                          Get.find<HomeController>()
                                  .homeResponse
                                  ?.consultingStates
                                  ?.length ??
                              1, (i) {
                        return ConsultingListWidget(
                          state.allConsults?.where((element) {
                                return element?.status ==
                                    consultingBloc
                                        .state.consultingStates?[i]?.status;
                              }).where((element) {
                                bool condition = false;
                                if (search.text.isEmpty) {
                                  condition = true;
                                } else {
                                  if (element?.title?.contains(search.text) ==
                                          true ||
                                      element?.description
                                              ?.contains(search.text) ==
                                          true ||
                                      element?.association?.name
                                              ?.contains(search.text) ==
                                          true ||
                                      element?.consultant?.name
                                              ?.contains(search.text) ==
                                          true) {
                                    condition = true;
                                  }
                                }
                                return condition;
                              }).toList() ??
                              [],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
