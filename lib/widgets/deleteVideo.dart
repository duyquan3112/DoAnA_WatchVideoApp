import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/infoVideo.dart';

class deleteVideo extends StatefulWidget {
  
  final infoVideo info;

  const deleteVideo({super.key, required this.info});

  @override
  State<deleteVideo> createState() => _deleteVideoState();
}

class _deleteVideoState extends State<deleteVideo> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure delete video'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'No'),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async { Navigator.pop(context,await yes());} ,
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
      child: const Text('Delete'),
    );
  }

  Future yes()async{
  var db = FirebaseFirestore.instance;
  var docRef = db.collection("video_list").doc(widget.info.vidId);

  return docRef.delete();
  // FirebaseFirestore.instance.collection("video_list").doc(widget.info.vidId)  
  //   .collection("messages").snapshots().doc(widget.info.vidId).
}
}

