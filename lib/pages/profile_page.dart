// ignore_for_file: library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/widgets/edit_video.dart';
import 'package:flutter/material.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;
import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/delete_video.dart';
import '../widgets/video_card.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    super.key,
    this.info,
    this.user,
    this.isLogin = false,
  });

  final InfoVideo? info;
  final UserData? user;
  final bool isLogin;
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  build(BuildContext context) {
    final user1 = widget.user;
    final isLogin = widget.isLogin;
    final docid = user1?.docId;
    final name = widget.info?.ownerName ?? '';
    var videos = FirebaseFirestore.instance.collection('video_list');

    //QuerySnapshot vidbelongtodocid = await firestore.collection('videos').where
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 200, 0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                    iconSize: 40,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.alarm),
                  onPressed: () {},
                  alignment: Alignment.center,
                  iconSize: 40,
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                  alignment: Alignment.center,
                  iconSize: 40,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      //backgroundImage: NetworkImage(user1!.avatarUrl),
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      name, // name cua chu video lay tu trong infoVideo
                      style: const TextStyle(fontSize: 30),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    _showDialog();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    // padding: EdgeInsets.fromLTRB(0, 20, 0, 20),

                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Edit video"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(width: 4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DeleteVideo(
                  info: widget.info,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.purpleAccent,
                    backgroundColor: Colors.black,
                  ),
                  // ignore: avoid_print hct
                  onPressed: () => print('chang to manage profile page'),
                  child: const Text('Manage Profile'))
            ],
          ),

          //render video co dieu kien hct
          StreamBuilder(
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
                          info.ownerName =
                              snapshot.data!.docs[index]['ownerName'];
                          info.likedCount =
                              snapshot.data!.docs[index]['likedCount'];
                          //name owner == name cua video thi moi hien thi video cua user do hct
                          if (info.ownerName == name) {
                            return VideoCard(
                              key: UniqueKey(),
                              users: user1,
                              // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                              // title: snapshot.data!.docs[index]['title'],
                              // des: snapshot.data!.docs[index]['description'],
                              // vidId: snapshot.data!.docs[index].id,
                              infoVid: info,
                              isLogin: widget.isLogin,
                            );
                          } else {
                            return Container();
                          }
                        }),
                  );
                }
                return const Text('no data');
              })
        ],
      ),
    );
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      child: EditVideo(
        info: widget.info,
      ),
    );
  }
}
