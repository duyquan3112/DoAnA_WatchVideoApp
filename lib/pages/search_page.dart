import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/get_user_data.dart';
import '../models/info_video.dart';
import '../widgets/video_card.dart';

class SearchPage extends StatefulWidget {
  final UserData? users;
  final bool isLogin;
  const SearchPage({
    super.key,
    this.users,
    this.isLogin = false,
  });
  @override
  State<SearchPage> createState() {
    // TODO: implement createState
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('video_list').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<InfoVideo> infoVideos = [];

            for (var doc in snapshot.data!.docs) {
              InfoVideo info = InfoVideo();
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
              return const Center(child: Text('No data'));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: infoVideos.length,
                itemBuilder: (context, index) {
                  return VideoCard(
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
    );
  }
}
