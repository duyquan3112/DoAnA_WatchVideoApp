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
  const videoCard({super.key, required this.uRLVideo});

  @override
  State<videoCard> createState() => _videoCardState();
}

class _videoCardState extends State<videoCard> {
  // Future<File> genThumbnailFile(String path) async {
  //   String? fileName;
  //   try {
  //     fileName = await VideoThumbnail.thumbnailFile(
  //       video: path,
  //       thumbnailPath: "assets/images/thumbnail",
  //       imageFormat: ImageFormat.JPEG,
  //       maxHeight:
  //           100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //       quality: 75,
  //     );
  //     File file = File(fileName!);
  //     return file;
  //   } catch (e) {
  //     print(e);
  //     fileName = AppAssets.thumbDefault;
  //     File file = File(fileName);
  //     return file;
  //   }
  // }

  // Future<File> getThumbnail() async {
  //   File file = await genThumbnailFile(widget.uRLVideo);
  //   setState(() {
  //     print(file.path);
  //   });
  //   return file;
  // }

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
              title: Text('Ten cua Video'),
              subtitle: Text('Ho va ten nguoi dung'),
              trailing: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
