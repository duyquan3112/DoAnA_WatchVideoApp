import 'dart:io';

import 'package:do_an/models/info_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/get_user_data.dart';
import '../pages/watching_page.dart';
import 'delete_video.dart';

class VideoCard extends StatefulWidget {
  final InfoVideo infoVid;
  final UserData? users;
  final bool? isLogin;
  const VideoCard({
    super.key,
    required this.infoVid,
    this.users,
    this.isLogin = false,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  String? _thumbnailUrl;
  UserData? currentUser;

  ///Viet lai ham setState
  ///Neu widget hien tai xuat hien tren khu vuc xem duoc cua man hinh
  ///thi moi render ra widget do
  ///Neu khong (nguoi dung vuot xuong widget khac, widget hien tai khong thuoc khu vuc xem duoc)
  ///thi cac object cua widget se null
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  ///Ham khoi tao thumbnail cho video
  ///Thumbnail la frame dau tien cua video
  void genThumbnail() async {
    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
        video: widget.infoVid.url ?? '',
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP);
  }

  @override
  void initState() {
    super.initState();
    genThumbnail();
    currentUser = widget.users;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _thumbnailUrl != null
        ? Card(
            shadowColor: Colors.black87,
            elevation: 8,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WatchingPage(
                      users: currentUser,
                      info: widget.infoVid,
                      isLogin: widget.isLogin ?? false,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: size.height * 1 / 5,
                        width: size.width,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
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
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      isThreeLine: true,
                      leading: const CircleAvatar(),
                      title: Text(widget.infoVid.title ?? ''),
                      subtitle: Text(widget.infoVid.description ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        onPressed: () => DeleteVideo(info: widget.infoVid),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
