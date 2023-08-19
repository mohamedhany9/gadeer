import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/user_actions.dart';
import 'package:get/get.dart';

class ConsultantActionsWidget extends StatelessWidget {
  ConsultantActionsWidget({Key? key}) : super(key: key);
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: consultingBloc.state.current!.type == "_public"
                  ? [
                      Flexible(
                        child: CustomButton(
                          "قبول",
                          () async {
                            UserActions.acceptConsulting(
                                consultingBloc.state.current!.id);
                          },
                          color: Colors.green,
                        ),
                      )
                    ]
                  : [
                      Flexible(
                          child: CustomButton(
                        "قبول",
                        () async {

                          UserActions.acceptConsulting(
                              consultingBloc.state.current!.id);
                        },
                        color: Colors.green,
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: CustomButton(
                          "رفض",
                          () async {
                            UserActions.rejectConsulting(
                                consultingBloc.state.current!.id);
                          },
                          color: Colors.red,
                        ),
                      )
                    ],
            ),
          )
        ],
      ),
    );
  }
}
