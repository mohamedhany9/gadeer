import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.state.dart';
import 'package:gadeer/modules/register/helper/register_steps.helper.dart';
import 'package:gadeer/modules/register/widgets/register_header.widget.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final RegisterBloc _registerBloc = Get.find<RegisterBloc>();
  late RegisterState _registerState;

  @override
  void initState() {
    _registerBloc.initTabController(this);
    _registerState = _registerBloc.state;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: BlocBuilder<RegisterBloc, RegisterState>(
            bloc: _registerBloc,
            builder: (context, state) {
              _registerState = state;
              return Column(
                children: [
                  RegisterHeaderWidget(
                    steps: _steps(),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          repeat: ImageRepeat.repeat,
                          image: AssetImage(
                            Constants.background1,
                          ),
                        ),
                      ),
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _registerBloc.tabController,
                        children: registerStepsList
                            .map(
                              (tab) => SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                child: tab.child!(_registerBloc),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _steps() {
    return Column(
      children: [
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10),
            child: TabBar(
              controller: _registerBloc.tabController,
              indicatorColor: Colors.transparent,
              tabs: registerStepsList.map((tab) {
                bool isActive = tab.index! <= _registerState.currentStep!;
                return Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isActive ? Colors.white : Colors.white54),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Icon(
                          tab.icon,
                          size: 40,
                          color: isActive ? Colors.white : Colors.white54,
                        ),
                      ),
                      if (tab.index! < _registerState.currentStep!)
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              Icons.check_circle,
                              size: 26,
                              color: Colors.green[300],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Text(
          registerStepsList[_registerState.currentStep!].title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }
}
