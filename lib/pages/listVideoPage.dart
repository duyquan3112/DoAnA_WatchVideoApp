import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/gamePage.dart';
import 'package:do_an/pages/moviePage.dart';
import 'package:do_an/pages/musicPage.dart';
import 'package:do_an/widgets/videoCard.dart';
import 'package:flutter/material.dart';

import '../models/getUserData.dart';
import '../values/app_assets.dart';

class listVideo extends StatefulWidget {
  final UserData? users;
  final String? userId;
  final bool isLogin;
  final String? filter;
  final bool? isDes;
  const listVideo(
      {super.key,
      required this.users,
      required this.userId,
      required this.isLogin,
      required this.filter,
      required this.isDes});

  @override
  State<listVideo> createState() => _listVideoState();
}

class _listVideoState extends State<listVideo> {
  UserData? currentUser;
  int _visibleVideoCount = 5;
  int _additionalVideoCount = 5;

  @override
  void initState() {
    super.initState();
    currentUser = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    var videos = FirebaseFirestore.instance
        .collection('video_list')
        .orderBy(widget.filter!, descending: widget.isDes!);

    return StreamBuilder(
      stream: videos.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final videoCount = snapshot.data!.docs.length;
          final visibleVideoCount = _visibleVideoCount <= videoCount
              ? _visibleVideoCount
              : videoCount;

          return Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              itemCount:
                  visibleVideoCount + (_visibleVideoCount < videoCount ? 1 : 0),
              itemBuilder: (context, index) {
                if (_visibleVideoCount < videoCount &&
                    index == visibleVideoCount) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _visibleVideoCount += _additionalVideoCount;
                      });
                    },
                    child: Container(
                      height: 50,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          'Load More',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                infoVideo info = infoVideo();
                info.description = snapshot.data!.docs[index]['description'];
                info.title = snapshot.data!.docs[index]['title'];
                info.url = snapshot.data!.docs[index]['videoUrl'];
                info.vidId = snapshot.data!.docs[index].id;
                info.userId = snapshot.data!.docs[index]['ownerId'];
                info.types = snapshot.data!.docs[index]['type'];
                info.ownerName = snapshot.data!.docs[index]['ownerName'];
                info.likedCount = snapshot.data!.docs[index]['likedCount'];

                return videoCard(
                  key: UniqueKey(),
                  users: currentUser,
                  infoVid: info,
                  isLogin: widget.isLogin,
                );
              },
            ),
          );
        } else {
          return Center(child: const Text('No data'));
        }
      },
    );
  }
}
