import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/hours_widget.dart';
import 'package:gadeer/component/logout_popup_menu.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/helper_methods.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/bloc/account_state.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class AccountHeaderWidget extends StatelessWidget {
  final AccountBloc accountBloc = Get.find<AccountBloc>();
  AccountHeaderWidget();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AccountBloc, AccountState>(
        bloc: accountBloc,
        builder: (context, accountState) {
          return Container(
            width: size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    image: AssetImage(Constants.background3)),
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )),
            child: SafeArea(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.notificationsPage);
                          }),
                      LogoutPopupMenu(),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          File? image = await HelperMethods.pickImage();
                          if (image != null) {
                            accountBloc.changeAvatar(image);
                          }
                        },
                        child: SizedBox(
                          width: size.width * 0.3,
                          height: size.width * 0.3,
                          child: Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 4, color: Colors.white),
                                  image: new DecorationImage(
                                    image: new CachedNetworkImageProvider(
                                        accountBloc.state.user?.photo ??
                                            Constants.logo),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.solidEdit,
                                    color: Colors.teal[50],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '${accountBloc.state.user?.firstName} ${accountBloc.state.user?.lastName ?? ""}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (accountBloc.state.user?.jobTitle != "")
                        Text(
                          "${accountBloc.state.user?.jobTitle ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      if (accountBloc.state.user?.partnername != "")
                        Text(
                          "${accountBloc.state.user?.partnername ?? ""}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (Get.find<AccountBloc>().state.accountType ==
                          AccountType.consultant)
                        ShowRatingWidget(
                            accountBloc.state.user?.rate?.toDouble() ?? 0.0),
                      HoursWidget(
                        accountType: accountBloc.state.user!.membershipType ==
                                AccountType.association.toShortString()
                            ? AccountType.association
                            : AccountType.consultant,
                        consultingSeconds:
                            accountBloc.state.user!.consultingSeconds,
                        meetingSeconds: accountBloc.state.user!.meetingSeconds,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
