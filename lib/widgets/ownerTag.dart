import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/profilePage.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:like_button/like_button.dart';

import '../values/app_styles.dart';

class ownerTag extends StatefulWidget {
  final infoVideo infoVid;
  final UserData users;
  const ownerTag({super.key, required this.infoVid, required this.users});

  @override
  State<ownerTag> createState() => _ownerTagState();
}

class _ownerTagState extends State<ownerTag> {
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MyProfilePage(info: widget.infoVid,))),
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
                  widget.infoVid.ownerName!,
                  style: AppStyles.h4.copyWith(
                      color: AppColors.blackGrey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
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
                      ? const Color.fromARGB(255, 238, 0, 52)
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
    );
  }
}
