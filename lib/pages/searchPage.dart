import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/videoCard.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return searchPageState();
  }
}

class searchPageState extends State<StatefulWidget> {
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
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        if (title.isEmpty) {
                          return videoCard(
                              uRLVideo: snapshot.data!.docs[index]['videoUrl'],
                              title: snapshot.data!.docs[index]['title'],
                              des: snapshot.data!.docs[index]['description']);
                        }
                        if (data['title']
                            .toString()
                            .startsWith(title.toLowerCase())) {
                          return (ListTile(
                            title: Text(data['title']),
                            subtitle: Text(data['description']),
                          ));
                        }

                        // Card(
                      }
                      //     child: ListTile(
                      //   isThreeLine: true,
                      //   leading: CircleAvatar(),
                      //   title: Text(snapshot.data!.docs[index]['title']),
                      //   subtitle: Text(snapshot.data!.docs[index]['description']),
                      //   trailing: Icon(Icons.more_vert),
                      // )),
                      );
                } else {
                  return Center(child: const Text('No data'));
                }
              }),
        ));
  }
}
