import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

class ImageFullScreen extends StatelessWidget {
  String image;
  ImageFullScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Image.network(image
          ),
      ),
    );
  }
}
