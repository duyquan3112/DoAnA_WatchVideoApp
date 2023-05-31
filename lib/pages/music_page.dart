import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/video_card.dart';

class MyMusicApp extends StatefulWidget {
  final UserData? users;
  final bool isLogin;
  const MyMusicApp({super.key, required this.users, required this.isLogin});
  @override
  State<MyMusicApp> createState() {
    // TODO: implement createState
    return MyMusicAppState();
  }
}

class MyMusicAppState extends State<MyMusicApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (Scaffold(
        appBar: AppBar(title: const Text('Music Page')),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('video_list').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            InfoVideo info = InfoVideo();
                            info.description =
                                snapshot.data!.docs[index]['description'];
                            info.title = snapshot.data!.docs[index]['title'];
                            info.url = snapshot.data!.docs[index]['videoUrl'];
                            info.vidId = snapshot.data!.docs[index].id;
                            info.types = snapshot.data!.docs[index]['type'];

                            print(info.types);
                            if (info.types == 'musics') {
                              return VideoCard(
                                // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                                // title: snapshot.data!.docs[index]['title'],
                                // des: snapshot.data!.docs[index]['description'],
                                // vidId: snapshot.data!.docs[index].id,
                                users: widget.users,
                                infoVid: info,
                                isLogin: widget.isLogin,
                              );
                            }
                            return Container();
                          }),
                    ),
                  ],
                );
              } else {
                return const Text('No music');
              }
            })));
  }
}
