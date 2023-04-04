import 'package:comment_box/comment/comment.dart';
import 'package:do_an/models/commentModel.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/values/app_styles.dart';
import 'package:do_an/widgets/comment.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';
import 'package:avatar_view/avatar_view.dart';
import 'package:mock_data/mock_data.dart';
import 'package:visibility_detector/visibility_detector.dart';

class watchingPage extends StatefulWidget {
  const watchingPage({super.key});

  @override
  State<watchingPage> createState() => _watchingPageState();
}

class _watchingPageState extends State<watchingPage> {
  late FlickManager flickManager;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Chuks Okwuenu',
      'pic': 'assets/icons/system/user.png',
      'message': 'I love to code',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Biggi Man',
      'pic': 'assets/icons/system/user.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Tunde Martins',
      'pic': 'assets/icons/system/user.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Biggi Man',
      'pic': 'assets/icons/system/user.png',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
  ];

  @override
  void initState() {
    //fileData = [];
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://firebasestorage.googleapis.com/v0/b/android-b258a.appspot.com/o/files%2F3c1d3c7f2b694a9ba7c8895072e29254.MOV?alt=media&token=28c769f3-4f1a-4603-ac02-9b7709c82355"),
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        //height: MediaQuery.of(context).size.height,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: VisibilityDetector(
                key: ObjectKey(flickManager),
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction == 0 && this.mounted) {
                    flickManager.flickControlManager?.autoPause();
                  } else if (visibility.visibleFraction == 1) {
                    flickManager.flickControlManager?.autoResume();
                  }
                },
                child: SizedBox(
                  height: size.height * 1 / 3.5,
                  child: FlickVideoPlayer(
                    flickManager: flickManager,
                    flickVideoWithControls: FlickVideoWithControls(
                      videoFit: BoxFit.fitHeight,
                      closedCaptionTextStyle: TextStyle(fontSize: 8),
                      controls: FlickPortraitControls(),
                    ),
                    flickVideoWithControlsFullscreen: FlickVideoWithControls(
                      controls: FlickLandscapeControls(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('This is an example video',
                  style: AppStyles.h4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              width: size.width,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const AvatarView(
                      radius: 25,
                      avatarType: AvatarType.CIRCLE,
                      imagePath: "assets/icons/system/user.png",
                    ),
                  ),
                  Text(
                    " Duy Quan",
                    style: AppStyles.h4.copyWith(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: size.width * 1 / 3,
                    child: LikeButton(
                      onTap: onLikeButtonTapped,
                      size: 40,
                      circleColor: const CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return ImageIcon(
                          AssetImage(AppAssets.heart),
                          color: isLiked
                              ? Color.fromARGB(255, 238, 0, 52)
                              : Colors.grey,
                        );
                      },
                      likeCount: 0,
                      countDecoration: (count, likeCount) {
                        return Text(
                          '$likeCount',
                          style: AppStyles.h4.copyWith(color: Colors.black),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 25,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: size.width * 1,
                    child: Text(
                      "Comment ${filedata.length}",
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  Expanded(
                    child: CommentBox(
                      userImage: CommentBox.commentImageParser(
                          imageURLorPath: "assets/icons/system/user.png"),
                      child: CommentChild(data: filedata),
                      labelText: 'Write a comment...',
                      errorText: 'Comment cannot be blank',
                      withBorder: false,
                      sendButtonMethod: () {
                        if (formKey.currentState!.validate()) {
                          print(commentController.text);
                          setState(() {
                            var value = {
                              'name': 'New User',
                              'pic': 'assets/icons/system/user.png',
                              'message': commentController.text,
                              'date': '2021-01-01 12:00:00'
                            };
                            filedata.insert(0, value);
                          });
                          commentController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        } else {
                          print("Not validated");
                        }
                      },
                      formKey: formKey,
                      commentController: commentController,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      textColor: AppColors.blackGrey,
                      sendWidget: Icon(Icons.send_sharp,
                          size: 30, color: Color.fromARGB(255, 177, 177, 177)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget commentChild(data) {
  //   return ListView(
  //     children: [
  //       for (var i = 0; i < data.length; i++)
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
  //           child: ListTile(
  //             leading: GestureDetector(
  //               onTap: () async {
  //                 // Display the image in large form.
  //                 print("Comment Clicked");
  //               },
  //               child: Container(
  //                 height: 50.0,
  //                 width: 50.0,
  //                 decoration: new BoxDecoration(
  //                     color: Colors.blue,
  //                     borderRadius: new BorderRadius.all(Radius.circular(50))),
  //                 child: CircleAvatar(
  //                     radius: 50,
  //                     backgroundImage: CommentBox.commentImageParser(
  //                         imageURLorPath: data[i]['pic'])),
  //               ),
  //             ),
  //             title: Text(
  //               data[i]['name'],
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(data[i]['message']),
  //             trailing: Text(data[i]['date'], style: TextStyle(fontSize: 10)),
  //           ),
  //         )
  //     ],
  //   );
  // }
}
