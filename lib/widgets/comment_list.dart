import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/widgets/comment.dart';
import 'package:flutter/material.dart';

import '../models/comment_model.dart';

class CommentList extends StatefulWidget {
  final String vidId;
  const CommentList({super.key, required this.vidId});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var comments = FirebaseFirestore.instance
        .collection('comment_list')
        .orderBy('date', descending: false);

    //Hien thi comment, cap nhat lien tuc khi co du lieu moi hoac thay doi du lieu
    return StreamBuilder<QuerySnapshot>(
      stream: comments.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: Transform.scale(
              scale: 1,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return MediaQuery.removePadding(
          //xoa khoang trang mac dinh
          context: context,
          removeTop: true,
          child: ListView(
            //hien thi list cac comment cua video
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              if (document['vidId'] == widget.vidId) {
                CommentModel comment = CommentModel();
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
