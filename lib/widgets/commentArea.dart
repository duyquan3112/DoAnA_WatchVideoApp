import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:date_format/date_format.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/widgets/commentList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/commentModel.dart';
import '../models/infoVideo.dart';

class commentArea extends StatefulWidget {
  final infoVideo info;
  const commentArea({super.key, required this.info});

  @override
  State<commentArea> createState() => _commentAreaState();
}

class _commentAreaState extends State<commentArea> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Future pushComment(commentModel comment) async {
    await FirebaseFirestore.instance.collection('comment_list').add({
      'name': comment.name,
      'content': comment.content,
      'avtUrl': comment.avtUrl,
      'date': comment.date,
      'vidId': comment.vidId
      // 'type':
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: CommentBox(
              userImage: CommentBox.commentImageParser(
                  imageURLorPath: "assets/icons/system/user.png"),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () {
                if (formKey.currentState!.validate()) {
                  print(commentController.text);
                  setState(() {
                    var date = DateTime.now();
                    var formattedDate = formatDate(date, [
                      dd,
                      '/',
                      mm,
                      '/',
                      yyyy,
                      ' ',
                      HH,
                      ':',
                      nn,
                    ]);
                    commentModel comment = commentModel();
                    comment.avtUrl = 'assets/icons/system/user.png';
                    comment.content = commentController.text;
                    comment.name = 'New User';
                    comment.date = formattedDate.toString();
                    comment.vidId = widget.info.vidId;
                    pushComment(comment);
                  });
                  commentController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                } else {
                  print("Not validated");
                }
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: AppColors.blackGrey,
              sendWidget: const Icon(Icons.send_sharp,
                  size: 30, color: Color.fromARGB(255, 177, 177, 177)),
              child: commentList(
                vidId: widget.info.vidId!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
