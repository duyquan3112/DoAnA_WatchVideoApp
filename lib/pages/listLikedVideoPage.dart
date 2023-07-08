import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/getUserData.dart';
import '../models/infoVideo.dart';
import '../widgets/videoCard.dart';

class likedVideo extends StatefulWidget {
  final bool isLogin;
  const likedVideo({super.key, required this.isLogin});

  @override
  State<likedVideo> createState() => _likedVideoState();
}

class _likedVideoState extends State<likedVideo> {
  UserData? currentUser;

  ///Ham de lay info video tu Firebase bang docId
  ///Khi tra ve se tra ve 1 object thuoc lop infoVideo
  Future<infoVideo> getInfoVideo(String docId, infoVideo info) async {
    var collection = FirebaseFirestore.instance.collection('video_list');
    var doc = collection.doc(docId).get();
    await doc.then((DocumentSnapshot document) {
      info.description = document['description'];
      info.title = document['title'];
      info.url = document['videoUrl'];
      info.vidId = document.id;
      info.userId = document['ownerId'];
      info.types = document['type'];
      info.ownerName = document['ownerName'];
      info.likedCount = document['likedCount'];
      info.thumbnailUrl = document['thumbnailUrl'];
    });
    return info;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      currentUser = UserData.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // StreamBuilder de cap nhat gia tri lien tuc, co the thay doi bang widget khac neu muon
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('liked_video').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Flexible(
              //ListView se hien thi cac widget tuong ung voi moi data tra ve
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    infoVideo info = infoVideo();
                    if (snapshot.data!.docs[index]['userId'] ==
                        currentUser!.docId) {
                      //FutureBuilder se xu ly ham async truoc, khi du lieu tra ve se render ra
                      return FutureBuilder(
                          future: getInfoVideo(
                              snapshot.data!.docs[index]['vidId'], info),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return videoCard(
                                users: currentUser,
                                infoVid: info,
                                isLogin: widget.isLogin,
                              );
                            }

                            return const SizedBox();
                          });
                    }

                    return const SizedBox();
                  }),
            );
          } else {
            return Center(child: const Text('No data'));
          }
        });
  }
}
