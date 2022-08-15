import 'dart:io' as io;

import 'package:dio/dio.dart' as dio;
import 'package:gadeer/data/model/comment_model.dart';
import 'package:gadeer/data/request/consulting/add_comment.request.dart';
import 'package:gadeer/data/response/consulting/get_comment.response.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/chat/service/chat_service.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatController extends GetxController {
  ChatService chatService = Get.find<ChatService>();
  List<CommentModel?> allComments = [];

  Future addComment(String? id, AddCommentRequest addComment) async {
    CommentModel commentModel = CommentModel(
        message: addComment.message,
        status: 0,
        userId: Get.find<AccountBloc>().state.user?.id.toString(),
        fileInternal: addComment.file,
        imageFileInternal: addComment.image);

    allComments.insert(0, commentModel);
    update();

    await chatService.addComment(id, addComment).then((addCommentResponse) {
      print("responsex status" + " ${addCommentResponse.status}");
      if (addCommentResponse.status == 0) {
        print("responsex remove");
        allComments.removeAt(0);
        update();
      } else {
        List<CommentModel?> commentsx = [];
        allComments.removeAt(0);
        commentsx.add(addCommentResponse.commentModel);
        commentsx.addAll(allComments);
        allComments = commentsx;
        print("responsex add");
        update();
      }
    }).catchError((e) {
      print("responsex remove");
      print(e.toString());
      allComments.removeAt(0);
      update();
    });
  }

  void addCommentFromNotification(CommentModel comment) {
    allComments.insert(0, comment);
    print("comment " + allComments.length.toString());
    update();
  }

  Future getAllComments(String? id) async {
    GetCommentResponse getCommentResponse = await chatService.getComments(id);
    allComments = getCommentResponse.data ?? [];
    print("length" + allComments.length.toString());

    update();
  }

  Future handleFileClick(CommentModel comment) async {
    io.Directory appDocDir = await getApplicationDocumentsDirectory();
    io.File fileDir = io.File(appDocDir.path + comment.fileName!);
    if (await fileDir.exists()) {
      OpenFile.open(fileDir.path);
    } else {
      try {
        io.File file = io.File(fileDir.path);

        var raf = file.openSync(mode: io.FileMode.write);
        dio.Response response = await dio.Dio().get(
          comment.filePath!,
          options: dio.Options(
              responseType: dio.ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }),
        );
        print(response.headers);

        raf.writeFromSync(response.data);
        await raf.close();
      } catch (e) {
        Notifications.error("خطأ في تحميل الملف");
      }
    }
  }
}
