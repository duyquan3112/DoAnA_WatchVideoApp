import 'dart:io';

import 'package:do_an/pages/watchingPage.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class videoCard extends StatefulWidget {
  final String uRLVideo;
  final String title;
  final String des;
  const videoCard(
      {super.key,
      required this.uRLVideo,
      required this.title,
      required this.des});

  @override
  State<videoCard> createState() => _videoCardState();
}

class _videoCardState extends State<videoCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => watchingPage(
                        uRlVideo: widget.uRLVideo,
                      )));
        },
        child: Column(
          children: [
            // FutureBuilder(
            //     future: getThumbnail(),
            //     builder: ((context, snapshot) {
            //       if (snapshot.hasData) {
            //         File file = snapshot.data as File;
            //         return Image.file(file);
            //       }
            //       return CircularProgressIndicator();
            //     })),
            ListTile(
              isThreeLine: true,
              leading: CircleAvatar(),
              title: Text(widget.title),
              subtitle: Text(widget.des),
              trailing: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
