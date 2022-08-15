import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:get/get.dart';

class ChatHeaderWidget extends StatelessWidget {
  ChatHeaderWidget({Key? key}) : super(key: key);
  final int? userId = Get.find<AccountBloc>().state.user?.id;
  final ConsultingBloc consultingBloc = Get.find<ConsultingBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )),
      child: SafeArea(
        child: Stack(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    (userId == consultingBloc.state.current?.association?.id
                        ? consultingBloc.state.current?.consultant?.photo ?? ""
                        : consultingBloc.state.current?.association?.photo ??
                            ""),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (userId == consultingBloc.state.current?.association?.id
                          ? consultingBloc.state.current?.consultant?.name ?? ""
                          : consultingBloc.state.current?.association?.name ??
                              ""),
                      style: TextStyles.subTitle.copyWith(color: Colors.white),
                    ),
                    Text(
                      consultingBloc.state.current?.title ?? "",
                      style: TextStyles.hint.copyWith(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
