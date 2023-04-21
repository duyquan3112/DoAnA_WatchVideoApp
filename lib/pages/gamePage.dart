import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "../models/infoVideo.dart";
import "../widgets/videoCard.dart";

class MyGameApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyGameAppState();
  }
}

class MyGameAppState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('video_list').snapshots(),
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
                        infoVideo info = infoVideo();
                        info.description =
                            snapshot.data!.docs[index]['description'];
                        info.title = snapshot.data!.docs[index]['title'];
                        info.url = snapshot.data!.docs[index]['videoUrl'];
                        info.vidId = snapshot.data!.docs[index].id;
                        info.types = snapshot.data!.docs[index]['type'];
                        if (info.types == 'games') {
                          return videoCard(
                            // uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                            // title: snapshot.data!.docs[index]['title'],
                            // des: snapshot.data!.docs[index]['description'],
                            // vidId: snapshot.data!.docs[index].id,
                            infoVid: info,
                          );
                        }
                      }),
                ),
              ],
            );
          } else
            return Text('No Game');
        });
  }
}
