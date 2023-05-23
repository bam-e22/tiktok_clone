import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostVideModel extends FamilyAsyncNotifier<void, String> {
  late final VideosRepository _videosRepository;
  late final String _videoId;

  @override
  FutureOr<void> build(String videoId) {
    _videoId = videoId;
    _videosRepository = ref.read(videosRepo);
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;
    await _videosRepository.likeVideo(
      videoId: _videoId,
      userId: user!.uid,
    );
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostVideModel, void, String>(
  () => VideoPostVideModel(),
);
