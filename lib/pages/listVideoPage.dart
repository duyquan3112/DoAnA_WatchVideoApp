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
  const listVideo({super.key, required this.users, required this.userId});

  @override
  State<listVideo> createState() => _listVideoState();
}

class _listVideoState extends State<listVideo> {
  UserData? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = widget.users;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String uRlVideo = AppAssets.videoDefault;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('video_list').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MyMusicApp(
                                      users: widget.users!,
                                    ))),
                          );
                        },
                        child: Text('Music'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MyGameApp(
                                      users: widget.users,
                                    ))),
                          );
                        },
                        child: Text('Game'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (MyMoviesApp(
                                      users: widget.users!,
                                    ))),
                          );
                        },
                        child: Text('Movies'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                        ),
                      ),
                    ]),
                Flexible(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        infoVideo info = infoVideo();
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
                        return videoCard(
                          users: currentUser,
                          // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                          // title: snapshot.data!.docs[index]['title'],
                          // des: snapshot.data!.docs[index]['description'],
                          // vidId: snapshot.data!.docs[index].id,
                          infoVid: info,
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
                ),
              ],
            );
          } else {
            return Center(child: const Text('No data'));
          }
        });
  }
}
