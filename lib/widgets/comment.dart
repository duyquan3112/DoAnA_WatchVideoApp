import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';

class CommentChild extends StatefulWidget {
  final String name;
  final String avtUrl;
  final String content;
  final String date;

  const CommentChild(
      {super.key,
      required this.avtUrl,
      required this.name,
      required this.content,
      required this.date});

  @override
  State<CommentChild> createState() => _CommentChildState();
}

class _CommentChildState extends State<CommentChild> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            // Display the image in large form.
            print("Comment Clicked");
          },
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.all(Radius.circular(50))),
            child: CircleAvatar(
                radius: 50,
                backgroundImage: CommentBox.commentImageParser(
                    imageURLorPath: widget.avtUrl)),
          ),
        ),
        title: Text(
          widget.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.content),
        trailing: Text(widget.date, style: TextStyle(fontSize: 10)),
      ),
    );
  }
}
