import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/video_card.dart';

class ListVideo extends StatefulWidget {
  final UserData? users;
  final String? userId;
  final bool isLogin;
  final String? filter;
  final bool? isDes;
  const ListVideo({
    super.key,
    required this.users,
    required this.userId,
    required this.isLogin,
    required this.filter,
    required this.isDes,
  });

  @override
  State<ListVideo> createState() => _ListVideoState();
}

class _ListVideoState extends State<ListVideo> {
  UserData? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.users;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //String uRlVideo = AppAssets.videoDefault;

    var videos = FirebaseFirestore.instance
        .collection('video_list')
        .orderBy(widget.filter!, descending: widget.isDes!);
    return StreamBuilder(
        stream: videos.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Flexible(
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    InfoVideo info = InfoVideo();
                    info.description =
                        snapshot.data!.docs[index]['description'];
                    info.title = snapshot.data!.docs[index]['title'];
                    info.url = snapshot.data!.docs[index]['videoUrl'];
                    info.vidId = snapshot.data!.docs[index].id;
                    info.userId = snapshot.data!.docs[index]['ownerId'];
                    info.types = snapshot.data!.docs[index]['type'];
                    info.ownerName = snapshot.data!.docs[index]['ownerName'];
                    info.likedCount = snapshot.data!.docs[index]['likedCount'];
                    return VideoCard(
                      key: UniqueKey(),
                      users: currentUser,
                      // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                      // title: snapshot.data!.docs[index]['title'],
                      // des: snapshot.data!.docs[index]['description'],
                      // vidId: snapshot.data!.docs[index].id,
                      infoVid: info,
                      isLogin: widget.isLogin,
                    );
                  }
                  // Card(
                  //     child: ListTile(
                  //   isThreeLine: true,
                  //   leading: CircleAvatar(),
                  //   title: Text(snapshot.data!.docs[index]['title']),
                  //   subtitle: Text(snapshot.data!.docs[index]['description']),
                  //   trailing: Icon(Icons.more_vert),
                  // )),
                  ),
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        });
  }
}
