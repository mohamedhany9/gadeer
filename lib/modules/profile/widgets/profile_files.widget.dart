import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/widgets/pfd_webview.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:get/get.dart';

class ProfileFilesWidget extends StatelessWidget {
  const ProfileFilesWidget(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel? profileModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...profileModel?.files?.map<Widget>((file) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.find<ProfileBloc>().addProfileFile(file.key ?? "");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        width: (Get.width / 2) - 16,
                        child: Column(
                          children: [
                            Icon(
                              file.path == null
                                  ? FontAwesomeIcons.filePdf
                                  : FontAwesomeIcons.fileSignature,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              file.name ?? "",
                              style: TextStyles.hint.copyWith(
                                color: Colors.blueGrey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        left: 5,
                        top: 5,
                        child: file.path == null ? Container() : GestureDetector(
                            onTap: (){
                              Get.to(PDFWebView(
                                url: file.path!,
                              ));
                            },
                            child: Icon(FontAwesomeIcons.eye,color: Colors.blueGrey,)))
                  ],
                );
              }).toList() ??
              []
        ],
      ),
    );
  }
}
