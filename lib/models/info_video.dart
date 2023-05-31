// ignore_for_file: file_names

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class InfoVideo {
  String? title;
  String? description;
  String? url;
  String? userId;
  String? vidId;
  String? types;
  String? ownerName;
  int likedCount;
  String? date;
  int? timeStamp;

  InfoVideo({
    this.title,
    this.description,
    this.url,
    this.userId,
    this.vidId,
    this.types,
    this.ownerName,
    this.likedCount = 0,
    this.date,
    this.timeStamp,
  });

  InfoVideo copyWith({
    String? title,
    String? description,
    String? url,
    String? userId,
    String? vidId,
    String? types,
    String? ownerName,
    int likedCount = 0,
    String? date,
    int? timeStamp,
  }) =>
      InfoVideo(
        title: title ?? this.title,
        description: description ?? this.description,
        url: url ?? this.url,
        userId: userId ?? this.userId,
        vidId: vidId ?? this.vidId,
        types: types ?? this.types,
        ownerName: ownerName ?? this.ownerName,
        likedCount: likedCount,
        date: date ?? this.date,
        timeStamp: timeStamp ?? this.timeStamp,
      );

  factory InfoVideo.fromJson(Map<String, dynamic> json) => InfoVideo(
        title: json["title"],
        description: json["description"],
        url: json["videoUrl"],
        userId: json["userId"],
        vidId: json["vidId"],
        types: json["types"],
        ownerName: json["ownerName"],
        likedCount: json["likedCount"],
        date: json["date"],
        timeStamp: json["timeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "videoUrl": url,
        "userId": userId,
        "vidId": vidId,
        "types": types,
        "ownerName": ownerName,
        "likedCount": likedCount,
        "date": date,
        "timeStamp": timeStamp,
      };
}
