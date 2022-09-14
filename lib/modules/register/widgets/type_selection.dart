import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/user_type_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/service/register_api_service.dart';

import '../../../helper/notifications.dart';
import '../bloc/register.event.dart';

class TypeSelection extends StatefulWidget {
  final RegisterBloc? registerBloc;

  TypeSelection({this.registerBloc});

  @override
  _TypeSelectionState createState() => _TypeSelectionState();
}

class _TypeSelectionState extends State<TypeSelection> {
  AccountType? selectedType;

  List<UserTypeData> usertypeList = [] ;

  bool _loading = true ;

  getSubjectData() async {
    try {
      ServiceApi serviceApi = new ServiceApi();
      await serviceApi.getUsertype();
      setState(() {
        usertypeList = serviceApi.usertypeList;
        _loading = false;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getSubjectData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: _loading == true ? Center(
              child: Container(
                color: Colors.white,
                height: 70,
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SpinKitFadingCube(
                      color: AppColors.primary,
                      size: 30.0,
                      duration: Duration(milliseconds: 1000),
                    ),
                  ),
                ),
              ),
            ) :Container(
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
                  usertypeList[0].isActive == true ? _typeRow(
                    icon: Icons.account_circle,
                    label: 'خــبيــر',
                    isSelected: selectedType == AccountType.consultant,
                    type: AccountType.consultant,
                  ) : Container(),
                  usertypeList[1].isActive == true ? _typeRow(
                    icon: Icons.account_balance,
                    label: 'جمعية',
                    isSelected: selectedType == AccountType.association,
                    type: AccountType.association,
                  ):Container(),
                  usertypeList[0].isActive == true ? _typeRow(
                    icon: Icons.account_balance,
                    label: 'أفراد',
                    isSelected: selectedType == AccountType.user,
                    type: AccountType.user,
                  ):Container(),
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
                  SizedBox(
                    height: 10,
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
