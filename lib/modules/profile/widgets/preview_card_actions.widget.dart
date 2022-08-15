import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class PreviewCardActions extends StatelessWidget {
  const PreviewCardActions(this.profileModel, this._screenshotController,
      {Key? key})
      : super(key: key);
  final ProfileModel? profileModel;
  final ScreenshotController _screenshotController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Flexible(
            child: CustomButton("مشاركه", () async {
              await _screenshotController
                  .captureAndSave(
                (await getDownloadsDirectory())!.path,
                fileName: "${profileModel?.name}.png",
              )
                  .then((value) {
                Share.shareFiles([value!]);
              });
            }),
          ),
        ],
      ),
    );
  }
}
