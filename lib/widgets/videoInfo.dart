import 'package:do_an/values/app_colors.dart';
import 'package:do_an/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/infoVideo.dart';

class videoInfo extends StatelessWidget {
  final infoVideo info;
  const videoInfo({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.title!,
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
              info.description!,
              style: AppStyles.h5.copyWith(color: AppColors.blackGrey),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
