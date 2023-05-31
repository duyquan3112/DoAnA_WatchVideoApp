import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "../models/get_user_data.dart";
import "../models/info_video.dart";
import "../widgets/video_card.dart";

class MyGameApp extends StatefulWidget {
  final UserData? users;
  final bool isLogin;
  const MyGameApp({super.key, required this.users, required this.isLogin});

  @override
  State<MyGameApp> createState() => MyGameAppState();
}

class MyGameAppState extends State<MyGameApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return (Scaffold(
        appBar: AppBar(title: const Text('This is Game Page')),
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
                            if (info.types == 'games') {
                              return VideoCard(
                                users: widget.users,
                                // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                                // title: snapshot.data!.docs[index]['title'],
                                // des: snapshot.data!.docs[index]['description'],
                                // vidId: snapshot.data!.docs[index].id,
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
                return const Text('No Game');
              }
            })));
  }
}
