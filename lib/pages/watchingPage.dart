import 'package:do_an/models/getUserData.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/widgets/commentArea.dart';
import 'package:do_an/widgets/ownerTag.dart';
import 'package:do_an/widgets/videoInfo.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class watchingPage extends StatefulWidget {
  final infoVideo info;
  final UserData? users;
  const watchingPage({super.key, required this.info, required this.users});

  @override
  State<watchingPage> createState() => _watchingPageState();
}

class _watchingPageState extends State<watchingPage> {
  late FlickManager flickManager;
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  UserData? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = widget.users;
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.info.url!),
      autoInitialize: true,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  bool showPopButton = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.only(top: 40),
        constraints: const BoxConstraints.expand(),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(),
        //height: MediaQuery.of(context).size.height,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
                      height: size.height * 1 / 3,
                      child: FlickVideoPlayer(
                        flickManager: flickManager,
                        flickVideoWithControls: const FlickVideoWithControls(
                          videoFit: BoxFit.contain,
                          closedCaptionTextStyle: TextStyle(fontSize: 8),
                          controls: FlickPortraitControls(),
                        ),
                        flickVideoWithControlsFullscreen:
                            const FlickVideoWithControls(
                          videoFit: BoxFit.contain,
                          controls: FlickLandscapeControls(),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset(
                    AppAssets.left_Arrow,
                    color: AppColors.lightGrey,
                    width: 20,
                  ),
                ),
              ],
            ),
            videoInfo(info: widget.info),
            ownerTag(
              users: currentUser,
              infoVid: widget.info,
            ),
            const Divider(
              color: Colors.black,
              height: 5,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            currentUser?.username != null
                ? commentArea(info: widget.info)
                : Center(
                    heightFactor: size.height * 1 / 100,
                    child: Text('Please Login to comment and react video!'))
          ],
        ),
      ),
    );
  }
}
