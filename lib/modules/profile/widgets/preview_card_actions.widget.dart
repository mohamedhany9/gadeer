import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:hexcolor/hexcolor.dart';
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
      child: GestureDetector(
        onTap: () async{
          await _screenshotController
              .captureAndSave(
              (await getDownloadsDirectory())!.path,
          fileName: "${profileModel?.name}.png",
          )
              .then((value) {
          Share.shareFiles([value!]);
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: [HexColor("#1AC4B8"),HexColor("#607D8B")],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("مشاركة",style: TextStyle(fontSize: 16,color: Colors.white),),
              SizedBox(width: 20,),
              Icon(Icons.share,color: Colors.white,)
              // Flexible(
              //   child: CustomButton("مشاركه", () async {
              //     await _screenshotController
              //         .captureAndSave(
              //       (await getDownloadsDirectory())!.path,
              //       fileName: "${profileModel?.name}.png",
              //     )
              //         .then((value) {
              //       Share.shareFiles([value!]);
              //     });
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
