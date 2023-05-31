import 'package:avatar_view/avatar_view.dart';
import 'package:do_an/models/info_video.dart';
import 'package:do_an/pages/profile_page.dart';
import 'package:do_an/values/app_colors.dart';
import 'package:do_an/widgets/like_button.dart';
import 'package:flutter/material.dart';

import '../models/get_user_data.dart';
import '../values/app_styles.dart';

class OwnerTag extends StatefulWidget {
  final InfoVideo? infoVid;
  final UserData? users;
  final bool isLogin;
  const OwnerTag({
    super.key,
    this.infoVid,
    this.users,
    this.isLogin = false,
  });

  @override
  State<OwnerTag> createState() => _OwnerTagState();
}

class _OwnerTagState extends State<OwnerTag> {
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
                    widget.infoVid?.ownerName ?? '',
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
