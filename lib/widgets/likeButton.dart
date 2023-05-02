import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/getUserData.dart';
import '../values/app_assets.dart';
import '../values/app_styles.dart';

class LikeButton extends StatefulWidget {
  final infoVideo info;
  final bool isLogin;
  const LikeButton({super.key, required this.info, required this.isLogin});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  UserData? currentUser;
  bool? isLiked = false;

  Future onLikeButtonTapped() async {
    if (!widget.isLogin) {
      final snackbar = SnackBar(
        content: Text('Please Login to react!'),
        showCloseIcon: true,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      var likedCountRef = FirebaseFirestore.instance
          .collection('video_list')
          .doc(widget.info.vidId);
      isLiked!
          ? {
              await likedCountRef
                  .update({'likedCount': --widget.info.likedCount}),
              await deleteLikedVideo(),
              setState(() {
                isLiked = !isLiked!;
              })
            }
          : {
              await likedCountRef
                  .update({'likedCount': ++widget.info.likedCount}),
              await addLikedVideo(),
              setState(() {
                isLiked = !isLiked!;
              })
            };
    }
  }

  Future addLikedVideo() async {
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection
        .add({'userId': currentUser!.docId, 'vidId': widget.info.vidId});
  }

  Future deleteLikedVideo() async {
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection.doc(await getLikedDocId()).delete();
  }

  Future<String> getLikedDocId() async {
    String? res;
    var collection = FirebaseFirestore.instance.collection('liked_video');
    await collection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['userId'] == currentUser!.docId &&
            doc['vidId'] == widget.info.vidId) {
          res = doc.id;
          break;
        }
      }
    });
    return res!;
  }

  Future<bool> checkLiked() async {
    bool? res;
    var collection = FirebaseFirestore.instance.collection('liked_video');
    var docs = collection
        .where('userId', isEqualTo: currentUser!.docId)
        .where('vidId', isEqualTo: widget.info.vidId)
        .get();

    await docs.then((values) {
      res = values.docs.isNotEmpty;
      return res;
    });
    return res!;
  }

  Future<void> setUpLikedFlag() async {
    if (widget.isLogin) {
      isLiked = await checkLiked();
      setState(() {
        isLiked;
      });
    } else {
      setState(() {
        isLiked = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      currentUser = UserData.getCurrentUser();
    });
    setUpLikedFlag();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int likeCount = widget.info.likedCount;
    return SizedBox(
      width: size.width * 1 / 3,
      child: TextButton.icon(
          onPressed: onLikeButtonTapped,
          icon: ImageIcon(
            AssetImage(AppAssets.heart),
            color:
                isLiked! ? const Color.fromARGB(255, 238, 0, 52) : Colors.grey,
          ),
          label: Text('$likeCount',
              style: AppStyles.h4.copyWith(color: Colors.black))),
    );
  }
}
