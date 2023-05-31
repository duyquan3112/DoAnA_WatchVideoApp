import 'package:do_an/values/app_colors.dart';
import 'package:do_an/values/app_styles.dart';
import 'package:flutter/material.dart';

import '../models/info_video.dart';

class VideoInfo extends StatelessWidget {
  final InfoVideo? info;
  const VideoInfo({
    super.key,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(info?.title ?? '',
              style: AppStyles.h4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          Text(
            'Description: ',
            style: AppStyles.h5.copyWith(
                color: AppColors.blackGrey, fontWeight: FontWeight.bold),
          ),
          Text(
            info?.description ?? '',
            style: AppStyles.h5.copyWith(color: AppColors.blackGrey),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
