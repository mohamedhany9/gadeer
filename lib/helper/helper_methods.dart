import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'app.theme.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AuthState {
  static const int advisor = 0;
  static const int association = 1;
}

// helper methods
class HelperMethods {
  // pick image
  static Future<File?> pickImage() async {
    File? image;

    return showDialog<File>(
      barrierDismissible: true,
      context: Get.context!,
      builder: (c) => Dialog(
        child: SizedBox(
          height: 350,
          width: Get.width * .6,
          child: Center(
            child: Material(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "مصدر الصورة",
                      style: TextStyles.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      "الاستوديو".tr,
                      () async {
                        final picked = await ImagePicker().getImage(
                            source: ImageSource.gallery,
                            maxHeight: 480,
                            maxWidth: 600,
                            imageQuality: 60);

                        if (picked != null) {
                          image = File(picked.path);
                          Navigator.pop(c, image);
                        } else {
                          Navigator.pop(c, image);
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomButton(
                      "الكاميرا".tr,
                      () async {
                        final picked = await ImagePicker().getImage(
                            source: ImageSource.camera,
                            maxHeight: 480,
                            maxWidth: 600,
                            imageQuality: 60);

                        if (picked != null) {
                          image = File(picked.path);
                          Navigator.pop(c, image);
                        } else {
                          Navigator.pop(c, image);
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      "رجوع",
                      () {
                        Navigator.pop(c, image);
                      },
                      textColor: Colors.white,
                      color: Colors.red,
                      hasBorder: false,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> takePicture(GlobalKey genKey) async {
  //   RenderRepaintBoundary boundary = genKey.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List? pngBytes = byteData?.buffer.asUint8List();
  //   File imgFile = new File('$directory/photo.png');
  //   imgFile.writeAsBytes(pngBytes!);
  // }

  
}
