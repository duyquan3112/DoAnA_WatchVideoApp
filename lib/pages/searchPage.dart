import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:flutter/material.dart';

import '../models/infoVideo.dart';
import '../widgets/videoCard.dart';

class searchPage extends StatefulWidget {
  final UserData users;
  final bool isLogin;
  const searchPage({Key? key, required this.users, required this.isLogin})
      : super(key: key);

  @override
  searchPageState createState() => searchPageState();
}

class searchPageState extends State<searchPage> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search Name Here',
            ),
            onChanged: (val) {
              setState(() {
                title = val;
              });
            },
          ),
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('video_list').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<infoVideo> infoVideos = [];

              for (var doc in snapshot.data!.docs) {
                infoVideo info = infoVideo();
                info.description = doc['description'];
                info.title = doc['title'];
                info.url = doc['videoUrl'];
                info.vidId = doc.id;
                info.userId = doc['ownerId'];
                info.types = doc['type'];
                info.ownerName = doc['ownerName'];
                info.likedCount = doc['likedCount'];

                // Check if the search input matches the video title
                if (title.isEmpty ||
                    info.title
                        .toString()
                        .toLowerCase()
                        .contains(title.toLowerCase())) {
                  infoVideos.add(info);
                }
              }

              if (infoVideos.isEmpty) {
                return Center(child: const Text('No data'));
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: infoVideos.length,
                  itemBuilder: (context, index) {
                    return videoCard(
                      users: widget.users,
                      infoVid: infoVideos[index],
                      isLogin: widget.isLogin,
                    );
                  },
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
