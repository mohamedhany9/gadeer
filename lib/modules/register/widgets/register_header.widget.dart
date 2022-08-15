import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart';

class RegisterHeaderWidget extends StatelessWidget {
  final Widget? steps;
  RegisterHeaderWidget({Key? key, this.steps});
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(Constants.background2),
          ),
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      height: isKeyboardVisible ? Get.height * .23 : Get.height * .37,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (isKeyboardVisible)
                  Container()
                else
                  Expanded(
                    child: Center(
                      child: Container(
                        height: Get.height * .17,
                        child: Image.asset(
                          Constants.logoWhite,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                steps!
              ],
            ),
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
