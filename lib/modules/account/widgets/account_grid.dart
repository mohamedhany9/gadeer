import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/modules/account/widgets/common_question.dart';
import 'package:gadeer/modules/account/widgets/files_consult.dart';
import 'package:gadeer/modules/account/widgets/pfd_webview.dart';
import 'package:gadeer/modules/account/widgets/timeline_dialog.widget.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:get/get.dart';

import 'change_password_pop.dart';

class AccountGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _ProfileCard(
            title: 'بيانات الحساب',
            icon: Icons.account_box_outlined,
            onTap: () => Get.toNamed(Routes.editAccount)),
        _ProfileCard(
            title: 'تغيير كلمة المرور',
            icon: Icons.security,
            onTap: () {
              Get.dialog(Dialog(child: ChangePasswordPob()));
              // showDialog(
              //     context: context,
              //     builder: (c) {
              //       return ChangePasswordPob();
              //     });
            }),
        _ProfileCard(
            title: 'مواعيد الاستشارات',
            icon: FontAwesomeIcons.calendarAlt,
            onTap: () {
              Get.dialog(
                TimeLineDialog(),
              );
            }),
        _ProfileCard(
            title: 'الملف الشخصي',
            icon: Icons.person,
            onTap: () {
              Get.find<AppBloc>().changePage(2);
            }),
        _ProfileCard(
            title: 'الاسئله الشائعة',
            icon: Icons.question_answer,
            onTap: () => Get.to(CommonQuestion())),
        _ProfileCard(
            title: 'الملفات الاستشارية',
            icon: Icons.file_present,
            onTap: () => Get.to(FileConsult())),
      ],
    );
  }
}

//tiny widgets

class _ProfileCard extends StatelessWidget {
  const _ProfileCard(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  final String? title;
  final IconData? icon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: Get.width / 2,
        height: 120,
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
              Text(
                title ?? '',
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
