import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:do_an/models/commentModel.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/values/app_styles.dart';
import 'package:do_an/widgets/comment.dart';
import 'package:do_an/widgets/commentList.dart';
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
  final String uRlVideo;
  final String vidId;
  const watchingPage({super.key, required this.uRlVideo, required this.vidId});

  @override
  State<watchingPage> createState() => _watchingPageState();
}

class _watchingPageState extends State<watchingPage> {
  late FlickManager flickManager;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.uRlVideo),
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future pushComment(commentModel comment) async {
    await FirebaseFirestore.instance.collection('comment_list').add({
      'name': comment.name,
      'content': comment.content,
      'avtUrl': comment.avtUrl,
      'date': comment.date,
      'vidId': comment.vidId
      // 'type':
    });
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
                  Expanded(
                    child: CommentBox(
                      userImage: CommentBox.commentImageParser(
                          imageURLorPath: "assets/icons/system/user.png"),
                      labelText: 'Write a comment...',
                      errorText: 'Comment cannot be blank',
                      withBorder: false,
                      sendButtonMethod: () {
                        if (formKey.currentState!.validate()) {
                          print(commentController.text);
                          setState(() {
                            commentModel comment = new commentModel();
                            comment.avtUrl = 'assets/icons/system/user.png';
                            comment.content = commentController.text;
                            comment.name = 'New User';
                            comment.date = DateTime.now().toString();
                            comment.vidId = widget.vidId;
                            pushComment(comment);
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
                      child: commentList(
                        vidId: widget.vidId,
                      ),
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
}
