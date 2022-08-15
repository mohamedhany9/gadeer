import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';

class Notifications {
  static bool isOverlay = false;
  static success(String? message) => showSnackBar(
        content: message,
        backgroundColor: Colors.green,
      );

  static error(String? message) => showSnackBar(
        content: message,
        backgroundColor: Colors.red,
      );

  static fromRemoteNotification(String title, String body, {Function? onTap}) {
    Get.snackbar(title, body, borderColor: Colors.white, borderWidth: 4,
        onTap: (_) {
      if (onTap != null) {
        onTap();
      }
    },
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 5),
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white);
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false,
    );
  }

  static showLoading() {
    if (isOverlay == true) {
      return;
    }
    isOverlay = true;

    Get.dialog(NewOverLay());
  }

  static hideLoading() {
    if (isOverlay) {
      Get.back();
      isOverlay = false;
    }
  }

  static showSnackBar(
      {String? content, Color? textColor, required Color backgroundColor}) {
    Get.rawSnackbar(
        message: content,
        backgroundColor: backgroundColor,
        snackPosition: SnackPosition.BOTTOM);
  }

  static confirmDialog(
      {required String title,
      required String content,
      String? cancelText,
      String? confirmText,
      Function? onConfirm,
      Function? onCancel,
      bool dismissible = true}) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 12,
              ),
              Text(
                title,
                style: TextStyles.title,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                content,
                style: TextStyles.subTitle,
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(confirmText ?? "تأكيد", () async {
                      Get.back();
                      if (onConfirm != null) {
                        await onConfirm();
                      }
                    }),
                    CustomButton(
                      cancelText ?? "الغاء",
                      () async {
                        Get.back();
                        if (onCancel != null) {
                          await onCancel();
                        }
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
      // title: title,
      // middleText: content,
      // actions: [
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       CustomButton(confirmText ?? "تأكيد", () async {
      //         Get.back();
      //         if (onConfirm != null) {
      //           await onConfirm();
      //         }
      //       }),
      //       CustomButton(
      //         cancelText ?? "الغاء",
      //         () async {
      //           Get.back();
      //           if (onCancel != null) {
      //             await onCancel();
      //           }
      //         },
      //         color: Colors.red,
      //       ),
      //     ],
      //   )
      // ],
    );
  }
}

class NewOverLay extends StatefulWidget {
  @override
  _NewOverLayState createState() => _NewOverLayState();
}

class _NewOverLayState extends State<NewOverLay> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
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
      ),
    );
  }
}
