import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/core/local_storage/storage_manager.dart';
import 'package:flutter/material.dart';

import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/video_card.dart';

class LikedVideo extends StatefulWidget {
  final bool isLogin;
  const LikedVideo({super.key, required this.isLogin});

  @override
  State<LikedVideo> createState() => _LikedVideoState();
}

class _LikedVideoState extends State<LikedVideo> {
  UserData? currentUser;

  ///Ham de lay info video tu Firebase bang docId
  ///Khi tra ve se tra ve 1 object thuoc lop infoVideo
  Future<InfoVideo> getinfoVideo(String docId, InfoVideo info) async {
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
    });
    return info;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      currentUser = StorageManager.instance.userCurrent;
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
                    InfoVideo info = InfoVideo();
                    if (snapshot.data!.docs[index]['userId'] ==
                        currentUser!.docId) {
                      //FutureBuilder se xu ly ham async truoc, khi du lieu tra ve se render ra
                      return FutureBuilder(
                          future: getinfoVideo(
                              snapshot.data!.docs[index]['vidId'], info),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return VideoCard(
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
            return const Center(child: Text('No data'));
          }
        });
  }
}
