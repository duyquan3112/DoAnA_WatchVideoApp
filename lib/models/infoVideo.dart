class infoVideo {
  String? title;
  String? description;
  String? url;
  String? thumbnailUrl;
  String? userId;
  String? vidId;
  String? types;
  String? ownerName;
  int likedCount;
  String? date;

  infoVideo({
    this.title,
    this.description,
    this.url,
    this.thumbnailUrl,
    this.userId,
    this.vidId,
    this.types,
    this.ownerName,
    this.likedCount = 0,
    this.date,
  });
}
