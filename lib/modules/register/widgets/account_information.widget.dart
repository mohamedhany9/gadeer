import 'package:flutter/material.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/widgets/association_register_form.widget.dart';
import 'package:gadeer/modules/register/widgets/consultant_register_form.widget.dart';

class AccountInformationWidget extends StatelessWidget {
  final RegisterBloc? registerBloc;
  AccountInformationWidget({Key? key, this.registerBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return registerBloc!.state.accountType == AccountType.consultant
        ? ConsultantRegisterForm(registerBloc)
        : AssociationFormWidget(registerBloc);
  }
}
