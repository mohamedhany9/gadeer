import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/consulting_appbar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.state.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/consulting_details.widget.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/offline_time_tab.widget.dart';
import 'package:gadeer/modules/consulting/widgets/meeting_list/meeting_list.widget.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_details/user_widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class ConsultingDetailsPage extends StatefulWidget {
  @override
  _ConsultingDetailsPageState createState() => _ConsultingDetailsPageState();
}

class _ConsultingDetailsPageState extends State<ConsultingDetailsPage> {
  // ignore: close_sinks
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  final AccountType accountType =
      Get.find<AccountBloc>().state.user!.membershipType ==
              AccountType.association.toShortString()
          ? AccountType.association
          : AccountType.consultant;

  @override
  Widget build(BuildContext context) {
    print(consultingBloc.state.current!.status);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child: BlocBuilder<ConsultingBloc, ConsultingState>(
            bloc: consultingBloc,
            builder: (context, snapshot) {
              return DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    ConsultingAppBar(consultingBloc.state.current),
                    Expanded(
                      child: TabBarView(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await consultingBloc.refreshConsultingEvent();
                            },
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: ClampingScrollPhysics(),
                              children: [
                                ConsultingDetailsWidget(
                                    consultingBloc.state.current),
                                SizedBox(
                                  height: 10,
                                ),
                                accountType == AccountType.consultant
                                    ? UserWidget(consultingBloc
                                        .state.current?.association)
                                    : UserWidget(consultingBloc
                                        .state.current?.consultant),
                                SizedBox(
                                  height: 8,
                                ),
                                if (consultingBloc.state.current?.status ==
                                        "in progress" &&
                                    accountType == AccountType.association)
                                  _buildRateText(),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        MeetingListWidget(
                            consultingBloc.state.current?.meetings),
                        OfflineTimesTab()
                      ]),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _buildRateText() {
    return Center(
        child: Text(
      "في حاله الانتهاء من الاستشاره برجاء الضغط علي علامه تقييم الاستشاره و تقييم الخبير",
      textAlign: TextAlign.center,
    ));
  }
}
