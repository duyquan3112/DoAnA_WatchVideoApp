import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/info_video.dart';

class DeleteVideo extends StatefulWidget {
  final InfoVideo? info;

  const DeleteVideo({
    super.key,
    required this.info,
  });

  @override
  State<DeleteVideo> createState() => _DeleteVideoState();
}

class _DeleteVideoState extends State<DeleteVideo> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Delete video'),
          content: const Text('Are you sure delete video'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'No'),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, await yes());
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
      child: const Text('Delete'),
    );
  }

  Future yes() async {
    var db = FirebaseFirestore.instance;
    var docRef = db.collection("video_list").doc(widget.info?.vidId);

    return docRef.delete();
    // FirebaseFirestore.instance.collection("video_list").doc(widget.info.vidId)
    //   .collection("messages").snapshots().doc(widget.info.vidId).
  }
}
