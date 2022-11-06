import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/chat/widgets/chat_header.widget.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.state.dart';
import 'package:gadeer/modules/meeting/widgets/add_meeting.widget.dart';
import 'package:get/get.dart';

import 'controller/chat_controller.dart';
import 'widgets/add_comment.widget.dart';
import 'widgets/comment_item.widget.dart';

class ChatPage extends StatelessWidget {
  final int? userId = Get.find<AccountBloc>().state.user?.id;
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();
  final ChatController chatController = Get.find();
  late final String? consultingId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (_) {
      consultingId = Get.arguments;
      print("responsex ${Get.arguments}");
      if (consultingBloc.state.current?.id != int.parse(consultingId!)) {
        consultingBloc.showConsulting(int.parse(consultingId!),
            goToPage: false);
      }
      chatController.getAllComments(consultingId);
    }, builder: (_) {
      print("responsex getbuilder");
      return Scaffold(
        body: Container(
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
          child: Column(
            children: [
              BlocBuilder<ConsultingBloc, ConsultingState>(
                  bloc: consultingBloc,
                  builder: (c, s) {
                    return ChatHeaderWidget();
                  }),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: ListView.builder(
                      reverse: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: chatController.allComments.length,
                      itemBuilder: (c, i) {
                        return CommentItemWidget(
                            comment: chatController.allComments[i]!);
                      }),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              if (consultingBloc.state.current?.status != "completed")
                AddCommentWidget(consultingId),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton("اضافة اجتماع", () {
                  Get.to(AddMeetingWidget(consultingBloc.state.current!.id));
                },),
              ),
              SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      );
    });
  }
}
