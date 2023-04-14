import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/commentModel.dart';
import 'package:do_an/widgets/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class commentList extends StatefulWidget {
  final String vidId;
  const commentList({super.key, required this.vidId});

  @override
  State<commentList> createState() => _commentListState();
}

class _commentListState extends State<commentList> {
  // List<commentModel> commentList = [];
  // List<commentModel> getComment() {
  //   var db = FirebaseFirestore.instance;
  //   db.collection('comment_list').get().then((data) {
  //     for (var value in data.docs) {
  //       if (widget.vidId == value['vidId']) {
  //         commentModel comments = new commentModel();
  //         comments.avtUrl = value['avtUrl'];
  //         comments.name = value['name'];
  //         comments.content = value['content'];
  //         comments.date = value['date'];
  //         commentList.add(comments);
  //       }
  //     }
  //   });

  //   return commentList;
  // }

  @override
  void initState() {
    //getComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('comment_list').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (widget.vidId == snapshot.data!.docs[index]['vidId']) {
                      return CommentChild(
                        avtUrl: snapshot.data!.docs[index]['avtUrl'],
                        content: snapshot.data!.docs[index]['content'],
                        date: snapshot.data!.docs[index]['date'],
                        name: snapshot.data!.docs[index]['name'],
                      );
                    }
                    ;
                  });
            } else {
              return Center(child: const Text('No data'));
            }
          }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //       child: ListView.builder(
  //           shrinkWrap: true,
  //           physics: const AlwaysScrollableScrollPhysics(),
  //           itemCount: commentList.length,
  //           itemBuilder: (context, index) {
  //             return CommentChild(
  //               avtUrl: commentList[index].avtUrl!,
  //               content: commentList[index].content!,
  //               date: commentList[index].date!,
  //               name: commentList[index].name!,
  //             );
  //           }));
  // }
}
