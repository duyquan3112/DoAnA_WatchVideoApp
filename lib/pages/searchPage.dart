import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:flutter/material.dart';

import '../models/infoVideo.dart';
import '../widgets/videoCard.dart';

class searchPage extends StatefulWidget {
  final UserData users;
  const searchPage({super.key, required this.users});
  @override
  State<searchPage> createState() {
    // TODO: implement createState
    return searchPageState();
  }
}

class searchPageState extends State<searchPage> {
  String title = '';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search Name Here'),
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
              stream: FirebaseFirestore.instance
                  .collection('video_list')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<infoVideo> infoVideos = [];
                  snapshot.data!.docs.forEach((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    if (title.isEmpty ||
                        data['title']
                            .toString()
                            .toLowerCase()
                            .contains(title.toLowerCase())) {
                      infoVideo info = infoVideo();
                      info.description = data['description'];
                      info.title = data['title'];
                      info.url = data['videoUrl'];

                      infoVideos.add(info);
                    }
                  });
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: infoVideos.length,
                    itemBuilder: (context, index) {
                      return videoCard(
                          users: widget.users, infoVid: infoVideos[index]);
                    },
                  );
                } else {
                  return Center(child: const Text('No data'));
                }
              }),
        ));
  }
}





// return ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: snapshot.data!.docs.length,
                  //     itemBuilder: (context, index) {
                  //       var data = snapshot.data!.docs[index].data()
                  //           as Map<String, dynamic>;
                  //       if (title.isEmpty) {
                  //         // return videoCard(
                  //         //     uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                  //         //     title: snapshot.data!.docs[index]['title'],
                  //         //     des: snapshot.data!.docs[index]['description']);

                  //         infoVideo info = infoVideo();
                  //         info.description =
                  //             snapshot.data!.docs[index]['description'];
                  //         info.title = snapshot.data!.docs[index]['title'];
                  //         info.url = snapshot.data!.docs[index]['videoUrl'];
                  //         info.vidId = snapshot.data!.docs[index].id;
                  //         return videoCard(infoVid: info);
                  //       }

                  //       if (data['title']
                  //           .toString()
                  //           .toLowerCase()
                  //           .startsWith(title.toLowerCase())) {
                  //         infoVideo info = infoVideo();
                  //         info.description = data['description'];
                  //         info.title = data['title'];
                  //         info.url = data['videoUrl'];

                  //         return videoCard(infoVid: info);
                  //       }
                  //     }

                  //     // Card(

                  //     //     child: ListTile(
                  //     //   isThreeLine: true,
                  //     //   leading: CircleAvatar(),
                  //     //   title: Text(snapshot.data!.docs[index]['title']),
                  //     //   subtitle: Text(snapshot.data!.docs[index]['description']),
                  //     //   trailing: Icon(Icons.more_vert),
                  //     // )),
                  //     );