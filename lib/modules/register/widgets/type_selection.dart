import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

import '../bloc/register.event.dart';

class TypeSelection extends StatefulWidget {
  final RegisterBloc? registerBloc;

  TypeSelection({this.registerBloc});

  @override
  _TypeSelectionState createState() => _TypeSelectionState();
}

class _TypeSelectionState extends State<TypeSelection> {
  AccountType? selectedType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text('برجاء اختيار نوع العضوية'),
                  SizedBox(
                    height: 30,
                  ),
                  _typeRow(
                    icon: Icons.account_circle,
                    label: 'خــبيــر',
                    isSelected: selectedType == AccountType.consultant,
                    type: AccountType.consultant,
                  ),
                  _typeRow(
                    icon: Icons.account_balance,
                    label: 'جمعيه',
                    isSelected: selectedType == AccountType.association,
                    type: AccountType.association,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (selectedType != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomButton('التالي', () {
                          widget.registerBloc!.add(
                              SelectedAccountTypeEvent(type: selectedType));
                        })
                      ],
                    ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _typeRow({
    IconData? icon,
    required String label,
    required bool isSelected,
    AccountType? type,
  }) =>
      InkWell(
        onTap: () {
          setState(() {
            selectedType = type;
          });
        },
        child: Container(
          height: 80,
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[200],
              image: DecorationImage(
                repeat: ImageRepeat.repeat,
                image: AssetImage(Constants.background2),
              ),
              gradient: isSelected
                  ? LinearGradient(
                      end: Alignment.topCenter,
                      begin: Alignment.bottomCenter,
                      colors: [
                        Colors.teal[400]!,
                        AppColors.primary,
                      ],
                    )
                  : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 48,
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                color: isSelected ? Colors.white : Colors.transparent,
                size: 40,
              ),
            ],
          ),
        ),
      );
}
