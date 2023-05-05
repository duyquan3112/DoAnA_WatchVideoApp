class infoVideo {
  String? title;
  String? description;
  String? url;
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
    this.userId,
    this.vidId,
    this.types,
    this.ownerName,
    this.likedCount = 0,
    this.date,
  });
}
