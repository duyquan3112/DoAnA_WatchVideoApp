import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';

class CommentChild extends StatefulWidget {
  final List data;
  const CommentChild({super.key, required this.data});

  @override
  State<CommentChild> createState() => _CommentChildState();
}

class _CommentChildState extends State<CommentChild> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Text("Not have comment yet!");
    } else {
      return ListView(
        children: [
          for (var i = 0; i < widget.data.length; i++)
            Padding(
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
                        borderRadius:
                            new BorderRadius.all(Radius.circular(50))),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CommentBox.commentImageParser(
                            imageURLorPath: widget.data[i]['pic'])),
                  ),
                ),
                title: Text(
                  widget.data[i]['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.data[i]['message']),
                trailing: Text(widget.data[i]['date'],
                    style: TextStyle(fontSize: 10)),
              ),
            )
        ],
      );
    }
  }
}
