import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/comment_model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/chat/controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class CommentItemWidget extends StatelessWidget {
  CommentItemWidget({Key? key, required this.comment}) : super(key: key);
  final CommentModel comment;
  final ChatController chatController = Get.find();
  final int? userId = Get.find<AccountBloc>().state.user?.id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: comment.userId == userId.toString()
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          SizedBox(
            width: Get.width * .7,
            child: Column(
              crossAxisAlignment: comment.userId == userId.toString()
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                if (comment.filePath != null) _buildFile(),
                if (comment.fileInternal != null) _buildLocalFile(),
                if (comment.image != null) _buildImage(),
                if (comment.imageFileInternal != null) _buildLocalImage(),
                if (comment.message != null) _buildMessage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: comment.userId == userId.toString()
            ? Colors.grey[300]
            : AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.end,
        children: [
          AutoSizeText(
            comment.message!,
            style: TextStyles.hint.copyWith(
                color: comment.userId == userId.toString()
                    ? Colors.black
                    : Colors.white),
            textAlign: TextAlign.start,
          ),
          if (userId.toString() == comment.userId)
            SizedBox(
              width: 4,
            ),
          if (userId.toString() == comment.userId)
            Transform.translate(
              offset: Offset(0, 2),
              child: Icon(
                comment.status == CommentModel.pendingState
                    ? Icons.timer
                    : Icons.check,
                size: 16,
                color: comment.status == CommentModel.pendingState
                    ? Colors.grey
                    : AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocalImage() {
    return InkWell(
      onTap: () {
        Get.dialog(Dialog(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.file(comment.imageFileInternal!),
          ),
        ));
      },
      child: Container(
        width: 150,
        child: Image.file(
          comment.imageFileInternal!,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return InkWell(
      onTap: () {
        Get.dialog(Dialog(
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: CachedNetworkImage(
              imageUrl: comment.image!,
            ),
          ),
        ));
      },
      child: Container(
        width: 150,
        child: CachedNetworkImage(
          imageUrl: comment.image!,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget _buildLocalFile() {
    return InkWell(
      onTap: () {
        OpenFile.open(comment.fileInternal?.path);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                comment.fileInternal?.path.split('/').last ?? "",
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Icon(Icons.file_copy)
          ],
        ),
      ),
    );
  }

  Widget _buildFile() {
    return InkWell(
      onTap: () {
        chatController.handleFileClick(comment);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                comment.fileName!,
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Icon(Icons.file_download)
          ],
        ),
      ),
    );
  }
}
