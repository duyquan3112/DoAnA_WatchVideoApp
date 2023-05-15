import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an/models/getUserData.dart';
import 'package:do_an/models/infoVideo.dart';
import 'package:do_an/pages/profilePage.dart';
import 'package:do_an/values/app_assets.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/widgets/likeButton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../values/app_styles.dart';

class ownerTag extends StatefulWidget {
  final infoVideo infoVid;
  final UserData? users;
  final bool isLogin;
  const ownerTag(
      {super.key,
      required this.infoVid,
      required this.users,
      required this.isLogin});

  @override
  State<ownerTag> createState() => _ownerTagState();
}

class _ownerTagState extends State<ownerTag> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 1 / 15,
      width: size.width,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 1 / 1.8,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MyProfilePage(
                            info: widget.infoVid,
                            user: widget.users,
                            isLogin: widget.isLogin,
                          ))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const AvatarView(
                      radius: 16,
                      avatarType: AvatarType.CIRCLE,
                      imagePath: "assets/icons/system/user.png",
                    ),
                  ),
                  Text(
                    widget.infoVid.ownerName!,
                    style: AppStyles.h4.copyWith(
                      color: AppColors.blackGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeButton(
            isLogin: widget.isLogin,
            info: widget.infoVid,
          )
        ],
      ),
    );
  }
}
