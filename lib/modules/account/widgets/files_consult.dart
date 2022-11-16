import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/file_data_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/service/service_api.dart';
import 'package:gadeer/modules/account/widgets/pfd_webview.dart';
import 'package:get/get.dart';


class FileConsult extends StatefulWidget {
  const FileConsult({Key? key}) : super(key: key);

  @override
  State<FileConsult> createState() => _FileConsultState();
}

class _FileConsultState extends State<FileConsult> {

  late FileData filedata;

  bool _loading = false;

  getFileConsultData() async {
    try {
    ServiceApi serviceApi = new ServiceApi();
    await serviceApi.getFileConsultData();
    setState(() {
      filedata = serviceApi.filedata;
      _loading = true;

    });
    } catch (e) {
      setState(() {
        // _loading = false;
        // Fluttertoast.showToast(
        //   msg: "Error From Server",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.CENTER,
        // );
      });
    }

  }

  @override
  void initState() {
    getFileConsultData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("الاسئلة الشائعة"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child: Wrap(
          children: [
            _ProfileCard(
                title: 'ملفات الخبير',
                icon: Icons.file_present,
                onTap: () => Get.to(PDFWebView(
                  url: filedata.consultantsFile!,
                ))),
            _ProfileCard(
                title: 'ملفات الجمعية',
                icon: Icons.file_present,
                onTap: () => Get.to(PDFWebView(
                  url: filedata.associations!,
                ))),
            _ProfileCard(
                title: 'ملفات الفرد',
                icon: Icons.file_present,
                onTap: () => Get.to(PDFWebView(
                  url: filedata.userFile!,
                ))),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);

  final String? title;
  final IconData? icon;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: Get.width / 2,
        height: 120,
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
              Text(
                title ?? '',
                style: TextStyle(
                  color: Colors.blueGrey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}