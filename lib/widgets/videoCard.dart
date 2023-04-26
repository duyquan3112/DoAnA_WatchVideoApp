import 'dart:io';

import 'package:do_an/models/getUserData.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/watchingPage.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/widgets/deleteVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class videoCard extends StatefulWidget {
  final infoVideo infoVid;
  final UserData users;
  // final String uRLVideo;
  // final String title;
  // final String des;
  // final String vidId;
  const videoCard(
      {super.key,
      required this.users,
      // required this.uRLVideo,
      // required this.title,
      // required this.des,
      // required this.vidId,
      required this.infoVid});

  @override
  State<videoCard> createState() => _videoCardState();
}

class _videoCardState extends State<videoCard> {
  String? _thumbnailUrl;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void genThumbnail() async {
    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
        video: widget.infoVid.url!,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    genThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      shadowColor: Colors.black87,
      elevation: 8,
      child: InkWell(
        onTap: () {
          print(widget.infoVid.vidId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => watchingPage(
                        users: widget.users,
                        info: widget.infoVid,
                      )));
        },
        child: Column(
          children: [
            Stack(fit: StackFit.loose, alignment: Alignment.center, children: [
              Container(
                height: size.height * 1 / 5,
                width: size.width,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_thumbnailUrl != null)
                      Stack(alignment: Alignment.center, children: [
                        Container(
                          width: size.width * 1 / 5,
                          color: Colors.black,
                        ),
                        Image.file(
                          File(_thumbnailUrl!),
                          scale: 1,
                          height: size.height * 1 / 5,
                        ),
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black45,
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ])
                    else
                      const CircularProgressIndicator()
                  ],
                ),
              )
            ]),
            Container(
              color: Colors.white,
              child: ListTile(
                isThreeLine: true,
                leading: const CircleAvatar(),
                title: Text(widget.infoVid.title!),
                subtitle: Text(widget.infoVid.description!),
                trailing: IconButton(icon:const Icon(Icons.more_vert_outlined) ,onPressed: () => deleteVideo(info: widget.infoVid),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
