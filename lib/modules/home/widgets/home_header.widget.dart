import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/component/logout_popup_menu.dart';
import 'package:gadeer/data/response/home/home.response.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/bloc/account_state.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/show_associations/show_assosiations.page.dart';
import 'package:gadeer/modules/search_consultants/search_consultants.page.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class HomeHeaderWidget extends StatelessWidget {
  final accountBloc = Get.find<AccountBloc>();
  final HomeResponse? homeResponse;
  HomeHeaderWidget(this.homeResponse);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, constrains) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            _HeaderRow(constrains, accountBloc),
            if (constrains.maxHeight > 190)
              SizedBox(
                height: 4,
              ),
            if (constrains.maxHeight > 180)
              Text(
                accountBloc.state.user?.fullName ?? "",
                style: TextStyles.subTitleBold.copyWith(color: Colors.white),
              ),
            if (constrains.maxHeight > 190)
              SizedBox(
                height: 4,
              ),
            if (constrains.maxHeight > 180)
              _FotterWidget(accountBloc, homeResponse)
          ],
        ),
      );
    });
  }
}

//tiny widgets

class _HeaderRow extends StatelessWidget {
  _HeaderRow(this.constraints, this._accountBloc, {Key? key}) : super(key: key);
  final AccountBloc _accountBloc;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        BlocBuilder<AccountBloc, AccountState>(
            bloc: _accountBloc,
            builder: (context, snapshot) {
              double size;
              if (constraints.maxHeight < 300 && constraints.maxHeight > 170) {
                size = constraints.maxHeight * .45;
              } else {
                size = 80;
              }
              return Center(
                child: InkWell(
                  onTap: () {
                    Get.find<AppBloc>().changePage(2);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: size,
                    height: size,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(width: 4, color: Colors.white),
                      image: _accountBloc.state.user?.photo != null
                          ? new DecorationImage(
                              image: NetworkImage(
                                  _accountBloc.state.user?.photo ?? ''),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }),
        LogoutPopupMenu(),
      ],
    );
  }
}

class _FotterWidget extends StatelessWidget {
  const _FotterWidget(this.accountBloc, this.homeResponse, {Key? key})
      : super(key: key);
  final AccountBloc accountBloc;
  final HomeResponse? homeResponse;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                Get.find<AppBloc>().changePage(1);
                Get.find<ConsultingBloc>().changeIndex("completed");
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Center(
                      child: Text(
                        homeResponse == null
                            ? "0"
                            : homeResponse?.consultingCount.toString() ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'استشارة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (accountBloc.state.accountType == AccountType.association) {
                  Get.to(() => SearchConsultantsPage());
                } else {
                  Get.to(() => ShowAssosiationPage());
                }
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: Center(
                      child: Text(
                        homeResponse == null
                            ? "0"
                            : homeResponse?.userCount.toString() ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    accountBloc.state.user?.membershipType ==
                            AccountType.association.toShortString()
                        ? "خبير"
                        : "جمعيه",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
