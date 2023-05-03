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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var comments = FirebaseFirestore.instance
        .collection('comment_list')
        .orderBy('date', descending: false);
    return StreamBuilder<QuerySnapshot>(
      stream: comments.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: Transform.scale(
              scale: 1,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              if (document['vidId'] == widget.vidId) {
                commentModel comment = commentModel();
                comment.avtUrl = document['avtUrl'];
                comment.name = document['name'];
                comment.content = document['content'];
                comment.date = document['date'];
                return CommentChild(
                  comment: comment,
                );
              }
              return const SizedBox(
                height: 0,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
