import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

void main() {
  group("VideoModel Test", () {
    test("Constructor", () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        likes: 123,
        comments: 345,
        createdAt: 456,
      );

      expect(video.id, "id");
    });

    test("fromJson Constructor", () {
      final video = VideoModel.fromJson(json: {
        "id": "id",
        "title": "title",
        "description": "description",
        "fileUrl": "fileUrl",
        "thumbnailUrl": "thumbnailUrl",
        "creatorUid": "creatorUid",
        "creator": "creator",
        "likes": 1,
        "comments": 2,
        "createdAt": 3,
      }, videoId: "videoId");

      expect(video.title, "title");
      expect(video.comments, isInstanceOf<int>());
    });

    test("toJson Method", () {
      final video = VideoModel(
        id: "id",
        title: "title",
        description: "description",
        fileUrl: "fileUrl",
        thumbnailUrl: "thumbnailUrl",
        creatorUid: "creatorUid",
        creator: "creator",
        likes: 123,
        comments: 345,
        createdAt: 456,
      );

      final json = video.toJson();

      expect(json["id"], "id");
      expect(json["likes"], isInstanceOf<int>());
    });
  });
}
