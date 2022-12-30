import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

class ImageFullScreen extends StatelessWidget {
  const ImageFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Image.network("https://test.gadeer.org/storage/avatar/01EEe5vv2t2yYhXoKHTWG3d6zNm0dYtfDhlA64y9.jpg"
          ),
      ),
    );
  }
}
