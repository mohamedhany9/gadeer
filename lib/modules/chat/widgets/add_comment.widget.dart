import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/request/consulting/add_comment.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/helper_methods.dart';
import 'package:gadeer/modules/chat/controller/chat_controller.dart';
import 'package:get/get.dart';

class AddCommentWidget extends StatefulWidget {
  final String? consultingId;

  AddCommentWidget(this.consultingId);
  @override
  _AddCommentWidgetState createState() => _AddCommentWidgetState();
}

String? consultingId;
ChatController chatController = Get.find();

class _AddCommentWidgetState extends State<AddCommentWidget> {
  File? image;
  File? file;
  TextEditingController message = TextEditingController();
  bool enabled = true;

  @override
  void initState() {
    consultingId = widget.consultingId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Directionality(
              textDirection: TextDirection.ltr,
              child: InkWell(
                onTap: () {
                  if (enabled = true) {
                    _addCommentAction();
                  }
                },
                child: CircleAvatar(
                  backgroundColor: enabled ? AppColors.primary : Colors.grey,
                  child: Center(
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            controller: message,
            decoration: inputDecoration(
              fill: Colors.yellowAccent[50],
              enabledBorder: Colors.grey[400],
              borderRadius: 30,
            ),
          )),
          SizedBox(
            width: 4,
          ),
          IconButton(
              icon: Icon(
                Icons.image,
                color: image == null ? Colors.grey : AppColors.primary,
              ),
              onPressed: () async {
                image = await HelperMethods.pickImage();
                setState(() {});
              }),
          IconButton(
              icon: Icon(
                Icons.file_upload,
                color: file == null ? Colors.grey : AppColors.primary,
              ),
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  file = File(result.files.single.path!);
                } else {
                  // User canceled the picker
                }
                setState(() {});
              })
        ],
      ),
    );
  }

  void _addCommentAction() {
    enabled = false;
    setState(() {});
    if (message.text.isEmpty && file == null && image == null) {
      enabled = true;
      setState(() {});
      return;
    }
    AddCommentRequest addCommentRequest =
        AddCommentRequest(file: file, image: image, message: message.text);
    message.clear();
    image = null;
    file = null;
    enabled = true;
    setState(() {});
    chatController.addComment(consultingId, addCommentRequest);
  }
}
