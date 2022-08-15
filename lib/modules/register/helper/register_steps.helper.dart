import 'package:flutter/material.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/widgets/account_information.widget.dart';
import 'package:gadeer/modules/register/widgets/enter_phone.dart';
import 'package:gadeer/modules/register/widgets/type_selection.dart';
import 'package:gadeer/modules/register/widgets/verification_code.dart';

class RegisterStep {
  final int? index;
  final String? title;
  final IconData? icon;
  Widget Function(RegisterBloc registerBloc)? child;
  RegisterStep({this.index, this.title, this.icon, this.child});
}

List<RegisterStep> registerStepsList = [
  RegisterStep(
    index: 0,
    title: 'نوع الحساب',
    icon: Icons.account_box,
    child: (registerBloc) => TypeSelection(registerBloc: registerBloc),
  ),
  RegisterStep(
    index: 1,
    title: 'ادخال رقم الجوال',
    icon: Icons.phone,
    child: (registerBloc) => EnterPhone(),
  ),
  RegisterStep(
    index: 2,
    title: 'ادخال رمز التأكيد',
    icon: Icons.verified_user,
    child: (registerBloc) => VerificationCode(),
  ),
  RegisterStep(
      index: 3,
      title: 'البيانات الشخصية',
      icon: Icons.contact_mail,
      child: (registerBloc) => AccountInformationWidget(
            registerBloc: registerBloc,
          )),
];
