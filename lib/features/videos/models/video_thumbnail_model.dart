class VideoThumbnailModel {
  VideoThumbnailModel({
    required this.thumbnailUrl,
    required this.videoId,
  });

  VideoThumbnailModel.fromJson({
    required Map<String, dynamic> json,
  })  : thumbnailUrl = json["thumbnailUrl"],
        videoId = json["videoId"];

  final String thumbnailUrl;
  final String videoId;
}
