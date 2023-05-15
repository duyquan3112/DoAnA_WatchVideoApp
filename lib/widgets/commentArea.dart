import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:date_format/date_format.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/widgets/commentList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path/path.dart';

import '../models/commentModel.dart';
import '../models/getUserData.dart';
import '../models/infoVideo.dart';

class commentArea extends StatefulWidget {
  final infoVideo info;
  final UserData currentUser;
  const commentArea({super.key, required this.info, required this.currentUser});

  @override
  State<commentArea> createState() => _commentAreaState();
}

class _commentAreaState extends State<commentArea> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  ///Ham push comment len database
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
              //box de nhap comment
              userImage: CommentBox.commentImageParser(
                  imageURLorPath: widget.currentUser.avatarUrl),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () {
                if (formKey.currentState!.validate()) {
                  print(commentController.text);
                  setState(() {
                    //format datetime
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
                    commentModel comment =
                        commentModel(); // tao object comment va khoi tao gia tri cua object
                    comment.avtUrl = widget.currentUser.avatarUrl;
                    comment.content = commentController.text;
                    comment.name = widget.currentUser.username;
                    comment.date = formattedDate.toString();
                    comment.vidId = widget.info.vidId;
                    pushComment(comment); //day comment len database
                  });
                  commentController
                      .clear(); //xoa buffer cua comment cu sau khi push len database
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
